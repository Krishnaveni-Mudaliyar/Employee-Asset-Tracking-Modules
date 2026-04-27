page 50114 "AST Asset Tracking Role Center"
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
            part(AssetActivities; "AST Asset Cue") { ApplicationArea = All; }
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
                    RunObject = page "AST Company Asset List";
                    ToolTip = 'View and manage all company assets.';
                }
                action(AssetCategories)
                {
                    Caption = 'Asset Categories';
                    ApplicationArea = All;
                    RunObject = page "AST Asset Category List";
                    ToolTip = 'View and manage asset categories.';
                }
                action(AssetStatistics)
                {
                    Caption = 'Asset Statistics';
                    ApplicationArea = All;
                    RunObject = page "AST Asset Statistics";
                    ToolTip = 'View a statistical overview of all assets.';
                }
            }
            group(Assignments)
            {
                Caption = 'Assignments';

                action(AssetAssignments)
                {
                    Caption = 'Asset Assignments';
                    ApplicationArea = All;
                    RunObject = page "AST Asset Assignment List";
                    ToolTip = 'Create and manage open asset assignment documents.';
                }
                action(PostedAssignments)
                {
                    Caption = 'Posted Assignments';
                    ApplicationArea = All;
                    RunObject = page "AST Posted Assignment List";
                    ToolTip = 'View all posted assignment and return documents.';
                }
            }
            group(Administration)
            {
                Caption = 'Administration';

                action(AssetSetup)
                {
                    Caption = 'Asset Tracking Setup';
                    ApplicationArea = All;
                    RunObject = page "AST Asset Tracking Setup";
                    ToolTip = 'Configure the Asset Tracking module settings.';
                }
                action(ImportAssets)
                {
                    Caption = 'Import Assets';
                    ApplicationArea = All;
                    RunObject = xmlport "AST Asset Migration";
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
                RunObject = report "AST Asset Register";
                ToolTip = 'Print the full asset register.';
            }
            action(HandoverLetterReport)
            {
                Caption = 'Asset Handover Letter';
                ApplicationArea = All;
                RunObject = report "AST Asset Handover Letter";
                ToolTip = 'Print an asset handover letter for a posted assignment.';
            }
            action(EmployeeSummaryReport)
            {
                Caption = 'Employee Asset Summary';
                ApplicationArea = All;
                RunObject = report "AST Employee Asset Summary";
                ToolTip = 'Print a summary of assets per employee.';
            }
            action(OverdueReturnReport)
            {
                Caption = 'Overdue Asset Returns';
                ApplicationArea = All;
                RunObject = report "AST Overdue Asset Return";
                ToolTip = 'Print a list of assets with overdue returns.';
            }
            action(AssetHistoryReport)
            {
                Caption = 'Asset History';
                ApplicationArea = All;
                RunObject = report "AST Asset History";
                ToolTip = 'Print the full history of assets.';
            }
        }
    }
}