page 50130 "Customer Approval List"
{
    PageType = List;
    SourceTable = "Customer Approval Request";
    Caption = 'Customer Approval Requests';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'The customer number requiring approval';
                }

                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Tooltip = 'The name of the customer';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = StatusStyle;
                    Tooltip = 'Current approval status';
                }

                field("Requested Date"; Rec."Requested Date")
                {
                    ApplicationArea = All;
                    Tooltip = 'Date when approval was requested';
                }

                field("Requested By"; Rec."Requested By")
                {
                    ApplicationArea = All;
                    Tooltip = 'User who requested the approval';
                }

                field("Approved Date"; Rec."Approved Date")
                {
                    ApplicationArea = All;
                    Tooltip = 'Date when approval was granted';
                }

                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Tooltip = 'User who approved the request';
                }

                field("Rejected Date"; Rec."Rejected Date")
                {
                    ApplicationArea = All;
                    Tooltip = 'Date when approval was rejected';
                }

                field("Rejection Reason"; Rec."Rejection Reason")
                {
                    ApplicationArea = All;
                    Tooltip = 'Reason for rejection if applicable';
                }

                field(Comments; Rec.Comments)
                {
                    ApplicationArea = All;
                    Tooltip = 'Additional comments about the approval';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Approve")
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                Tooltip = 'Approve the customer release request';

                trigger OnAction()
                var
                    Customer: Record Customer;
                    CustomerMgt: Codeunit "Customer Approval Mgt.";
                begin
                    if Rec.Status <> Rec.Status::Open then
                        Error('Only pending approvals can be approved.');

                    if Customer.Get(Rec."Customer No.") then begin
                        CustomerMgt.ApproveCustomer(Customer);
                    end else
                        Error('Customer %1 not found.', Rec."Customer No.");

                    CurrPage.Update();
                end;
            }

            action("Reject")
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                Tooltip = 'Reject the customer release request';

                trigger OnAction()
                var
                    Customer: Record Customer;
                    CustomerMgt: Codeunit "Customer Approval Mgt.";
                    RejectionReason: Text;
                begin
                    if Rec.Status <> Rec.Status::Open then
                        Error('Only pending approvals can be rejected.');

                    // Get rejection reason from user
                    if PromptForRejectionReason(RejectionReason) then begin
                        if Customer.Get(Rec."Customer No.") then begin
                            CustomerMgt.RejectCustomer(Customer, RejectionReason);
                        end else
                            Error('Customer %1 not found.', Rec."Customer No.");

                        CurrPage.Update();
                    end;
                end;
            }

            action("View Customer")
            {
                ApplicationArea = All;
                Caption = 'View Customer';
                Image = Card;
                Promoted = true;
                PromotedCategory = Process;
                Tooltip = 'Open the customer card';

                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    if Customer.Get(Rec."Customer No.") then begin
                        Page.Run(Page::"Customer Card", Customer);
                    end else
                        Error('Customer %1 not found.', Rec."Customer No.");
                end;
            }
        }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        SetStatusStyle();
    end;

    local procedure SetStatusStyle()
    begin
        case Rec.Status of
            Rec.Status::Open:
                StatusStyle := 'Ambiguous';
            Rec.Status::"Pending for Approval":
                StatusStyle := 'Favorable';
            Rec.Status::Rejected:
                StatusStyle := 'Unfavorable';
            else
                StatusStyle := '';
        end;
    end;

    local procedure PromptForRejectionReason(var RejectionReason: Text): Boolean

    begin
        RejectionReason := 'Rejected by user';
        exit(true);
    end;
}
