// Full assignment approval workflow manager.
// Handles: request → pending → approve/reject/delegate → notify → post.
// Integrates with AST Asset Notification for emails.
// Called from the Assignment Card (actions: Send for Approval, Approve, Reject, Delegate).

codeunit 50117 "AST Workflow Mgt."
{
    // ------------------- Request Approval --------------------

    procedure RequestApproval(Var pRecHeader: Record "AST Asset Assignment Header")
    var
        lCodNotification: Codeunit "AST Asset Notification";
        lRecSetup: Record "AST Asset Tracking Setup";

    begin
        pRecHeader.TestField("Employee No.");
        pRecHeader.TestField("Assignment Date");

        if pRecHeader.Status <> pRecHeader.Status::Open
        then
            Error('Only open assignments can be submitted for approval.');

        if pRecHeader."Approval Status" = pRecHeader."Approval Status"::PendingApproval then
            Error('Assignment %1 is already awaiting approval.', pRecHeader."No.");

        lRecSetup.Get();
        pRecHeader."Approval Status" := pRecHeader."Approval Status"::PendingApproval;
        pRecHeader."Approval Requested By" := CopyStr(UserId(), 1, 50);
        pRecHeader."Approval Requested Date" := Today;
        pRecHeader.Modify(true);

        //Notify approver via email

        if lRecSetup."Require Approval" then
            SendApprovalRequestEmail(pRecHeader, lRecSetup."Approval Manager Email");

        LogWorkflowEvent(pRecHeader."No.", 'SUBMITTED',
        StrSubstNo('Submitted by %1 on %2', UserId(), Format(Today)));
    end;

    // -------------------    Approve   --------------------

    procedure ApproveAssignment(var pRecHeader: Record "AST Asset Assignment Header")
    var
        lRecSetup: Record "AST Asset Tracking Setup";
    begin
        if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::PendingApproval then
            Error('Assignment %1 is not pending approval (Current Status: %2).',
            pRecHeader."No.", pRecHeader."Approval Status");

        pRecHeader."Approval Status" := pRecHeader."Approval Status"::Approved;
        pRecHeader."Approved By" := CopyStr(UserId(), 1, 50);
        pRecHeader."Approved Date" := Today();
        pRecHeader.Modify(true);

        lRecSetup.Get();
        SendApprovalDecisionEmail(pRecHeader,
        lRecSetup."Approval Manager Email", true);
        LogWorkflowEvent(pRecHeader."No.", 'APPROVED',
        StrSubstNo('Approved by %1 on %2', UserId(), Format(Today)));
    end;

    // ------------------- Reject --------------------

    procedure RejectAssignment(var pRecHeader: Record "AST Asset Assignment Header"; pTxtReason: Text[250])

    var
        lRecSetup: Record "AST Asset Tracking Setup";
    begin
        if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::PendingApproval then
            Error('Assignment %1 is not pending approval.', pRecHeader."No.");

        pRecHeader."Approval Status" := pRecHeader."Approval Status"::Rejected;
        pRecHeader."Rejection Reason" := pTxtReason;
        pRecHeader."Approved By" := CopyStr(UserId(), 1, 50);
        pRecHeader."Approved Date" := Today;
        pRecHeader.Modify(true);

        lRecSetup.Get();
        SendApprovalDecisionEmail(pRecHeader, lRecSetup."Approval Manager Email", false);
        LogWorkflowEvent(pRecHeader."No.", 'REJECTED',
        StrSubstNo('Rejected by %1. Reason: %2', UserId(), pTxtReason));

    end;

    // ------------------- Delegate (Re-route to another approver) --------------------

    procedure DelegateApproval(var pRecHeader: Record "AST Asset Assignment Header";
                                    pTxtDelegateTo: Text[50])
    begin
        if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::PendingApproval then
            Error('Only Pending Approval assignments can be delegated.');

        if pTxtDelegateTo = '' then
            Error('Delegate-to user must be specified.');

        pRecHeader."Delegated To" := pTxtDelegateTo;
        pRecHeader.Modify(true);
        LogWorkflowEvent(pRecHeader."No.", 'DELEGATED',
            StrSubstNo('Delegated by %1 to %2 on %3',
                UserId(), pTxtDelegateTo, Format(Today)));
    end;

    // ------------------- Recall (Return to open before approval decision) --------------------

    procedure RecallApprovalRequest(var pRecHeader: Record "AST Asset Assignment Header")
    begin
        if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::PendingApproval then
            Error('Only Pending Approval assignments can be recalled.');

        pRecHeader."Approval Status" := pRecHeader."Approval Status"::Open;
        pRecHeader."Approval Requested By" := '';
        pRecHeader."Delegated To" := '';
        pRecHeader.Modify(true);
        LogWorkflowEvent(pRecHeader."No.", 'RECALLED',
            StrSubstNo('Recalled by %1 on %2', UserId(), Format(Today)));
    end;

    // ------------------- BATCH: escalate assignments pending approval beyond threshold --------------------

    procedure EscalateOverdueApprovals()
    var
        lRecHeader: Record "AST Asset Assignment Header";
        lRecSetup: Record "AST Asset Tracking Setup";
        lIntEscalateDays: Integer;
        lIntCount: Integer;
    begin
        lRecSetup.Get();
        lIntEscalateDays := lRecSetup."Approval Escalation Days";
        if lIntEscalateDays <= 0 then
            lIntEscalateDays := 3; // Default: escalate after 3 days

        lRecHeader.SetRange("Approval Status", lRecHeader."Approval Status"::PendingApproval);
        lRecHeader.SetFilter("Approval Requested Date",
            '<%1', CalcDate(StrSubstNo('<-%1D>', lIntEscalateDays), Today));
        if lRecHeader.FindSet(true) then
            repeat
                lRecHeader."Escalated" := true;
                lRecHeader.Modify(true);
                SendEscalationEmail(lRecHeader, lRecSetup."Approval Manager Email");
                LogWorkflowEvent(lRecHeader."No.", 'ESCALATED',
                    StrSubstNo('Escalated on %1: pending > %2 days',
                        Format(Today), lIntEscalateDays));
                lIntCount += 1;
            until lRecHeader.Next() = 0;

        if lIntCount > 0 then
            Message('%1 assignment(s) have been escalated to the approval manager.', lIntCount);
    end;

    // ------------------- INTERNAL: email helpers (best-effort; wrap in try/catch) --------------------

    local procedure SendApprovalRequestEmail(pRecHeader: Record "AST Asset Assignment Header";
                                                 pTxtApproverEmail: Text[100])
    var
        lCodEmail: Codeunit "AST Email Mgt.";
    begin
        if pTxtApproverEmail = '' then
            exit;
        lCodEmail.SendApprovalRequestNotification(pRecHeader, pTxtApproverEmail);
    end;

    local procedure SendApprovalDecisionEmail(pRecHeader: Record "AST Asset Assignment Header";
                                               pTxtManagerEmail: Text[100];
                                               pBolApproved: Boolean)
    var
        lCodEmail: Codeunit "AST Email Mgt.";
    begin
        lCodEmail.SendApprovalDecisionNotification(pRecHeader, pTxtManagerEmail, pBolApproved);
    end;

    local procedure SendEscalationEmail(pRecHeader: Record "AST Asset Assignment Header";
                                         pTxtManagerEmail: Text[100])
    var
        lCodEmail: Codeunit "AST Email Mgt.";
    begin
        if pTxtManagerEmail = '' then
            exit;
        lCodEmail.SendEscalationNotification(pRecHeader, pTxtManagerEmail);
    end;

    // ------------------- INTERNAL: audit log --------------------

    local procedure LogWorkflowEvent(pTxtDocNo: Code[20];
                                       pTxtEvent: Code[30];
                                       pTxtDetails: Text[250])
    var
        lRecLog: Record "AST Asset Log Entry";
        lIntNextEntry: Integer;
    begin
        lRecLog.SetLoadFields("Entry No.");
        if lRecLog.FindLast() then
            lIntNextEntry := lRecLog."Entry No." + 1
        else
            lIntNextEntry := 1;

        lRecLog.Init();
        lRecLog."Entry No." := lIntNextEntry;
        lRecLog."Asset No." := '';           // header-level event
        lRecLog."Document No." := pTxtDocNo;
        lRecLog."Log Entry Type" := lRecLog."Log Entry Type"::Assigned; // closest enum value
        lRecLog.Description := CopyStr(StrSubstNo('[WORKFLOW:%1] %2', pTxtEvent, pTxtDetails), 1, 250);
        lRecLog."Changed By" := CopyStr(UserId(), 1, 50);
        lRecLog."Changed Date" := Today;
        lRecLog."Changed Time" := Time;
        lRecLog.Insert();
    end;
}