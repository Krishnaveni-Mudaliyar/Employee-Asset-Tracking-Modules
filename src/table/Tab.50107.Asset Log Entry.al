table 50107 "Asset Log Entry"
{
    Caption = 'Asset Log Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Asset No."; Code[20])
        {
            Caption = 'Asset No.';
            DataClassification = CustomerContent;
            TableRelation = "Company Asset";
        }
        field(3; "Transaction Type"; Enum "Transaction Type")
        {
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(4; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(5; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = CustomerContent;
        }
        field(6; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(7; "Log Date"; Date)
        {
            Caption = 'Log Date';
            DataClassification = CustomerContent;
        }
        field(8; "Log Time"; Time)
        {
            Caption = 'Log Time';
            DataClassification = CustomerContent;
        }
        field(9; "Asset Status Before"; Enum "Asset Status")
        {
            Caption = 'Asset Status Before';
            DataClassification = CustomerContent;
        }
        field(10; "Asset Status After"; Enum "Asset Status")
        {
            Caption = 'Asset Status After';
            DataClassification = CustomerContent;
        }
        field(11; "Condition Before"; Enum "Asset Condition")
        {
            Caption = 'Condition Before';
            DataClassification = CustomerContent;
        }
        field(12; "Condition After"; Enum "Asset Condition")
        {
            Caption = 'Condition After';
            DataClassification = CustomerContent;
        }
        field(13; Notes; Text[250])
        {
            Caption = 'Notes';
            DataClassification = CustomerContent;
        }
        field(14; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(AssetNo; "Asset No.") { }
        key(EmployeeNo; "Employee No.") { }
    }

    trigger OnInsert()
    var
        lRecLogEntry: Record "Asset Log Entry";
    begin
        lRecLogEntry.LockTable();
        if lRecLogEntry.FindLast() then
            "Entry No." := lRecLogEntry."Entry No." + 1
        else
            "Entry No." := 1;

        "Log Date" := Today;
        "Log Time" := Time;
        "Created By" := CopyStr(UserId(), 1, 50);
    end;

    trigger OnDelete()
    begin
        Error('Asset log entries cannot be deleted. They are permanent audit records.');
    end;

    trigger OnModify()
    begin
        Error('Asset log entries cannot be modified. They are permanent audit records.');
    end;
}