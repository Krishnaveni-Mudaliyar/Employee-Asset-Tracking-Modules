codeunit 50105 "AST Asset Events"
{

    [IntegrationEvent(false, false)]
    procedure OnBeforePostAssetAssignment(
        var pRecHeader: Record "AST Asset Assignment Header"; var pBolHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterPostAssetAssignment(var pRecPostedHeader: Record "AST Posted Assignment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeProcessReturn(var pRecPostedHeader: Record "AST Posted Assignment Header";
     var pBolHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterProcessReturn(var pRecPostedHeader: Record "AST Posted Assignment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAssetStatusChanged(var pRecAsset: Record "AST Company Asset"; pEnumOldStatus: Enum "AST Asset Status"; pEnumNewStatus: Enum "AST Asset Status")
    begin
    end;
}