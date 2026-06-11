permissionset 50102 "AST-ASSIGN"
{
    Assignable = true;
    Caption = 'AST - Assign (Assignment Access)';

    Permissions =
        tabledata "Asset Tracking Setup" = R,
        tabledata "Asset Category" = R,
        tabledata "Company Asset" = RIMD,
        tabledata "Asset Assignment Header" = RIMD,
        tabledata "Asset Assignment Line" = RIMD,
        tabledata "Posted Assignment Header" = R,
        tabledata "Posted Assignment Line" = R,
        tabledata "Asset Log Entry" = RI,

        page "Asset Category List" = X,
        page "Company Asset List" = X,
        page "Company Asset Card" = X,
        page "Asset Assignment List" = X,
        page "Asset Assignment" = X,
        page "Assignment Lines Subpage" = X,
        page "Posted Assignment List" = X,
        page "Posted Assignment" = X,
        page "Posted Assign Line Subpage" = X,
        page "Asset History Factbox" = X,
        page "Asset Tracking Role Center" = X,

        codeunit "Asset Validation" = X,
        codeunit "Asset Posting Mgt." = X,
        codeunit "Asset Return Mgt." = X,
        codeunit "Asset Log Mgt." = X,
        codeunit "Asset Events" = X,
        codeunit "Telemetry" = X,
        codeunit "Excel Export" = X,

        report "Asset Register" = X,
        report "Asset Handover Letter" = X;
}
