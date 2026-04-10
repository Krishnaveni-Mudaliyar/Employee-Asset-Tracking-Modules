permissionset 50100 "AST-ADMIN"
{
    Assignable = true;
    Caption = 'AST-ADMIN (FUll access)';

    Permissions =
        // Table Data

        tabledata "AST Asset Tracking Setup" = RIMD,
        tabledata "AST Asset Category" = RIMD,
        tabledata "AST Company Asset" = RIMD,
        tabledata "AST Asset Assignment Header" = RIMD,
        tabledata "AST Asset Assignment Line" = RIMD,
        tabledata "AST Posted Assignment Header" = RIMD,
        tabledata "AST Posted Assignment Line" = RIMD,
        tabledata "AST Asset Log Entry" = RI,

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
        page "AST Employee Asset Factbox" = X,
        page "AST Asset Statistics" = X,
        page "AST Asset Tracking Role Center" = X,
        page "AST Asset Cue" = X,
        page "AST Company Asset API" = X,
        page "AST Asset Assignment API" = X,
        page "AST Posted Assignment API" = X,

        // Codeunits
        codeunit "AST Asset Validation" = X,
        codeunit "AST Asset Posting Mgt." = X,
        codeunit "AST Asset Return Mgt." = X,
        codeunit "AST Asset Log Mgt." = X,
        codeunit "AST Asset Notification" = X,
        codeunit "AST Asset Events" = X,
        codeunit "AST Install" = X,

         // Reports
         report "AST Asset Register" = X,
        report "AST Asset Handover Letter" = X,
        report "AST Employee Asset Summary" = X,
        report "AST Overdue Asset Return" = X,
        report "AST Asset History" = X,

        //  XMLport 
        xmlport "AST Asset Migration" = X;
}