table 50100 "AST Asset Tracking Setup"
{
    Caption = 'Asset Tracking Setup';
    DataClassification = ToBeClassified;
    DrillDownPageId = "AST Asset Tracking Setup";
    LookupPageId = "AST Asset Tracking Setup";

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = SystemMetadata;
        }
        field(2; "Asset Nos."; Code[20])
        {
            Caption = 'Asset Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(3; "Assignment Nos."; Code[20])
        {
            Caption = 'Assignment Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
        field(4; "Default Return Days"; Integer)
        {
            Caption = 'Default Return Days';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(5; "Require Approval"; Boolean)
        {
            Caption = 'Require Approval';
            DataClassification = CustomerContent;
        }
        field(6; "Default Asset Condition"; Enum "AST Asset Condition")
        {
            Caption = 'Default Asset Condition';
            DataClassification = CustomerContent;
        }
        field(7; "Send Email Notification"; Boolean)
        {
            Caption = 'Send Email Notification';
            DataClassification = CustomerContent;
        }
        field(8; "Admin Email Address"; Text[80])
        {
            Caption = 'Admin Email Address';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin

    end;

    trigger OnDelete()
    begin
        Error('The Asset Tracking Setup Cannot be deleted.');
    end;

}
