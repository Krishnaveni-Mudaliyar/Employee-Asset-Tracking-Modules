page 50106 "AST Asset Assignment"
{
    PageType = Document;
    SourceTable = "AST Asset Assignment Header";
    Caption = 'Asset Assignment';
    UsageCategory = None;
    AboutTitle = 'Asset Assignment';
    AboutText = 'An assignment document links one or more assets to an employee. Add lines for each asset, then Post (or Send for Approval if approval is required).';

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
                    ToolTip = 'Specifies the unique number of the asset assignment.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name.';
                    Editable = false;
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of assignment.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected return date.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purpose of the assignment.';
                    MultiLine = true;
                }
            }
            group(StatusGroup)
            {
                Caption = 'Status';
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document status.';
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current approval status.';
                    Editable = false;
                    StyleExpr = ApprovalStyle;
                }
            }
            part(Lines; "AST Assignment Lines Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(FactBoxes)
        {
            part(AssetHistory; "AST Asset History Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
            part(EmployeeAssets; "AST Employee Asset Factbox")
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
            action(Post)
            {
                Caption = 'Post';
                Image = Post;
                ApplicationArea = All;
                ToolTip = 'Post the asset assignment document.';
                Enabled = IsOpen;

                trigger OnAction()
                var
                    lCodPostingMgt: Codeunit "AST Asset Posting Mgt.";
                    lCodTelemetry: Codeunit "AST Telemetry";
                begin
                    if not Confirm('Post assignment %1?', true, Rec."No.") then
                        exit;
                    if not Codeunit.Run(Codeunit::"AST Asset Posting Mgt.", Rec) then begin
                        lCodTelemetry.LogPostingError(Rec."No.", GetLastErrorText());
                        Error(GetLastErrorText());
                    end;
                    Message('Assignment %1 posted successfully.', Rec."No.");
                    CurrPage.Close();
                end;
            }
            action(SendForApproval)
            {
                Caption = 'Send for Approval';
                Image = SendApprovalRequest;
                ApplicationArea = All;
                ToolTip = 'Send this assignment to the approver for review.';
                Enabled = IsOpen;

                trigger OnAction()
                var
                    lCodPostingMgt: Codeunit "AST Asset Posting Mgt.";
                begin
                    lCodPostingMgt.SendForApproval(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Approve)
            {
                Caption = 'Approve';
                Image = Approve;
                ApplicationArea = All;
                ToolTip = 'Approve this assignment for posting.';
                Enabled = IsPendingApproval;

                trigger OnAction()
                var
                    lCodPostingMgt: Codeunit "AST Asset Posting Mgt.";
                begin
                    lCodPostingMgt.ApproveAssignment(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Reject)
            {
                Caption = 'Reject';
                Image = Reject;
                ApplicationArea = All;
                ToolTip = 'Reject this assignment request.';
                Enabled = IsPendingApproval;

                trigger OnAction()
                var
                    lCodPostingMgt: Codeunit "AST Asset Posting Mgt.";
                begin
                    lCodPostingMgt.RejectAssignment(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Navigation)
        {
            action(ViewLog)
            {
                Caption = 'Asset Log';
                Image = Log;
                ApplicationArea = All;
                ToolTip = 'View audit log entries related to this assignment.';

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
            actionref(Post_Promoted; Post) { }
            actionref(SendForApproval_Promoted; SendForApproval) { }
        }
    }

    var
        IsOpen, IsPendingApproval : Boolean;
        ApprovalStyle: Text;

    trigger OnAfterGetRecord()
    begin
        IsOpen := Rec.Status = Rec.Status::Open;
        IsPendingApproval :=
            Rec."Approval Status" = Rec."Approval Status"::PendingApproval;

        case Rec."Approval Status" of
            Rec."Approval Status"::Approved:
                ApprovalStyle := 'Favorable';
            Rec."Approval Status"::Rejected:
                ApprovalStyle := 'Unfavorable';
            Rec."Approval Status"::PendingApproval:
                ApprovalStyle := 'Ambiguous';
            else
                ApprovalStyle := 'None';
        end;
    end;
}