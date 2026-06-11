tableextension 50104 "Customer Ext" extends Customer
{
    fields
    {
        field(50100; "Approval Status"; Enum "Approval Status")
        {
            Caption = 'Approval Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50101; "Blocked"; Option)
        {
            Caption = 'Blocked';
            OptionMembers = " ","All","Invoice","Shipment","Payment";
            OptionCaptions = ' ,All,Invoice,Shipment,Payment';
        }

        field(50102; "Approval Required"; Boolean)
        {
            Caption = 'Approval Required';
            DataClassification = ToBeClassified;
        }

        field(50103; "Requested By"; Code[50])
        {
            Caption = 'Requested By';
            DataClassification = ToBeClassified;
            Editable = false;
        }

        field(50104; "Request Date"; DateTime)
        {
            Caption = 'Request Date';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}
