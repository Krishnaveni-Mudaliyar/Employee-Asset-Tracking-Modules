page 50110 "AST Posted Assign Line Subpage"
{
    PageType = ListPart;
    SourceTable = "AST Posted Assignment Line";
    Caption = 'Lines';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique number of the asset.';
                }
                field("Asset Description"; Rec."Asset Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset description.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial number of the asset.';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category code of the asset.';
                }
                field("Condition at Handover"; Rec."Condition at Handover")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the condition at handover of the asset.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Notes of the asset.';
                    MultiLine = true;
                }
            }
        }
    }
}