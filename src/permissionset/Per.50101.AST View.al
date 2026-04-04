permissionset 50101 "AST-VIEW"
{
    Assignable = true;
    Caption = 'AST-VIEW';

    Permissions =
            tabledata "AST Posted Assignment Header" = R,
               tabledata "AST Asset Assignment Line" = R,
        tabledata "AST Company Asset" = R,
        tabledata "AST Asset Category" = R,
        tabledata "AST Asset Tracking Setup" = R,
        tabledata "AST Posted Assignment Line" = R,
        tabledata "AST Asset Log Entry" = R,
        tabledata "AST Asset Assignment Header" = R,
        page "AST Asset Category List" = X,
             page "AST Asset Category Card" = X,
               page "AST Company Asset List" = X,
        page "AST Company Asset Card" = X,
              page "AST Asset Assignment" = X,
             page "AST Posted Assignment List" = X,
        page "AST Posted Assignment" = X,
            page "AST Asset History Factbox" = X,
                page "AST Asset Tracking Role Center" = X,
            report "AST Asset Handover Letter" = X,
        report "AST Asset Register" = X;
}
