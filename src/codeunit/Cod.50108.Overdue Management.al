codeunit 50108 "Overdue Management"
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        RunOverdueCheck();
    end;

    procedure RunOverdueCheck()
    var
        lHdr: Record "Posted Assignment Header";
        lAsset: Record "Company Asset";
        lSetup: Record "Asset Tracking Setup";
        lEmail: Codeunit "Email Mgt.";
        lCount: Integer;
    begin
        lSetup.Get();

        // ── 1. Flag newly overdue ───
        lHdr.SetRange(
            "Transaction Type",
            "Transaction Type"::Assignment);

        lHdr.SetRange(
            "Return Date",
            0D);

        lHdr.SetFilter(
            "Expected Return Date",
            '<%1',
            Today);

        lHdr.SetRange(
            "Is Overdue",
            false);

        if lHdr.FindSet(true) then
            repeat
                lHdr."Is Overdue" := true;
                lHdr."Overdue Since Date" := lHdr."Expected Return Date";
                lHdr."Overdue Days" := Today - lHdr."Expected Return Date";
                lHdr.Modify(false);
                // Mirror flag on Company Asset
                if lAsset.Get(GetAssetNoForDoc(lHdr."No.")) then begin
                    lAsset."Is Overdue" := true;
                    lAsset.Modify(false);
                end;
                lCount += 1;
            until lHdr.Next() = 0;

        // ── 2. Refresh Overdue Days on already-flagged ────
        lHdr.Reset();
        lHdr.SetRange("Is Overdue", true);
        lHdr.SetRange("Return Date", 0D);
        if lHdr.FindSet(true) then
            repeat
                lHdr."Overdue Days" := Today - lHdr."Expected Return Date";
                lHdr.Modify(false);
            until lHdr.Next() = 0;

        // ── 3. Clear flag on returned records ─────
        lHdr.Reset();
        lHdr.SetRange("Is Overdue", true);
        lHdr.SetFilter("Return Date", '>%1', 0D);
        if lHdr.FindSet(true) then
            repeat
                lHdr."Is Overdue" := false;
                lHdr."Overdue Days" := 0;
                lHdr.Modify(false);
            until lHdr.Next() = 0;

        // ── 4. Email alert ─────
        if (lCount > 0) and lSetup."Send Email Notification" then
            lEmail.SendOverdueEmail(lCount);

        // ── 5. Warranty alert ───────
        if lSetup."Send Email Notification" then
            lEmail.SendWarrantyExpiryEmail();
    end;

    local procedure GetAssetNoForDoc(pDocNo: Code[20]): Code[20]
    var
        lLine: Record "Posted Assignment Line";
    begin
        lLine.SetRange("Document No.", pDocNo);
        if lLine.FindFirst()
        then
            exit(lLine."Asset No.");
        exit('');
    end;

    procedure CreateJobQueueEntry()
    var
        lJQ: Record "Job Queue Entry";
    begin
        lJQ.SetRange(
            "Object Type to Run",
            lJQ."Object Type to Run"::Codeunit);

        lJQ.SetRange(
            "Object ID to Run",
            Codeunit::"Overdue Management");

        if not lJQ.IsEmpty()
        then
            exit;

        lJQ.Init();
        lJQ."Object Type to Run" := lJQ."Object Type to Run"::Codeunit;
        lJQ."Object ID to Run" := Codeunit::"Overdue Management";
        lJQ.Description := 'Daily Overdue & Warranty Check';
        lJQ."Run on Mondays" := true;
        lJQ."Run on Tuesdays" := true;
        lJQ."Run on Wednesdays" := true;
        lJQ."Run on Thursdays" := true;
        lJQ."Run on Fridays" := true;
        lJQ."Starting Time" := 080000T;
        lJQ."Recurring Job" := true;
        lJQ."No. of Minutes between Runs" := 1440;
        lJQ.Insert();
    end;

    procedure RunManual()
    begin
        RunOverdueCheck();
        Message('Overdue check complete. Posted Assignments updated.');
    end;
}