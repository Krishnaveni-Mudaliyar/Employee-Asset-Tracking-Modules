page 50100 "AST Asset Tracking Setup"
{
    PageType = Card;
    SourceTable = "AST Asset Tracking Setup";
    Caption = 'Asset Tracking Setup';
    UsageCategory = Administration;
    ApplicationArea = All;
    InsertAllowed = false;
    AboutTitle = 'Asset Tracking Setup';
    AboutText = 'Configure the Employee Asset Tracking module: number series, default return period, approval requirements and email notification settings.';
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(NumberSeries)
            {
                Caption = 'Number Series';

                field("Asset Nos."; Rec."Asset Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for assets.';
                }
                field("Assignment Nos."; Rec."Assignment Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series for assignments.';
                }

            }
            group(Defaults)
            {
                Caption = 'Defaults';

                field("Default Return Days"; Rec."Default Return Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default number of days before asset return.';
                }
                field("Default Asset Condition"; Rec."Default Asset Condition")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default condition for new asset.';
                }
                field("Require Approval"; Rec."Require Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether approval is required before posting assignments.';
                }
                field("Approval Threshold Amount"; Rec."Approval Threshold Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset value above which approval is required.';
                }
            }
            group(Notifications)
            {
                Caption = 'Notifications';

                field("Send Email Notification"; Rec."Send Email Notification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether email notifications are sent on assignment.';
                }
                field("Admin Email Address"; Rec."Admin Email Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address that receives admin alert notifications.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec."Primary Key" := '';
            Rec.Insert(true);
        end;
    end;
}