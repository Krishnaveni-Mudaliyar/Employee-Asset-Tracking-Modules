codeunit 50109 "AST Posting Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        lCodPostingMgt: Codeunit "AST Asset Posting Mgt.";

    [Test]
    procedure TestPostAssignment_ValidDocument_CreatesPostedHeader()
    var
        lRecHeader: Record "AST Asset Assignment Header";
        lRecLine: Record "AST Asset Assignment Line";
        lRecAsset: Record "AST Company Asset";
        lRecPostedHeader: Record "AST Posted Assignment Header";
        lCodNoSeries: Codeunit "No. Series";
    begin
        // [SCENARIO] Posting a valid open assignment creates a posted header record
        // [GIVEN] A setup record exists (Install codeunit handles this)
        // [GIVEN] An available asset
        lRecAsset.Init();
        lRecAsset."No." := 'TEST-ASSET-POST';
        lRecAsset.Status := lRecAsset.Status::Available;
        lRecAsset.Description := 'Test Asset for Posting';
        if not lRecAsset.Insert() then begin
            lRecAsset.Get('TEST-ASSET-POST');
            lRecAsset.Status := lRecAsset.Status::Available;
            lRecAsset.Modify();
        end;

        // [GIVEN] An open assignment header
        lRecHeader.Init();
        lRecHeader."No." := 'TEST-ASSIGN-POST';
        lRecHeader."Employee No." := 'EMP001';
        lRecHeader."Employee Name" := 'Test Employee';
        lRecHeader."Assignment Date" := Today;
        lRecHeader.Status := lRecHeader.Status::Open;
        lRecHeader."Approval Status" := lRecHeader."Approval Status"::Open;
        lRecHeader.Insert();

        // [GIVEN] One line with the available asset
        lRecLine.Init();
        lRecLine."Document No." := 'TEST-ASSIGN-POST';
        lRecLine."Line No." := 10000;
        lRecLine."Asset No." := 'TEST-ASSET-POST';
        lRecLine."Condition at Handover" := lRecLine."Condition at Handover"::Good;
        lRecLine.Insert();

        // [WHEN] Post the assignment
        lCodPostingMgt.PostAssetAssignment(lRecHeader);

        // [THEN] Posted header must exist
        lRecPostedHeader.SetRange("No.", 'TEST-ASSIGN-POST');
        if not lRecPostedHeader.FindFirst() then
            Error('Posted header was not created after posting.');

        // [THEN] Original header must be deleted
        lRecHeader.SetRange("No.", 'TEST-ASSIGN-POST');
        if lRecHeader.FindFirst() then
            Error('Original assignment header should have been deleted after posting.');
    end;

    [Test]
    procedure TestPostAssignment_UpdatesAssetStatusToAssigned()
    var
        lRecAsset: Record "AST Company Asset";
    begin
        // [SCENARIO] After posting, the asset status must be Assigned
        // [THEN] Asset from previous test must now be Assigned
        if lRecAsset.Get('TEST-ASSET-POST') then
            if lRecAsset.Status <> lRecAsset.Status::Assigned then
                Error('Asset status must be Assigned after posting. Current: %1', lRecAsset.Status);
    end;

    [Test]
    procedure TestPostAssignment_CreatesLogEntry()
    var
        lRecLog: Record "AST Asset Log Entry";
    begin
        // [SCENARIO] After posting, an Assignment log entry must exist for the asset
        lRecLog.SetRange("Asset No.", 'TEST-ASSET-POST');
        lRecLog.SetRange("Transaction Type", lRecLog."Transaction Type"::Assignment);
        if not lRecLog.FindFirst() then
            Error('Assignment log entry was not created after posting.');
    end;
}
