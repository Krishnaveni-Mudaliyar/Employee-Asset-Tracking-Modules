codeunit 50152 "Return Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        lCodReturnMgt: Codeunit "Asset Return Mgt.";

    [Test]
    procedure TestProcessReturn_SetsAssetAvailable()
    var
        lRecPostedHeader: Record "Posted Assignment Header";
        lRecPostedLine: Record "Posted Assignment Line";
        lRecAsset: Record "Company Asset";
    begin
        lRecAsset.Init();
        lRecAsset."No." := 'TEST-ASSET-RETURN';
        lRecAsset.Status := lRecAsset.Status::Assigned;
        lRecAsset."Assigned to Employee No." := 'EMP001';
        lRecAsset."Last Assignment Date" := Today - 10;
        if not lRecAsset.Insert() then begin
            lRecAsset.Get('TEST-ASSET-RETURN');
            lRecAsset.Status := lRecAsset.Status::Assigned;
            lRecAsset."Assigned to Employee No." := 'EMP001';
            lRecAsset."Last Assignment Date" := Today - 10;
            lRecAsset.Modify();
        end;

        lRecPostedHeader.Init();
        lRecPostedHeader."No." := 'TEST-POSTED-RET';
        lRecPostedHeader."Employee No." := 'EMP001';
        lRecPostedHeader."Employee Name" := 'Test Employee';
        lRecPostedHeader."Transaction Type" := lRecPostedHeader."Transaction Type"::Assignment;
        if not lRecPostedHeader.Insert() then
            lRecPostedHeader.Get('TEST-POSTED-RET');

        lRecPostedLine.Init();
        lRecPostedLine."Document No." := 'TEST-POSTED-RET';
        lRecPostedLine."Line No." := 10000;
        lRecPostedLine."Asset No." := 'TEST-ASSET-RETURN';
        if not lRecPostedLine.Insert() then begin
            lRecPostedLine.Get('TEST-POSTED-RET', 10000);
        end;

        lCodReturnMgt.ProcessReturn(lRecPostedHeader);

        lRecAsset.Get('TEST-ASSET-RETURN');
        if lRecAsset.Status <> lRecAsset.Status::Available then
            Error('Asset status must be Available after return. Current: %1', lRecAsset.Status);
    end;

    [Test]
    procedure TestProcessReturn_ClearsEmployeeNo()
    var
        lRecAsset: Record "Company Asset";
    begin
        lRecAsset.Get('TEST-ASSET-RETURN');
        if lRecAsset."Assigned to Employee No." <> '' then
            Error('Assigned to Employee No. must be blank after return. Current: %1', lRecAsset."Assigned to Employee No.");
    end;

    [Test]
    procedure TestProcessReturn_ClearsLastAssignmentDate()
    var
        lRecAsset: Record "Company Asset";
    begin
        lRecAsset.Get('TEST-ASSET-RETURN');
        if lRecAsset."Last Assignment Date" <> 0D then
            Error('Last Assignment Date must be 0D after return. Current: %1', lRecAsset."Last Assignment Date");
    end;

    [Test]
    procedure TestProcessReturn_CreatesReturnLogEntry()
    var
        lRecLog: Record "Asset Log Entry";
    begin
        lRecLog.SetRange("Asset No.", 'TEST-ASSET-RETURN');
        lRecLog.SetRange("Transaction Type", lRecLog."Transaction Type"::Return);
        if not lRecLog.FindFirst() then
            Error('Return log entry was not created after return processing.');
    end;
}