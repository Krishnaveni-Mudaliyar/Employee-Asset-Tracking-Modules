codeunit 50118 "Customer Approval Mgt"
{
    Caption = 'Customer Approval Management';

    // ==================== REQUEST APPROVAL ====================
    procedure RequestApproval(var pRecCustomer: Record Customer)
    var
        lRecSetup: Record "Customer Approval Setup";
    begin
        lRecSetup.Get('SETUP');

        // Validate mandatory fields
        pRecCustomer.TestField("No.");
        pRecCustomer.TestField(Name);

        // Check current status
        if pRecCustomer."Approval Status" = pRecCustomer."Approval Status"::"Pending for Approval" then
            Error('Customer %1 is already pending approval.', pRecCustomer."No.");

        if pRecCustomer."Approval Status" = pRecCustomer."Approval Status"::Released then
            Error('Customer %1 is already released. Use Reopen to change.', pRecCustomer."No.");

        // Set status to Pending
        pRecCustomer."Approval Status" := pRecCustomer."Approval Status"::"Pending for Approval";
        pRecCustomer."Approval Requested By" := CopyStr(UserId(), 1, 50);
        pRecCustomer."Approval Requested Date" := Today();

        // Block if configured
        if lRecSetup."Block Customer Until Release" then
            pRecCustomer.Blocked := pRecCustomer.Blocked::All;

        pRecCustomer.Modify(true);

        // Log event
        LogApprovalEvent(pRecCustomer."No.", 'SUBMITTED', StrSubstNo('Submitted by %1', UserId()));

        Message('Approval request sent for customer %1.', pRecCustomer."No.");
    end;

    // ==================== APPROVE CUSTOMER ====================
    procedure ApproveCustomer(var pRecCustomer: Record Customer)
    var
        lRecSetup: Record "Customer Approval Setup";
    begin
        lRecSetup.Get('SETUP');

        // Validate status
        if pRecCustomer."Approval Status" <> pRecCustomer."Approval Status"::"Pending for Approval" then
            Error('Customer %1 is not pending approval. Current status: %2.',
                pRecCustomer."No.", pRecCustomer."Approval Status");

        // Validate PAN uniqueness
        ValidatePANUniqueness(pRecCustomer."No.", pRecCustomer."VAT Registration No.");

        // Validate mandatory fields before releasing
        pRecCustomer.TestField("No.");
        pRecCustomer.TestField(Name);
        pRecCustomer.TestField(Address);
        pRecCustomer.TestField(City);

        // Set to Released
        pRecCustomer."Approval Status" := pRecCustomer."Approval Status"::Released;
        pRecCustomer."Approved By" := CopyStr(UserId(), 1, 50);
        pRecCustomer."Approved Date" := Today();
        pRecCustomer.Blocked := pRecCustomer.Blocked::" ";  // Unblock for released
        pRecCustomer.Modify(true);

        // Log event
        LogApprovalEvent(pRecCustomer."No.", 'APPROVED', StrSubstNo('Approved by %1', UserId()));

        Message('Customer %1 has been approved and released.', pRecCustomer."No.");
    end;

    // ==================== RELEASE CUSTOMER ====================
    procedure ReleaseCustomer(var pRecCustomer: Record Customer)
    var
        lRecSetup: Record "Customer Approval Setup";
    begin
        lRecSetup.Get('SETUP');

        // Validate status - can only release if pending
        if pRecCustomer."Approval Status" <> pRecCustomer."Approval Status"::"Pending for Approval" then
            Error('Can only release customers pending approval. Current status: %1.', pRecCustomer."Approval Status");

        // Validate mandatory fields
        pRecCustomer.TestField("No.");
        pRecCustomer.TestField(Name);

        // Set to Released
        pRecCustomer."Approval Status" := pRecCustomer."Approval Status"::Released;
        pRecCustomer."Approved By" := CopyStr(UserId(), 1, 50);
        pRecCustomer."Approved Date" := Today();
        pRecCustomer.Blocked := pRecCustomer.Blocked::" ";  // Unblock
        pRecCustomer.Modify(true);

        // Log event
        LogApprovalEvent(pRecCustomer."No.", 'RELEASED', StrSubstNo('Released by %1', UserId()));

        Message('Customer %1 has been released.', pRecCustomer."No.");
    end;

    // ==================== REOPEN CUSTOMER ====================
    procedure ReopenCustomer(var pRecCustomer: Record Customer)
    var
        lRecSetup: Record "Customer Approval Setup";
    begin
        lRecSetup.Get('SETUP');

        // Can only reopen if released
        if pRecCustomer."Approval Status" <> pRecCustomer."Approval Status"::Released then
            Error('Can only reopen released customers. Current status: %1.', pRecCustomer."Approval Status");

        // Confirmation
        if not Confirm('Reopen customer %1? This will reset the approval.', true, pRecCustomer."No.") then
            exit;

        // Reset to Open
        pRecCustomer."Approval Status" := pRecCustomer."Approval Status"::Open;
        pRecCustomer."Blocked" := pRecCustomer.Blocked::All;  // Block for reopened
        pRecCustomer."Approved By" := '';
        pRecCustomer."Approved Date" := 0D;
        pRecCustomer."Approval Requested By" := '';
        pRecCustomer."Approval Requested Date" := 0D;
        pRecCustomer.Modify(true);

        // Log event
        LogApprovalEvent(pRecCustomer."No.", 'REOPENED', StrSubstNo('Reopened by %1', UserId()));

        Message('Customer %1 has been reopened.', pRecCustomer."No.");
    end;

    // ==================== VALIDATION PROCEDURES ====================
    local procedure ValidatePANUniqueness(pCodCustomerNo: Code[20]; pTxtVATNo: Text[20])
    var
        lRecCustomer: Record Customer;
    begin
        if pTxtVATNo = '' then
            Error('VAT Registration No. (PAN) is mandatory before releasing.');

        // Check for duplicate PAN
        lRecCustomer.SetFilter("No.", '<>%1', pCodCustomerNo);
        lRecCustomer.SetRange("VAT Registration No.", pTxtVATNo);

        if lRecCustomer.FindFirst() then
            Error('VAT Registration No. %1 is already assigned to customer %2.', pTxtVATNo, lRecCustomer."No.");
    end;

    // ==================== LOGGING ====================
    local procedure LogApprovalEvent(pCodCustomerNo: Code[20]; pTxtEvent: Text[30]; pTxtDetails: Text[250])
    var
        lRecLog: Record "Customer Approval Log";
        lIntNextEntry: Integer;
    begin
        // Get next entry number
        lRecLog.SetLoadFields("Entry No.");
        if lRecLog.FindLast() then
            lIntNextEntry := lRecLog."Entry No." + 1
        else
            lIntNextEntry := 1;

        // Create log entry
        lRecLog.Init();
        lRecLog."Entry No." := lIntNextEntry;
        lRecLog."Customer No." := pCodCustomerNo;
        lRecLog."Event Type" := pTxtEvent;
        lRecLog.Description := pTxtDetails;
        lRecLog."Changed By" := CopyStr(UserId(), 1, 50);
        lRecLog."Changed Date" := Today();
        lRecLog."Changed Time" := Time();
        lRecLog.Insert();
    end;
}