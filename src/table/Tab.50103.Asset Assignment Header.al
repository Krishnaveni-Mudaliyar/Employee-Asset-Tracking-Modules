table 50103 "Asset Assignment Header"
{
    Caption = 'Asset Assignment';
    DrillDownPageId = "Asset Assignment List";
    LookupPageId = "Asset Assignment List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
            TableRelation = Employee;

            trigger OnValidate()
            var
                lRecEmployee: Record Employee;
            begin
                if "Employee No." = '' then begin
                    "Employee Name" := '';
                    Department := '';
                    exit;
                end;
                lRecEmployee.Get("Employee No.");
                "Employee Name" := CopyStr(lRecEmployee."First Name" + ' ' + lRecEmployee."Last Name", 1, 100);
                Department := lRecEmployee."Global Dimension 1 Code";
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Assignment Date"; Date)
        {
            Caption = 'Assignment Date';
            DataClassification = CustomerContent;
        }
        field(5; "Expected Return Date"; Date)
        {
            Caption = 'Expected Return Date';
            DataClassification = CustomerContent;
        }
        field(6; Status; Enum "Assignment Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; Department; Text[50])
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
        }
        field(9; Purpose; Text[250])
        {
            Caption = 'Purpose';
            DataClassification = CustomerContent;
        }
        field(10; "No. of Lines"; Integer)
        {
            Caption = 'No. of Lines';
            FieldClass = FlowField;
            CalcFormula = Count("Asset Assignment Line"
           where("Document No." = field("No.")));
            Editable = false;
        }
        field(101; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(102; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
        }
        field(103; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(104; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(EmployeeNo; "Employee No.") { }
        key(AssignmentDate; "Assignment Date") { }
    }

    trigger OnInsert()
    var
        lRecSetup: Record "Asset Tracking Setup";
        lCodNoSeries: Codeunit "No. Series";

    begin
        lRecSetup.Get();
        if "No." = '' then begin
            lRecSetup.TestField("Assignment Nos.");
            "No." := lCodNoSeries.GetNextNo(
                lRecSetup."Assignment Nos.", Today, true);
        end;
        Status := Status::Open;
        "Assignment Date" := Today;

        if lRecSetup."Default Return Days" > 0 then
            "Expected Return Date" := Today + lRecSetup."Default Return Days";

        "Created By" := CopyStr(UserId(), 1, 50);
        "Created Date" := Today;
        "Last Modified By" := CopyStr(UserId(), 1, 50);
        "Last Modified Date" := Today;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := CopyStr(UserId(), 1, 50);
        "Last Modified Date" := Today;
    end;

    trigger OnDelete()
    var
        lRecLine: Record "Asset Assignment Line";

    begin
        if Status in [Status::Approved, Status::Posted] then
            Error('You cannot delete assignment %1 with status %2.',
            "No.", Status);

        lRecLine.SetRange("Document No.", "No.");
        lRecLine.DeleteAll(true);
    end;
}