// Adds: Return Date, Return Processed By, Return Notes, Days on Loan,
//       Is Overdue (Boolean, maintained by Cod.50108), Overdue Since Date,
//       Overdue Days. Fields 12-18. Originals 1-11, 101-102 untouched.
tableextension 50101 "Posted Assign Hdr Ext" extends "Posted Assignment Header"
{
    fields
    {
        field(12; "Return Date"; Date)
        {
            Caption = 'Return Date';
            DataClassification = CustomerContent;
        }
        field(13; "Return Processed By"; Code[50])
        {
            Caption = 'Return Processed By';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Return Notes"; Text[250])
        {
            Caption = 'Return Notes';
            DataClassification = CustomerContent;
        }
        field(15; "Days on Loan"; Integer)
        {
            Caption = 'Days on Loan';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(16; "Is Overdue"; Boolean)
        {
            Caption = 'Is Overdue';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(17; "Overdue Since Date"; Date)
        {
            Caption = 'Overdue Since Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(18; "Overdue Days"; Integer)
        {
            Caption = 'Overdue Days';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(IsOverdue; "Is Overdue") { }
        key(ReturnDate; "Return Date") { }
        key(ExpReturn; "Expected Return Date") { }
    }
}
