table 50105 "AST Posted Assignment Header"
{
    Caption = 'AST Posted Assignment Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Ass Header"; Code[20])
        {
            Caption = '';
        }
    }
    keys
    {
        key(PK; "Ass Header")
        {
            Clustered = true;
        }
    }
}
