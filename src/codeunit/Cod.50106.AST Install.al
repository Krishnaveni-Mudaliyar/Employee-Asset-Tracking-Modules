namespace AST.AssetTracking;

using Microsoft.Foundation.NoSeries;
using System.Threading;

codeunit 50106 "AST Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    begin
        CreateDefaultSetup();
        CreateDefaultNumberSeries();
        CreateDefaultCategories();
        CreateJobQueueEntries();
    end;

    local procedure CreateDefaultSetup()
    var
        lRecSetup: Record "AST Asset Tracking Setup";
    begin
        if lRecSetup.Get() then
            exit;
        lRecSetup.Init();
        lRecSetup."Primary Key" := '';
        lRecSetup."Default Return Days" := 30;
        lRecSetup."Require Approval" := false;
        lRecSetup."Send Email Notification" := false;
        lRecSetup.Insert(true);
    end;

    local procedure CreateDefaultNumberSeries()
    var
        lRecNoSeries: Record "No. Series";
        lRecNoSeriesLine: Record "No. Series Line";
        lRecSetup: Record "AST Asset Tracking Setup";
    begin
        if not lRecNoSeries.Get('AST-ASSET') then begin
            lRecNoSeries.Init();
            lRecNoSeries.Code := 'AST-ASSET';
            lRecNoSeries.Description := 'Asset Numbers';
            lRecNoSeries."Default Nos." := true;
            lRecNoSeries.Insert(true);

            lRecNoSeriesLine.Init();
            lRecNoSeriesLine."Series Code" := 'AST-ASSET';
            lRecNoSeriesLine."Line No." := 10000;
            lRecNoSeriesLine."Starting No." := 'AST-A-00001';
            lRecNoSeriesLine."Ending No." := 'AST-A-99999';
            lRecNoSeriesLine."Increment-by No." := 1;
            lRecNoSeriesLine.Insert(true);
        end;

        if not lRecNoSeries.Get('AST-ASSIGN') then begin
            lRecNoSeries.Init();
            lRecNoSeries.Code := 'AST-ASSIGN';
            lRecNoSeries.Description := 'Assignment Numbers';
            lRecNoSeries."Default Nos." := true;
            lRecNoSeries.Insert(true);

            lRecNoSeriesLine.Init();
            lRecNoSeriesLine."Series Code" := 'AST-ASSIGN';
            lRecNoSeriesLine."Line No." := 10000;
            lRecNoSeriesLine."Starting No." := 'AST-0001';
            lRecNoSeriesLine."Ending No." := 'AST-9999';
            lRecNoSeriesLine."Increment-by No." := 1;
            lRecNoSeriesLine.Insert(true);
        end;

        lRecSetup.Get();
        lRecSetup."Asset Nos." := 'AST-ASSET';
        lRecSetup."Assignment Nos." := 'AST-ASSIGN';
        lRecSetup.Modify(true);
    end;

    local procedure CreateDefaultCategories()
    begin
        InsertCategory('IT-HW', 'IT Hardware', "AST Asset Category Type"::"IT Equipment");
        InsertCategory('IT-ACC', 'IT Accessories', "AST Asset Category Type"::"IT Equipment");
        InsertCategory('IT-MOB', 'Mobile Devices', "AST Asset Category Type"::"IT Equipment");
        InsertCategory('IT-NW', 'Network Equipment', "AST Asset Category Type"::"IT Equipment");
        InsertCategory('COMM', 'Communication', "AST Asset Category Type"::Other);
        InsertCategory('FURN', 'Furniture', "AST Asset Category Type"::Furniture);
        InsertCategory('AV', 'Audio Visual', "AST Asset Category Type"::Other);
        InsertCategory('IT-EQUIP', 'IT Equipment', "AST Asset Category Type"::"IT Equipment");
        InsertCategory('VEHICLE', 'Vehicle', "AST Asset Category Type"::Vehicle);
        InsertCategory('MACHINERY', 'Machinery', "AST Asset Category Type"::Machinery);
    end;

    local procedure CreateJobQueueEntries()
    var
        lRecJobQueueEntry: Record "Job Queue Entry";
    begin
        lRecJobQueueEntry.SetRange("Object Type to Run", lRecJobQueueEntry."Object Type to Run"::Codeunit);
        lRecJobQueueEntry.SetRange("Object ID to Run", Codeunit::"AST Asset Notification");
        if lRecJobQueueEntry.FindFirst() then
            exit;

        lRecJobQueueEntry.Init();
        lRecJobQueueEntry."Object Type to Run" := lRecJobQueueEntry."Object Type to Run"::Codeunit;
        lRecJobQueueEntry."Object ID to Run" := Codeunit::"AST Asset Notification";
        lRecJobQueueEntry.Description := 'AST: Daily Overdue Asset Notification';
        lRecJobQueueEntry."Run on Mondays" := true;
        lRecJobQueueEntry."Run on Tuesdays" := true;
        lRecJobQueueEntry."Run on Wednesdays" := true;
        lRecJobQueueEntry."Run on Thursdays" := true;
        lRecJobQueueEntry."Run on Fridays" := true;
        lRecJobQueueEntry."Starting Time" := 080000T;
        lRecJobQueueEntry.Status := lRecJobQueueEntry.Status::"On Hold";

        lRecJobQueueEntry.Insert(true);
        lRecJobQueueEntry.SetRange("Object ID to Run", Codeunit::"AST Asset Notification");
        lRecJobQueueEntry.SetRange(Description, 'AST: Daily Warranty Expiry Notification');

        if not lRecJobQueueEntry.FindFirst() then begin
            lRecJobQueueEntry.Init();
            lRecJobQueueEntry."Object Type to Run" := lRecJobQueueEntry."Object Type to Run"::Codeunit;
            lRecJobQueueEntry."Object ID to Run" := Codeunit::"AST Asset Notification";
            lRecJobQueueEntry.Description := 'AST: Daily Warranty Expiry Notification';
            lRecJobQueueEntry."Run on Mondays" := true;
            lRecJobQueueEntry."Run on Tuesdays" := true;
            lRecJobQueueEntry."Run on Wednesdays" := true;
            lRecJobQueueEntry."Run on Thursdays" := true;
            lRecJobQueueEntry."Run on Fridays" := true;
            lRecJobQueueEntry."Starting Time" := 083000T;
            lRecJobQueueEntry.Status := lRecJobQueueEntry.Status::"On Hold";
            lRecJobQueueEntry.Insert(true);
        end;
    end;

    local procedure InsertCategory(pCodCode: Code[20]; pTxtDescription: Text[100]; pEnumType: Enum "AST Asset Category Type")
    var
        lRecCategory: Record "AST Asset Category";
    begin
        if lRecCategory.Get(pCodCode) then
            exit;
        lRecCategory.Init();
        lRecCategory.Code := pCodCode;
        lRecCategory.Description := pTxtDescription;
        lRecCategory."Category Type" := pEnumType;
        lRecCategory.Insert(true);
    end;
}