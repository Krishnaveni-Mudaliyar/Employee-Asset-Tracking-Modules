query 50101 "AST Asset Statistics Query"
{
    Caption = 'Asset Statistics Query';
    QueryType = Normal;

    elements
    {
        dataitem(CompanyAsset; "AST Company Asset")
        {
            column(CategoryCode; "Category Code") { }
            column(AssetStatus; Status) { }
            column(AssetCondition; Condition) { }

            // FIX: Method = Count must have NO field source.
            // Count counts dataitem rows — it does not operate on a specific field.
            column(Count)
            {
                Method = Count;
            }

            // Method = Sum requires a numeric field source — correct as-is.
            column(TotalPurchasePrice; "Purchase Price")
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        // No default filter — returns all assets grouped by Status and Category
    end;
}
