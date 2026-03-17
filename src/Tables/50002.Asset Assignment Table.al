table 50002 "Asset Assignment Table"
{
    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            NotBlank = True;
            Caption = 'Entry No';
        }
        field(2; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            TableRelation = "Employee Table"."Employee ID";

            trigger OnValidate()
            var
                RecEmployee: Record "Employee Table";
            begin
                // Defensive Validation (beyond Table relation)
                if not RecEmployee.Get("Employee ID") then
                    Error('Employee %1 does not exist.', "Employee ID");
            end;
        }
        field(3; "Asset ID"; Code[20])
        {
            Caption = 'Asset ID';
            TableRelation = "Asset Table"."Asset ID";

            trigger OnValidate()
            var
                RecAsset: Record "Asset Table";
            begin
                // Defensive Validation (beyond Table relation)
                if not RecAsset.Get("Asset ID") then
                    Error('Asset %1 is already assigned.', "Asset ID");
            end;
        }
        field(4; "Assignment Date"; Date)
        {
            Caption = 'Assignment Date';
        }
        field(5; "Return Date"; Date)
        {
            Caption = 'Return Date';
        }
        field(6; Notes; Text[250])
        {
            Caption = ' Notes';
        }
        field(7; Status; Option)
        {
            optionmembers = "0","1";
            optioncaption = 'Assigned,Returned';
            Caption = 'Status';
        }
    }

    keys
    {
        key(PK; "Entry No")
        {
            Clustered = true;
        }
        key(K1; "Employee ID", "Asset ID")
        {
            Unique = true;
        }
    }

    trigger OnInsert()
    var
        AssetRec: Record "Asset Table";
    begin
        // Mark Asset as assigned
        if AssetRec.Get("Asset ID") then begin
            AssetRec."Is Assigned" := true;
            AssetRec.Modify();
        end;
    end;

    trigger OnDelete()
    var
        AssetRec: Record "Asset Table";
    begin
        // Release asset when assignment is removed
        if AssetRec.Get("Asset ID") then begin
            AssetRec."Is Assigned" := false;
            AssetRec.Modify();
        end;
    end;
}