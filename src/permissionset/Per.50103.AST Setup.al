permissionset 50103 "AST-Setup"
{
    Assignable = true;
    Caption = 'Asset Tracking - Setup';

    Permissions =
        table "AST Asset Tracking Setup" = X,
        tabledata "AST Asset Tracking Setup" = RIMD,
        table "AST Asset Category" = X,
        tabledata "AST Asset Category" = RIMD,
        table "AST Company Asset" = X,
        tabledata "AST Company Asset" = R,
        table "AST Asset Assignment Header" = X,
        tabledata "AST Asset Assignment Header" = R,
        table "AST Asset Assignment Line" = X,
        tabledata "AST Asset Assignment Line" = R,
        table "AST Posted Assignment Header" = X,
        tabledata "AST Posted Assignment Header" = R,
        table "AST Posted Assignment Line" = X,
        tabledata "AST Posted Assignment Line" = R,
        table "AST Asset Log Entry" = X,
        tabledata "AST Asset Log Entry" = R,

        page "AST Asset Tracking Setup" = X,
        page "AST Asset Category List" = X,
        page "AST Asset Category Card" = X,
        page "AST Company Asset List" = X,
        page "AST Asset Tracking Role Center" = X,
        codeunit "AST Install" = X,
        report "AST Asset Register" = X;
}
