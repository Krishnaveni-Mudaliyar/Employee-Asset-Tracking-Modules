query 50100 "AST Asset Assignment Query"
{
    Caption = 'Asset Assignment Query';
    QueryType = Normal;

    elements
    {
        dataitem(PostedHeader; "AST Posted Assignment Header")
        {
            column(DocumentNo; "No.") { }
            column(Employee_No_; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(Assignment_Date; "Assignment Date") { }
            column(Expected_Return_Date; "Expected Return Date") { }
            column(Posting_Date; "Posting Date") { }
            column(Department; Department) { }
            column(Transaction_Type; "Transaction Type") { }

            dataitem(PostedLine; "AST Posted Assignment Line")
            {
                DataItemLink = "Document No." = PostedHeader."No.";

                column(Asset_No_; "Asset No.") { }
                column(AssetDescription; "Asset Description") { }
                column(SerialNo; "Serial No.") { }
                column(CategoryCode; "Category Code") { }
                column(ConditionAtHandover; "Condition at Handover") { }
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        SetRange(Transaction_Type, "AST Transaction Type"::Assignment);
    end;
}
