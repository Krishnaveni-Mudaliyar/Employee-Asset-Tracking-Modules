pageextension 50101 "Setup Page Ext" extends "Asset Tracking Setup"
{
    layout
    {
        addlast(content)
        {
            group(TransferGroup)
            {
                Caption = 'Transfers & Reservations';
                field("Transfer Nos."; Rec."Transfer Nos.")
                {
                    ApplicationArea = All;
                }
                field("Reservation Expiry Days"; Rec."Reservation Expiry Days")
                {
                    ApplicationArea = All;
                }
            }
            group(DeprecGroup)
            {
                Caption = 'Depreciation';
                field("Default Depreciation Rate %"; Rec."Default Depreciation Rate %")
                {
                    ApplicationArea = All;
                }
            }
            group(AlertGroup)
            {
                Caption = 'Alert Thresholds';
                field("Warranty Alert Days"; Rec."Warranty Alert Days")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(SetupJobQueues)
            {
                Caption = 'Create / Refresh Job Queue Entries';
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Creates or refreshes the daily Overdue Check and weekly Depreciation Batch job queue entries.';
                trigger OnAction()
                var
                    lOvd: Codeunit "Overdue Management";
                begin
                    // Create/refresh only the job queue entry for the available codeunit.
                    lOvd.CreateJobQueueEntry();
                    Message('Job queue entry for Overdue Check created/refreshed.');
                end;
            }
            action(RunOverdueNow)
            {
                Caption = 'Run Overdue Check Now';
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    lOvd: Codeunit "Overdue Management";
                begin
                    lOvd.RunManual();
                end;
            }
        }
    }
}
