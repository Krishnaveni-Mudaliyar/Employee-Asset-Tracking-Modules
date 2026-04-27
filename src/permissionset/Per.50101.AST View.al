permissionset 50101 "AST-VIEW"
{
    Assignable = true;
    Caption = 'AST-View Only (Read Access)';

    Permissions =
        tabledata "AST Asset Tracking Setup" = R,
        tabledata "AST Asset Category" = R,
        tabledata "AST Company Asset" = R,
        tabledata "AST Asset Assignment Header" = R,
        tabledata "AST Asset Assignment Line" = R,
        tabledata "AST Posted Assignment Header" = R,
        tabledata "AST Posted Assignment Line" = R,
        tabledata "AST Asset Log Entry" = R,

        page "AST Asset Category List" = X,
        page "AST Asset Category Card" = X,
        page "AST Company Asset List" = X,
        page "AST Company Asset Card" = X,
        page "AST Asset Assignment List" = X,
        page "AST Asset Assignment" = X,
        page "AST Assignment Lines Subpage" = X,

        page "AST Posted Assignment List" = X,
        page "AST Posted Assignment" = X,
        page "AST Posted Assign Line Subpage" = X,
        page "AST Asset History Factbox" = X,
        page "AST Employee Asset Factbox" = X,
        page "AST Asset Tracking Role Center" = X,

        report "AST Asset Register" = X,
        report "AST Asset Handover Letter" = X,
        report "AST Employee Asset Summary" = X,
        report "AST Asset History" = X;
}
