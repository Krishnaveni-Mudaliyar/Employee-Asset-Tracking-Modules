page 50131 "Rejection Reason Dialog"
{
    PageType = StandardDialog;
    Caption = 'Rejection Reason';

    layout
    {
        area(Content)
        {
            group(Details)
            {
                field(RejectionReason; RejectionReason)
                {
                    Caption = 'Rejection Reason';
                    ApplicationArea = All;
                    MultiLine = true;
                    Tooltip = 'Enter the reason for rejecting this customer approval';
                }
            }
        }
    }

    var
        RejectionReason: Text[500];

    procedure GetReason(): Text[500]
    begin
        exit(RejectionReason);
    end;
}
