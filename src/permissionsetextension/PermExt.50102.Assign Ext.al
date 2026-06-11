permissionsetextension 50102 "AST-ASSIGN Ext" extends "AST-ASSIGN"
{
    Permissions =
        tabledata "Asset Reservation" = RIMD,
        tabledata "Asset Transfer Header" = RIMD,
        tabledata "Asset Transfer Line" = RIMD,

        page "Asset Reservation List" = X,
        page "Asset Reservation Card" = X,
        page "Asset Transfer List" = X,
        page "Asset Transfer Card" = X,
        page "Asset Transfer Subform" = X,

        codeunit "Asset Transfer Mgt" = X,
        codeunit "Return Enrichment" = X,

        report "Asset QR Label" = X,

        xmlport "Asset CSV Import Full" = X;
}
