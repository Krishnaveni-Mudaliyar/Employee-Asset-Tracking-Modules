pageextension 50105 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addafter(Name)
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
                Editable = false;
                StyleExpr = ApprovalStatusStyle;
            }

            field("Blocked"; Rec."Blocked")
            {
                ApplicationArea = All;
                Tooltip = 'Blocks customer from further transactions if status is not released';
            }
        }
    }

    actions
    {
        addafter("&Customer")
        {
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = Approval;

                action("Request Release")
                {
                    ApplicationArea = All;
                    Caption = 'Request Release';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Tooltip = 'Request approval to release this customer';

                    trigger OnAction()
                    var
                        CustomerMgt: Codeunit "Customer Management";
                    begin
                        if Rec."Approval Status" = Rec."Approval Status"::Released then
                            Error('This customer is already released.');

                        if Rec."Approval Status" = Rec."Approval Status"::"Pending for Approval" then
                            Error('Approval request already pending for this customer.');

                        CustomerMgt.RequestApproval(Rec);
                        CurrPage.Update();
                    end;
                }

                action("Reopen")
                {
                    ApplicationArea = All;
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;
                    Tooltip = 'Reopen released customer for editing';

                    trigger OnAction()
                    var
                        CustomerMgt: Codeunit "Customer Management";
                    begin
                        if Rec."Approval Status" <> Rec."Approval Status"::Released then
                            Error('Only released customers can be reopened.');

                        CustomerMgt.ReopenCustomer(Rec);
                        CurrPage.Update();
                    end;
                }
            }
        }
    }

    var
        ApprovalStatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        SetApprovalStatusStyle();
    end;

    local procedure SetApprovalStatusStyle()
    begin
        case Rec."Approval Status" of
            Rec."Approval Status"::Open:
                ApprovalStatusStyle := 'Subordinate';
            Rec."Approval Status"::"Pending for Approval":
                ApprovalStatusStyle := 'Ambiguous';
            Rec."Approval Status"::Released:
                ApprovalStatusStyle := 'Favorable';
        end;
    end;
}
