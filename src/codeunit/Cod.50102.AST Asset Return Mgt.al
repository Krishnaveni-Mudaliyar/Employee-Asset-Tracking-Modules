codeunit 50102 "AST Asset Return Mgt."
{
    procedure ProcessReturn(var pRecPostedHeader: Record "AST Posted Assignment Header")
    var
        lRecPostedLine: Record "AST Posted Assignment Line";
        lRecAsset: Record "AST Company Asset";
        lCodLogMgt: Codeunit "AST Asset Log Mgt.";
        lCodEvents: Codeunit "AST Asset Events";
        lCodTelemetry: Codeunit "AST Telemetry";
        lEnumStatusBefore: Enum "AST Asset Status";
        lBolHandled: Boolean;
    begin
        pRecPostedHeader.TestField("No.");

        // FIX: OnBeforeProcessReturn event existed in Cod.50105 but was NEVER raised.
        // This broke the extensibility contract — subscribers registered but never fired.
        lCodEvents.OnBeforeProcessReturn(pRecPostedHeader, lBolHandled);
        if lBolHandled then
            exit;

        lRecPostedLine.SetLoadFields("Document No.", "Line No.", "Asset No.");
        lRecPostedLine.SetRange("Document No.", pRecPostedHeader."No.");
        if lRecPostedLine.FindSet() then
            repeat
                lRecAsset.Get(lRecPostedLine."Asset No.");
                lEnumStatusBefore := lRecAsset.Status;

                lRecAsset.Status := lRecAsset.Status::Available;
                lRecAsset."Assigned to Employee No." := '';
                lRecAsset."Last Assignment Date" := 0D;
                lRecAsset.Modify(true);

                lCodLogMgt.CreateLogEntry(
                    lRecAsset,
                    lEnumStatusBefore,
                    lRecAsset.Status::Available,
                    "AST Transaction Type"::Return,
                    pRecPostedHeader."No.",
                    pRecPostedHeader."Employee No.",
                    pRecPostedHeader."Employee Name");

                // FIX: Telemetry was never called from Return — now integrated
                lCodTelemetry.LogAssetReturned(
                    lRecPostedLine."Asset No.",
                    pRecPostedHeader."Employee No.",
                    pRecPostedHeader."No.");

            until lRecPostedLine.Next() = 0;

        // FIX: OnAfterProcessReturn event existed but was NEVER raised
        lCodEvents.OnAfterProcessReturn(pRecPostedHeader);
    end;
}
