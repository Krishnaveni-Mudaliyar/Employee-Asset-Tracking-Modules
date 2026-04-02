codeunit 50104 "AST Asset Notification"
{
    procedure SendOverdueNotification()
    var
        lRecAsset: Record "AST Company Asset";
        lRecSetup: Record "AST Asset Tracking Setup";
        lRecEmployee: Record Employee;
        lNotification: Notification;

    begin
        lRecSetup.Get();
        if not lRecSetup."Send Email Notification" then
            exit;

        //Find all assigned assets past return date
        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
        lRecAsset.SetFilter(
            "Last Assignment Date", '<%1', Today);

        if lRecAsset.FindSet() then
            repeat
                // Show BC notification to current user
                lNotification.Id := CreateGuid();
                lNotification.Message :=
                StrSubstNo('Asset %1 assigned to %2 is overdue for return.',
                lRecAsset."No.",
                lRecAsset."Assigned to Employee No.");
                lNotification.Scope := NotificationScope::LocalScope;
                lNotification.Send();
            until lRecAsset.Next() = 0;
    end;

    procedure SendWarrantyExpiryNotification()
    var
        lRecAsset: Record "AST Company Asset";
        lNotification: Notification;
        lDatWarningDate: Date;

    begin
        // Warn 30 days before warranty expires
        lDatWarningDate := CalcDate('<+30D>', Today);

        lRecAsset.SetFilter(
            "Warranty Expiry Date", '>=%1&<=%2',
            Today, lDatWarningDate);
        if lRecAsset.FindSet() then
            repeat
                lNotification.Id := CreateGuid();
                lNotification.Message := StrSubstNo(
                    'Asset %1 warranty expires on %2.',
                    lRecAsset."No.",
                    lRecAsset."Warranty Expiry Date");
                lNotification.Scope := NotificationScope::LocalScope;
                lNotification.Send();
            until lRecAsset.Next() = 0;
    end;
}