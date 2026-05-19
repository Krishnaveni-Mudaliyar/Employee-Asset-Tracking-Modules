// Runs on Install and Upgrade.
// Seeds: Transfer No. Series, Job Queue entries for Overdue Check and Depreciation Batch.
codeunit 50110 "AST Install Additions"
{
    Subtype = Install;
    trigger OnInstall() begin Run(); end;
    trigger OnUpgradePerDatabase() begin Run(); end;

    local procedure Run()
    var
        lSetup: Record "AST Asset Tracking Setup";
        lNS:    Record "No. Series";
        lNSL:   Record "No. Series Line";
        lOvd:   Codeunit "AST Overdue Management";
        lDep:   Codeunit "AST Depreciation Batch";
    begin
        lSetup.Get();

        // Transfer No. Series
        if not lNS.Get('AST-TRANS') then begin
            lNS.Init(); lNS.Code := 'AST-TRANS';
            lNS.Description := 'AST Asset Transfers';
            lNS."Default Nos." := true; lNS."Manual Nos." := false;
            lNS.Insert(true);
            lNSL.Init(); lNSL."Series Code" := 'AST-TRANS'; lNSL."Line No." := 10000;
            lNSL."Starting No." := 'TRF-0001'; lNSL."Increment-by No." := 1;
            lNSL.Insert(true);
        end;
        if lSetup."Transfer Nos." = '' then begin
            lSetup."Transfer Nos." := 'AST-TRANS';
            lSetup.Modify(true);
        end;

        // Default new setup fields if zero/blank
        if lSetup."Default Depreciation Rate %" = 0 then lSetup."Default Depreciation Rate %" := 20;
        if lSetup."Warranty Alert Days" = 0 then lSetup."Warranty Alert Days" := 30;
        if lSetup."Reservation Expiry Days" = 0 then lSetup."Reservation Expiry Days" := 7;
        lSetup.Modify(false);

        // Job Queues
        lOvd.CreateJobQueueEntry();
        lDep.CreateJobQueueEntry();

        if lSetup."Admin Email Address" = '' then
            Message('Post-install: Set Admin Email Address in Asset Tracking Setup to enable email alerts.');
    end;
}
