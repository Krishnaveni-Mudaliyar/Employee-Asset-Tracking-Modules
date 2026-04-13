page 50106 "AST Asset Assignment"
{
    PageType = Document;
    SourceTable = "AST Asset Assignment Header";
    Caption = 'Asset Assignment';
    UsageCategory = None;

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
                    ToolTip = 'Specifies the unique number of asset assignment.';
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
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset assignment date.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected return date.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department with whom you are assigned the asset.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purpose of assigning the asset.';
                    MultiLine = true;
                }
            }
            group("Status group")
            {
                Caption = 'Status';
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of asset assignment.';
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current approval status of the assignment.';
                    Editable = false;
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
                ToolTip = 'Posts the asset assignment document.';
                Enabled = IsOpen;

                trigger OnAction()
                var
                    lCodPostingMgt: Codeunit "AST Asset Posting Mgt.";
                begin
                    if not Confirm('Post assignment %1?', true, Rec."No.")
                    then
                        exit;
                    lCodPostingMgt.PostAssetAssignment(Rec);
                    Message('Assignment %1 posted successfully.', Rec."No.");
                    CurrPage.Close();
                end;
            }
            action(SendForApproval)
            {
                Caption = 'Send for Approval';
                Image = SendApprovalRequest;
                ApplicationArea = All;
                ToolTip = 'Sends the assignment for manager approval.';
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
                ToolTip = 'Approve the assignment for posting.';
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
                ToolTip = 'View audit log enteries related to this assignment.';

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
            actionref(SendForApproval_promoted; SendForApproval) { }
        }
    }
    var
        IsOpen: Boolean;
        IsPendingApproval: Boolean;
        ApprovalStyle: Text;

    trigger OnAfterGetRecord()
    begin
        IsOpen := Rec.Status = Rec.Status::Open;
        IsPendingApproval := Rec."Approval Status" = Rec."Approval Status"::PendingApproval;

        case Rec."Approval Status" of
            Rec."Approval Status"::Approved:
                ApprovalStyle := 'Favorable';
            Rec."Approval Status"::Rejected:
                ApprovalStyle := 'UnFavorable';
            Rec."Approval Status"::PendingApproval:
                ApprovalStyle := 'Ambiguous';
            else
                ApprovalStyle := 'None';
        end;
    end;
}
