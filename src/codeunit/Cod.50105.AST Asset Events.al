codeunit 50105 "AST Asset Events"
{
    // PURPOSE: Publisher events that allow other extensions to hook into
    // our module without modifying our code. This is the extensibility layer.
    //
    // HOW IT WORKS:
    // 1. We declare [IntegrationEvent] procedures here (publishers)
    // 2. Other extensions subscribe to these events using [EventSubscriber]
    // 3. When we raise the event, all subscribers are called automatically
    //
    // RULE: Publishers never contain logic. They are empty shells that
    // BC uses as "event hooks". Logic lives in subscribers.

    // Raised just before an asset assignment is posted
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
