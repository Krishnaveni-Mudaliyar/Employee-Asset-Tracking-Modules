page 50115 "AST Asset Cue"
{
    PageType = CardPart;
    Caption = 'Asset Activities';
    ApplicationArea = All;
    RefreshOnActivate = true;

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
                        Page.Run(Page::"AST Posted Assignment List", lRecPosted);
                    end;
                }
            }
        }
    }

    var
        AvailableCount: Integer;
        AssignedCount: Integer;
        MaintenanceCount: Integer;
        OpenAssignments: Integer;
        PostedToday: Integer;

    trigger OnOpenPage()
    begin
        CalculateCues();
    end;

    local procedure CalculateCues()
    var
        lRecAsset: Record "AST Company Asset";
        lRecHeader: Record "AST Asset Assignment Header";
        lRecPosted: Record "AST Posted Assignment Header";
    begin
        lRecAsset.SetRange(Status, lRecAsset.Status::Available);
        AvailableCount := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
        AssignedCount := lRecAsset.Count();

        lRecAsset.SetRange(Status, lRecAsset.Status::UnderMaintenance);
        MaintenanceCount := lRecAsset.Count();

        lRecHeader.SetRange(Status, lRecHeader.Status::Open);
        OpenAssignments := lRecHeader.Count();

        lRecPosted.SetRange("Posting Date", Today);
        PostedToday := lRecPosted.Count();
    end;
}
