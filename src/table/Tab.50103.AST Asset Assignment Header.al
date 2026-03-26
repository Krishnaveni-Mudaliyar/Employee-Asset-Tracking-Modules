table 50103 "AST Asset Assignment Header"
{
    Caption = 'AST Asset Assignment Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Assignment ID"; Code[20])
        {
            Caption = '';
        }
    }
    keys
    {
        key(PK; "Assignment ID")
        {
            Clustered = true;
        }
    }
}
