table 50101 "AST Asset Category"
{
    Caption = 'Asset Category';
    DrillDownPageId = "AST Asset Category List";
    LookupPageId = "AST Asset Category List";

    fields
    {
        field(1; Code; Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Category Type"; Enum "AST Asset Category Type")
        {
            Caption = 'Category Type';
            DataClassification = CustomerContent;
        }
        field(4; "Require Approval"; Boolean)
        {
            Caption = 'Require Approval';
            DataClassification = CustomerContent;
        }
        field(5; "Default Condition"; Enum "AST Asset Condition")
        {
            Caption = 'Default Condition';
            DataClassification = CustomerContent;
        }
        field(6; "No. of Assets"; Integer)
        {
            Caption = 'No. of Assets';
            FieldClass = FlowField;
            CalcFormula = Count("AST Company Asset"
                          where("Category Code" = field(Code)));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Code") { Clustered = true; }
    }
    trigger OnDelete()
    var
        lRecCompAsset: Record "AST Company Asset";
    begin
        lRecCompAsset.SetRange("Category Code", Code);
        if lRecCompAsset.FindFirst() then
            Error('You cannot delete category %1 because assets exist under it.', Code);
    end;
}