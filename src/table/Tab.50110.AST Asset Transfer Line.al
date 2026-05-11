table 50110 "AST Asset Transfer Line"
{
    Caption = 'Asset Transfer Line';

    fields
    {
        field(1; "Document No.";       Code[20])                      { Caption = 'Document No.'; TableRelation = "AST Asset Transfer Header"; DataClassification = CustomerContent; }
        field(2; "Line No.";           Integer)                       { Caption = 'Line No.'; DataClassification = CustomerContent; }
        field(3; "Asset No.";          Code[20])                      { Caption = 'Asset No.'; TableRelation = "AST Company Asset"; DataClassification = CustomerContent; }
        field(4; "Asset Description";  Text[100])                     { Caption = 'Asset Description'; Editable = false; DataClassification = CustomerContent; }
        field(5; "Serial No.";         Text[50])                      { Caption = 'Serial No.'; Editable = false; DataClassification = CustomerContent; }
        field(6; "Category Code";      Code[20])                      { Caption = 'Category Code'; Editable = false; DataClassification = CustomerContent; }
        field(7; Condition;            Enum "AST Asset Condition")    { Caption = 'Condition'; DataClassification = CustomerContent; }
        field(8; Notes;                Text[250])                     { Caption = 'Notes'; DataClassification = CustomerContent; }
    }
    keys { key(PK; "Document No.", "Line No.") { Clustered = true; } key(AssetNo; "Asset No.") { } }
    trigger OnInsert()
    var lAsset: Record "AST Company Asset";
    begin
        if lAsset.Get("Asset No.") then begin
            "Asset Description" := lAsset.Description;
            "Serial No."        := lAsset."Serial No.";
            "Category Code"     := lAsset."Category Code";
            Condition           := lAsset.Condition;
        end;
    end;
}
