table 50102 "AST Company Asset"
{
    Caption = 'Company Asset';
    DrillDownPageId = "AST Company Asset List";
    LookupPageId = "AST Company Asset List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Category Code"; Code[20])
        {
            Caption = 'Category Code';
            DataClassification = CustomerContent;
            TableRelation = "AST Asset Category";
        }
        field(4; "Category Description"; Text[100])
        {
            Caption = 'Category Description';
            FieldClass = FlowField;
            CalcFormula = Lookup("AST Asset Category".Description
                          where(Code = field("Category Code")));
            Editable = false;
        }
        field(5; "Serial No."; Text[50])
        {
            Caption = 'Serial No.';
            DataClassification = CustomerContent;
        }
        field(6; Status; Enum "AST Asset Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(7; Condition; Enum "AST Asset Condition")
        {
            Caption = 'Condition';
            DataClassification = CustomerContent;
        }
        field(8; "Purchase Date"; Date)
        {
            Caption = 'Purchase Date';
            DataClassification = CustomerContent;
        }
        field(9; "Purchase Price"; Decimal)
        {
            Caption = 'Purchase Price';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
        field(10; "Warranty Expiry Date"; Date)
        {
            Caption = 'Warranty Expiry Date';
            DataClassification = CustomerContent;
        }
        field(11; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            TableRelation = Vendor;
        }
        field(12; "Assigned to Employee No."; Code[20])
        {
            Caption = 'Assigned to Employee No.';
            DataClassification = CustomerContent;
            TableRelation = Employee;
        }
        field(13; "Assigned to Employee Name"; Text[100])
        {
            Caption = 'Assigned to Employee Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(14; "Last Assignment Date"; Date)
        {
            Caption = 'Last Assignment Date';
            DataClassification = CustomerContent;
        }
        field(15; Notes; Text[2048])
        {
            Caption = 'Notes';
            DataClassification = CustomerContent;
        }
        field(101; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(102; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = CustomerContent;
        }
        field(103; "Last Modified By"; Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
        }
        field(104; "Last Modified Date"; Date)
        {
            Caption = 'Last Modified Date';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "No.") { Clustered = true; }
        key(CategoryCode; "Category Code") { }
        key(EmployeeNo; "Assigned to Employee No.") { }
        key(Status; Status) { }
    }

    var
        ErrAssetAssignedLbl: Label 'Asset %1 cannot be deleted because it is currently assigned to employee %2.', Comment = '%1 = Asset No., %2 = Employee No.';
        ErrAssetDefaultConditionLbl: Label 'Default condition applied from setup.', Locked = true;

    trigger OnInsert()
    var
        lRecSetup: Record "AST Asset Tracking Setup";
        lCodNoSeries: Codeunit "No. Series";
    begin
        if "No." = '' then begin
            lRecSetup.Get();
            lRecSetup.TestField("Asset Nos.");
            "No." := lCodNoSeries.GetNextNo(lRecSetup."Asset Nos.", Today, true);
        end;

        if Status = Status::" " then
            Status := Status::Available;

        if Condition = Condition::" " then begin
            lRecSetup.Get();
            if lRecSetup."Default Asset Condition" <> lRecSetup."Default Asset Condition"::" " then
                Condition := lRecSetup."Default Asset Condition";
        end;

        "Created By" := CopyStr(UserId(), 1, 50);
        "Created Date" := Today;
        "Last Modified By" := CopyStr(UserId(), 1, 50);
        "Last Modified Date" := Today;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := CopyStr(UserId(), 1, 50);
        "Last Modified Date" := Today;
    end;

    trigger OnDelete()
    begin
        if Status = Status::Assigned then
            Error(ErrAssetAssignedLbl, "No.", "Assigned to Employee No.");
    end;
}