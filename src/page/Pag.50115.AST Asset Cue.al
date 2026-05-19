page 50115 "AST Asset Cue"
{
    PageType = CardPart;
    Caption = 'Asset Activities';
    ApplicationArea = All;
    RefreshOnActivate = true;
    AboutTitle = 'Asset Activity Tiles';
    AboutText = 'Live counts of assets and assignments. Click any tile to drill down into the matching records. The Overdue tile turns red when returns are outstanding.';

    layout
    {
        area(Content)
        {
            cuegroup(AssetStatus)
            {
                Caption = 'Asset Status';

                field(AvailableCount; AvailableCount)
                {
                    ApplicationArea = All;
                    Caption = 'Available';
                    ToolTip = 'Shows the number of assets currently available for assignment.';
                    StyleExpr = 'Favorable';

                    trigger OnDrillDown()
                    var
                        lRecAsset: Record "AST Company Asset";
                    begin
                        lRecAsset.SetRange(Status, lRecAsset.Status::Available);
                        Page.Run(Page::"AST Company Asset List", lRecAsset);
                    end;
                }
                field(AssignedCount; AssignedCount)
                {
                    ApplicationArea = All;
                    Caption = 'Assigned';
                    ToolTip = 'Shows the number of assets currently assigned to employees.';
                    StyleExpr = 'Strong';

                    trigger OnDrillDown()
                    var
                        lRecAsset: Record "AST Company Asset";
                    begin
                        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
                        Page.Run(Page::"AST Company Asset List", lRecAsset);
                    end;
                }
                field(MaintenanceCount; MaintenanceCount)
                {
                    ApplicationArea = All;
                    Caption = 'Under Maintenance';
                    ToolTip = 'Shows the number of assets currently under maintenance.';
                    StyleExpr = 'Ambiguous';

                    trigger OnDrillDown()
                    var
                        lRecAsset: Record "AST Company Asset";
                    begin
                        lRecAsset.SetRange(Status, lRecAsset.Status::UnderMaintenance);
                        Page.Run(Page::"AST Company Asset List", lRecAsset);
                    end;
                }
            }
            cuegroup(Assignments)
            {
                Caption = 'Assignments';

                field(OpenAssignments; OpenAssignments)
                {
                    ApplicationArea = All;
                    Caption = 'Open Assignments';
                    ToolTip = 'Shows the number of assignment documents currently open.';

                    trigger OnDrillDown()
                    var
                        lRecHeader: Record "AST Asset Assignment Header";
                    begin
                        lRecHeader.SetRange(Status, lRecHeader.Status::Open);
                        Page.Run(Page::"AST Asset Assignment List", lRecHeader);
                    end;
                }
                field(PostedToday; PostedToday)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Today';
                    ToolTip = 'Shows the number of assignments posted today.';

                    trigger OnDrillDown()
                    var
                        lRecPosted: Record "AST Posted Assignment Header";
                    begin
                        lRecPosted.SetRange("Posting Date", Today);
                        lRecPosted.SetRange("Transaction Type", lRecPosted."Transaction Type"::Assignment);
                        Page.Run(Page::"AST Posted Assignment List", lRecPosted);
                    end;
                }
                field(OverdueCount; OverdueCount)
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Returns';
                    ToolTip = 'Assignments past their expected return date. Click to run the Overdue report.';
                    StyleExpr = OverdueStyle;
                    trigger OnDrillDown()
                    begin
                        Report.RunModal(Report::"AST Overdue Asset Return");
                    end;
                }
            }
        }
    }

    var
        AvailableCount, AssignedCount, MaintenanceCount, OverdueCount : Integer;
        OpenAssignments, PostedToday : Integer;
        OverdueStyle: Text;

    trigger OnOpenPage()
    begin
        CalculateCues();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateCues();
    end;

    local procedure CalculateCues()
    var
        lRecAsset: Record "AST Company Asset";
        lRecHeader: Record "AST Asset Assignment Header";
        lRecPosted: Record "AST Posted Assignment Header";
    begin
        lRecAsset.SetLoadFields("No.", Status);
        lRecAsset.SetRange(Status, lRecAsset.Status::Available);
        AvailableCount := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
        AssignedCount := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::UnderMaintenance);
        MaintenanceCount := lRecAsset.Count();

        lRecHeader.SetLoadFields("No.", Status);
        lRecHeader.SetRange(Status, lRecHeader.Status::Open);
        OpenAssignments := lRecHeader.Count();

        lRecPosted.SetLoadFields("No.", "Posting Date", "Expected Return Date");
        lRecPosted.SetRange("Posting Date", Today);
        lRecPosted.SetRange("Transaction Type", lRecPosted."Transaction Type"::Assignment);
        PostedToday := lRecPosted.Count();

        lRecPosted.SetRange("Posting Date");
        lRecPosted.SetRange("Transaction Type", lRecPosted."Transaction Type"::Assignment);
        lRecPosted.SetFilter("Expected Return Date", '<>%1&<%2', 0D, Today);
        OverdueCount := lRecPosted.Count();

        if OverdueReturns() then
            OverdueStyle := 'Unfavorable'
        else
            OverdueStyle := 'Favorable';
    end;

    local procedure OverdueReturns(): Boolean
    begin
        exit(OverdueCount > 0);
    end;
}