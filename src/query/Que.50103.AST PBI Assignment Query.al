// Power BI–optimised assignment query with date, department, category filters.
query 50103 "AST PBI Assignment Query"
{
    Caption = 'PBI Assignment Query'; QueryType = Normal;
    elements
    {
        dataitem(PHdr; "AST Posted Assignment Header")
        {
            filter(AssignDateFrom;   "Assignment Date")                 { }
            filter(AssignDateTo;     "Assignment Date")                 { }
            filter(DeptFilter;       Department)                        { }
            filter(IsOverdueFilter;  "Is Overdue")                      { }
            filter(TransTypeFilter;  "Transaction Type")                { }
            column(DocumentNo;       "No.")                             { }
            column(EmployeeNo;       "Employee No.")                    { }
            column(EmployeeName;     "Employee Name")                   { }
            column(Department;       Department)                        { }
            column(AssignmentDate;   "Assignment Date")                 { }
            column(ExpectedReturn;   "Expected Return Date")            { }
            column(ReturnDate;       "Return Date")                     { }
            column(IsOverdue;        "Is Overdue")                      { }
            column(OverdueDays;      "Overdue Days")                    { }
            column(DaysOnLoan;       "Days on Loan")                    { }
            column(PostingDate;      "Posting Date")                    { }
            dataitem(PLine; "AST Posted Assignment Line")
            {
                DataItemLink = "Document No." = PHdr."No.";
                SqlJoinType = InnerJoin;
                filter(CategoryFilter; "Category Code")                 { }
                column(AssetNo;         "Asset No.")                    { }
                column(AssetDescription;"Asset Description")            { }
                column(CategoryCode;    "Category Code")                { }
                column(CondHandover;    "Condition at Handover")        { }
                column(CondReturn;      "Condition at Return")          { }
                column(CondDegraded;    "Condition Degraded")           { }
            }
        }
    }
}
