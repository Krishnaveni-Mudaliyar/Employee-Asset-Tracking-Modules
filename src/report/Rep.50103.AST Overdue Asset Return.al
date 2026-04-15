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
            DataItemTableView = where("Transaction Type" = const(Assignment));
            RequestFilterFields = "Employee No.", Department;

            column(DocNo; "No.") { }
            column(Employee_No; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(Assignment_Date; "Assignment Date") { }
            column(Expected_Return_Date; "Expected Return Date") { }
            column(Department; Department) { }

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
                // FIX: Two SetFilter calls on same field — second REPLACES the first.
                // Correct approach: combine both conditions in ONE filter expression.
                // '<>%1&<%2' means: not equal to 0D AND less than today
                SetFilter("Expected Return Date", '<>%1&<%2', 0D, Today);
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
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
            Type = RDLC;
            Caption = 'Overdue Asset Return (RDLC)';
            LayoutFile = '.src/reportlayout/AssetHistory.rdl';
        }
    }

    var
        AsOfDate: Date;

    trigger OnInitReport()
    begin
        AsOfDate := Today;
    end;
}
