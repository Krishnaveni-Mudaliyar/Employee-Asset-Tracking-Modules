table 50109 "Asset Transfer Header"
{
    Caption = 'Asset Transfer Header';
    LookupPageId = "Asset Transfer List";
    DrillDownPageId = "Asset Transfer List";

    fields
    {
        field(1; "No."; Code[20]) { Caption = 'No.'; DataClassification = CustomerContent; }
        field(2; "From Employee No."; Code[20]) { Caption = 'From Employee No.'; TableRelation = Employee; DataClassification = CustomerContent; }
        field(3; "From Employee Name"; Text[100]) { Caption = 'From Employee Name'; Editable = false; DataClassification = CustomerContent; }
        field(4; "To Employee No."; Code[20]) { Caption = 'To Employee No.'; TableRelation = Employee; DataClassification = CustomerContent; }
        field(5; "To Employee Name"; Text[100]) { Caption = 'To Employee Name'; Editable = false; DataClassification = CustomerContent; }
        field(6; "Transfer Date"; Date) { Caption = 'Transfer Date'; DataClassification = CustomerContent; }
        field(7; "From Department"; Text[50]) { Caption = 'From Department'; Editable = false; DataClassification = CustomerContent; }
        field(8; "To Department"; Text[50]) { Caption = 'To Department'; DataClassification = CustomerContent; }
        field(9; Status; Enum "Transfer Status") { Caption = 'Status'; Editable = false; DataClassification = CustomerContent; }
        field(10; Reason; Text[250]) { Caption = 'Reason'; DataClassification = CustomerContent; }
        field(11; "No. of Lines"; Integer) { Caption = 'No. of Lines'; FieldClass = FlowField; CalcFormula = Count("Asset Transfer Line" where("Document No." = field("No."))); Editable = false; }
        field(12; "Approved By"; Code[50]) { Caption = 'Approved By'; Editable = false; DataClassification = CustomerContent; }
        field(13; "Approval Date"; Date) { Caption = 'Approval Date'; Editable = false; DataClassification = CustomerContent; }
        field(101; "Created By"; Code[50]) { Caption = 'Created By'; Editable = false; DataClassification = CustomerContent; }
        field(102; "Created Date"; Date) { Caption = 'Created Date'; Editable = false; DataClassification = CustomerContent; }
    }
    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(FromEmp; "From Employee No.") { }
        key(ToEmp; "To Employee No.") { }
        key(Status; Status) { }
    }
    trigger OnInsert()
    var
        lSetup: Record "Asset Tracking Setup";
        lNS: Codeunit "No. Series";
        lEmp: Record Employee;
    begin
        if "No." = '' then begin
            lSetup.Get();
            lSetup.TestField("Transfer Nos.");
            "No." := lNS.GetNextNo(lSetup."Transfer Nos.", Today, true);
        end;
        Status := Status::Open;
        if "Transfer Date" = 0D then "Transfer Date" := Today;
        if lEmp.Get("From Employee No.") then begin
            "From Employee Name" := CopyStr(lEmp."First Name" + ' ' + lEmp."Last Name", 1, 100);
            "From Department" := lEmp."Global Dimension 1 Code";
        end;
        if lEmp.Get("To Employee No.") then
            "To Employee Name" := CopyStr(lEmp."First Name" + ' ' + lEmp."Last Name", 1, 100);
        "Created By" := CopyStr(UserId(), 1, 50);
        "Created Date" := Today;
    end;

    trigger OnDelete()
    var
        lLine: Record "Asset Transfer Line";
    begin
        if Status = Status::Completed then Error('Completed transfers cannot be deleted.');
        lLine.SetRange("Document No.", "No.");
        lLine.DeleteAll(true);
    end;
}
