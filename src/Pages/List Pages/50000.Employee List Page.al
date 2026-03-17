page 50000 "Employee List Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    SourceTable = "Employee Table";
    Caption = 'Employee Page';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Employee ID"; Rec."Employee ID")
                {
                    ShowMandatory = true;
                    Caption = 'Employee ID';
                }
                field(Name; Rec.Name)
                {
                    ShowMandatory = true;
                    Caption = 'Name';
                }
                field(Department; Rec.Department)
                { Caption = 'Department'; }
                field("Date Of Joining"; Rec."Date Of Joining")
                { Caption = 'Date Of Joining'; }
                field(Status; Rec.Status)
                { Caption = 'Status'; }
            }
        }
    }
}