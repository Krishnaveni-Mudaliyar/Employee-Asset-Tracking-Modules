codeunit 50112 "AST Performance Helpers"
{
    // SESSION 49: Performance Best Practices
    // This codeunit demonstrates the correct patterns.
    // Rule 1: SetLoadFields() — only load fields you actually need.
    //         Without it, BC loads ALL fields = unnecessary SQL bandwidth.
    // Rule 2: FindSet() for loops, FindFirst() for single records.
    //         Find('-') is old — never use it in new code.
    // Rule 3: SetRange before any Find — always filter before fetching.
    // Rule 4: CalcFields() only when needed — FlowFields are expensive.
    // Rule 5: LockTable() only in write transactions, never in reads.

    // CORRECT: Count assets per category efficiently
    procedure GetAssetCountByCategory(pCodCategoryCode: Code[20]): Integer
    var
        lRecAsset: Record "AST Company Asset";
    begin
        // SetLoadFields tells SQL to SELECT only these columns.
        // Without this, all 15 fields are loaded — 14 are wasted reads.
        lRecAsset.SetLoadFields("No.", "Category Code");
        lRecAsset.SetRange("Category Code", pCodCategoryCode);
        exit(lRecAsset.Count());
    end;

    // CORRECT: Get asset status without loading the whole record
    procedure GetAssetStatus(pCodAssetNo: Code[20]): Enum "AST Asset Status"
    var
        lRecAsset: Record "AST Company Asset";
    begin
        lRecAsset.SetLoadFields(Status);
        lRecAsset.Get(pCodAssetNo);
        exit(lRecAsset.Status);
    end;

    // CORRECT: Bulk update — avoid calling Modify() inside a loop where possible
    procedure SetAllCategoryAssetsAvailable(pCodCategoryCode: Code[20])
    var
        lRecAsset: Record "AST Company Asset";
    begin
        // Load only what we need to write
        lRecAsset.SetLoadFields("No.", Status, "Category Code");
        lRecAsset.SetRange("Category Code", pCodCategoryCode);
        lRecAsset.SetRange(Status, lRecAsset.Status::UnderMaintenance);

        // ModifyAll is a single SQL UPDATE — far faster than looping Modify()
        // Use this when all records get the same value
        lRecAsset.ModifyAll(Status, lRecAsset.Status::Available, true);
    end;

    // CORRECT: Process a set of assets efficiently
    procedure LogAllAssignedAssets()
    var
        lRecAsset: Record "AST Company Asset";
    begin
        // SetLoadFields — only columns needed for logging
        lRecAsset.SetLoadFields("No.", "Assigned to Employee No.", Status);
        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);

        // FindSet() — correct for loops. Loads records in pages from SQL.
        // DO NOT use Find('-') — it is obsolete.
        if lRecAsset.FindSet() then
            repeat
            // Process each record
            until lRecAsset.Next() = 0;
    end;

    // CORRECT: Check existence without loading data
    procedure AssetExists(pCodAssetNo: Code[20]): Boolean
    var
        lRecAsset: Record "AST Company Asset";
    begin
        lRecAsset.SetLoadFields("No.");
        // IsEmpty or FindFirst + exit — never Count() just to check existence
        exit(lRecAsset.Get(pCodAssetNo));
    end;

    // WRONG pattern — for education/documentation purposes:
    // lRecAsset.FindSet() → lRecAsset.CalcFields("Category Description") inside loop
    // → N+1 queries. Instead: use FlowField on the table itself,
    //   or join via query, or SetLoadFields with CalcFields once outside.
}
