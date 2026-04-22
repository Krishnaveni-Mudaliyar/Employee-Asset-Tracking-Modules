page 50112 "AST Employee Asset Factbox"
{
    PageType = CardPart;
    Caption = 'Employee Assets';
    ApplicationArea = All;
    // This FactBox is wired via SubPageLink on parent pages:
    //   SubPageLink = "Assigned to Employee No." = field("Employee No.")
    // BC passes the field value from the parent record into this page's
    // SourceTable filter. OnAfterGetCurrRecord then recalculates stats
    // every time the parent record changes — keeping the display live.
    SourceTable = "AST Company Asset";

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
        }
    }

    var
        EmployeeNo: Code[20];
        TotalAssignedAssets: Integer;
        TotalAssignmentValue: Decimal;

    trigger OnAfterGetCurrRecord()
    begin
        // Fires whenever the parent page navigates to a different record.
        // Rec is filtered by SubPageLink — read EmployeeNo from the filter
        // that BC applied, then recalculate stats for that employee.
        EmployeeNo := Rec.GetFilter("Assigned to Employee No.");
        CalculateStats();
    end;

    local procedure CalculateStats()
    var
        lRecAsset: Record "AST Company Asset";
    begin
        if EmployeeNo = '' then begin
            TotalAssignedAssets := 0;
            TotalAssignmentValue := 0;
            exit;
        end;

        lRecAsset.SetLoadFields("Assigned to Employee No.", Status, "Purchase Price");
        lRecAsset.SetRange("Assigned to Employee No.", EmployeeNo);
        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
        TotalAssignedAssets := lRecAsset.Count();

        lRecAsset.CalcSums("Purchase Price");
        TotalAssignmentValue := lRecAsset."Purchase Price";
    end;
}
