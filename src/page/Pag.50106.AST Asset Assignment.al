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
    }
    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post';
                Image = Post;
                Enabled = lBolIsOpen;

                trigger OnAction()
                begin
                    Message('Post will be implemented in the posting codeunit session.');
                end;
            }
            action(SendApproval)
            {
                Caption = 'Send for Approval';
                ApplicationArea = All;
                Image = SendApprovalRequest;
                Enabled = lBolIsOpen;
                trigger OnAction()
                begin
                    Message('Send for Approval will be implemented in the workflow session.');
                end;
            }
        }
    }
    var
        lBolIsOpen: Boolean;

    trigger OnAfterGetRecord()
    begin
        lBolIsOpen := Rec.Status = Rec.Status::Open;
    end;
}
