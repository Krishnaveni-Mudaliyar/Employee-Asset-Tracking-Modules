permissionset 50103 "AST-SETUP"
{
    Assignable = true;
    Caption = 'AST - Setup (Administration Access)';

    Permissions =
        tabledata "Asset Tracking Setup" = RIMD,
        tabledata "Asset Category" = RIMD,
        tabledata "Company Asset" = R,
        tabledata "Asset Assignment Header" = R,
        tabledata "Asset Assignment Line" = R,
        tabledata "Posted Assignment Header" = R,
        tabledata "Posted Assignment Line" = R,
        tabledata "Asset Log Entry" = R,

        page "Asset Tracking Setup" = X,
        page "Asset Category List" = X,
        page "Asset Category Card" = X,
        page "Company Asset List" = X,
        page "Asset Tracking Role Center" = X,

        codeunit "Install" = X,

        report "Asset Register" = X,

        xmlport "Asset Migration" = X;
}
