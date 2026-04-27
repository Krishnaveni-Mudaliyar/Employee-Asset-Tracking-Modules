xmlport 50100 "AST Asset Migration"
{
    Caption = 'Asset Migration';
    Direction = Import;
    Format = VariableText;
    FieldSeparator = ',';
    RecordSeparator = '\n';
    TextEncoding = UTF8;

    schema
    {
        textelement(Root)
        {
            tableelement(CompanyAsset; "AST Company Asset")
            {
                fieldelement(No; CompanyAsset."No.") { }
                fieldelement(Description; CompanyAsset.Description) { }
                fieldelement(CategoryCode; CompanyAsset."Category Code") { }
                fieldelement(SerialNo; CompanyAsset."Serial No.") { }
                fieldelement(PurchaseDate; CompanyAsset."Purchase Date") { }
                fieldelement(PurchasePrice; CompanyAsset."Purchase Price") { }
                fieldelement(Condition; CompanyAsset.Condition) { }

                trigger OnBeforeInsertRecord()
                begin
                    CompanyAsset.Status := CompanyAsset.Status::Available;

                    CompanyAsset."Created By" := CopyStr(UserId(), 1, 50);
                    CompanyAsset."Created Date" := Today;
                    CompanyAsset."Last Modified By" := CopyStr(UserId(), 1, 50);
                    CompanyAsset."Last Modified Date" := Today;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        Message('Asset import completed successfully.');
    end;
}