// Complete CSV import for Company Assets.
// Includes all original fields PLUS new extension fields:
// Location, Building, Floor/Room, Asset Tag, Depreciation Rate, Warranty Expiry.
// Direction = Both (supports export too).
// Original Xml.50100 (stub, import-only, minimal fields) is preserved.
xmlport 50101 "Asset CSV Import Full"
{
    Caption = 'Asset CSV Import / Export (Full)';
    Direction = Both;
    Format = VariableText;
    FieldSeparator = ',';
    RecordSeparator = '<NewLine>';
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement(CompanyAsset; "Company Asset")
            {
                XmlName = 'CompanyAsset';

                fieldelement(No_; CompanyAsset."No.") { }
                fieldelement(Description; CompanyAsset.Description) { }
                fieldelement(CategoryCode; CompanyAsset."Category Code") { }
                fieldelement(SerialNo; CompanyAsset."Serial No.") { }
                fieldelement(AssetTagNo; CompanyAsset."Asset Tag No.") { }
                fieldelement(Condition; CompanyAsset.Condition) { }
                fieldelement(PurchaseDate; CompanyAsset."Purchase Date") { }
                fieldelement(PurchasePrice; CompanyAsset."Purchase Price") { }
                fieldelement(DepreciationRatePct; CompanyAsset."Depreciation Rate %") { }
                fieldelement(WarrantyExpiryDate; CompanyAsset."Warranty Expiry Date") { }
                fieldelement(VendorNo; CompanyAsset."Vendor No.") { }
                fieldelement(LocationCode; CompanyAsset."Location Code") { }
                fieldelement(LocationDescription; CompanyAsset."Location Description") { }
                fieldelement(Building; CompanyAsset.Building) { }
                fieldelement(FloorRoom; CompanyAsset."Floor / Room") { }
                fieldelement(Notes; CompanyAsset.Notes) { }

                trigger OnBeforeInsertRecord()
                var
                    lSetup: Record "Asset Tracking Setup";
                    lNS: Codeunit "No. Series";
                begin
                    if CompanyAsset."No." = '' then begin
                        lSetup.Get();
                        lSetup.TestField("Asset Nos.");
                        CompanyAsset."No." := lNS.GetNextNo(lSetup."Asset Nos.", Today, true);
                    end;
                    CompanyAsset.Status := CompanyAsset.Status::Available;
                    if CompanyAsset.Condition = CompanyAsset.Condition::" " then
                        CompanyAsset.Condition := CompanyAsset.Condition::Good;
                    if CompanyAsset."Depreciation Rate %" = 0 then begin
                        lSetup.Get();
                        CompanyAsset."Depreciation Rate %" := lSetup."Default Depreciation Rate %";
                    end;
                    CompanyAsset."Book Value" := CompanyAsset."Purchase Price";
                    CompanyAsset."Created By" := CopyStr(UserId(), 1, 50);
                    CompanyAsset."Created Date" := Today;
                    CompanyAsset."Last Modified By" := CopyStr(UserId(), 1, 50);
                    CompanyAsset."Last Modified Date" := Today;
                    ImportCount += 1;
                end;

                trigger OnAfterInsertRecord()
                begin
                    InsertedCount += 1;
                end;
            }
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowResult; ShowResult) { ApplicationArea = All; Caption = 'Show Result Message'; }
                }
            }
        }
    }

    trigger OnInitXmlPort()
    begin
        ImportCount := 0;
        InsertedCount := 0;
    end;

    trigger OnPostXmlPort()
    begin
        if ShowResult then
            Message('Import complete. %1 row(s) processed, %2 inserted.', ImportCount, InsertedCount);
    end;

    var
        ImportCount: Integer;
        InsertedCount: Integer;
        ShowResult: Boolean;
}
