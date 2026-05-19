// Manages the full lifecycle of an Asset Transfer document:
// Approve → Complete → Cancel.
// On Complete: moves assets from From Employee to To Employee
// and creates an AST Asset Log Entry per asset.
codeunit 50115 "AST Asset Transfer Mgt"
{
    procedure ApproveTransfer(var pHdr: Record "AST Asset Transfer Header")
    begin
        if pHdr.Status <> pHdr.Status::Open then
            Error('Transfer %1 must be Open to approve.', pHdr."No.");
        pHdr.Status          := pHdr.Status::Approved;
        pHdr."Approved By"   := CopyStr(UserId(), 1, 50);
        pHdr."Approval Date" := Today;
        pHdr.Modify(true);
    end;

    procedure CompleteTransfer(var pHdr: Record "AST Asset Transfer Header")
    var
        lLine:  Record "AST Asset Transfer Line";
        lAsset: Record "AST Company Asset";
        lLog:   Codeunit "AST Asset Log Mgt.";
        lEmp:   Record Employee;
    begin
        if pHdr.Status <> pHdr.Status::Approved then
            Error('Transfer %1 must be Approved before completing.', pHdr."No.");
        pHdr.TestField("From Employee No.");
        pHdr.TestField("To Employee No.");
        if pHdr."From Employee No." = pHdr."To Employee No." then
            Error('From and To employees cannot be the same.');

        lLine.SetRange("Document No.", pHdr."No.");
        if lLine.IsEmpty() then
            Error('No asset lines on transfer %1.', pHdr."No.");

        if lEmp.Get(pHdr."To Employee No.") then
            pHdr."To Employee Name" := CopyStr(lEmp."First Name" + ' ' + lEmp."Last Name", 1, 100);

        if lLine.FindSet() then
            repeat
                lAsset.Get(lLine."Asset No.");
                if lAsset."Assigned to Employee No." <> pHdr."From Employee No." then
                    Error('Asset %1 is not assigned to %2.', lLine."Asset No.", pHdr."From Employee No.");

                lLog.CreateLogEntry(lAsset, lAsset.Status::Assigned, lAsset.Status::Assigned,
                    "AST Transaction Type"::Transfer, pHdr."No.",
                    pHdr."To Employee No.", pHdr."To Employee Name");

                lAsset."Assigned to Employee No."  := pHdr."To Employee No.";
                lAsset."Assigned to Employee Name" := pHdr."To Employee Name";
                lAsset."Last Assignment Date"       := pHdr."Transfer Date";
                lAsset.Condition                    := lLine.Condition;
                lAsset.Modify(true);
            until lLine.Next() = 0;

        pHdr.Status          := pHdr.Status::Completed;
        pHdr."Approved By"   := CopyStr(UserId(), 1, 50);
        pHdr."Approval Date" := Today;
        pHdr.Modify(true);
        Message('Transfer %1 completed. Assets moved to %2.', pHdr."No.", pHdr."To Employee Name");
    end;

    procedure CancelTransfer(var pHdr: Record "AST Asset Transfer Header")
    begin
        if pHdr.Status = pHdr.Status::Completed then
            Error('Completed transfers cannot be cancelled.');
        pHdr.Status := pHdr.Status::Cancelled;
        pHdr.Modify(true);
    end;
}
