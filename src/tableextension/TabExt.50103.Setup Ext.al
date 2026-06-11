// Extends Asset Tracking Setup with:
// - Transfer Nos., Default Depreciation Rate %, Warranty Alert Days,
//   Reservation Expiry Days (original fields 10-13)
// - Approval Manager Email, Approval Escalation Days (new fields 14-15)
tableextension 50103 "AST Setup Ext" extends "Asset Tracking Setup"
{
    fields
    {
        field(50010; "Transfer Nos."; Code[20])
        {
            Caption = 'Transfer Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(50011; "Default Depreciation Rate %"; Decimal)
        {
            Caption = 'Default Depreciation Rate %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
            InitValue = 20;
        }
        field(50012; "Warranty Alert Days"; Integer)
        {
            Caption = 'Warranty Alert Days';
            DataClassification = CustomerContent;
            MinValue = 0;
            InitValue = 30;
        }
        field(50013; "Reservation Expiry Days"; Integer)
        {
            Caption = 'Reservation Expiry Days';
            DataClassification = CustomerContent;
            MinValue = 1;
            InitValue = 7;
        }
        field(50014; "Approval Manager Email"; Text[100])
        {
            Caption = 'Approval Manager Email';
            DataClassification = CustomerContent;
        }
        field(50015; "Approval Escalation Days"; Integer)
        {
            Caption = 'Approval Escalation Days';
            DataClassification = CustomerContent;
            MinValue = 1;
            InitValue = 3;
        }
    }
}
