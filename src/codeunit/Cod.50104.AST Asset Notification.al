codeunit 50104 "AST Asset Notification"
{
    // OnRun is required for Job Queue execution.
    // The Job Queue calls the codeunit by ID and fires OnRun.
    // Without OnRun the Job Queue entry runs but nothing happens.
    trigger OnRun()
    begin
        SendOverdueNotification();
        SendWarrantyExpiryNotification();
    end;

    procedure SendOverdueNotification()
    var
        lRecPostedHeader: Record "AST Posted Assignment Header";
        lRecSetup: Record "AST Asset Tracking Setup";
        lNotification: Notification;
    begin
        lRecSetup.Get();
        if not lRecSetup."Send Email Notification" then
            exit;

        // FIX: Overdue check must query AST Posted Assignment Header
        // where Expected Return Date < Today and Transaction Type = Assignment.
        // The original code was filtering "Last Assignment Date" on Company Asset
        // which checks assignment date not the expected RETURN date — wrong field.
        lRecPostedHeader.SetRange("Transaction Type",
            lRecPostedHeader."Transaction Type"::Assignment);
        lRecPostedHeader.SetFilter("Expected Return Date", '<>%1&<%2', 0D, Today);

        if lRecPostedHeader.FindSet() then
            repeat
                lNotification.Id := CreateGuid();
                lNotification.Message := StrSubstNo(
                    'Assignment %1 for employee %2 is overdue for return. Expected: %3.',
                    lRecPostedHeader."No.",
                    lRecPostedHeader."Employee No.",
                    lRecPostedHeader."Expected Return Date");
                lNotification.Scope := NotificationScope::LocalScope;
                lNotification.Send();
            until lRecPostedHeader.Next() = 0;
    end;

    procedure SendWarrantyExpiryNotification()
    var
        lRecAsset: Record "AST Company Asset";
        lNotification: Notification;
        lDatWarningDate: Date;
    begin
        // Warn 30 days before warranty expires
        lDatWarningDate := CalcDate('<+30D>', Today);

        lRecAsset.SetLoadFields("No.", "Warranty Expiry Date");
        lRecAsset.SetFilter("Warranty Expiry Date", '>=%1&<=%2', Today, lDatWarningDate);

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
