xmlport 50100 "AST Asset Migration"
{
    Caption = 'Asset Migration';
    Direction = Import;
    // Direction = Import  → reads file into BC
    // Direction = Export  → writes BC data to file
    // Direction = Both    → supports both
    Format = VariableText;
    // Format = VariableText → CSV format
    // Format = Xml         → XML format
    // Format = Fixed       → Fixed width
    FieldSeparator = ',';
    // What separates fields in CSV
    RecordSeparator = '\n';
    // What separates records (new line)
    TextEncoding = UTF8;
    // Character encoding

    schema
    {
        textelement(Root)
        // Top level element — wraps all records
        {
            tableelement(CompanyAsset; "AST Company Asset")
            // Maps each CSV row to one record in AST Company Asset table
            {
                // ── IMPORTANT: No. must be FIRST so BC knows the primary key
                // before trying to insert the record.
                // The No. comes directly from the CSV — no series generation.
                fieldelement(No; CompanyAsset."No.") { }
                fieldelement(Description; CompanyAsset.Description) { }
                fieldelement(CategoryCode; CompanyAsset."Category Code") { }
                fieldelement(SerialNo; CompanyAsset."Serial No.") { }
                fieldelement(PurchaseDate; CompanyAsset."Purchase Date") { }
                fieldelement(PurchasePrice; CompanyAsset."Purchase Price") { }
                fieldelement(Condition; CompanyAsset.Condition) { }

                trigger OnBeforeInsertRecord()
                // Fires just before each row is inserted into the table.
                // No. is already filled from CSV above — do NOT generate from No. Series.
                // Only set fields that are NOT in the CSV.
                begin
                    // Default status for all imported assets
                    CompanyAsset.Status := CompanyAsset.Status::Available;

                    // Audit fields — who imported and when
                    CompanyAsset."Created By" := CopyStr(UserId(), 1, 50);
                    CompanyAsset."Created Date" := Today;
                    CompanyAsset."Last Modified By" := CopyStr(UserId(), 1, 50);
                    CompanyAsset."Last Modified Date" := Today;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    // Fires once after ALL rows have been imported successfully.
    begin
        Message('Asset import completed successfully.');
    end;
}
