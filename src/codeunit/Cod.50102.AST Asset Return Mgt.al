codeunit 50102 "AST Asset Return Mgt."
{
    procedure ProcessReturn(
        var pRecPostedHeader: Record "AST Posted Assignment Header")
    var
        lRecPostedLine: Record "AST Posted Assignment Line";
        lRecAsset: Record "AST Company Asset";
        lCodLogMgt: Codeunit "AST Asset Log Mgt.";
        lEnumStatusBefore: Enum "AST Asset Status";

    begin
        // Validate posted document exists
        pRecPostedHeader.TestField("No.");

        // Process each line
        lRecPostedLine.SetRange("Document No.", pRecPostedHeader."No.");
        if lRecPostedLine.FindSet() then
            repeat
                lRecAsset.Get(lRecPostedLine."Asset No.");

                // Capture status before change
                lEnumStatusBefore := lRecAsset.Status;

                // Return asset to available
                lRecAsset.Status := lRecAsset.Status::Available;
                lRecAsset."Assigned to Employee No." := '';
                lRecAsset."Last Assignment Date" := 0D;
                lRecAsset.Modify(true);

                // create return log entry
                lCodLogMgt.CreateLogEntry(
                    lRecAsset,
                    lEnumStatusBefore,
                    lRecAsset.Status::Available,
                    "AST Transaction Type"::Return,
                    pRecPostedHeader."No.",
                    pRecPostedHeader."Employee No.",
                    pRecPostedHeader."Employee Name");

            until lRecPostedLine.Next() = 0;
    end;
}