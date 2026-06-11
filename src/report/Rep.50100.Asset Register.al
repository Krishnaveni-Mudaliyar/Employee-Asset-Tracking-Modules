report 50100 "Asset Register"
{
    Caption = 'Asset Register';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem("Company Asset"; "Company Asset")
        {
            RequestFilterFields = Status, "Category Code";

            column(No_; "No.") { }
            column(Description; Description) { }
            column(Category_Code; "Category Code") { }
            column(Status; Status) { }
            column(Condition; Condition) { }
            column(Purchase_Date; "Purchase Date") { }
            column(Purchase_Price; "Purchase Price") { }
            column(AssignedEmployee; "Assigned to Employee No.") { }
            column(Serial_No_; "Serial No.") { }

            trigger OnPreDataItem()
            begin
                if (GetFilter(Status) = '') and (StatusFilter.AsInteger() > 0) then
                    SetRange(Status, StatusFilter);
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
    }
    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = 'src/reportlayout/RDL/ASTAssetRegister.rdl';
        }
        layout(WordLayout)
        {
            Type = Word;
            LayoutFile = 'src/reportlayout/WORD/ASTAssetRegister.docx';
        }
    }
    var
        StatusFilter: Enum "Asset Status";
}