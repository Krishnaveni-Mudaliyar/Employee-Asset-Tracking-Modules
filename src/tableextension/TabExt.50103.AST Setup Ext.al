// Adds: Transfer Nos., Default Depreciation Rate %,
//       Warranty Alert Days, Reservation Expiry Days.
// Fields 10-13. Originals 1-9 untouched.
tableextension 50103 "AST Setup Ext" extends "AST Asset Tracking Setup"
{
    fields
    {
        field(10; "Transfer Nos."; Code[20])
        {
            Caption = 'Transfer Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(11; "Default Depreciation Rate %"; Decimal)
        {
            Caption = 'Default Depreciation Rate %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            InitValue = 20;
        }
        field(12; "Warranty Alert Days"; Integer)
        {
            Caption = 'Warranty Alert Days';
            DataClassification = CustomerContent;
            MinValue = 0;
            InitValue = 30;
        }
        field(13; "Reservation Expiry Days"; Integer)
        {
            Caption = 'Reservation Expiry Days';
            DataClassification = CustomerContent;
            MinValue = 1;
            InitValue = 7;
        }
    }
}
