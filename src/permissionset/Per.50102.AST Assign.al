permissionset 50102 "AST-Assign"
{
    Assignable = true;
    Caption = 'Asset Tracking - Assign';


    Permissions =
        table "AST Asset Tracking Setup" = X,
        tabledata "AST Asset Tracking Setup" = R,
        table "AST Asset Category" = X,
        tabledata "AST Asset Category" = R,
        table "AST Company Asset" = X,
        tabledata "AST Company Asset" = RIMD,
        table "AST Asset Assignment Header" = X,
        tabledata "AST Asset Assignment Header" = RIMD,
        table "AST Asset Assignment Line" = X,
        tabledata "AST Asset Assignment Line" = RIMD,
        table "AST Posted Assignment Header" = X,
        tabledata "AST Posted Assignment Header" = R,
        table "AST Posted Assignment Line" = X,
        tabledata "AST Posted Assignment Line" = R,
        table "AST Asset Log Entry" = X,
        tabledata "AST Asset Log Entry" = RI,

        page "AST Asset Category List" = X,
        page "AST Company Asset List" = X,
        page "AST Company Asset Card" = X,
        page "AST Asset Assignment List" = X,
        page "AST Asset Assignment" = X,
        page "AST Assignment Lines Subpage" = X,
        page "AST Posted Assignment List" = X,
        page "AST Posted Assignment" = X,
        page "AST Asset History Factbox" = X,
        page "AST Asset Tracking Role Center" = X,
        codeunit "AST Asset Validation" = X,
        codeunit "AST Asset Posting Mgt." = X,
        codeunit "AST Asset Return Mgt." = X,
        codeunit "AST Asset Log Mgt." = X,
        report "AST Asset Register" = X,
        report "AST Asset Handover Letter" = X;
}
