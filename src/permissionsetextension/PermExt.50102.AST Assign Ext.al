permissionsetextension 50102 "AST-ASSIGN Ext" extends "AST-ASSIGN"
{
    Permissions =
        tabledata "AST Asset Reservation"        = RIMD,
        tabledata "AST Asset Transfer Header"    = RIMD,
        tabledata "AST Asset Transfer Line"      = RIMD,
        page       "AST Asset Reservation List"  = X,
        page       "AST Asset Reservation Card"  = X,
        page       "AST Asset Transfer List"     = X,
        page       "AST Asset Transfer Card"     = X,
        page       "AST Asset Transfer Subform"  = X,
        codeunit   "AST Asset Transfer Mgt"      = X,
        codeunit   "AST Return Enrichment"       = X,
        report     "AST Asset QR Label"          = X,
        xmlport    "AST Asset CSV Import Full"   = X;
}
