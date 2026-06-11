page 50123 "Asset Reservation List"
{
    PageType = List;
    SourceTable = "Asset Reservation";
    CardPageId = "Asset Reservation Card";
    Caption = 'Asset Reservations';
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Asset No."; Rec."Asset No.")
                {
                    ApplicationArea = All;
                }
                field("Asset Description"; Rec."Asset Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("From Date"; Rec."From Date")
                {
                    ApplicationArea = All;
                }
                field("To Date"; Rec."To Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = ResStyle;
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Fulfilled By Doc."; Rec."Fulfilled By Doc.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(CancelReservation)
            {
                Caption = 'Cancel Reservation';
                ApplicationArea = All;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    if Rec.Status <> Rec.Status::Active then
                        Error('Only Active reservations can be cancelled.');
                    if not Confirm('Cancel reservation %1?', true, Rec."No.")
                    then
                        exit;
                    Rec.Status := Rec.Status::Cancelled;
                    Rec.Modify(true);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::Active then
            ResStyle := 'Favorable'
        else if Rec.Status = Rec.Status::Expired then
            ResStyle := 'Unfavorable'
        else
            ResStyle := 'None';
    end;

    var
        ResStyle: Text;
}