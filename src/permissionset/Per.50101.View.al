permissionset 50101 "AST-VIEW"
{
    Assignable = true;
    Caption = 'AST-View Only (Read Access)';

    Permissions =
        tabledata "Asset Tracking Setup" = R,
        tabledata "Asset Category" = R,
        tabledata "Company Asset" = R,
        tabledata "Asset Assignment Header" = R,
        tabledata "Asset Assignment Line" = R,
        tabledata "Posted Assignment Header" = R,
        tabledata "Posted Assignment Line" = R,
        tabledata "Asset Log Entry" = R,

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
        page "Asset Tracking Role Center" = X,

        report "Asset Register" = X,
        report "Asset Handover Letter" = X,
        report "Employee Asset Summary" = X,
        report "Asset History" = X;

