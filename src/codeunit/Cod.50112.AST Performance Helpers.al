codeunit 50112 "AST Performance Helpers"
{
    procedure GetAssetCountByCategory(pCodCategoryCode: Code[20]): Integer
    var
        lRecAsset: Record "AST Company Asset";
    begin
        lRecAsset.SetLoadFields("No.", "Category Code");
        lRecAsset.SetRange("Category Code", pCodCategoryCode);
        exit(lRecAsset.Count());
    end;

    procedure GetAssetStatus(pCodAssetNo: Code[20]): Enum "AST Asset Status"
    var
        lRecAsset: Record "AST Company Asset";
    begin
        lRecAsset.SetLoadFields(Status);
        lRecAsset.Get(pCodAssetNo);
        exit(lRecAsset.Status);
    end;

    procedure SetAllCategoryAssetsAvailable(pCodCategoryCode: Code[20])
    var
        lRecAsset: Record "AST Company Asset";
    begin
        lRecAsset.SetLoadFields("No.", Status, "Category Code");
        lRecAsset.SetRange("Category Code", pCodCategoryCode);
        lRecAsset.SetRange(Status, lRecAsset.Status::UnderMaintenance);
        lRecAsset.ModifyAll(Status, lRecAsset.Status::Available, true);
    end;

    procedure LogAllAssignedAssets()
    var
        lRecAsset: Record "AST Company Asset";
    begin
        lRecAsset.SetLoadFields("No.", "Assigned to Employee No.", Status);
        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);

        if lRecAsset.FindSet() then
            repeat
            until lRecAsset.Next() = 0;
    end;

    procedure AssetExists(pCodAssetNo: Code[20]): Boolean
    var
        lRecAsset: Record "AST Company Asset";
    begin
        lRecAsset.SetLoadFields("No.");
        exit(lRecAsset.Get(pCodAssetNo));
    end;
}