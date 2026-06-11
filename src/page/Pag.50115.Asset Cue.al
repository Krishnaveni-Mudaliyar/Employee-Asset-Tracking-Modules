page 50115 "Asset Cue"
{
    PageType = CardPart;
    Caption = 'Asset Activities';
    ApplicationArea = All;
    RefreshOnActivate = true;
    AboutTitle = 'Asset Activity Tiles';
    AboutText = 'Live counts of assets, assignments, workflow items and reservations. Click any tile to drill down.';

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
                    ToolTip = 'Number of assets available for assignment.';
                    StyleExpr = 'Favorable';

                    trigger OnDrillDown()
                    var
                        lRecAsset: Record "Company Asset";
                    begin
                        lRecAsset.SetRange(Status, lRecAsset.Status::Available);
                        Page.Run(Page::"Company Asset List", lRecAsset);
                    end;
                }
                field(AssignedCount; AssignedCount)
                {
                    ApplicationArea = All;
                    Caption = 'Assigned';
                    ToolTip = 'Number of assets currently assigned to employees.';
                    StyleExpr = 'Strong';

                    trigger OnDrillDown()
                    var
                        lRecAsset: Record "Company Asset";
                    begin
                        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
                        Page.Run(Page::"Company Asset List", lRecAsset);
                    end;
                }
                field(MaintenanceCount; MaintenanceCount)
                {
                    ApplicationArea = All;
                    Caption = 'Under Maintenance';
                    ToolTip = 'Number of assets under maintenance.';
                    StyleExpr = 'Ambiguous';

                    trigger OnDrillDown()
                    var
                        lRecAsset: Record "Company Asset";
                    begin
                        lRecAsset.SetRange(Status, lRecAsset.Status::UnderMaintenance);
                        Page.Run(Page::"Company Asset List", lRecAsset);
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
                    ToolTip = 'Number of open assignment documents.';

                    trigger OnDrillDown()
                    var
                        lRecHeader: Record "Asset Assignment Header";
                    begin
                        lRecHeader.SetRange(Status, lRecHeader.Status::Open);
                        Page.Run(Page::"Asset Assignment List", lRecHeader);
                    end;
                }
                field(PostedToday; PostedToday)
                {
                    ApplicationArea = All;
                    Caption = 'Posted Today';
                    ToolTip = 'Assignments posted today.';

                    trigger OnDrillDown()
                    var
                        lRecPosted: Record "Posted Assignment Header";
                    begin
                        lRecPosted.SetRange("Posting Date", Today);
                        lRecPosted.SetRange("Transaction Type",
                            lRecPosted."Transaction Type"::Assignment);
                        Page.Run(Page::"Posted Assignment List", lRecPosted);
                    end;
                }
                field(OverdueCount; OverdueCount)
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Returns';
                    ToolTip = 'Assignments past their expected return date.';
                    StyleExpr = OverdueStyle;

                    trigger OnDrillDown()
                    begin
                        Report.RunModal(Report::"Overdue Asset Return");
                    end;
                }
            }

            cuegroup(WorkflowCues)
            {
                Caption = 'Workflow';

                field(PendingApprovals; PendingApprovals)
                {
                    ApplicationArea = All;
                    Caption = 'Pending Approvals';
                    ToolTip = 'Assignments awaiting approval decision.';
                    StyleExpr = PendingApprovalStyle;

                    trigger OnDrillDown()
                    var
                        lRecHeader: Record "Asset Assignment Header";
                    begin
                        lRecHeader.SetRange("Approval Status",
                            lRecHeader."Approval Status"::PendingApproval);
                        Page.Run(Page::"Asset Assignment List", lRecHeader);
                    end;
                }
                field(EscalatedApprovals; EscalatedApprovals)
                {
                    ApplicationArea = All;
                    Caption = 'Escalated';
                    ToolTip = 'Approval requests that have been escalated.';
                    StyleExpr = 'Unfavorable';

                    trigger OnDrillDown()
                    var
                        lRecHeader: Record "Asset Assignment Header";
                    begin
                        lRecHeader.SetRange(Escalated, true);
                        Page.Run(Page::"Asset Assignment List", lRecHeader);
                    end;
                }
                field(RejectedCount; RejectedCount)
                {
                    ApplicationArea = All;
                    Caption = 'Rejected';
                    ToolTip = 'Assignments that were rejected and need re-submission.';
                    StyleExpr = 'Attention';

                    trigger OnDrillDown()
                    var
                        lRecHeader: Record "Asset Assignment Header";
                    begin
                        lRecHeader.SetRange("Approval Status",
                            lRecHeader."Approval Status"::Rejected);
                        Page.Run(Page::"Asset Assignment List", lRecHeader);
                    end;
                }
            }
        }
    }

    var
        AvailableCount, AssignedCount, MaintenanceCount : Integer;
        OverdueCount, OpenAssignments, PostedToday : Integer;
        PendingApprovals, EscalatedApprovals, RejectedCount : Integer;
        OverdueStyle, PendingApprovalStyle : Text;

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
        lRecAsset: Record "Company Asset";
        lRecHeader: Record "Asset Assignment Header";
        lRecPosted: Record "Posted Assignment Header";
    begin
        lRecAsset.SetLoadFields("No.", Status);
        lRecAsset.SetRange(Status, lRecAsset.Status::Available);
        AvailableCount := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
        AssignedCount := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::UnderMaintenance);
        MaintenanceCount := lRecAsset.Count();

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

        lRecHeader.SetRange(Escalated);
        lRecHeader.SetRange("Approval Status",
            lRecHeader."Approval Status"::Rejected);
        RejectedCount := lRecHeader.Count();

        lRecPosted.SetLoadFields("No.", "Posting Date", "Transaction Type",
            "Expected Return Date");
        lRecPosted.SetRange("Posting Date", Today);
        lRecPosted.SetRange("Transaction Type",
            lRecPosted."Transaction Type"::Assignment);
        PostedToday := lRecPosted.Count();

        lRecPosted.SetRange("Posting Date");
        lRecPosted.SetRange("Transaction Type",
            lRecPosted."Transaction Type"::Assignment);
        lRecPosted.SetFilter("Expected Return Date",
            '<>%1&<%2', 0D, Today);
        OverdueCount := lRecPosted.Count();

        OverdueStyle :=
            if (OverdueCount > 0) then 'Unfavorable' else 'Favorable';
        PendingApprovalStyle :=
            if (PendingApprovals > 0) then 'Attention' else 'Favorable';
    end;
}
