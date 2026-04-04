permissionset 50101 "AST-View"
{
    Assignable = true;
    Caption = 'Asset Tracking - View';

    Permissions =
        table "AST Posted Assignment Header" = X,
        tabledata "AST Posted Assignment Header" = R,
        table "AST Asset Assignment Line" = X,
        tabledata "AST Asset Assignment Line" = R,
        table "AST Company Asset" = X,
        tabledata "AST Company Asset" = R,
        table "AST Asset Category" = X,
        tabledata "AST Asset Category" = R,
        table "AST Asset Tracking Setup" = X,
        tabledata "AST Asset Tracking Setup" = R,
        table "AST Posted Assignment Line" = X,
        tabledata "AST Posted Assignment Line" = R,
        table "AST Asset Log Entry" = X,
        tabledata "AST Asset Log Entry" = R,
        table "AST Asset Assignment Header" = X,
        tabledata "AST Asset Assignment Header" = R,
        page "AST Asset Category List" = X,
             page "AST Asset Category Card" = X,
        // page "AST Asset Tracking Setup" = X,
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
