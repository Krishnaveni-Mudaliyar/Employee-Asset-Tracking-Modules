page 50104 "AST Company Asset Card"
{
    PageType = Card;
    SourceTable = "AST Company Asset";
    Caption = 'Company Asset';
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document no.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category description.';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category code.';
                }
                field("Category Description"; Rec."Category Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category description.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial no..';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status.';
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the condition.';
                }
                field("Warranty Expiry Date"; Rec."Warranty Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the warranty expiry date.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor no.';
                }


            }
            group(Assignment)
            {
                Caption = 'Assignment Information';

                field("Assigned to Employee No."; Rec."Assigned to Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assigned to employee no..';
                }
                field("Assigned to Employee Name"; Rec."Assigned to Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assigned to employee name.';
                }
                field("Last Assignment Date"; Rec."Last Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last assignment date.';
                }


            }
            group(Purchase)
            {
                Caption = 'Purchase Details';

                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase date.';
                }
                field("Purchase Price"; Rec."Purchase Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase price.';
                }
            }
            group(Note)
            {
                Caption = 'Notes';

                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the notes.';
                }

            }
            group(Audit)
            {
                Caption = 'Audit Information';

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the created by.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the created date.';
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the modified by.';
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the modified date.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CreateAssignment)
            {
                Caption = 'Create Assignment';
                Image = Allocations;
                ApplicationArea = All;
                ToolTip = 'Creates a new assignment for this asset.';
                Enabled = IsAvailable;
                trigger OnAction()
                begin

                end;
            }
        }
    }
    var
        IsAssigned: Boolean;
        IsAvailable: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsAssigned := Rec.Status = Rec.Status::Assigned;
        IsAvailable := Rec.Status = Rec.Status::Available;
    end;

}
