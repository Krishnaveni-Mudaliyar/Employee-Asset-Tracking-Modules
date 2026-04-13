report 50103 "AST Overdue Asset Return"
{
    Caption = 'Overdue Asset Return';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem(PostedHeader; "AST Posted Assignment Header")
        {
            // Filter to only Assignment type records where expected return has passed
            DataItemTableView = where("Transaction Type" = const(Assignment));
            RequestFilterFields = "Employee No.", Department;

            column(DocNo; "No.") { }
            column(Employee_No; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(Assignment_Date; "Assignment Date") { }
            column(Expected_Return_Date; "Expected Return Date") { }
            column(Department; Department) { }
            column(Days_Overdue; Today - "Expected Return Date") { }

            dataitem(PostedLine; "AST Posted Assignment Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Asset_No; "Asset No.") { }
                column(Asset_Description; "Asset Description") { }
                column(Serial_No; "Serial No.") { }
                column(Category_Code; "Category Code") { }
            }

            trigger OnPreDataItem()
            begin
                // Only show records where Expected Return Date is in the past
                SetFilter("Expected Return Date", '<%1', Today);
                SetFilter("Expected Return Date", '<>%1', 0D);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    Caption = 'Options';
                    field(AsOfDate; AsOfDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Overdue As Of';
                        ToolTip = 'Specifies the date to check overdue assets against. Defaults to today.';
                    }
                }
            }
        }
    }

    rendering
    {
        layout(RDLCLayout)
        {
            LayoutFile = '.src/reportlayout/OverdueAssetReturn.rdl';
            Type = RDLC;
            Caption = 'Overdue Asset Return (RDLC)';
        }
    }

    var
        AsOfDate: Date;

    trigger OnInitReport()
    begin
        AsOfDate := Today;
    end;
}
