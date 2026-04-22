codeunit 50101 "AST Asset Posting Mgt."
{
    TableNo = "AST Asset Assignment Header";

    trigger OnRun()
    begin
        PostAssetAssignment(Rec);
    end;

    procedure PostAssetAssignment(var pRecHeader: Record "AST Asset Assignment Header")
    var
        lCodValidation: Codeunit "AST Asset Validation";
        lRecLine: Record "AST Asset Assignment Line";
        lRecSetup: Record "AST Asset Tracking Setup";
        lCodEvents: Codeunit "AST Asset Events";
        lBolHandled: Boolean;
        lRecPostedHeader: Record "AST Posted Assignment Header";
    begin
        lRecSetup.Get();
        if lRecSetup."Require Approval" then
            if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::Approved then
                Error('Assignment %1 must be approved before posting. Approval status: %2.',
                    pRecHeader."No.", pRecHeader."Approval Status");

        // Raise before-event — allow other extensions to intercept or cancel
        lCodEvents.OnBeforePostAssetAssignment(pRecHeader, lBolHandled);
        if lBolHandled then
            exit;

        // STEP 1: Validate Header
        lCodValidation.ValidateAssignmentHeader(pRecHeader);

        // STEP 2: Validate every Line
        lRecLine.SetRange("Document No.", pRecHeader."No.");
        if lRecLine.FindSet() then
            repeat
                lCodValidation.ValidateAssignmentLine(lRecLine, pRecHeader);
            until lRecLine.Next() = 0;

        // STEP 3: Create Posted Header
        InsertPostedHeader(pRecHeader);

        // STEP 4: Create Posted Lines + Update Asset statuses + Write log entries
        PostLines(pRecHeader);

        // STEP 5: Delete the original open document
        DeleteOriginalDocument(pRecHeader);

        // Raise after-event — telemetry per asset is already logged inside PostLines.
        lRecPostedHeader := GetPostedHeader(pRecHeader."No.");
        lCodEvents.OnAfterPostAssetAssignment(lRecPostedHeader);
    end;

    procedure SendForApproval(var pRecHeader: Record "AST Asset Assignment Header")
    begin
        pRecHeader.TestField("Employee No.");
        pRecHeader.TestField("Assignment Date");

        if pRecHeader.Status <> pRecHeader.Status::Open then
            Error('Only Open assignments can be sent for approval.');

        if pRecHeader."Approval Status" = pRecHeader."Approval Status"::PendingApproval then
            Error('Assignment %1 is already pending approval.', pRecHeader."No.");

        pRecHeader."Approval Status" := pRecHeader."Approval Status"::PendingApproval;
        pRecHeader.Modify(true);
        Message('Assignment %1 has been sent for approval.', pRecHeader."No.");
    end;

    procedure ApproveAssignment(var pRecHeader: Record "AST Asset Assignment Header")
    begin
        if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::PendingApproval then
            Error('Assignment %1 is not pending approval.', pRecHeader."No.");

        pRecHeader."Approval Status" := pRecHeader."Approval Status"::Approved;
        pRecHeader.Modify(true);
        Message('Assignment %1 has been approved.', pRecHeader."No.");
    end;

    procedure RejectAssignment(var pRecHeader: Record "AST Asset Assignment Header")
    begin
        if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::PendingApproval then
            Error('Assignment %1 is not pending approval.', pRecHeader."No.");

        pRecHeader."Approval Status" := pRecHeader."Approval Status"::Rejected;
        pRecHeader.Modify(true);
        Message('Assignment %1 has been rejected.', pRecHeader."No.");
    end;

    local procedure InsertPostedHeader(var pRecHeader: Record "AST Asset Assignment Header")
    var
        lRecPostedHeader: Record "AST Posted Assignment Header";
    begin
        lRecPostedHeader.Init();
        lRecPostedHeader.TransferFields(pRecHeader);
        lRecPostedHeader."Posting Date" := Today;
        lRecPostedHeader."Posted By" := CopyStr(UserId(), 1, 50);
        lRecPostedHeader."Transaction Type" := lRecPostedHeader."Transaction Type"::Assignment;
        lRecPostedHeader."Created By" := CopyStr(UserId(), 1, 50);
        lRecPostedHeader."Created Date" := Today;
        lRecPostedHeader.Insert(true);
    end;

    local procedure PostLines(var pRecHeader: Record "AST Asset Assignment Header")
    var
        lRecLine: Record "AST Asset Assignment Line";
        lRecPostedLine: Record "AST Posted Assignment Line";
        lRecAsset: Record "AST Company Asset";
        lCodLogMgt: Codeunit "AST Asset Log Mgt.";
        lCodTelemetry: Codeunit "AST Telemetry";
        lEnumStatusBefore: Enum "AST Asset Status";
    begin
        lRecLine.SetLoadFields("Document No.", "Line No.", "Asset No.", "Condition at Handover", Notes);
        lRecLine.SetRange("Document No.", pRecHeader."No.");
        if lRecLine.FindSet() then
            repeat
                lRecAsset.Get(lRecLine."Asset No.");
                lEnumStatusBefore := lRecAsset.Status;

                // Snapshot asset data at posting time into Posted Line
                lRecPostedLine.Init();
                lRecPostedLine."Document No." := pRecHeader."No.";
                lRecPostedLine."Line No." := lRecLine."Line No.";
                lRecPostedLine."Asset No." := lRecLine."Asset No.";
                lRecPostedLine."Asset Description" := lRecAsset.Description;
                lRecPostedLine."Serial No." := lRecAsset."Serial No.";
                lRecPostedLine."Category Code" := lRecAsset."Category Code";
                lRecPostedLine."Condition at Handover" := lRecLine."Condition at Handover";
                lRecPostedLine.Notes := lRecLine.Notes;
                lRecPostedLine.Insert(true);

                // Update asset status and employee reference
                lRecAsset.Status := lRecAsset.Status::Assigned;
                lRecAsset."Assigned to Employee No." := pRecHeader."Employee No.";
                // FIX: Populate the stored Employee Name field (no longer a FlowField)
                lRecAsset."Assigned to Employee Name" := CopyStr(pRecHeader."Employee Name", 1, 100);
                lRecAsset."Last Assignment Date" := pRecHeader."Assignment Date";
                lRecAsset.Modify(true);

                // Write audit log
                lCodLogMgt.CreateLogEntry(
                    lRecAsset,
                    lEnumStatusBefore,
                    lRecAsset.Status::Assigned,
                    "AST Transaction Type"::Assignment,
                    pRecHeader."No.",
                    pRecHeader."Employee No.",
                    pRecHeader."Employee Name");

                // FIX: Log one telemetry event per asset line — not a single 'MULTI'
                // placeholder. Application Insights receives a distinct signal per asset,
                // enabling accurate per-asset analytics and alerting.
                lCodTelemetry.LogAssetAssigned(
                    lRecLine."Asset No.",
                    pRecHeader."Employee No.",
                    pRecHeader."No.");

            until lRecLine.Next() = 0;
    end;

    local procedure DeleteOriginalDocument(var pRecHeader: Record "AST Asset Assignment Header")
    var
        lRecLine: Record "AST Asset Assignment Line";
    begin
        // Reset Status to Open so the OnDelete trigger's guard passes
        // (it blocks delete on Approved/Posted — Open is always deletable).
        // Do NOT touch Approval Status — setting it to Rejected before delete
        // would write a misleading audit record showing the document was rejected
        // when it was actually posted successfully.
        pRecHeader.Status := pRecHeader.Status::Open;
        pRecHeader.Modify(false); // RunTrigger = false — skip OnModify audit stamp; transient state

        lRecLine.SetRange("Document No.", pRecHeader."No.");
        lRecLine.DeleteAll(true);
        pRecHeader.Delete(true);
    end;

    local procedure GetPostedHeader(pCodNo: Code[20]): Record "AST Posted Assignment Header"
    var
        lRecPostedHeader: Record "AST Posted Assignment Header";
    begin
        lRecPostedHeader.Get(pCodNo);
        exit(lRecPostedHeader);
    end;
}
