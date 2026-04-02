codeunit 50106 "AST Install"
{
    Subtype = Install;
    // Subtype = Install → BC knows this runs
    // only on first installation

    trigger OnInstallAppPerCompany()
    //Runs once per company in the tenant
    begin
        CreateDefaultSetup();
        CreateDefaultNumberSeries();
        CreateDefaultCategories();
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
        // Asset Number Series
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

        // Assignment Number Series
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

        // Link to setup
        lRecSetup.Get(); // Already created above
        lRecSetup."Asset Nos." := 'AST-ASSET';
        lRecSetup."Assignment Nos." := 'AST-ASSIGN';
        lRecSetup.Modify(true);
    end;

    local procedure CreateDefaultCategories()
    var
        lRecCategory: Record "AST Asset Category";
    begin
        InsertCategory('IT-EQUIP', 'IT Equipment',
        "AST Asset Category Type"::"IT Equipment");
        InsertCategory('FURNITURE', 'Furniture',
        "AST Asset Category Type"::Furniture);
        InsertCategory('VEHICLE', 'Vehicle',
        "AST Asset Category Type"::Vehicle);
    end;

    local procedure InsertCategory(
        pCodCode: Code[20];
        pTxtDescription: Text[100];
        pEnumType: Enum "AST Asset Category Type")
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