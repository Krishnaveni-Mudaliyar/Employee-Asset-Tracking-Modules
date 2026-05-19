permissionsetextension 50101 "AST-VIEW Ext" extends "AST-VIEW"
{
    Permissions =
        tabledata "AST Asset Reservation"        = R,
        tabledata "AST Asset Transfer Header"    = R,
        tabledata "AST Asset Transfer Line"      = R,
        page       "AST Power BI Asset List"     = X,
        page       "AST Power BI Assignments"    = X,
        page       "AST Power BI Assignment Lines"= X,
        page       "AST Power BI Audit Log"      = X,
        page       "AST Asset Reservation List"  = X,
        page       "AST Asset Transfer List"     = X,
        report     "AST Asset Depreciation Schedule" = X,
        report     "AST Warranty Expiry Report"  = X,
        report     "AST Asset QR Label"          = X,
        query      "AST PBI Asset Query"         = X,
        query      "AST PBI Assignment Query"    = X;
}
