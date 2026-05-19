page 50113 "AST Asset Statistics"
{
    PageType = Card;
    Caption = 'Asset Statistics';
    UsageCategory = None;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    AboutTitle = 'Asset Statistics';
    AboutText = 'A real-time overview of all company assets by status and total value. Click Refresh to reload the latest figures.';

    layout
    {
        area(Content)
        {
            group(Overview)
            {
                Caption = 'Asset Overview';

                field(TotalAssets; TotalAssets)
                {
                    ApplicationArea = All;
                    Caption = 'Total Assets';
                    ToolTip = 'Specifies the total number of assets in the system.';
                }
                field(AvailableAssets; AvailableAssets)
                {
                    ApplicationArea = All;
                    Caption = 'Available';
                    ToolTip = 'Specifies the number of assets currently available for assignment.';
                    StyleExpr = 'Favorable';
                }
                field(AssignedAssets; AssignedAssets)
                {
                    ApplicationArea = All;
                    Caption = 'Assigned';
                    ToolTip = 'Specifies the number of assets currently assigned to employees.';
                    StyleExpr = 'Strong';
                }
                field(UnderMaintenanceAssets; UnderMaintenanceAssets)
                {
                    ApplicationArea = All;
                    Caption = 'Under Maintenance';
                    ToolTip = 'Specifies the number of assets currently under maintenance.';
                    StyleExpr = 'Ambiguous';
                }
                field(DisposedAssets; DisposedAssets)
                {
                    ApplicationArea = All;
                    Caption = 'Disposed';
                    ToolTip = 'Specifies the number of assets that have been disposed.';
                    StyleExpr = 'Subordinate';
                }
                field(TotalPurchaseValue; TotalPurchaseValue)
                {
                    ApplicationArea = All;
                    Caption = 'Total Purchase Value';
                    ToolTip = 'Specifies the total purchase value of all assets.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                Caption = 'Refresh';
                Image = Refresh;
                ApplicationArea = All;
                ToolTip = 'Recalculate all statistics to show the latest data.';
                AboutTitle = 'Refresh Statistics';
                AboutText = 'Click to reload all asset counts and values from the database.';

                trigger OnAction()
                begin
                    CalculateStats();
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        { actionref(Refresh_Promoted; Refresh) { } }
    }

    var
        AvailableAssets, AssignedAssets, TotalAssets, UnderMaintenanceAssets, DisposedAssets : Integer; TotalPurchaseValue: Decimal;

    trigger OnOpenPage()
    begin
        CalculateStats();
    end;

    local procedure CalculateStats()
    var
        lRecAsset: Record "AST Company Asset";
    begin
        lRecAsset.SetLoadFields("No.", Status, "Purchase Price");
        TotalAssets := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::Available);
        AvailableAssets := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
        AssignedAssets := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::UnderMaintenance);
        UnderMaintenanceAssets := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::Disposed);
        DisposedAssets := lRecAsset.Count();

        lRecAsset.SetRange(Status);
        lRecAsset.CalcSums("Purchase Price");
        TotalPurchaseValue := lRecAsset."Purchase Price";
    end;
}