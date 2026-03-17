table 50001 "Asset Table"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Asset ID"; code[20])
        {
            DataClassification = CustomerContent;
            Notblank = true;
            Caption = 'Asset ID';
        }
        field(2; "Asset Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Asset Name';
        }
        field(3; "Asset Type"; Option)
        {
            optionmembers = "0","1","2","3";
            optioncaption = 'Laptop, Phone, Access Card, Chair, Other';
            Caption = 'Asset Type';
        }
        field(4; "Purchase Date"; Date)
        { Caption = 'Purchase Date'; }
        field(5; "Asset Status"; Option)
        {
            optionmembers = "0","1","2","3";
            optioncaption = 'Available, Assigned, Under Maintenance, Lost';
            Caption = 'Asset Status';
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
        field(8; "Is Assigned"; Boolean)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Asset ID")
        {
            Clustered = true;
        }
    }
}