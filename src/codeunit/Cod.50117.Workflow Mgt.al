codeunit 50117 "Workflow Mgt."
{
    procedure RequestApproval(var pRecHeader: Record "Asset Assignment Header")
    var
        lRecSetup: Record "Asset Tracking Setup";
    begin
        pRecHeader.TestField("Employee No.");
        pRecHeader.TestField("Assignment Date");

        if pRecHeader.Status <> pRecHeader.Status::Open then
            Error('Only open assignments can be submitted for approval.');

        if pRecHeader."Approval Status" = pRecHeader."Approval Status"::Open then
            Error('Assignment %1 is already awaiting approval.',
            pRecHeader."No.");

        lRecSetup.Get();
        pRecHeader."Approval Status" := pRecHeader."Approval Status"::Open;
        pRecHeader."Approval Requested By" := CopyStr(UserId(), 1, 50);
        pRecHeader."Approval Requested On" := Today;
        pRecHeader.Modify(true);

        if lRecSetup."Require Approval" then
            SendApprovalRequestEmail(pRecHeader,
            lRecSetup."Approval Manager Email");

        LogWorkflowEvent(pRecHeader."No.", 'SUBMITTED',
            CopyStr(StrSubstNo('Submitted by %1 on %2',
            UserId(),
            Format(Today)),
            1, 250));
    end;

    procedure ApproveAssignment(var pRecHeader: Record "Asset Assignment Header")
    var
        lRecSetup: Record "Asset Tracking Setup";
    begin
        if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::Open then
            Error('Assignment %1 is not pending approval (Current Status: %2).',
                pRecHeader."No.",
                pRecHeader."Approval Status");

        pRecHeader."Approval Status" := pRecHeader."Approval Status"::Approved;
        pRecHeader."Approved By" := CopyStr(UserId(), 1, 50);
        pRecHeader."Approved Date" := Today;
        pRecHeader.Modify(true);

        lRecSetup.Get();
        SendApprovalDecisionEmail(pRecHeader,
        lRecSetup."Approval Manager Email",
        true);

        LogWorkflowEvent(pRecHeader."No.",
        'APPROVED',
            CopyStr(StrSubstNo
            ('Approved by %1 on %2',
            UserId(),
            Format(Today)),
            1, 250));
    end;

    procedure RejectAssignment(var pRecHeader: Record "Asset Assignment Header"; pTxtReason: Text[250])
    var
        lRecSetup: Record "Asset Tracking Setup";
    begin
        if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::Open then
            Error('Assignment %1 is not pending approval.',
            pRecHeader."No.");

        pRecHeader."Approval Status" := pRecHeader."Approval Status"::Rejected;
        pRecHeader."Rejection Reason" := pTxtReason;
        pRecHeader."Approved By" := CopyStr(UserId(), 1, 50);
        pRecHeader."Approved Date" := Today;
        pRecHeader.Modify(true);

        lRecSetup.Get();
        SendApprovalDecisionEmail(pRecHeader, lRecSetup."Approval Manager Email", false);
        LogWorkflowEvent(pRecHeader."No.", 'REJECTED',
            CopyStr(StrSubstNo('Rejected by %1. Reason: %2',
            UserId(),
            pTxtReason),
            1, 250));
    end;

    procedure DelegateApproval(var pRecHeader: Record "Asset Assignment Header"; pTxtDelegateTo: Text[50])
    begin
        if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::Open then
            Error('Only Pending Approval assignments can be delegated.');
        if pTxtDelegateTo = '' then
            Error('Delegate-to user must be specified.');

        pRecHeader."Delegated To" := pTxtDelegateTo;
        pRecHeader.Modify(true);
        LogWorkflowEvent(pRecHeader."No.",
        'DELEGATED',
            CopyStr(StrSubstNo
            ('Delegated by %1 to %2 on %3',
            UserId(),
            pTxtDelegateTo,
            Format(Today)),
            1, 250));
    end;

    procedure RecallApprovalRequest(var pRecHeader: Record "Asset Assignment Header")
    begin
        if pRecHeader."Approval Status" <> pRecHeader."Approval Status"::Open then
            Error('Only Pending Approval assignments can be recalled.');

        pRecHeader."Approval Status" := pRecHeader."Approval Status"::Open;
        pRecHeader."Approval Requested By" := '';
        pRecHeader."Delegated To" := '';
        pRecHeader.Modify(true);
        LogWorkflowEvent(pRecHeader."No.",
        'RECALLED',
            CopyStr(StrSubstNo
            ('Recalled by %1 on %2',
            UserId(), Format(Today)),
            1, 250));
    end;

    procedure EscalateOverdueApprovals()
    var
        lRecHeader: Record "Asset Assignment Header";
        lRecSetup: Record "Asset Tracking Setup";
        lIntEscalateDays: Integer;
        lIntCount: Integer;
    begin
        lRecSetup.Get();
        lIntEscalateDays := lRecSetup."Approval Escalation Days";
        if lIntEscalateDays <= 0 then
            lIntEscalateDays := 3;

        lRecHeader.SetRange("Approval Status", lRecHeader."Approval Status"::Open);
        lRecHeader.SetFilter("Approval Requested On",
            '<%1',
            CalcDate(StrSubstNo
            ('<-%1D>',
            lIntEscalateDays),
            Today));

        if lRecHeader.FindSet(true) then
            repeat
                lRecHeader.Escalated := true;
                lRecHeader.Modify(true);
                SendEscalationEmail(lRecHeader,
                lRecSetup."Approval Manager Email");

                LogWorkflowEvent(lRecHeader."No.",
                'ESCALATED',
                    CopyStr(StrSubstNo('Escalated on %1: pending > %2 days',
                    Format(Today),
                    lIntEscalateDays),
                    1, 250));

                lIntCount += 1;
            until lRecHeader.Next() = 0;

        if lIntCount > 0 then
            Message('%1 assignment(s) have been escalated to the approval manager.',
            lIntCount);
    end;

    local procedure SendApprovalRequestEmail(pRecHeader: Record "Asset Assignment Header"; pTxtApproverEmail: Text[100])
    var
        lCodEmail: Codeunit "Email Mgt.";
    begin
        if pTxtApproverEmail = '' then
            exit;
        lCodEmail.SendApprovalRequestNotification(pRecHeader,
        pTxtApproverEmail);
    end;

    local procedure SendApprovalDecisionEmail(pRecHeader: Record "Asset Assignment Header";
    pTxtManagerEmail: Text[100];
    pBolApproved: Boolean)

    var
        lCodEmail: Codeunit "Email Mgt.";
    begin
        lCodEmail.SendApprovalDecisionNotification(pRecHeader,
        pTxtManagerEmail,
        pBolApproved);
    end;

    local procedure SendEscalationEmail(pRecHeader: Record "Asset Assignment Header"; pTxtManagerEmail: Text[100])
    var
        lCodEmail: Codeunit "Email Mgt.";
    begin
        if pTxtManagerEmail = '' then
            exit;
        lCodEmail.SendEscalationNotification(pRecHeader, pTxtManagerEmail);
    end;

    local procedure LogWorkflowEvent(pTxtDocNo: Code[20]; pTxtEvent: Code[30]; pTxtDetails: Text[250])
    var
        lRecLog: Record "Asset Log Entry";
        lIntNextEntry: Integer;
    begin
        lRecLog.LockTable();
        if lRecLog.FindLast() then
            lIntNextEntry := lRecLog."Entry No." + 1
        else
            lIntNextEntry := 1;

        lRecLog.Init();
        lRecLog."Entry No." := lIntNextEntry;
        lRecLog."Asset No." := '';
        lRecLog."Document No." := pTxtDocNo;
        lRecLog."Log Entry Type" := lRecLog."Log Entry Type"::Assignment;

        lRecLog.Description := CopyStr(StrSubstNo('[WORKFLOW:%1] %2',
        pTxtEvent,
        pTxtDetails),
        1, 250);

        lRecLog."Changed By" := CopyStr(UserId(), 1, 50);
        lRecLog."Changed Date" := Today;
        lRecLog."Changed Time" := Time;
        lRecLog.Insert();
    end;
}