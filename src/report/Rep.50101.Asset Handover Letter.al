report 50101 "Asset Handover Letter"
{
    Caption = 'Asset Handover Letter';
    UsageCategory = Documents;
    ApplicationArea = All;
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem(Header; "Posted Assignment Header")
        {
            RequestFilterFields = "No.", "Employee No.";

            column(No_; "No.") { }
            column(Employee_No_; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(Assignment_Date; "Assignment Date") { }
            column(Expected_Return_Date; "Expected Return Date") { }
            column(Department; Department) { }
            column(Purpose; Purpose) { }
            column(Posting_Date; "Posting Date") { }
            column(Posted_By; "Posted By") { }

            dataitem(Lines; "Posted Assignment Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Asset_No_; "Asset No.") { }
                column(Asset_Description; "Asset Description") { }
                column(Serial_No_; "Serial No.") { }
                column(Category_Code; "Category Code") { }
                column(Condition_at_Handover; "Condition at Handover") { }
                column(Notes; Notes) { }
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
                { Caption = 'Filters'; }
            }
        }
    }

    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = 'src/reportlayout/RDL/ASTAssetHandoverLetter.rdl';
        }
        layout(WordLayout)
        {
            Type = Word;
            LayoutFile = 'src/reportlayout/WORD/ASTAssetHandoverLetter.docx';
        }
    }
}