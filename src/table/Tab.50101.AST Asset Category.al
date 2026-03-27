table 50101 "AST Asset Category"
{
    Caption = 'AST Asset Category';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Description; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Category Type"; Enum "AST Asset Category Type")
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Require Approval"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Default Condition"; enum "AST Asset Condition")
        {
            DataClassification = ToBeClassified;
        }
        field(6; "No. of Asset"; Integer)
        {
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
