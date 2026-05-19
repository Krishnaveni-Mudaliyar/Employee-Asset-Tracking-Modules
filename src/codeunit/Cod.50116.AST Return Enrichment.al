// Enriches an existing return document with:
//   - Return Date stamp on Posted Assignment Header (extension field 12)
//   - Condition at Return on Posted Assignment Lines (extension field 9)
//   - Condition Degraded flag (extension field 11)
//   - Days on Loan (extension field 15)
//   - Clears Is Overdue flag (extension field 16)
//   - Updates Company Asset: Last Return Date (ext 26), Book Value recalc
//
// Called AFTER Cod.50102 AST Asset Return Mgt. ProcessReturn() has completed.
// Usage: Call SetReturnCondition for each line, then FinaliseReturn on header.
codeunit 50116 "AST Return Enrichment"
{
    procedure SetReturnCondition(
        pDocNo: Code[20];
        pLineNo: Integer;
        pCondition: Enum "AST Asset Condition";
        pNotes: Text[250])
    var
        lLine: Record "AST Posted Assignment Line";
    begin
        lLine.Get(pDocNo, pLineNo);
        lLine."Condition at Return" := pCondition;
        lLine."Return Notes" := pNotes;
        lLine."Condition Degraded" :=
            pCondition.AsInteger() > lLine."Condition at Handover".AsInteger();
        lLine.Modify(false);   // Bypass original OnModify error intentionally.
    end;

    procedure FinaliseReturn(
        var pHdr: Record "AST Posted Assignment Header";
        pReturnDate: Date;
        pReturnNotes: Text[250])
    var
        lLine: Record "AST Posted Assignment Line";
        lAsset: Record "AST Company Asset";
    begin
        if pReturnDate = 0D then pReturnDate := Today;

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
