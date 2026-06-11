table 50105 "Posted Assignment Header"
{
    Caption = 'Posted Assignment Header';
    DrillDownPageId = "Posted Assignment List";
    LookupPageId = "Posted Assignment List";

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
        }
        field(3; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
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
        field(6; Department; Text[50])
        {
            Caption = 'Department';
            DataClassification = CustomerContent;
        }
        field(7; Purpose; Text[250])
        {
            Caption = 'Purpose';
            DataClassification = CustomerContent;
        }
        field(8; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        }
        field(9; "Posted By"; Code[50])
        {
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(10; "Transaction Type"; Enum "Transaction Type")
        {
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(11; "No. of Lines"; Integer)
        {
            Caption = 'No. of Lines';
            FieldClass = FlowField;
            CalcFormula = Count("Posted Assignment Line"
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
        key(PK; "No.") { Clustered = true; }
        key(EmployeeNo; "Employee No.") { }
        key(PostingDate; "Posting Date") { }
    }
    trigger OnDelete()
    begin
        Error('Posted assignments cannot be deleted.');
    end;
}