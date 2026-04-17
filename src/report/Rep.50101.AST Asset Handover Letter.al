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
            RequestFilterFields = "No.", "Employee No.";

            column(No_; "No.") { }
            column(Employee_No_; "Employee No.") { }
            column(Employee_Name; "Employee Name") { }
            column(Assignment_Date; "Assignment Date") { }
            column(Expected_Return_Date; "Expected Return Date") { }
            // FIX: These 4 columns were missing from the original report.
            // A handover letter is a legal document — it MUST include:
            // Department (to identify the business unit),
            // Purpose (reason for assignment),
            // Posted By (who authorised the handover),
            // Posting Date (official date of record).
            column(Department; Department) { }
            column(Purpose; Purpose) { }
            column(Posting_Date; "Posting Date") { }
            column(Posted_By; "Posted By") { }

            dataitem(Lines; "AST Posted Assignment Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(Asset_No_; "Asset No.") { }
                column(Asset_Description; "Asset Description") { }
                column(Serial_No_; "Serial No.") { }
                column(Category_Code; "Category Code") { }
                column(Condition_at_Handover; "Condition at Handover") { }
                column(Notes; Notes) { }
                // Added Notes — condition notes are important for dispute resolution
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
                }
            }
        }
    }

    rendering
    {
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = 'RDL/src/reportlayout/ASTAssetHandoverLetter.rdl';
        }
    }
}
