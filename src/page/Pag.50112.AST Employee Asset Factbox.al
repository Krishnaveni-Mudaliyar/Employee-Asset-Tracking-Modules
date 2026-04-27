page 50112 "AST Employee Asset Factbox"
{
    PageType = CardPart;
    Caption = 'Employee Assets';
    ApplicationArea = All;
    SourceTable = "AST Company Asset";
    Editable = false;
    AboutTitle = 'Employee Assets';
    AboutText = 'Shows a summary of assets currently assigned to this employee, total asset value, and any overdue return obligations.';

    layout
    {
        area(Content)
        {
            field(EmployeeNoDisplay; EmployeeNo)
            {
                ApplicationArea = All;
                Caption = 'Employee No.';
                ToolTip = 'Specifies the employee whose assets are shown.';
                Editable = false;
            }
            field(TotalAssignedAssets; TotalAssignedAssets)
            {
                ApplicationArea = All;
                Caption = 'Assigned Assets';
                ToolTip = 'Specifies the total number of assets currently assigned to this employee.';
                Editable = false;
                StyleExpr = 'Strong';
            }
            field(TotalAssignmentValue; TotalAssignmentValue)
            {
                ApplicationArea = All;
                Caption = 'Total Asset Value';
                ToolTip = 'Specifies the total purchase value of assets assigned to this employee.';
                Editable = false;
            }
            field(OverdueReturns; OverdueReturns)
            {
                ApplicationArea = All;
                Caption = 'Overdue Returns';
                ToolTip = 'Number of assignment documents past their expected return date for this employee.';
                Editable = false;
                StyleExpr = OverdueStyle;
            }
        }
    }

    var
        EmployeeNo: Code[20];
        TotalAssignedAssets: Integer;
        TotalAssignmentValue: Decimal;
        OverdueReturns: Integer;
        OverdueStyle: Text;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateStats();
    end;

    local procedure CalculateStats()
    var
        lRecAsset: Record "AST Company Asset";
        lRecPostedHeader: Record "AST Posted Assignment Header";
    begin
        lRecAsset.SetLoadFields("No.", "Purchase Price", Status, "Assigned to Employee No.");
        lRecAsset.SetRange("Assigned to Employee No.", Rec."No.");
        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
        TotalAssignedAssets := lRecAsset.Count();
        lRecAsset.CalcSums("Purchase Price");
        TotalAssignmentValue := lRecAsset."Purchase Price";

        lRecPostedHeader.SetRange("Employee No.", Rec."No.");
        lRecPostedHeader.SetRange("Transaction Type", lRecPostedHeader."Transaction Type"::Assignment);
        lRecPostedHeader.SetFilter("Expected Return Date", '<>%1&<%2', 0D, Today);
        OverdueReturns := lRecPostedHeader.Count();

        if OverdueReturns > 0 then
            OverdueStyle := 'Unfavorable'
        else
            OverdueStyle := 'Favorable'
    end;
}