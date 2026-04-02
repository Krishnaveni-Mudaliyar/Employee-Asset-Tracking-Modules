report 50100 "AST Asset Register"
{
    Caption = 'Asset Register';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem("Company Asset"; "AST Company Asset")
        {
            column(No_; "No.") { }
            column(Description; Description) { }
            column(Category_Code; "Category Code") { }
            column(Status; Status) { }
            column(Condition; Condition) { }
            column(Purchase_Date; "Purchase Date") { }
            column(Purchase_Price; "Purchase Price") { }
            column(AssignedEmployee; "Assigned to Employee No.") { }
            column(Serial_No_; "Serial No.") { }
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
            LayoutFile = 'src/reportlayout/ASTAssetRegister.rdlc';
        }
    }
    var
        StatusFilter: Enum "AST Asset Status";
}
