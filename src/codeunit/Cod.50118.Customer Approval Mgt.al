codeunit 50118 "Customer Management"
{
    /// <summary>
    /// Request approval for a customer to be released
    /// </summary>
    procedure RequestApproval(var Customer: Record Customer)
    var
        ApprovalRequest: Record "Customer Approval Request";
        ApprovalMgt: Codeunit "Approval Request Management";
        ConfirmMessage: Label 'Do you want to request approval for this customer?';
    begin
        if not Confirm(ConfirmMessage) then
            exit;

        // Validate mandatory fields before approval
        ValidateCustomerBeforeApproval(Customer);

        // Create approval request record
        ApprovalRequest.Init();
        ApprovalRequest."Customer No." := Customer."No.";
        ApprovalRequest.Status := ApprovalRequest.Status::"Pending Approval";
        ApprovalRequest."Requested Date" := Today();
        ApprovalRequest."Requested By" := UserId();
        ApprovalRequest.Insert(true);

        // Update customer status
        Customer."Approval Status" := Customer."Approval Status"::"Pending for Approval";
        Customer."Requested By" := UserId();
        Customer."Request Date" := CurrentDateTime();
        Customer."Blocked" := Customer."Blocked"::Invoice;
        Customer.Modify(true);

        Message('Approval request has been submitted.');
    end;

    /// <summary>
    /// Release customer (Approve)
    /// </summary>
    procedure ReleaseCustomer(var Customer: Record Customer)
    var
        ApprovalRequest: Record "Customer Approval Request";
        ReleaseMsg: Label 'Do you want to release this customer?';
    begin
        if not Confirm(ReleaseMsg) then
            exit;

        if Customer."Approval Status" <> Customer."Approval Status"::"Pending for Approval" then
            Error('Only customers pending approval can be released.');

        // Update customer status to released
        Customer."Approval Status" := Customer."Approval Status"::Released;
        Customer."Blocked" := Customer."Blocked"::" ";
        Customer.Modify(true);

        // Update approval request
        if ApprovalRequest.Get(Customer."No.") then begin
            ApprovalRequest.Status := ApprovalRequest.Status::Approved;
            ApprovalRequest."Approved Date" := Today();
            ApprovalRequest."Approved By" := UserId();
            ApprovalRequest.Modify(true);
        end;

        Message('Customer released successfully.');
    end;

    /// <summary>
    /// Reject customer approval request
    /// </summary>
    procedure RejectCustomer(var Customer: Record Customer; RejectionReason: Text)
    var
        ApprovalRequest: Record "Customer Approval Request";
        RejectMsg: Label 'Do you want to reject this customer approval request?';
    begin
        if not Confirm(RejectMsg) then
            exit;

        if Customer."Approval Status" <> Customer."Approval Status"::"Pending for Approval" then
            Error('Only pending customers can be rejected.');

        // Update customer status back to open
        Customer."Approval Status" := Customer."Approval Status"::Open;
        Customer."Blocked" := Customer."Blocked"::" ";
        Customer.Modify(true);

        // Update approval request
        if ApprovalRequest.Get(Customer."No.") then begin
            ApprovalRequest.Status := ApprovalRequest.Status::Rejected;
            ApprovalRequest."Rejection Reason" := CopyStr(RejectionReason, 1, 250);
            ApprovalRequest."Rejected Date" := Today();
            ApprovalRequest."Rejected By" := UserId();
            ApprovalRequest.Modify(true);
        end;

        Message('Approval request has been rejected.');
    end;

    /// <summary>
    /// Reopen released customer
    /// </summary>
    procedure ReopenCustomer(var Customer: Record Customer)
    var
        ApprovalRequest: Record "Customer Approval Request";
        ReopenMsg: Label 'Do you want to reopen this customer? This will require new approval.';
    begin
        if not Confirm(ReopenMsg) then
            exit;

        if Customer."Approval Status" <> Customer."Approval Status"::Released then
            Error('Only released customers can be reopened.');

        // Update customer status to open
        Customer."Approval Status" := Customer."Approval Status"::Open;
        Customer.Modify(true);

        // Archive approval request
        if ApprovalRequest.Get(Customer."No.") then begin
            ApprovalRequest.Status := ApprovalRequest.Status::Reopened;
            ApprovalRequest.Modify(true);
        end;

        Message('Customer has been reopened and now requires new approval.');
    end;

    /// <summary>
    /// Validate customer before approval request
    /// </summary>
    local procedure ValidateCustomerBeforeApproval(var Customer: Record Customer)
    begin
        if Customer."No." = '' then
            Error('Customer number is required.');

        if Customer.Name = '' then
            Error('Customer name is required.');

        if Customer."Gen. Bus. Posting Group" = '' then
            Error('Gen. Bus. Posting Group is required before approval.');

        if Customer."Customer Posting Group" = '' then
            Error('Customer Posting Group is required before approval.');

        if Customer."Payment Terms Code" = '' then
            Error('Payment Terms Code is required before approval.');

        // Check for duplicate PAN No.
        if ValidatePANNoDuplicate(Customer) then
            Error('PAN No. %1 is already assigned to another customer.', Customer."VAT Registration No.");
    end;

    /// <summary>
    /// Validate PAN No. for duplicate entries
    /// </summary>
    local procedure ValidatePANNoDuplicate(var Customer: Record Customer): Boolean
    var
        OtherCustomer: Record Customer;
    begin
        OtherCustomer.SetFilter("No.", '<>%1', Customer."No.");
        OtherCustomer.SetFilter("VAT Registration No.", '%1', Customer."VAT Registration No.");
        exit(OtherCustomer.FindFirst());
    end;

    /// <summary>
    /// Get customer approval status display text
    /// </summary>
    procedure GetApprovalStatusText(ApprovalStatus: Enum "Approval Status"): Text
    begin
        case ApprovalStatus of
            ApprovalStatus::Open:
                exit('Open');
            ApprovalStatus::"Pending for Approval":
                exit('Pending for Approval');
            ApprovalStatus::Released:
                exit('Released');
        end;
    end;
}
