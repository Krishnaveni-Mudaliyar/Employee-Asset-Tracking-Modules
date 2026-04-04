permissionset 50100 "AST-ADMIN"
{
    Assignable = true;
    Caption = 'AST-ADMIN';

    Permissions =
// Tables

tabledata "AST Asset Tracking Setup" = RIMD,
 tabledata "AST Asset Category" = RIMD,
        tabledata "AST Company Asset" = RIMD,
        tabledata "AST Asset Assignment Header" = RIMD,
        tabledata "AST Asset Assignment Line" = RIMD,
        tabledata "AST Posted Assignment Header" = RIMD,
        tabledata "AST Posted Assignment Line" = RIMD,
        tabledata "AST Asset Log Entry" = RIMD,

 // Objects (Pages,Codeunit,reports)

 page "AST Asset Tracking Setup" = X,
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
        page "AST Asset Tracking Role Center" = X,
        codeunit "AST Asset Validation" = X,
        codeunit "AST Asset Posting Mgt." = X,
        codeunit "AST Asset Return Mgt." = X,
        codeunit "AST Asset Log Mgt." = X,
        codeunit "AST Asset Notification" = X,
        report "AST Asset Register" = X,
        report "AST Asset Handover Letter" = X;
}