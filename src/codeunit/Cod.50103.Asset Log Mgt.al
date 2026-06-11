codeunit 50103 "Asset Log Mgt."
{
    procedure CreateLogEntry(
      pRecAsset: Record "Company Asset";
      pEnumStatusBefore: Enum "Asset Status";
      pEnumStatusAfter: Enum "Asset Status";
      pEnumTransactionType: Enum "Transaction Type";
      pCodDocumentNo: Code[20];
      pCodEmployeeNo: Code[20];
      pTxtEmployeeName: Text[100])
    var
        lRecLogEntry: Record "Asset Log Entry";
    begin
        lRecLogEntry.Init();
        lRecLogEntry."Asset No." := pRecAsset."No.";
        lRecLogEntry."Transaction Type" := pEnumTransactionType;
        lRecLogEntry."Document No." := pCodDocumentNo;
        lRecLogEntry."Employee No." := pCodEmployeeNo;
        lRecLogEntry."Employee Name" := CopyStr(pTxtEmployeeName, 1, 100);
        lRecLogEntry."Asset Status Before" := pEnumStatusBefore;
        lRecLogEntry."Asset Status After" := pEnumStatusAfter;
        lRecLogEntry."Condition Before" := pRecAsset.Condition;
        lRecLogEntry."Condition After" := pRecAsset.Condition;
        lRecLogEntry.Insert(true);
    end;
}