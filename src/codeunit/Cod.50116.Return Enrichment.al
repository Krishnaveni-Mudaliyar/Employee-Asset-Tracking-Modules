codeunit 50116 "Return Enrichment"
{
    procedure SetReturnCondition(
        pDocNo: Code[20];
        pLineNo: Integer;
        pCondition: Enum "Asset Condition";
        pNotes: Text[250])
    var
        lLine: Record "Posted Assignment Line";
    begin
        lLine.Get(pDocNo, pLineNo);
        lLine."Condition at Return" := pCondition;
        lLine."Return Notes" := pNotes;
        lLine."Condition Degraded" :=
            pCondition.AsInteger() > lLine."Condition at Handover".AsInteger();
        lLine.Modify(false);   // Bypass original OnModify error intentionally.
    end;

    procedure FinaliseReturn(
        var pHdr: Record "Posted Assignment Header";
        pReturnDate: Date;
        pReturnNotes: Text[250])
    var
        lLine: Record "Posted Assignment Line";
        lAsset: Record "Company Asset";
    begin
        if pReturnDate = 0D
        then
            pReturnDate := Today;

        pHdr."Return Date" := pReturnDate;
        pHdr."Return Processed By" := CopyStr(UserId(), 1, 50);
        pHdr."Return Notes" := pReturnNotes;
        pHdr."Days on Loan" := pReturnDate - pHdr."Assignment Date";
        pHdr."Is Overdue" := false;
        pHdr."Overdue Days" := 0;
        pHdr.Modify(false);

        // Default Condition at Return = Condition at Handover if not set
        lLine.SetRange("Document No.", pHdr."No.");
        if lLine.FindSet(true) then
            repeat
                if lLine."Condition at Return" = lLine."Condition at Return"::" " then begin
                    lLine."Condition at Return" := lLine."Condition at Handover";
                    lLine.Modify(false);
                end;
                // Update Company Asset Last Return Date and Book Value
                if lAsset.Get(lLine."Asset No.") then begin
                    lAsset."Last Return Date" := pReturnDate;
                    lAsset."Is Overdue" := false;
                    lAsset.RecalcBookValue();
                    lAsset.Modify(false);
                end;
            until lLine.Next() = 0;
    end;
}
