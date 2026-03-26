table 50100 "AST Asset Tracking Setup"
{
    Caption = 'AST Asset Tracking Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Asset ID"; Code[20])
        {
            Caption = '';
        }
    }
    keys
    {
        key(PK; "Asset ID")
        {
            Clustered = true;
        }
    }
}
