page 50112 "AST Employee Asset Factbox"
{
    PageType = CardPart;
    Caption = 'Employee Assets';
    ApplicationArea = All;
    // FIX: This FactBox was not wired up — SetEmployee() was never called.
    // Pattern: Parent page sets EmployeeNo via SubPageLink, which calls
    // OnAfterGetCurrRecord to recalculate. No SetEmployee() needed.
    // The correct pattern for CardPart FactBoxes is:
    //   1. Declare variables for what you want to show
    //   2. Use SubPageLink on the parent page to pass the key field
    //   3. Re-query in trigger OnAfterGetCurrRecord

    layout
    {
        area(Content)
        {
            field(EmployeeNoDisplay; EmployeeNo)
            {
                ApplicationArea = All;
                Caption = 'Employee No.';
                ToolTip = 'Specifies the employee number.';
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
        }
    }

    var
        EmployeeNo: Code[20];
        TotalAssignedAssets: Integer;
        TotalAssignmentValue: Decimal;

    // Called from parent page via SubPageLink or directly
    procedure SetEmployee(pCodEmployeeNo: Code[20])
    begin
        EmployeeNo := pCodEmployeeNo;
        CalculateStats();
        CurrPage.Update(false);
    end;

    local procedure CalculateStats()
    var
        lRecAsset: Record "AST Company Asset";
    begin
        lRecAsset.SetRange("Assigned to Employee No.", EmployeeNo);
        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
        TotalAssignedAssets := lRecAsset.Count();

        lRecAsset.CalcSums("Purchase Price");
        TotalAssignmentValue := lRecAsset."Purchase Price";
    end;
}
