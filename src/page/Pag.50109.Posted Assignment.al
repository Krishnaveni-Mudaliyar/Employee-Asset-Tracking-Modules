page 50109 "Posted Assignment"
{
    PageType = Document;
    SourceTable = "Posted Assignment Header";
    Caption = 'Posted Asset Assignment';
    UsageCategory = None;
    AboutTitle = 'Posted Asset Assignment';
    AboutText = 'A permanent record of a completed assignment. Use Process Return when the employee returns the assets — all listed assets will return to Available status.';
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
                    ToolTip = 'Specifies the posted assignment number.';
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
                    ToolTip = 'Specifies the date when assets were assigned.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected date for asset return.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department the asset was assigned to.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the stated purpose of this assignment.';
                    MultiLine = true;
                }
            }
            group(PostingDetails)
            {
                Caption = 'Posting Details';

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date this assignment was posted.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who posted this assignment.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this is an Assignment or Return transaction.';
                }
            }
            part(Lines; "Posted Assign Line Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(FactBoxes)
        {
            part(AssetHistory; "Asset History Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            part(EmployeeAssets; "Employee Asset Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Assigned to Employee No." = field("Employee No.");
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
                ToolTip = 'Process the return of all assets in this assignment back to Available status.';
                Enabled = IsAssignmentType;

                trigger OnAction()
                var
                    lCodReturnMgt: Codeunit "Asset Return Mgt.";
                begin
                    if not Confirm(
                        'Process return for assignment %1?\n\nAll assets will be set back to Available status.',
                        true,
                        Rec."No.")
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
                    lRecLog: Record "Asset Log Entry";
                begin
                    lRecLog.SetRange("Document No.", Rec."No.");
                    Page.Run(0, lRecLog);
                end;
            }
        }
        area(Promoted)
        {
            actionref(ProcessReturn_Promoted; ProcessReturn) { }
        }
    }
    var
        IsAssignmentType: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsAssignmentType := Rec."Transaction Type" = Rec."Transaction Type"::Assignment;
    end;
}