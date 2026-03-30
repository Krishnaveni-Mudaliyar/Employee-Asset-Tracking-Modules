table 50103 "AST Asset Assignment Header"
{
    Caption = 'Asset Assignment';
    DrillDownPageId = "AST Asset Assignment List";
    LookupPageId = "AST Asset Assignment List";

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
                Department := lRecEmployee."Global Dimension 1 Code";
                "Employee Name" := CopyStr(lRecEmployee."First Name" + ' ' + lRecEmployee."Last Name", 1, 100);
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
        field(6; Status; Enum "AST Assignment Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; "Approval Status"; Enum "AST Approval Status")
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
            CalcFormula = Count("AST Asset Assignment Line"
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
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
        key(EmployeeNo; "Employee No.") { }
        key(AssignmentDate; "Assignment Date") { }
    }

    trigger OnInsert()
    var
        lRecSetup: Record "AST Asset Tracking Setup";
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
    end;

    trigger OnDelete()
    var
        lRecLine: Record "AST Asset Assignment Line";

    begin
        if Status in [Status::Approved, Status::Posted] then
            Error('You cannot delete assignment %1 with status %2.',
            "No.", Status);

        lRecLine.SetRange("Document No.", "No.");
        lRecLine.DeleteAll(true);
    end;
}
