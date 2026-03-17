table 50000 "Employee Table"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Employee ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee ID';
            Notblank = True;
        }
        field(2; Name; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Name';
        }
        field(3; Department; Option)
        {
            optionmembers = "0","1","2","3";
            optioncaption = 'HR,IT,Admin,Others';
            Caption = 'Department';
        }
        field(4; "Date Of Joining"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Of Joining';
        }
        field(5; Status; Option)
        {
            optionmembers = "0","1";
            optioncaption = 'Active, Unactive';
            Caption = 'Status';
        }
        field(6; "Created By"; Code[50])
        {
            DataClassification = CustomerContent;
            caption = 'Created By';
        }
        field(7; "Created Date & Time"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = False;
            Caption = 'Created Date & Time';
        }
    }

    keys
    {
        key(PK; "Employee ID")
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec."Created By" := UserId;
        Rec."Created Date & Time" := CurrentDateTime;
    end;
}