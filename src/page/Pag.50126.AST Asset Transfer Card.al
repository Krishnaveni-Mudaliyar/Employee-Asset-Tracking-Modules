page 50126 "AST Asset Transfer Card"
{
    PageType = Document;
    SourceTable = "AST Asset Transfer Header";
    Caption = 'Asset Transfer';
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("From Employee No."; Rec."From Employee No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        lEmp: Record Employee;
                    begin
                        if lEmp.Get(Rec."From Employee No.") then begin
                            Rec."From Employee Name" := CopyStr(lEmp."First Name" + ' ' + lEmp."Last Name", 1, 100);
                            Rec."From Department" := lEmp."Global Dimension 1 Code";
                        end;
                    end;
                }
                field("From Employee Name"; Rec."From Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("To Employee No."; Rec."To Employee No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        lEmp: Record Employee;
                    begin
                        if lEmp.Get(Rec."To Employee No.")
                        then
                            Rec."To Employee Name" := CopyStr(lEmp."First Name" + ' ' + lEmp."Last Name", 1, 100);
                    end;
                }
                field("To Employee Name"; Rec."To Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("To Department"; Rec."To Department")
                {
                    ApplicationArea = All;
                }
                field("Transfer Date"; Rec."Transfer Date")
                {
                    ApplicationArea = All;
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Approval Date"; Rec."Approval Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part(Lines; "AST Asset Transfer Subform")
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
            action(Approve)
            {
                Caption = 'Approve Transfer';
                ApplicationArea = All;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = Rec.Status = Rec.Status::Open;
                trigger OnAction()
                var
                    lMgt: Codeunit "AST Asset Transfer Mgt";
                begin
                    lMgt.ApproveTransfer(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(Complete)
            {
                Caption = 'Complete Transfer';
                ApplicationArea = All;
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = Rec.Status = Rec.Status::Approved;
                trigger OnAction()
                var
                    lMgt: Codeunit "AST Asset Transfer Mgt";
                begin
                    if not Confirm('Complete transfer %1? Assets will be moved to %2.', true, Rec."No.", Rec."To Employee Name")
                    then
                        exit;
                    lMgt.CompleteTransfer(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(CancelTransfer)
            {
                Caption = 'Cancel Transfer';
                ApplicationArea = All;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                Enabled = Rec.Status <> Rec.Status::Completed;
                trigger OnAction()
                var
                    lMgt: Codeunit "AST Asset Transfer Mgt";
                begin
                    lMgt.CancelTransfer(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
