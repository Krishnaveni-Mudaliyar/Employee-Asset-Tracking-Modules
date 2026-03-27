table 50102 "AST Company Asset"
{
    Caption = 'AST Company Asset';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Category Code"; Code[20])
        {
            Caption = '';
        }
    }
    keys
    {
        key(PK; "Category Code")
        {
            Clustered = true;
        }
    }
}
