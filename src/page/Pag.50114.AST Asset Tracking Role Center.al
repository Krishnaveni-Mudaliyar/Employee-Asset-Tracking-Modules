page 50114 "AST Asset Tracking Role Center"
{
    ApplicationArea = All;
    Caption = 'Asset Tracking';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            // Cue groups show counts/KPIs
            group(AssetOverview)
            {
                Caption = 'Asset Overview';

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
                    RunObject = page "AST Company Asset List";
                }
                action(AssetCategories)
                {
                    Caption = 'Asset Categories';
                    ApplicationArea = All;
                    RunObject = page "AST Asset Category List";
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
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action(AssetSetup)
                {
                    Caption = 'Asset Tracking Setup';
                    ApplicationArea = All;
                    RunObject = page "AST Asset Tracking Setup";
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
            }
            action(HandoverLetterReport)
            {
                Caption = 'Asset Handover Letter';
                ApplicationArea = All;
                RunObject = report "AST Asset Handover Letter";
            }
            action(PostedAssignments)
            {
                Caption = 'Posted Assignments';
                ApplicationArea = All;
            }
            action(PostedAssignmentList)
            {
                Caption = 'Posted Assignment List';
                ApplicationArea = All;
            }
        }
    }
}
