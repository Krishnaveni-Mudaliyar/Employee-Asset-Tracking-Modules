// Extends the Role Center with navigation to new features:
// Reservations, Transfers, Power BI feeds, new reports.
pageextension 50105 "AST Role Center Ext" extends "AST Asset Tracking Role Center"
{
    actions
    {
        addlast(Sections)
        {
            group(AdvancedGroup)
            {
                Caption = 'Advanced';
                action(Reservations)
                {
                    Caption = 'Asset Reservations'; ApplicationArea = All;
                    RunObject = page "AST Asset Reservation List";
                    ToolTip = 'View and manage asset reservations.';
                }
                action(Transfers)
                {
                    Caption = 'Asset Transfers'; ApplicationArea = All;
                    RunObject = page "AST Asset Transfer List";
                    ToolTip = 'View and manage asset transfer documents.';
                }
            }
        }
        addlast(Reporting)
        {
            action(DeprecReport)
            {
                Caption = 'Depreciation Schedule'; ApplicationArea = All;
                RunObject = report "AST Asset Depreciation Schedule";
                ToolTip = 'Print asset depreciation and book value schedule.';
            }
            action(WarrantyReport)
            {
                Caption = 'Warranty Expiry Report'; ApplicationArea = All;
                RunObject = report "AST Warranty Expiry Report";
                ToolTip = 'Print assets with upcoming warranty expiry.';
            }
            action(QRLabelReport)
            {
                Caption = 'Print Asset QR Labels'; ApplicationArea = All;
                RunObject = report "AST Asset QR Label";
                ToolTip = 'Print QR/barcode identification labels for assets.';
            }
            action(FullImportXML)
            {
                Caption = 'Import Assets (Full CSV)'; ApplicationArea = All;
                RunObject = xmlport "AST Asset CSV Import Full";
                ToolTip = 'Import assets from CSV with all fields including location and depreciation.';
            }
        }
    }
}
