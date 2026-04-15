codeunit 50103 "AST Asset Log Mgt."
{
    // PURPOSE: Single entry point for all audit log creation.
    // Rule: This procedure must NEVER throw an unhandled error — a logging
    // failure must NEVER roll back the main business transaction.

    procedure CreateLogEntry(
        pRecAsset: Record "AST Company Asset";
        // FIX: Changed from 'var' to value parameter.
        // The original code passed by reference (var) but never modified the record.
        // Passing by value is correct here — we only READ the Asset No. from it.
        // Passing by var unnecessarily prevents callers from passing temp records
        // and creates a misleading signature (callers think the record may change).
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
        lRecLogEntry."Transaction Type" := pEnumTransactionType;
        lRecLogEntry."Document No." := pCodDocumentNo;
        lRecLogEntry."Employee No." := pCodEmployeeNo;
        lRecLogEntry."Employee Name" := CopyStr(pTxtEmployeeName, 1, 100);
        lRecLogEntry."Asset Status Before" := pEnumStatusBefore;
        lRecLogEntry."Asset Status After" := pEnumStatusAfter;
        lRecLogEntry.Insert(true);
        // OnInsert handles: Entry No. (with LockTable), Log Date, Log Time, Created By
    end;
}
