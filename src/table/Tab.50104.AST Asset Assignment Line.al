table 50104 "AST Asset Assignment Line"
{
    Caption = 'Asset Assignment Line';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
            TableRelation = "AST Asset Assignment Header";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(3; "Asset No."; Code[20])
        {
            Caption = 'Asset No';
            DataClassification = CustomerContent;
            TableRelation = "AST Company Asset";

            trigger OnValidate()
            var
                lRecAsset: Record "AST Company Asset";

            begin
                if "Asset No." = '' then exit;

                lRecAsset.Get("Asset No.");

                if lRecAsset.Status <> lRecAsset.Status::Available then
                    Error('Asset %1 is not available. Current status: %2', "Asset No.", lRecAsset.Status);
            end;
        }
        field(4; "Asset Description"; Text[100])
        {
            Caption = 'Asset Description';
            FieldClass = FlowField;
            CalcFormula = Lookup("AST Company Asset".Description
where("No." = field("Asset No.")));
        }
        field(5; "Serial No."; Text[50])
        {
            Caption = 'Serial No.';
            FieldClass = FlowField;
            CalcFormula = Lookup("AST Company Asset"."Serial No."
            where("No." = field("Asset No.")));
        }
        field(6; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            FieldClass = FlowField;
            CalcFormula = Lookup("AST Company Asset"."Category Code"
            where("No." = field("Category Code")));
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

    trigger OnInsert()
    begin
        if "Line No." = 0 then
            "Line No." := GetNextLineNo();
    end;

    local procedure GetNextLineNo(): Integer
    var
        lRecLine: Record "AST Asset Assignment Line";
    begin
        lRecLine.SetRange("Document No.", "Document No.");
        if lRecLine.FindLast() then
            exit(lRecLine."Line No." + 10000)
        else
            exit(10000);
    end;
}