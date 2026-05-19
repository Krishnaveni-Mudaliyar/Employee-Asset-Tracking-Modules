// Weekly job queue codeunit.
// Calls RecalcBookValue on every Company Asset that has a
// Purchase Date and Depreciation Rate > 0, keeping Book Value current.
codeunit 50114 "AST Depreciation Batch"
{
    TableNo = "Job Queue Entry";
    trigger OnRun() begin RunDepreciationUpdate(); end;

    procedure RunDepreciationUpdate()
    var
        lAsset:   Record "AST Company Asset";
        lUpdated: Integer;
    begin
        if lAsset.FindSet(true) then
            repeat
                if (lAsset."Purchase Date" <> 0D) and (lAsset."Depreciation Rate %" > 0) then begin
                    lAsset.RecalcBookValue();
                    lAsset.Modify(false);
                    lUpdated += 1;
                end;
            until lAsset.Next() = 0;
        Message('Book value recalculated for %1 asset(s).', lUpdated);
    end;

    procedure CreateJobQueueEntry()
    var lJQ: Record "Job Queue Entry"; lEnq: Codeunit "Job Queue - Enqueue";
    begin
        lJQ.SetRange("Object Type to Run", lJQ."Object Type to Run"::Codeunit);
        lJQ.SetRange("Object ID to Run", Codeunit::"AST Depreciation Batch");
        if not lJQ.IsEmpty() then exit;
        lJQ.Init();
        lJQ."Object Type to Run" := lJQ."Object Type to Run"::Codeunit;
        lJQ."Object ID to Run"   := Codeunit::"AST Depreciation Batch";
        lJQ.Description          := 'AST – Weekly Book Value Recalculation';
        lJQ."Run on Mondays"     := true;
        lJQ."Starting Time"      := 070000T;
        lJQ."Recurring Job"      := true;
        lJQ."No. of Minutes between Runs" := 10080;
        lEnq.EnqueueJobQueueEntry(lJQ);
    end;
}
