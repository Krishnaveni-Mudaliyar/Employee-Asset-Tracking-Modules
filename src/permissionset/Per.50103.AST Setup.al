permissionset 50103 "AST-SETUP"
{
    Assignable = true;
    Caption = 'AST-SETUP';

    Permissions =
              tabledata "AST Asset Tracking Setup" = RIMD,
              tabledata "AST Asset Category" = RIMD,
                tabledata "AST Company Asset" = R,
            tabledata "AST Asset Assignment Header" = R,
               tabledata "AST Asset Assignment Line" = R,
             tabledata "AST Posted Assignment Header" = R,
              tabledata "AST Posted Assignment Line" = R,
               tabledata "AST Asset Log Entry" = R,

        page "AST Asset Tracking Setup" = X,
        page "AST Asset Category List" = X,
        page "AST Asset Category Card" = X,
        page "AST Company Asset List" = X,
        page "AST Asset Tracking Role Center" = X,
        codeunit "AST Install" = X,
        report "AST Asset Register" = X;
}
