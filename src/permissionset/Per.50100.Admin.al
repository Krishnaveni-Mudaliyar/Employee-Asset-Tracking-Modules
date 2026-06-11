permissionset 50100 "AST-ADMIN"
{
    Assignable = true;
    Caption = 'AST - Admin (Full Access)';

    Permissions =
        tabledata "Asset Tracking Setup" = RIMD,
        tabledata "Asset Category" = RIMD,
        tabledata "Company Asset" = RIMD,
        tabledata "Asset Assignment Header" = RIMD,
        tabledata "Asset Assignment Line" = RIMD,
        tabledata "Posted Assignment Header" = RIMD,
        tabledata "Posted Assignment Line" = RIMD,
        tabledata "Asset Log Entry" = RI,

        page "Asset Tracking Setup" = X,
        page "Asset Category List" = X,
        page "Asset Category Card" = X,
        page "Company Asset List" = X,
        page "Company Asset Card" = X,
        page "Asset Assignment List" = X,
        page "Asset Assignment" = X,
        page "Assignment Lines Subpage" = X,
        page "Posted Assignment List" = X,
        page "Posted Assignment" = X,
        page "Posted Assign Line Subpage" = X,
        page "Asset History Factbox" = X,
        page "Employee Asset Factbox" = X,
        page "Asset Statistics" = X,
        page "Asset Tracking Role Center" = X,
        page "Asset Cue" = X,
        page "Company Asset API" = X,
        page "Asset Assignment API" = X,
        page "Posted Assignment API" = X,

        codeunit "Asset Validation" = X,
        codeunit "Asset Posting Mgt." = X,
        codeunit "Asset Return Mgt." = X,
        codeunit "Asset Log Mgt." = X,
        codeunit "Asset Notification" = X,
        codeunit "Asset Events" = X,
        codeunit "Install" = X,
        codeunit "Upgrade" = X,
        codeunit "Excel Export" = X,
        codeunit "Performance Helpers" = X,
        codeunit "Telemetry" = X,

        report "Asset Register" = X,
        report "Asset Handover Letter" = X,
        report "Employee Asset Summary" = X,
        report "Overdue Asset Return" = X,
        report "Asset History" = X,

        query "Asset Assignment Query" = X,
        query "Asset Statistics Query" = X,

        xmlport "Asset Migration" = X;
}
