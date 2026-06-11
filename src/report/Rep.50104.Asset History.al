report 50104 "Asset History"
{
    Caption = 'Asset History';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem(CompanyAsset; "Company Asset")
        {
            RequestFilterFields = "No.", "Category Code", Status;

            column(Asset_No; "No.") { }
            column(Asset_Description; Description) { }
            column(Asset_CategoryCode; "Category Code") { }
            column(Asset_SerialNo; "Serial No.") { }
            column(Asset_Status; Status) { }
            column(Asset_Condition; Condition) { }
            column(Asset_PurchaseDate; "Purchase Date") { }
            column(Asset_PurchasePrice; "Purchase Price") { }

            dataitem(LogEntry; "Asset Log Entry")
            {
                DataItemLink = "Asset No." = field("No.");
                DataItemTableView = sorting("Entry No.");

                column(Log_EntryNo; "Entry No.") { }
                column(Log_TransactionType; "Transaction Type") { }
                column(Log_DocumentNo; "Document No.") { }
                column(Log_EmployeeNo; "Employee No.") { }
                column(Log_EmployeeName; "Employee Name") { }
                column(Log_Date; "Log Date") { }
                column(Log_StatusBefore; "Asset Status Before") { }
                column(Log_StatusAfter; "Asset Status After") { }
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
            LayoutFile = 'src/reportlayout/RDL/ASTAssetHistory.rdl';
        }
        layout(WordLayout)
        {
            Type = Word;
            LayoutFile = 'src/reportlayout/WORD/ASTAssetHistory.docx';
        }
    }
}