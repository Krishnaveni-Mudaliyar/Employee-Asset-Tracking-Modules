// NOTE: This codeunit has been corrected.
// The original referenced "Customer Approval Setup" and "Customer Approval Log"
// which do not exist in this extension. It has been rewritten to use only
// standard BC Customer table fields (via table extension pattern) and
// Asset Log Entry for audit logging.
//
// PREREQUISITE: A tableextension on Customer must add the following fields:
//   "Approval Status" (Enum), "Approval Requested By" (Code[50]),
//   "Approval Requested Date" (Date), "Approved By" (Code[50]),
//   "Approved Date" (Date), "Block Customer Until Release" logic.
// Until that extension is added, this codeunit should NOT be published.
// It is included here for completeness and will compile once the Customer
// table extension (TabExt.50104.CustomerApprovalExt.al) is added.

codeunit 50118 "Customer Approval Mgt."
{
    // Caption = 'Customer Approval Management';

    procedure RequestApproval(var pRecCustomer: Record Customer)
    begin
        pRecCustomer.TestField("No.");
        pRecCustomer.TestField(Name);

        if pRecCustomer."Approval Status" = pRecCustomer."Approval Status"::"open" then
            Error('Customer %1 is already pending approval.', pRecCustomer."No.");

        if pRecCustomer."Approval Status" = pRecCustomer."Approval Status"::Released then
            Error('Customer %1 is already released. Use Reopen to change.', pRecCustomer."No.");

        pRecCustomer."Approval Status" := pRecCustomer."Approval Status"::"Pending for Approval";
        pRecCustomer."Approval Requested By" := CopyStr(UserId(), 1, 50);
        pRecCustomer."Approval Request Date" := CurrentDateTime;
        pRecCustomer.Validate(Blocked, Enum::"Customer Blocked"::All);
        pRecCustomer.Modify(true);

        LogEvent(pRecCustomer."No.", StrSubstNo('SUBMITTED by %1', UserId()));
        Message('Approval request sent for customer %1.', pRecCustomer."No.");
    end;

    procedure ApproveCustomer(var pRecCustomer: Record Customer)
    begin
        if pRecCustomer."Approval Status" <> pRecCustomer."Approval Status"::"Pending for Approval" then
            Error('Customer %1 is not pending approval. Current status: %2.',
                pRecCustomer."No.", pRecCustomer."Approval Status");

        ValidatePANUniqueness(pRecCustomer."No.", pRecCustomer."VAT Registration No.");
        pRecCustomer.TestField(Name);
        pRecCustomer.TestField(Address);
        pRecCustomer.TestField(City);

        pRecCustomer."Approval Status" := pRecCustomer."Approval Status"::Released;
        pRecCustomer."Approved By" := CopyStr(UserId(), 1, 50);
        pRecCustomer."Approved Date" := Today();
        pRecCustomer.Validate(Blocked, Enum::"Customer Blocked"::" ");
        pRecCustomer.Modify(true);

        LogEvent(pRecCustomer."No.", StrSubstNo('APPROVED by %1', UserId()));
        Message('Customer %1 has been approved and released.', pRecCustomer."No.");
    end;

    procedure RejectCustomer(var pRecCustomer: Record Customer; pReason: Text[250])
    begin
        if pRecCustomer."Approval Status" <> pRecCustomer."Approval Status"::"Pending for Approval" then
            Error('Customer %1 is not pending approval.', pRecCustomer."No.");

        pRecCustomer."Approval Status" := pRecCustomer."Approval Status"::Rejected;
        pRecCustomer."Approved By" := CopyStr(UserId(), 1, 50);
        pRecCustomer."Approved Date" := Today();
        pRecCustomer.Modify(true);

        LogEvent(pRecCustomer."No.", CopyStr(StrSubstNo('REJECTED by %1. Reason: %2', UserId(), pReason), 1, 250));
        Message('Customer %1 has been rejected.', pRecCustomer."No.");
    end;

    procedure ReopenCustomer(var pRecCustomer: Record Customer)
    begin
        if pRecCustomer."Approval Status" <> pRecCustomer."Approval Status"::Released then
            Error('Can only reopen released customers. Current status: %1.', pRecCustomer."Approval Status");

        if not Confirm('Reopen customer %1? This will reset the approval.', true, pRecCustomer."No.") then
            exit;

        pRecCustomer."Approval Status" := pRecCustomer."Approval Status"::Open;
        pRecCustomer.Blocked := pRecCustomer.Blocked::All;
        pRecCustomer."Approved By" := '';
        pRecCustomer."Approved Date" := 0D;
        pRecCustomer."Approval Requested By" := '';
        pRecCustomer."Approval Request Date" := CurrentDateTime;
        pRecCustomer.Modify(true);

        LogEvent(pRecCustomer."No.", StrSubstNo('REOPENED by %1', UserId()));
        Message('Customer %1 has been reopened.', pRecCustomer."No.");
    end;

    local procedure ValidatePANUniqueness(pCodCustomerNo: Code[20]; pTxtVATNo: Text[20])
    var
        lRecCustomer: Record Customer;
    begin
        if pTxtVATNo = '' then
            Error('VAT Registration No. (PAN) is mandatory before releasing.');
        lRecCustomer.SetFilter("No.", '<>%1', pCodCustomerNo);
        lRecCustomer.SetRange("VAT Registration No.", pTxtVATNo);
        if lRecCustomer.FindFirst() then
            Error('VAT Registration No. %1 is already assigned to customer %2.', pTxtVATNo, lRecCustomer."No.");
    end;

    local procedure LogEvent(pCodCustomerNo: Code[20]; pTxtDetails: Text[250])
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
        lRecLog."Document No." := pCodCustomerNo;
        lRecLog."Log Entry Type" := lRecLog."Log Entry Type"::Assignment;
        lRecLog.Description := CopyStr(StrSubstNo('[CUST-APPROVAL] %1', pTxtDetails), 1, 250);
        lRecLog."Changed By" := CopyStr(UserId(), 1, 50);
        lRecLog."Changed Date" := Today();
        lRecLog."Changed Time" := Time();
        lRecLog.Insert();
    end;
}