codeunit 50104 "AST Asset Notification"
{
    procedure SendOverdueNotification()
    var
        lRecPostedHeader: Record "AST Posted Assignment Header";
        lRecSetup: Record "AST Asset Tracking Setup";
        lNotification: Notification;
        lIntCount: Integer;

    begin
        lRecSetup.Get();
        if not lRecSetup."Send Email Notification" then
            exit;

        lRecPostedHeader.SetRange("Transaction Type", lRecPostedHeader."Transaction Type"::Assignment);
        lRecPostedHeader.SetFilter("Expected Return Date", '<>%1&<%2', 0D, Today);
        lIntCount := lRecPostedHeader.Count();
        if lIntCount = 0 then
            exit;

        lNotification.Id := CreateGuid();
        if lIntCount = 1 then begin
            lRecPostedHeader.FindFirst();
            lNotification.Message := StrSubstNo('1 asset assignment is overdue for return. Employee: %1, Due: %2.', lRecPostedHeader."Employee No.", lRecPostedHeader."Expected Return Date");
        end else
            lNotification.Message := StrSubstNo('%1 asset assignments are overdue for return. Review the Overdue Asset Return report.', lIntCount);
        lNotification.Scope := NotificationScope::LocalScope;
        lNotification.AddAction('View Overdue Report', Codeunit::"AST Asset Notification", 'OpenOverdueReport');
        lNotification.Send();
    end;

    procedure OpenOverdueReport(pNotification: Notification)
    begin
        Report.RunModal(Report::"AST Overdue Asset Return");
    end;

    procedure SendWarrantyExpiryNotification()
    var
        lRecAsset: Record "AST Company Asset";
        lNotification: Notification;
        lDatWarningDate: Date;
        lIntCount: Integer;
    begin

        lDatWarningDate := CalcDate('<+30D>', Today);
        lRecAsset.SetLoadFields("No.", "Warranty Expiry Date");
        lRecAsset.SetFilter("Warranty Expiry Date", '>=%1&<=%2', Today, lDatWarningDate);
        lIntCount := lRecAsset.Count();
        if lIntCount = 0 then
            exit;

        lNotification.Id := CreateGuid();
        if lIntCount = 1 then begin
            lRecAsset.FindFirst();
            lNotification.Message := StrSubstNo('1 asset warranty expires within 30 days. Asset: %1, Expiry: %2.', lRecAsset."No.", lRecAsset."Warranty Expiry Date");
        end else
            lNotification.Message := StrSubstNo('%1 asset warranties expire within 30 days. Review your asset register.', lIntCount);
        lNotification.Scope := NotificationScope::LocalScope;
        lNotification.Send();
    end;
}