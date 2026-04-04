page 50117 "AST Asset Assignment API"
{
    PageType = API;
    APIPublisher = 'KrishnaveniMudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'assetAssignment';
    EntitySetName = 'assetAssignments';
    SourceTable = "AST Posted Assignment Header";
    ODataKeyFields = "No.";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(number; Rec."No.") { }
                field(employeeNo; Rec."Employee No.") { }
                field(employeeName; Rec."Employee Name") { }
                field(assignmentDate; Rec."Assignment Date") { }
                field(expectedReturnDate;
                Rec."Expected Return Date")
                { }
                field(postingDate; Rec."Posting Date") { }
                field(postedBy; Rec."Posted By") { }
                field(transactionType;
                Rec."Transaction Type")
                { }
                field(department; Rec.Department) { }
            }
        }
    }
}