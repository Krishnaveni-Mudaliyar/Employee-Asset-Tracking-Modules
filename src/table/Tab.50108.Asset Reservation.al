table 50108 "Asset Reservation"
{
    Caption = 'Asset Reservation';
    LookupPageId = "Asset Reservation List";
    DrillDownPageId = "Asset Reservation List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            TableRelation = "Company Asset";
            DataClassification = CustomerContent;
        }
        field(3; "Asset Description"; Text[100])
        {
            Caption = 'Asset Description';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(4; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            TableRelation = Employee;
            DataClassification = CustomerContent;
        }
        field(5; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(6; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = CustomerContent;
        }
        field(7; "To Date"; Date)
        {
            Caption = 'To Date';
            DataClassification = CustomerContent;
        }
        field(8; Status; Enum "Reservation Status")
        {
            Caption = 'Status';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(9; Purpose; Text[250])
        {
            Caption = 'Purpose';
            DataClassification = CustomerContent;
        }
        field(10; Department; Text[50])
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
        }
        field(11; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(12; "Fulfilled By Doc."; Code[20])
        {
            Caption = 'Fulfilled by Assignment No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(101; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(102; "Created Date"; Date)
        {
            Caption = 'Created Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(AssetDate; "Asset No.", "From Date") { }
        key(EmployeeNo; "Employee No.") { }
        key(Status; Status) { }
    }
    trigger OnInsert()
    var
        lSetup: Record "Asset Tracking Setup";
        lAsset: Record "Company Asset";
        lEmp: Record Employee;
    begin
        if "No." = '' then
            "No." := CopyStr(
                'RES-' +
                Format(Today, 0, '<Year4><Month,2><Day,2>') +
                 '-'
                 + Format(Time, 0, '<Hours24><Minutes,2>'),
                  1,
                   20);

        if "From Date" = 0D then
            "From Date" := Today;

        if "To Date" = 0D then
            Error('Please specify a To Date.');

        if "To Date" <= "From Date" then
            Error('To Date must be after From Date.');

        if lAsset.Get("Asset No.") then begin
            "Asset Description" := lAsset.Description;
            if not (lAsset.Status in [lAsset.Status::Available]) then
                Error('Asset %1 is not Available for reservation (status: %2).', "Asset No.", lAsset.Status);
        end;

        if lEmp.Get("Employee No.") then
            "Employee Name" := CopyStr(lEmp."First Name" + ' ' + lEmp."Last Name", 1, 100);

        Rec.Status := Enum::"Asset Reservation Status"::Active;
        lSetup.Get();
        "Expiry Date" := Today + lSetup."Reservation Expiry Days";
        "Created By" := CopyStr(UserId(), 1, 50);
        "Created Date" := Today;
    end;
}