codeunit 50105 "AST Asset Events"
{
    [IntegrationEvent(false, false)]
    procedure OnBeforePostAssetAssignment(
            var pRecHeader: Record "AST Asset Assignment Header";
            var pBolHandled: Boolean)
    begin
        // Empty — subscribers add logic here
    end;

    // Raised just after an asset assignment has been posted successfully
    [IntegrationEvent(false, false)]
    procedure OnAfterPostAssetAssignment(
        var pRecPostedHeader: Record "AST Posted Assignment Header")
    begin
        // Empty — subscribers add logic here
    end;

    // Raised just before an asset return is processed
    [IntegrationEvent(false, false)]
    procedure OnBeforeProcessReturn(
        var pRecPostedHeader: Record "AST Posted Assignment Header";
        var pBolHandled: Boolean)
    begin
        // Empty — subscribers add logic here
    end;

    // Raised after a return has been processed
    [IntegrationEvent(false, false)]
    procedure OnAfterProcessReturn(
        var pRecPostedHeader: Record "AST Posted Assignment Header")
    begin
        // Empty — subscribers add logic here
    end;

    // Raised when an asset status changes
    [IntegrationEvent(false, false)]
    procedure OnAssetStatusChanged(
        var pRecAsset: Record "AST Company Asset";
        pEnumOldStatus: Enum "AST Asset Status";
        pEnumNewStatus: Enum "AST Asset Status")
    begin
        // Empty — subscribers add logic here
    end;
}