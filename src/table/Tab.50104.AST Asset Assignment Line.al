table 50104 "AST Asset Assignment Line"
{
    Caption = 'AST Asset Assignment Line';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Asset Assignment ID"; Code[20])
        {
            Caption = '';
        }
    }
    keys
    {
        key(PK; "Asset Assignment ID")
        {
            Clustered = true;
        }
    }
}
