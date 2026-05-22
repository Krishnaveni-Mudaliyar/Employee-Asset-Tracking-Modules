page 50107 "AST Assignment Lines Subpage"
{
    PageType = ListPart;
    SourceTable = "AST Asset Assignment Line";
    Caption = 'Lines';
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique asset number.';
                }
                field("Asset Description"; Rec."Asset Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique asset description.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique serial number.';
                    Editable = false;
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category code.';
                    Editable = false;
                }
                field("Condition at Handover"; Rec."Condition at Handover")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the condition at handover of the asset.';
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the notes of the asset.';
                    MultiLine = true;
                }
            }
        }
    }
}