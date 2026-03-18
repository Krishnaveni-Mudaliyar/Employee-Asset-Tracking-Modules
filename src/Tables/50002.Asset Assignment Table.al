table 50002 "Asset Assignment Table"
{
    fields
    {
        field(1; "Entry No"; Integer)
        {
            // AutoIncrement = true;
            NotBlank = True;
            Caption = 'Entry No';
        }
        field(2; "Employee ID"; Code[20])
        {
            Caption = 'Employee ID';
            // Default (Validated)
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
            //validation Disabled
            TableRelation = "Asset Table"."Asset ID";
            ValidateTableRelation = false;

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

            trigger OnValidate()
            begin
                // Business Rule : No Future Assignment Allowed
                if "Assignment Date" > Today then
                    Error('Assignment date cannot be in the future.');
            end;
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
        field(8; "Created Date"; Date)
        {
            Editable = false;
        }
        field(9; "Assignment ID"; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(PK; "Assignment ID")
        {
            Clustered = true;
        }
        key(Employee; "Employee ID")
        {
            Unique = true;
        }
        key(EmployeeAsset; "Employee ID", "Asset ID") { }
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

        //Automatically set creation date
        "Created Date" := Today;
    end;

    trigger OnModify()
    begin
        // Optional: Prevent modification of created date
        if xRec."Created Date" <> "Created Date" then
            Error('Created Date cannot be modified.');
    end;

    trigger OnDelete()
    var
        AssetRec: Record "Asset Table";
    begin
        // Release asset when assignment is removed
        if AssetRec.Get("Asset ID") then begin
            AssetRec."Is Assigned" := false;
            AssetRec.Modify();

            // Example: Add control before deletion
            if "Assignment Date" <> 0D then
                Message('Assignment record is being deleted.');
        end;
    end;
}