// OData API page exposing posted assignment data enriched with department dimension
// for Power BI department-level dashboards (who has what, overdue by dept, etc.).
// Endpoint: /api/KrishnaveniMudaliyar/assetTracking/v1.0/companies({id})/astPbiDeptAssignments
page 50129 "Power BI Dept Analytics"
{
    PageType = API;
    APIPublisher = 'KrishnaveniMudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'astPbiDeptAssignment';
    EntitySetName = 'astPbiDeptAssignments';
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
                field(transactionType; Rec."Transaction Type") { }
                field(assignmentDate; Rec."Assignment Date") { }
                field(expectedReturn; Rec."Expected Return Date") { }
                field(returnDate; Rec."Return Date") { }
                field(postingDate; Rec."Posting Date") { }
                field(isOverdue; Rec."Is Overdue") { }
                field(overdueDays; Rec."Overdue Days") { }
                field(daysOnLoan; Rec."Days on Loan") { }
                field(noOfLines; Rec."No. of Lines") { }
                part(lines; "Power BI Assignment Lines")
                {
                    EntityName = 'PbiDeptAssignmentLine';
                    EntitySetName = 'PbiDeptAssignmentLines';
                    SubPageLink = "Document No." = field("No.");
                }
            }
        }
    }
}
