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
                }
                field(AssignedAssets; AssignedAssets)
                {
                    ApplicationArea = All;
                    Caption = 'Assigned';
                    ToolTip = 'Specifies the number of assets currently assigned to employees.';
                }
                field(UnderMaintenanceAssets; UnderMaintenanceAssets)
                {
                    ApplicationArea = All;
                    Caption = 'Under Maintenance';
                    ToolTip = 'Specifies the number of assets currently under maintenance.';
                }
                field(DisposedAssets; DisposedAssets)
                {
                    ApplicationArea = All;
                    Caption = 'Disposed';
                    ToolTip = 'Specifies the number of assets that have been disposed.';
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
    var
        TotalAssets: Integer;
        AvailableAssets: Integer;
        AssignedAssets: Integer;
        UnderMaintenanceAssets: Integer;
        DisposedAssets: Integer;
        TotalPurchaseValue: Decimal;

    trigger OnOpenPage()
    var
        lRecAsset: Record "AST Company Asset";
    begin
        // Calculate all stats when page opens
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