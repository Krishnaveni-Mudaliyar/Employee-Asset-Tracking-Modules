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
                    MultiLine = true;
                }
            }

            group(PostingDetails)
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
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(FactBoxes)
        {
            part(SystemInfo; "System Information FactBox")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ProcessReturn)
            {
                Caption = 'Process Return';
                Image = Return;
                ApplicationArea = All;
                ToolTip = 'Process the return of all assets in this assignment. Assets will be set back to available status and a return log wntry will be created.';
                Enabled = IsAssignmentType;

                trigger OnAction()
                var
                    lCodReturnMgt: Codeunit "AST Asset Return Mgt.";
                begin
                    if not confirm(
                        'Process return for assignment %1\n\nAll %2 assets will be set back to available status.',
                        true,
                        Rec."No.",
                        Rec."No. of Lines")
                         then
                        exit;
                    lCodReturnMgt.ProcessReturn(Rec);
                    Message('Return processed successfully. Assets are now available.');
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(ViewAssetLog)
            {
                Caption = 'Asset Log';
                Image = Log;
                ApplicationArea = All;
                ToolTip = 'View all log entries related to this assignment.';

                trigger OnAction()
                var
                    lRecLog: Record "AST Asset Log Entry";
                begin
                    lRecLog.SetRange("Document No.", Rec."No.");
                    Page.Run(0, lRecLog);
                end;
            }
        }
        area(Promoted)
        {
            actionref(ProcessReturn_promoted; ProcessReturn) { }
        }
    }
    var
        IsAssignmentType: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsAssignmentType := Rec."Transaction Type" = Rec."Transaction Type"::Assignment;
    end;
}