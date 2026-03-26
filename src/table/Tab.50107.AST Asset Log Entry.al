table 50107 "AST Asset Log Entry"
{
    Caption = 'AST Asset Log Entry';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Log ID"; Code[20])
        {
            Caption = '';
        }
    }
    keys
    {
        key(PK; "Log ID")
        {
            Clustered = true;
        }
    }
}
