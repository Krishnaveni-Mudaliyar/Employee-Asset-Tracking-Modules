table 50106 "AST Posted Assignment Line"
{
    Caption = 'Posted Assignment Line';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "AST Posted Assignment Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            DataClassification = CustomerContent;
        }
        field(4; "Asset Description"; Text[100])
        {
            Caption = 'Asset Description';
            DataClassification = CustomerContent;
        }
        field(5; "Serial No."; Text[50])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(6; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            DataClassification = CustomerContent;
        }
        field(7; "Condition at Handover"; Enum "AST Asset Condition")
        {
            Caption = 'Condition at Handover';
            DataClassification = CustomerContent;
        }
        field(8; Notes; Text[250])
        {
            Caption = 'Notes';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    begin
        Error('Posted assignments cannot be deleted.');
    end;

    trigger OnModify()
    begin
        Error('Posted assignment lines cannot be modified. They are permanent records.');
    end;
}
