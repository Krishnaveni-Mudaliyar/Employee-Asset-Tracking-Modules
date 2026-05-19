// Extends AST-ADMIN with all new objects added in v2.0 patch.
permissionsetextension 50100 "AST-ADMIN Ext" extends "AST-ADMIN"
{
    Permissions =
        // New tables
        tabledata "AST Asset Reservation"        = RIMD,
        tabledata "AST Asset Transfer Header"    = RIMD,
        tabledata "AST Asset Transfer Line"      = RIMD,
        table      "AST Asset Reservation"       = X,
        table      "AST Asset Transfer Header"   = X,
        table      "AST Asset Transfer Line"     = X,
        // New pages
        page       "AST Power BI Asset List"      = X,
        page       "AST Power BI Assignments"     = X,
        page       "AST Power BI Assignment Lines"= X,
        page       "AST Power BI Audit Log"       = X,
        page       "AST Asset Reservation List"   = X,
        page       "AST Asset Reservation Card"   = X,
        page       "AST Asset Transfer List"      = X,
        page       "AST Asset Transfer Card"      = X,
        page       "AST Asset Transfer Subform"   = X,
        // New codeunits
        codeunit   "AST Overdue Management"       = X,
        codeunit   "AST Email Mgt"                = X,
        codeunit   "AST Install Additions"        = X,
        codeunit   "AST Depreciation Batch"       = X,
        codeunit   "AST Asset Transfer Mgt"       = X,
        codeunit   "AST Return Enrichment"        = X,
        // New reports
        report     "AST Asset Depreciation Schedule" = X,
        report     "AST Warranty Expiry Report"   = X,
        report     "AST Asset QR Label"           = X,
        // New queries
        query      "AST PBI Asset Query"          = X,
        query      "AST PBI Assignment Query"     = X,
        // New xmlport
        xmlport    "AST Asset CSV Import Full"    = X;
}
