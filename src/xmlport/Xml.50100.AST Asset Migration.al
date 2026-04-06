xmlport 50100 "AST Asset Migration"
{
    Caption = 'Asset Migration';
    Direction = Import;
    // Direction = Import → reads file into BC
    // Direction = Export → writes BC data to file
    // Direction = Both   → supports both
    Format = VariableText;
    // Format = VariableText → CSV format
    // Format = Xml → XML format
    // Format = Fixed → Fixed width
    FieldSeparator = ',';
    // What separates fields in CSV
    RecordSeparator = '\n';
    // What separates records (new line)
    TextEncoding = UTF8;
    // Character encoding

    schema
    {
        textelement(Root)
        //Top level Element
        {
            tableelement(CompanyAsset; "AST Company Asset")
            {
                fieldelement(Description; CompanyAsset.Description) { }
                fieldelement(CategoryCode; CompanyAsset."Category Code") { }
                fieldelement(SerialNo; CompanyAsset."Serial No.") { }
                fieldelement(PurchaseDate; CompanyAsset."Purchase Date") { }
                fieldelement(PurchasePrice; CompanyAsset."Purchase Price") { }
                fieldelement(Condition; CompanyAsset.Condition) { }

                trigger OnBeforeInsertRecord()
                var
                    lRecSetup: Record "AST Asset Tracking Setup";
                    lCodNoSeries: Codeunit "No. Series";
                begin
                    // Auto-generate asset No. on import
                    lRecSetup.Get();
                    CompanyAsset."No." := lCodNoSeries.GetNextNo(
                        lRecSetup."Asset Nos.", Today, true);

                    // Set default status for imported assets
                    CompanyAsset.Status := CompanyAsset.Status::Available;

                    // Set audit fields
                    CompanyAsset."Created By" := CopyStr(UserId(), 1, 50);
                    CompanyAsset."Created Date" := Today;
                    CompanyAsset."Last Modified By" := CopyStr(UserId(), 1, 50);
                    CompanyAsset."Last Modified Date" := Today;
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
                action(ImportAssets)
                {
                    Caption = 'Import Assets';
                    Image = Import;
                    ToolTip = 'Import company assets from a CSV file.';

                    trigger OnAction()
                    var
                        lxmlport: XmlPort "AST Asset Migration";
                    begin
                        lxmlport.Run();
                    end;
                }
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        Message('Asset import completed successfully.');
    end;



}
