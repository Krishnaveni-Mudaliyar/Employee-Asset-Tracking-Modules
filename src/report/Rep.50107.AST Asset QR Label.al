// Prints one label per asset containing No., Description, Category,
// Serial No., Asset Tag, Location and QR text string.
// RDLC layout file: src/reportlayout/RDL/ASTAssetQRLabel.rdl
// For QR rendering use BC Barcode Font library or custom RDLC image expression.

report 50107 "AST Asset QR Label"
{
    Caption = 'Asset QR / Barcode Label';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Asset; "AST Company Asset")
        {
            RequestFilterFields = "No.", "Category Code", Status;

            column(AssetNo; "No.") { }
            column(Description; Description) { }
            column(CategoryCode; "Category Code") { }
            column(SerialNo; "Serial No.") { }
            column(AssetTagNo; "Asset Tag No.") { }
            column(LocationCode; "Location Code") { }
            column(Building; Building) { }
            column(FloorRoom; "Floor / Room") { }
            column(Status; Status) { }
            column(PurchaseDate; "Purchase Date") { }
            column(QRCodeData; QRCodeDataTxt) { }
            column(CompanyName; CompanyName()) { }

            trigger OnAfterGetRecord()
            begin
                // QR data: pipe-delimited for easy scanning
                QRCodeDataTxt := CopyStr(
                    "No." + '|' + "Serial No." + '|' + "Asset Tag No." + '|' + CompanyName(),
                    1, 250);
            end;
        }
    }
    var
        QRCodeDataTxt: Text[250];
}
