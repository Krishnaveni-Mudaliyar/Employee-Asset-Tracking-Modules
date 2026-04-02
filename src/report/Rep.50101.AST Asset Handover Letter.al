report 50101 "AST Asset Handover Letter"
{
    Caption = 'Asset Handover Letter';
    UsageCategory = Documents;
    ApplicationArea = All;
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem(Header; "AST Posted Assignment Header")
        {
            column(No_; "No.") { }
            column(Employee_No_; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(Assignment_Date; "Assignment Date") { }
            column(Expected_Return_Date; "Expected Return Date") { }

            dataitem(Lines; "AST Posted Assignment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                column(Asset_No_; "Asset No.") { }
                column(Asset_Description; "Asset Description") { }
                column(Serial_No_; "Serial No.") { }
                column(Category_Code; "Category Code") { }
                column(Condition_at_Handover; "Condition at Handover") { }
            }
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
                    Caption = 'Filters';
                    field(StatusFilter; StatusFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Status Filter';
                        ToolTip = 'Specifies the status to filter assets by.';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = 'src/reportlayout/ASTAssetHandoverLetter.rdlc';
        }
    }
    var
        StatusFilter: Enum "AST Asset Status";
}
