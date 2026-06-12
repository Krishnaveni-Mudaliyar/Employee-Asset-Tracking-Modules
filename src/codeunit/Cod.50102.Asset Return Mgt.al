codeunit 50102 "Asset Return Mgt."
{
    procedure ProcessReturn(var pRecPostedHeader: Record "Posted Assignment Header")
    var
        lRecPostedLine: Record "Posted Assignment Line";
        lRecAsset: Record "Company Asset";
        lCodLogMgt: Codeunit "Asset Log Mgt.";
        lCodEvents: Codeunit "Asset Events";
        lCodTelemetry: Codeunit "Asset Telemetry";
        lEnumStatusBefore: Enum "Asset Status";
        lBolHandled: Boolean;
    begin
        pRecPostedHeader.TestField("No.");

        if pRecPostedHeader."Transaction Type" = pRecPostedHeader."Transaction Type"::Return
        then
            Error('Assignment %1 has already been returned. Double-Return not allowed.', pRecPostedHeader."No.");

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
                lRecAsset."Assigned to Employee Name" := '';
                lRecAsset."Last Assignment Date" := 0D;
                lRecAsset.Modify(true);

                lCodLogMgt.CreateLogEntry(lRecAsset, lEnumStatusBefore, lRecAsset.Status::Available, "Transaction Type"::Return, pRecPostedHeader."No.", pRecPostedHeader."Employee No.", pRecPostedHeader."Employee Name");

                lCodTelemetry.LogAssetReturned(lRecPostedLine."Asset No.", pRecPostedHeader."Employee No.", pRecPostedHeader."No.");

            until lRecPostedLine.Next() = 0;

        pRecPostedHeader."Transaction Type" := pRecPostedHeader."Transaction Type"::Return;
        pRecPostedHeader.Modify(false);

        CreateReturnDocument(pRecPostedHeader);
        lCodEvents.OnAfterProcessReturn(pRecPostedHeader);
    end;

    local procedure CreateReturnDocument(var pRecOriginal: Record "Posted Assignment Header")
    var
        lRecReturnHeader: Record "Posted Assignment Header";
        lRecOrigLine: Record "Posted Assignment Line";
        lRecReturnLine: Record "Posted Assignment Line";
        lCodReturnNo: Code[20];
    begin
        lCodReturnNo := CopyStr('RET-' + pRecOriginal."No.", 1, 20);

        if lRecReturnHeader.Get(lCodReturnNo) then
            exit;

        lRecReturnHeader.Init();
        lRecReturnHeader.TransferFields(pRecOriginal);
        lRecReturnHeader."No." := lCodReturnNo;
        lRecReturnHeader."Transaction Type" := lRecReturnHeader."Transaction Type"::Return;
        lRecReturnHeader."Posting Date" := Today;
        lRecReturnHeader."Posted By" := CopyStr(UserId(), 1, 50);
        lRecReturnHeader."Created By" := CopyStr(UserId(), 1, 50);
        lRecReturnHeader."Created Date" := Today;
        lRecReturnHeader.Insert(false);

        lRecOrigLine.SetRange("Document No.", pRecOriginal."No.");
        if lRecOrigLine.FindSet() then
            repeat
                lRecReturnLine.Init();
                lRecReturnLine.TransferFields(lRecOrigLine);
                lRecReturnLine."Document No." := lCodReturnNo;
                lRecReturnLine.Insert(false);
            until lRecOrigLine.Next() = 0;
    end;
}