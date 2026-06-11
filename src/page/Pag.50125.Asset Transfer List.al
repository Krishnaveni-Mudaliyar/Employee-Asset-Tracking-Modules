page 50125 "Asset Transfer List"
{
    PageType = List;
    SourceTable = "Asset Transfer Header";
    CardPageId = "Asset Transfer Card";
    Caption = 'Asset Transfers';
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
                field("From Employee Name"; Rec."From Employee Name")
                {
                    ApplicationArea = All;
                }
                field("To Employee Name"; Rec."To Employee Name")
                {
                    ApplicationArea = All;
                }
                field("From Department"; Rec."From Department")
                {
                    ApplicationArea = All;
                }
                field("To Department"; Rec."To Department")
                {
                    ApplicationArea = All;
                }
                field("Transfer Date"; Rec."Transfer Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    StyleExpr = TrfStyle;
                }
                field("No. of Lines"; Rec."No. of Lines")
                {
                    ApplicationArea = All;
                }
                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec.Status = Rec.Status::Completed
        then
            TrfStyle := 'Favorable'
        else if Rec.Status = Rec.Status::Cancelled
        then
            TrfStyle := 'Unfavorable'
        else
            TrfStyle := 'None';
    end;

    var
        TrfStyle: Text;
}
