codeunit 50103 "AST Asset Log Mgt."
{
    procedure CreateLogEntry(
        var pRecAsset: Record "AST Company Asset";
        pEnumStatusBefore: Enum "AST Asset Status";
        pEnumStatusAfter: Enum "AST Asset Status";
        pEnumTransactionType: Enum "AST Transaction Type";
        pCodDocumentNo: Code[20];
        pCodEmployeeNo: Code[20];
        pTxtEmployeeName: Text[100])

    var
        lRecLogEntry: Record "AST Asset Log Entry";
    begin
        lRecLogEntry.Init();
        lRecLogEntry."Asset No." := pRecAsset."No.";
        lRecLogEntry."Transaction Type" := lRecLogEntry."Transaction Type"::Assignment;
        lRecLogEntry."Document No." := pCodDocumentNo;
        lRecLogEntry."Employee No." := pCodEmployeeNo;
        lRecLogEntry."Employee Name" := CopyStr(pTxtEmployeeName, 1, 100);
        lRecLogEntry."Asset Status Before" := pEnumStatusBefore;
        lRecLogEntry."Asset Status After" := pEnumStatusAfter;
        lRecLogEntry.Insert(true);
        // OnInsert trigger handles: Entry No., Log Date, Log Time, Created By
    end;
}