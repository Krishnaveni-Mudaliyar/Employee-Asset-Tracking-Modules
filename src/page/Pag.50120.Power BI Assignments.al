// OData API page for Power BI – Posted Assignment Headers with Lines.
page 50120 "Power BI Assignments"
{
    PageType = API;
    APIPublisher = 'KrishnaveniMudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'astPbiAssignment';
    EntitySetName = 'astPbiAssignments';
    SourceTable = "Posted Assignment Header";
    ODataKeyFields = "No.";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(documentNo; Rec."No.") { }
                field(employeeNo; Rec."Employee No.") { }
                field(employeeName; Rec."Employee Name") { }
                field(department; Rec.Department) { }
                field(assignmentDate; Rec."Assignment Date") { }
                field(expectedReturn; Rec."Expected Return Date") { }
                field(returnDate; Rec."Return Date") { }
                field(postingDate; Rec."Posting Date") { }
                field(transactionType; Rec."Transaction Type") { }
                field(isOverdue; Rec."Is Overdue") { }
                field(overdueDays; Rec."Overdue Days") { }
                field(daysOnLoan; Rec."Days on Loan") { }
                field(returnNotes; Rec."Return Notes") { }
                field(postedBy; Rec."Posted By") { }
                field(noOfLines; Rec."No. of Lines") { }
                part(lines; "Power BI Assignment Lines")
                {
                    EntityName = 'PBIAssignmentLine';
                    EntitySetName = 'PBIAssignmentLines';
                    SubPageLink = "Document No." = field("No.");
                }
            }
        }
    }
}
