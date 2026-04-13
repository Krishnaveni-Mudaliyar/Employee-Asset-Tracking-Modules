report 50102 "AST Employee Asset Summary"
{
    Caption = 'Employee Asset Summary';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RDLCLayout;

    dataset
    {
        dataitem(Employee; Employee)
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code";

            column(Employee_No; "No.") { }
            column(Employee_FullName; "First Name" + ' ' + "Last Name") { }
            column(Department; "Global Dimension 1 Code") { }

            dataitem("AST Company Asset"; "AST Company Asset")
            {
                DataItemLink = "Assigned to Employee No." = field("No.");
                DataItemTableView = where(Status = const(Assigned));

                column(Asset_No; "No.") { }
                column(Asset_Description; Description) { }
                column(Asset_CategoryCode; "Category Code") { }
                column(Asset_SerialNo; "Serial No.") { }
                column(Asset_Condition; Condition) { }
                column(Asset_PurchasePrice; "Purchase Price") { }
                column(Asset_LastAssignmentDate; "Last Assignment Date") { }
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
            LayoutFile = '.src/reportlayout/AssetSummary.rdl';
            Type = RDLC;
            Caption = 'Employee Asset Summary (RDLC)';
        }
    }
}