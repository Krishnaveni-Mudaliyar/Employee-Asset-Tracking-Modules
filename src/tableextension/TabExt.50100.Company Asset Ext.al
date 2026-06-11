// Adds: Location, Building, Floor/Room, Asset Tag, Depreciation Rate,
//       Book Value, Is Overdue (Boolean - maintained by Cod.50108),
//       Photo (Media), Current Expected Return Date, Last Return Date.
// Fields 16-26. Original fields 1-15, 101-104 are untouched.
tableextension 50100 "Company Asset Ext" extends "Company Asset"
{
    fields
    {
        field(16; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = CustomerContent;
        }
        field(17; "Location Description"; Text[100])
        {
            Caption = 'Location Description';
            DataClassification = CustomerContent;
        }
        field(18; Building; Code[20])
        {
            Caption = 'Building';
            DataClassification = CustomerContent;
        }
        field(19; "Floor / Room"; Text[50])
        {
            Caption = 'Floor / Room';
            DataClassification = CustomerContent;
        }
        field(20; "Asset Tag No."; Text[50])
        {
            Caption = 'Asset Tag No.';
            DataClassification = CustomerContent;
        }
        field(21; "Depreciation Rate %"; Decimal)
        {
            Caption = 'Depreciation Rate %';
            DataClassification = CustomerContent;
            MinValue = 0;
            MaxValue = 100;
        }
        field(22; "Book Value"; Decimal)
        {
            Caption = 'Book Value (₹)';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(23; "Is Overdue"; Boolean)
        {
            Caption = 'Is Overdue';
            DataClassification = CustomerContent;
            // Maintained by Cod.50108 AST Overdue Management (job queue).
            Editable = false;
        }
        field(24; Photo; Media)
        {
            Caption = 'Photo';
            DataClassification = CustomerContent;
        }
        field(25; "Current Expected Return Date"; Date)
        {
            Caption = 'Current Expected Return Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(26; "Last Return Date"; Date)
        {
            Caption = 'Last Return Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    procedure RecalcBookValue()
    var
        lYears: Decimal;
    begin
        if ("Purchase Date" = 0D) or ("Depreciation Rate %" = 0) then begin
            "Book Value" := "Purchase Price";
            exit;
        end;
        lYears := (Today - "Purchase Date") / 365;
        "Book Value" := "Purchase Price" * Power(1 - "Depreciation Rate %" / 100, lYears);
        if "Book Value" < 0 then
            "Book Value" := 0;
    end;
}
