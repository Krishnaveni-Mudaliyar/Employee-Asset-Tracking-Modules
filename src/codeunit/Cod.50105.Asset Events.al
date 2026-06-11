codeunit 50105 "Asset Events"
{

    [IntegrationEvent(false, false)]
    procedure OnBeforePostAssetAssignment(
        var pRecHeader: Record "Asset Assignment Header"; var pBolHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterPostAssetAssignment(var pRecPostedHeader: Record "Posted Assignment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeProcessReturn(var pRecPostedHeader: Record "Posted Assignment Header";
     var pBolHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterProcessReturn(var pRecPostedHeader: Record "Posted Assignment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnAssetStatusChanged(var pRecAsset: Record "Company Asset"; pEnumOldStatus: Enum "Asset Status"; pEnumNewStatus: Enum "Asset Status")
    begin
    end;
}