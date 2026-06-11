query 50100 "Asset Assignment Query"
{
    Caption = 'Asset Assignment Query';
    QueryType = Normal;

    elements
    {
        dataitem(PostedHeader; "Posted Assignment Header")
        {
            column(DocumentNo; "No.") { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; "Employee Name") { }
            column(AssignmentDate; "Assignment Date") { }
            column(ExpectedReturnDate; "Expected Return Date") { }
            column(PostingDate; "Posting Date") { }
            column(Department; Department) { }
            column(TransactionType; "Transaction Type") { }

            dataitem(PostedLine; "Posted Assignment Line")
            {
                DataItemLink = "Document No." = PostedHeader."No.";

                column(AssetNo; "Asset No.") { }
                column(AssetDescription; "Asset Description") { }
                column(SerialNo; "Serial No.") { }
                column(CategoryCode; "Category Code") { }
                column(ConditionAtHandover; "Condition at Handover") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        SetRange(TransactionType, "Transaction Type"::Assignment);
    end;
}