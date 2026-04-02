page 50109 "AST Posted Assignment"
{
    PageType = Document;
    SourceTable = "AST Posted Assignment Header";
    Caption = 'Posted Asset Assignment';
    UsageCategory = None;

    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

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
                    ToolTip = 'Specifies the unique identifier of the posted asset assignment.';
                }

                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number associated with this assignment.';
                }

                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the employee.';
                }

                field("Assignment Date"; Rec."Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the asset was assigned.';
                }

                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected return date of the asset.';
                }

                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department to which the asset is assigned.';
                }

                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purpose of the asset assignment.';
                }
            }

            group(Posting)
            {
                Caption = 'Posting Details';

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the assignment was posted.';
                }

                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who posted the assignment.';
                }

                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of transaction recorded.';
                }
            }
            part(Lines; "AST Posted Assign Line Subpage")
            {
                SubPageLink = "Document No." = field("No.");
                ApplicationArea = All;
            }
        }
    }
}