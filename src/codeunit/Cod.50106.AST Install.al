codeunit 50106 "AST Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
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
        // FIX: Original install created IT-EQUIP, FURNITURE, VEHICLE.
        // The migration CSV uses: IT-HW, IT-ACC, IT-MOB, IT-NW, COMM, FURN, AV.
        // This mismatch caused ALL 55 CSV rows to fail on import because
        // Tab.50102 has TableRelation = "AST Asset Category" on Category Code.
        // Install must create categories that match what the data migration uses.
        InsertCategory('IT-HW', 'IT Hardware', "AST Asset Category Type"::"IT Equipment");
        InsertCategory('IT-ACC', 'IT Accessories', "AST Asset Category Type"::"IT Equipment");
        InsertCategory('IT-MOB', 'Mobile Devices', "AST Asset Category Type"::"IT Equipment");
        InsertCategory('IT-NW', 'Network Equipment', "AST Asset Category Type"::"IT Equipment");
        InsertCategory('COMM', 'Communication', "AST Asset Category Type"::Other);
        InsertCategory('FURN', 'Furniture', "AST Asset Category Type"::Furniture);
        InsertCategory('AV', 'Audio Visual', "AST Asset Category Type"::Other);
        // General-purpose categories
        InsertCategory('IT-EQUIP', 'IT Equipment', "AST Asset Category Type"::"IT Equipment");
        InsertCategory('VEHICLE', 'Vehicle', "AST Asset Category Type"::Vehicle);
        InsertCategory('MACHINERY', 'Machinery', "AST Asset Category Type"::Machinery);
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
