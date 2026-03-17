page 50001 "Employee Card Page"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    Editable = true;
    SourceTable = "Employee Table";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Employee ID"; Rec."Employee ID")
                {
                    Caption = 'Employee ID';
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    Editable = true;
                }
                field(Department; Rec.Department)
                {
                    Caption = 'Department';
                    Editable = true;
                }
                field("Date Of Joining"; Rec."Date Of Joining")
                {
                    Caption = 'Date Of Joining';
                    Editable = true;
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                }
            }
        }
    }
}