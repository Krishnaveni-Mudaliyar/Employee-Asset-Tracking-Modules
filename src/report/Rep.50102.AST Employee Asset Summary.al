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
            column(Employee_FirstName; "First Name") { }
            column(Employee_LastName; "Last Name") { }
            // FIX: Cannot use expressions in column() — must be single field references.
            // Concatenate First + Last name in the RDLC layout expression:
            // =Fields!Employee_FirstName.Value & " " & Fields!Employee_LastName.Value
            column(Department; "Global Dimension 1 Code") { }
            column(Employee_Email; "Company E-Mail") { }

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
            Type = RDLC;
            Caption = 'Employee Asset Summary (RDLC)';
            LayoutFile = 'src/reportlayout/AssetHistory.rdl';
        }
    }
}
