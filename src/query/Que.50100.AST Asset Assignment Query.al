query 50100 "AST Asset Assignment Query"
{
    Caption = 'Asset Assignment Query';
    QueryType = Normal;
    // Used for: Power BI, API consumers, and statistics page
    // Returns active assignments — posted header joined with posted lines

    elements
    {
        dataitem(PostedHeader; "AST Posted Assignment Header")
        {
            column(DocumentNo; "No.") { }
            column(EmployeeNo; "Employee No.") { }
            column(EmployeeName; "Employee Name") { }
            column(AssignmentDate; "Assignment Date") { }
            column(ExpectedReturnDate; "Expected Return Date") { }
            column(PostingDate; "Posting Date") { }
            column(Department; Department) { }
            column(TransactionType; "Transaction Type") { }

            dataitem(PostedLine; "AST Posted Assignment Line")
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
        // Default filter: only Assignment type (not Returns)
        SetRange(TransactionType, "AST Transaction Type"::Assignment);
    end;
}
