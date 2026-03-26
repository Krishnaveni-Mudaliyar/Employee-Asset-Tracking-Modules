table 50102 "AST Company Asset"
{
    Caption = 'AST Company Asset';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Company ID"; Code[20])
        {
            Caption = '';
        }
    }
    keys
    {
        key(PK; "Company ID")
        {
            Clustered = true;
        }
    }
}
