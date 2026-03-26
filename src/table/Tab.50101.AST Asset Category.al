table 50101 "AST Asset Category"
{
    Caption = 'AST Asset Category';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Category ID"; Code[20])
        {
            Caption = '';
        }
    }
    keys
    {
        key(PK; "Category ID")
        {
            Clustered = true;
        }
    }
}
