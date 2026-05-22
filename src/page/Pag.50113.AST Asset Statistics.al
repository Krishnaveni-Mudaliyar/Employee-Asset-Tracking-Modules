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
            }
            group(ValueKPIs)
            {
                Caption = 'Financial KPIs';
                field(TotalPurchaseValue; TotalPurchaseValue)
                {
                    ApplicationArea = All;
                    Caption = 'Total Purchase Value';
                    ToolTip = 'Specifies the total purchase value of all assets.';
                }
                field(TotalBookValue; TotalBookValue)
                {
                    ApplicationArea = All;
                    Caption = 'Total Book Value';
                    ToolTip = 'Current total book (depreciated) value of all assets.';
                }
                field(AveragePurchasePrice; AveragePurchasePrice)
                {
                    ApplicationArea = All;
                    Caption = 'Avg. Purchase Price';
                    ToolTip = 'Average Purchase Price per asset.';
                }
                field(WarrantyExpiringCount; WarrantyExpiringCount)
                {
                    ApplicationArea = All;
                    Caption = 'Warranty Expiring (30 days)';
                    StyleExpr = 'Attention';
                    ToolTip = 'Assets whose warranty expires within the next 30 days.';
                }
            }
            group(WorkflowKPIs)
            {
                Caption = 'Workflow KPIs';

                field(OpenAssignments; OpenAssignments)
                {
                    ApplicationArea = All;
                    Caption = 'Pending Approval';
                    StyleExpr = if (PendingApprovals > 0)
                    then 'Attention' else 'Favorable';
                    ToolTip = 'Open assignments awaiting approval.';
                }
                field(EscalatedApprovals; EscalatedApprovals)
                {
                    ApplicationArea = All;
                    Caption = 'Escalated Approvals';
                    StyleExpr = if (EscalatedApprovals > 0)
                    then
                     'Unfavorable'
                      else 
                      'Favorable';
                    ToolTip = 'Approvals that have been escalated.';
                }
                field(OverdueReturns; OverdueReturns)
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Returns';
                    StyleExpr = if (OverdueReturns > 0) then 'Unfavorable' else 'Favorable';
                    ToolTip = 'Assignments past their expected return date.';
                }
                field(PostedThisMonth; PostedThisMonth)
                {
                    ApplicationArea = All;
                    Caption = 'Assignments This Month';
                    ToolTip = 'Total assignment documents posted in the current calendar month.';
                }
                field(ReturnsThisMonth; ReturnsThisMonth)
                {
                    ApplicationArea = All;
                    Caption = 'Returns This Month';
                    ToolTip = 'Total return documents posted in the current calendar month.';
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
        lRecHeader: Record "AST Asset Assignment Header";
        lRecPosted: Record "AST Posted Assignment Header";
        lDtMonthStart: Date;
    begin
        // Asset counts
        lRecAsset.SetLoadFields("No.", Status, "Purchase Price",
        "Book Value", "Warranty Expiry Date");
        TotalAssets := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::Available);
        AvailableAssets := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
        AssignedAssets := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::UnderMaintenance);
        UnderMaintenanceAssets := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::Disposed);
        DisposedAssets := lRecAsset.Count();

        // Financial KPIs
        lRecAsset.SetRange(Status);
        lRecAsset.CalcSums("Purchase Price", "Book Value");
        TotalPurchaseValue := lRecAsset."Purchase Price";
        TotalBookValue := lRecAsset."Book Value";
        if TotalAssets > 0 then
            AveragePurchasePrice := TotalPurchaseValue / TotalAssets;

        // Warranty expiring in 30 days
        lRecAsset.SetFilter("Warranty Expiry Date",
            '>=%1&<=%2', Today, Today + 30);
        WarrantyExpiringCount := lRecAsset.Count();

        // Workflow KPIs
        lRecHeader.SetLoadFields("No.", Status, "Approval Status", Escalated);
        lRecHeader.SetRange(Status, lRecHeader.Status::Open);
        OpenAssignments := lRecHeader.Count();

        lRecHeader.SetRange(Status);
        lRecHeader.SetRange("Approval Status",
            lRecHeader."Approval Status"::PendingApproval);
        PendingApprovals := lRecHeader.Count();

        lRecHeader.SetRange("Approval Status");
        lRecHeader.SetRange(Escalated, true);
        EscalatedApprovals := lRecHeader.Count();

        // Overdue returns
        lRecPosted.SetLoadFields("No.", "Transaction Type",
            "Expected Return Date", "Return Date");
        lRecPosted.SetRange("Transaction Type",
            lRecPosted."Transaction Type"::Assignment);
        lRecPosted.SetFilter("Expected Return Date",
            '<>%1&<%2', 0D, Today);
        lRecPosted.SetRange("Return Date", 0D);
        OverdueReturns := lRecPosted.Count();

        // This-month activity
        lDtMonthStart := DMY2Date(1, Date2DMY(Today, 2), Date2DMY(Today, 3));
        lRecPosted.SetRange("Return Date");
        lRecPosted.SetRange("Expected Return Date");
        lRecPosted.SetFilter("Posting Date",
            '>=%1&<=%2', lDtMonthStart, Today);

        lRecPosted.SetRange("Transaction Type",
            lRecPosted."Transaction Type"::Assignment);
        PostedThisMonth := lRecPosted.Count();

        lRecPosted.SetRange("Transaction Type",
            lRecPosted."Transaction Type"::Return);
        ReturnsThisMonth := lRecPosted.Count();
    end;
}