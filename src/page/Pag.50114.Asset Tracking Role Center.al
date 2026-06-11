page 50114 "Asset Tracking Role Center"
{
    PageType = RoleCenter;
    Caption = 'Asset Tracking';
    ApplicationArea = All;
    AboutTitle = 'Asset Tracking Role Center';
    AboutText = 'Your central hub for managing company assets. The activity tiles show live counts. Use the navigation menu to access assets, assignments, reports, and setup.';

    layout
    {
        area(RoleCenter)
        {
            part(AssetActivities; "Asset Cue")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group(Assets)
            {
                Caption = 'Assets';

                action(CompanyAssets)
                {
                    Caption = 'Company Assets';
                    ApplicationArea = All;
                    RunObject = page "Company Asset List";
                    ToolTip = 'View and manage all company assets.';
                }
                action(AssetCategories)
                {
                    Caption = 'Asset Categories';
                    ApplicationArea = All;
                    RunObject = page "Asset Category List";
                    ToolTip = 'View and manage asset categories.';
                }
                action(AssetStatistics)
                {
                    Caption = 'Asset Statistics';
                    ApplicationArea = All;
                    RunObject = page "Asset Statistics";
                    ToolTip = 'View a statistical overview of all assets.';
                }
                action(AssetReservations)
                {
                    Caption = 'Asset Reservations';
                    ApplicationArea = All;
                    RunObject = page "Asset Reservation List";
                    ToolTip = 'View and manage asset reservation requests.';
                }
                action(AssetTransfers)
                {
                    Caption = 'Asset Transfers';
                    ApplicationArea = All;
                    RunObject = page "Asset Transfer List";
                    ToolTip = 'View and manage inter-location asset transfers.';
                }
            }
            group(Assignments)
            {
                Caption = 'Assignments';

                action(AssetAssignments)
                {
                    Caption = 'Asset Assignments';
                    ApplicationArea = All;
                    RunObject = page "Asset Assignment List";
                    ToolTip = 'Create and manage open asset assignment documents.';
                }
                action(PostedAssignments)
                {
                    Caption = 'Posted Assignments';
                    ApplicationArea = All;
                    RunObject = page "Posted Assignment List";
                    ToolTip = 'View all posted assignment and return documents.';
                }
            }
            group(Workflow)
            {
                Caption = 'Workflow';

                action(PendingApprovals)
                {
                    Caption = 'Pending Approvals';
                    ApplicationArea = All;
                    ToolTip = 'View assignment documents awaiting approval.';
                    Image = Approval;

                    trigger OnAction()
                    var
                        lRecHeader: Record "Asset Assignment Header";
                    begin
                        lRecHeader.SetRange("Approval Status",
                            lRecHeader."Approval Status"::PendingApproval);
                        Page.Run(Page::"Asset Assignment List", lRecHeader);
                    end;
                }
                action(EscalateApprovals)
                {
                    Caption = 'Escalate Overdue Approvals';
                    ApplicationArea = All;
                    ToolTip = 'Manually trigger escalation emails for approvals pending beyond the threshold.';
                    Image = SendEmailPdf;

                    trigger OnAction()
                    var
                        lCodWorkflow: Codeunit "Workflow Mgt.";
                    begin
                        lCodWorkflow.EscalateOverdueApprovals();
                    end;
                }
            }
            group(PowerBI)
            {
                Caption = 'Power BI';

                action(PBIAssets)
                {
                    Caption = 'Assets Data Feed';
                    ApplicationArea = All;
                    RunObject = page "Power BI Asset List";
                    ToolTip = 'OData feed: all assets for Power BI charts.';
                }
                action(PBIAssignments)
                {
                    Caption = 'Assignments Data Feed';
                    ApplicationArea = All;
                    RunObject = page "Power BI Assignments";
                    ToolTip = 'OData feed: posted assignments for Power BI.';
                }
                action(PBICategories)
                {
                    Caption = 'Category Analytics Feed';
                    ApplicationArea = All;
                    RunObject = page "Power BI Category Analytics";
                    ToolTip = 'OData feed: assets with category details for Power BI bar/pie charts.';
                }
                action(PBIDept)
                {
                    Caption = 'Department Analytics Feed';
                    ApplicationArea = All;
                    RunObject = page "Power BI Dept Analytics";
                    ToolTip = 'OData feed: assignments by department for Power BI dashboards.';
                }
                action(PBIAuditLog)
                {
                    Caption = 'Audit Log Feed';
                    ApplicationArea = All;
                    RunObject = page "Power BI Audit Log";
                    ToolTip = 'OData feed: audit log for Power BI compliance visuals.';
                }
            }
            group(Administration)
            {
                Caption = 'Administration';

                action(AssetSetup)
                {
                    Caption = 'Asset Tracking Setup';
                    ApplicationArea = All;
                    RunObject = page "Asset Tracking Setup";
                    ToolTip = 'Configure the Asset Tracking module settings.';
                }
                action(ImportAssets)
                {
                    Caption = 'Import Assets';
                    ApplicationArea = All;
                    RunObject = xmlport "Asset Migration";
                    ToolTip = 'Import assets from a CSV file.';
                }
            }
        }
        area(Reporting)
        {
            action(AssetRegisterReport)
            {
                Caption = 'Asset Register';
                ApplicationArea = All;
                RunObject = report "Asset Register";
                ToolTip = 'Print the full asset register.';
            }
            action(HandoverLetterReport)
            {
                Caption = 'Asset Handover Letter';
                ApplicationArea = All;
                RunObject = report "Asset Handover Letter";
                ToolTip = 'Print an asset handover letter for a posted assignment.';
            }
            action(EmployeeSummaryReport)
            {
                Caption = 'Employee Asset Summary';
                ApplicationArea = All;
                RunObject = report "Employee Asset Summary";
                ToolTip = 'Print a summary of assets per employee.';
            }
            action(OverdueReturnReport)
            {
                Caption = 'Overdue Asset Returns';
                ApplicationArea = All;
                RunObject = report "Overdue Asset Return";
                ToolTip = 'Print a list of assets with overdue returns.';
            }
            action(AssetHistoryReport)
            {
                Caption = 'Asset History';
                ApplicationArea = All;
                RunObject = report "Asset History";
                ToolTip = 'Print the full history of assets.';
            }
            action(DepreciationReport)
            {
                Caption = 'Depreciation Schedule';
                ApplicationArea = All;
                RunObject = report "Asset Depreciation Schedule";
                ToolTip = 'Print asset depreciation schedule.';
            }
            action(WarrantyReport)
            {
                Caption = 'Warranty Expiry';
                ApplicationArea = All;
                RunObject = report "Warranty Expiry Report";
                ToolTip = 'Print upcoming warranty expiry list.';
            }
        }
    }
}