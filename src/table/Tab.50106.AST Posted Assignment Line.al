table 50106 "AST Posted Assignment Line"
{
    Caption = 'AST Posted ';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Ass Line"; Code[20])
        {
            Caption = '';
        }
    }
    keys
    {
        key(PK; "Ass Line")
        {
            Clustered = true;
        }
    }
}
