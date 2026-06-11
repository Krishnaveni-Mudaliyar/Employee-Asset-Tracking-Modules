page 50127 "Asset Transfer Subform"
{
    PageType = ListPart;
    SourceTable = "Asset Transfer Line";
    Caption = 'Assets to Transfer';
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                }
                field("Asset Description"; Rec."Asset Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                }
                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
