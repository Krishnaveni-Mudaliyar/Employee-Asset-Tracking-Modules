page 50105 "Asset Assignment List"
{
    PageType = List;
    SourceTable = "Asset Assignment Header";
    CardPageId = "Asset Assignment";
    UsageCategory = Documents;
    AboutTitle = 'Asset Assignments';
    AboutText = 'Open assignment documents waiting to be posted. Open a document to add assets, set the employee, and post the assignment.';
    Caption = 'Asset Assignment';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique number of asset assignment.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique number of employee or employee number.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name.';
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assignment date of the asset.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected return date of the asset.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the asset.';
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current approval status of the assignment.';
                }
                field("No. of Lines"; Rec."No. of Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of lines in asset assignment.';
                }
            }
        }
    }
}