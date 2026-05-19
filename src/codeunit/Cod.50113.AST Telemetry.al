codeunit 50113 "AST Telemetry"
{
    procedure LogAssetAssigned(pCodAssetNo: Code[20]; pCodEmployeeNo: Code[20]; pCodDocumentNo: Code[20])
    var
        lDimensions: Dictionary of [Text, Text];
    begin
        lDimensions.Add('AssetNo', pCodAssetNo);
        lDimensions.Add('EmployeeNo', pCodEmployeeNo);
        lDimensions.Add('DocumentNo', pCodDocumentNo);
        lDimensions.Add('Company', CompanyName());
        lDimensions.Add('User', UserId());

        Session.LogMessage('AST-ASSIGN-001', StrSubstNo('Asset %1 assigned to employee %2 via document %3.', pCodAssetNo, pCodEmployeeNo, pCodDocumentNo), Verbosity::Normal, DataClassification::OrganizationIdentifiableInformation, TelemetryScope::ExtensionPublisher, lDimensions);
    end;

    procedure LogAssetReturned(pCodAssetNo: Code[20]; pCodEmployeeNo: Code[20]; pCodDocumentNo: Code[20])
    var
        lDimensions: Dictionary of [Text, Text];
    begin
        lDimensions.Add('AssetNo', pCodAssetNo);
        lDimensions.Add('EmployeeNo', pCodEmployeeNo);
        lDimensions.Add('DocumentNo', pCodDocumentNo);
        lDimensions.Add('Company', CompanyName());

        Session.LogMessage('AST-RETURN-001', StrSubstNo('Asset %1 returned from employee %2 via document %3.', pCodAssetNo, pCodEmployeeNo, pCodDocumentNo), Verbosity::Normal, DataClassification::OrganizationIdentifiableInformation, TelemetryScope::ExtensionPublisher, lDimensions);
    end;

    procedure LogPostingError(pCodDocumentNo: Code[20]; pTxtError: Text)
    var
        lDimensions: Dictionary of [Text, Text];
    begin
        lDimensions.Add('DocumentNo', pCodDocumentNo);
        lDimensions.Add('ErrorMessage', CopyStr(pTxtError, 1, 250));
        lDimensions.Add('User', UserId());

        Session.LogMessage('AST-ERROR-001', StrSubstNo('Posting error on assignment %1: %2', pCodDocumentNo, pTxtError), Verbosity::Error, DataClassification::OrganizationIdentifiableInformation, TelemetryScope::ExtensionPublisher, lDimensions);
    end;

    procedure LogImportCompleted(pIntRecordCount: Integer)
    var
        lDimensions: Dictionary of [Text, Text];
    begin
        lDimensions.Add('RecordCount', Format(pIntRecordCount));
        lDimensions.Add('ImportedBy', UserId());
        lDimensions.Add('Company', CompanyName());

        Session.LogMessage('AST-IMPORT-001', StrSubstNo('%1 assets imported successfully.', pIntRecordCount), Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, lDimensions);
    end;
}