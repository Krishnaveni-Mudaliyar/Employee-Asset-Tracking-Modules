codeunit 50109 "Email Mgt"
{
    procedure SendOverdueEmail(pCount: Integer)
    var
        lSetup: Record "Asset Tracking Setup";
        lEmail: Codeunit Email;
        lMsg: Codeunit "Email Message";
        lHdr: Record "Posted Assignment Header";
        lBody: Text;
    begin
        lSetup.Get();
        if not lSetup."Send Email Notification"
        then
            exit;
        lSetup.TestField("Admin Email Address");

        lBody := StrSubstNo('<h2 style="color:#c0392b">%1 Overdue Return(s) as of %2</h2>', pCount, Format(Today));
        lBody += '<table border="1" cellpadding="4"><tr><th>Assignment</th><th>Employee</th><th>Dept</th><th>Expected Return</th><th>Days Overdue</th></tr>';
        lHdr.SetRange("Is Overdue", true);
        lHdr.SetRange("Return Date", 0D);
        if lHdr.FindSet() then
            repeat
                lBody += StrSubstNo('<tr><td>%1</td><td>%2</td><td>%3</td><td>%4</td><td><b>%5</b></td></tr>',
                    lHdr."No.", lHdr."Employee Name", lHdr.Department,
                    Format(lHdr."Expected Return Date"), lHdr."Overdue Days");
            until lHdr.Next() = 0;
        lBody += '</table>';

        lMsg.Create(lSetup."Admin Email Address",
            StrSubstNo('%1 Overdue Return(s) – Action Required – %2', pCount, Format(Today)),
            lBody, true);
        lEmail.Send(lMsg);
    end;

    procedure SendWarrantyExpiryEmail()
    var
        lSetup: Record "Asset Tracking Setup";
        lAsset: Record "Company Asset";
        lEmail: Codeunit Email;
        lMsg: Codeunit "Email Message";
        lBody: Text;
        lCount: Integer;
    begin
        lSetup.Get();
        if not lSetup."Send Email Notification"
        then
            exit;

        lSetup.TestField("Admin Email Address");
        lAsset.SetFilter("Warranty Expiry Date", '>=%1&<=%2', Today, Today + lSetup."Warranty Alert Days");
        lCount := lAsset.Count();

        if lCount = 0
        then
            exit;

        lBody := StrSubstNo('<h2>%1 Asset Warranty Expiry/Expiries in Next %2 Days</h2>', lCount, lSetup."Warranty Alert Days");
        lBody += '<table border="1" cellpadding="4"><tr><th>Asset No.</th><th>Description</th><th>Expiry</th><th>Status</th></tr>';
        if lAsset.FindSet() then
            repeat
                lBody += StrSubstNo('<tr><td>%1</td><td>%2</td><td>%3</td><td>%4</td></tr>',
                    lAsset."No.", lAsset.Description, Format(lAsset."Warranty Expiry Date"), lAsset.Status);
            until lAsset.Next() = 0;
        lBody += '</table>';

        lMsg.Create(lSetup."Admin Email Address",
            StrSubstNo('%1 Asset Warranty Expiries in %2 Days', lCount, lSetup."Warranty Alert Days"),
            lBody, true);
        lEmail.Send(lMsg);
    end;

    procedure SendApprovalRequestEmail(pHdr: Record "Asset Assignment Header")
    var
        lSetup: Record "Asset Tracking Setup";
        lEmail: Codeunit Email;
        lMsg: Codeunit "Email Message";
        lBody: Text;
    begin
        lSetup.Get();

        if not lSetup."Send Email Notification"
        then
            exit;

        lSetup.TestField("Admin Email Address");
        lBody := '<h2>Approval Required – Asset Assignment</h2>';
        lBody += '<table cellpadding="5">';
        lBody += StrSubstNo('<tr><td><b>Assignment No.</b></td><td>%1</td></tr>', pHdr."No.");
        lBody += StrSubstNo('<tr><td><b>Employee</b></td><td>%1 (%2)</td></tr>', pHdr."Employee Name", pHdr."Employee No.");
        lBody += StrSubstNo('<tr><td><b>Department</b></td><td>%1</td></tr>', pHdr.Department);
        lBody += StrSubstNo('<tr><td><b>Assignment Date</b></td><td>%1</td></tr>', Format(pHdr."Assignment Date"));
        lBody += StrSubstNo('<tr><td><b>Expected Return</b></td><td>%1</td></tr>', Format(pHdr."Expected Return Date"));
        lBody += '</table><p>Please log in to Business Central to Approve or Reject.</p>';
        lMsg.Create(lSetup."Admin Email Address",
            StrSubstNo('Approval Required: Assignment %1', pHdr."No."),
            lBody, true);
        lEmail.Send(lMsg);
    end;

    procedure SendApprovalResultEmail(pHdr: Record "Asset Assignment Header"; pApproved: Boolean)
    var
        lSetup: Record "Asset Tracking Setup";
        lEmp: Record Employee;
        lEmail: Codeunit Email;
        lMsg: Codeunit "Email Message";
        lTo: Text[80];
        lResult: Text;
        lBody: Text;
    begin
        lSetup.Get();

        if not lSetup."Send Email Notification"
        then
            exit;

        lTo := lSetup."Admin Email Address";

        if lEmp.Get(pHdr."Employee No.") and (lEmp."Company E-Mail" <> '')
        then
            lTo := CopyStr(lEmp."Company E-Mail", 1, 80);
        if pApproved
        then
            lResult := 'APPROVED'
        else
            lResult := 'REJECTED';

        lBody := StrSubstNo('<h2>Assignment %1 – %2</h2><p>Dear %3,</p>', pHdr."No.", lResult, pHdr."Employee Name");

        if pApproved
         then
            lBody += '<p style="color:green"><b>Approved.</b> Assets are ready for collection.</p>'
        else
            lBody += '<p style="color:red"><b>Rejected.</b> Please contact your manager for details.</p>';
        lMsg.Create(lTo,
            StrSubstNo('Assignment %1 – %2', pHdr."No.", lResult),
            lBody,
            true);
        lEmail.Send(lMsg);
    end;
}