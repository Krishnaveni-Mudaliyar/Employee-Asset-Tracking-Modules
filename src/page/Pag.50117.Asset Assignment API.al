page 50117 "Asset Assignment API"
{
    PageType = API;
    APIPublisher = 'KrishnaveniMudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'postedAssignment';
    EntitySetName = 'postedAssignments';
    SourceTable = "Posted Assignment Header";
    ODataKeyFields = "No.";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(Number; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted assignment number.';
                }
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number.';
                }
                field(EmployeeName; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name.';
                }
                field(AssignmentDate; Rec."Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assignment date.';
                }
                field(ExpectedReturnDate; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected return date.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
                field(postedBy; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who posted this assignment.';
                }
                field(transactionType; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction type.';
                }
                field(department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department.';
                }
            }
        }
    }
}