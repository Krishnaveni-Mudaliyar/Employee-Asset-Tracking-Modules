query 50101 "AST Asset Statistics Query"
{
    Caption = 'Asset Statistics Query';
    QueryType = Normal;
    // Used for: Role Center cues, Power BI dashboard
    // Returns asset counts grouped by Status and Category

    elements
    {
        dataitem(CompanyAsset; "AST Company Asset")
        {
            column(CategoryCode; "Category Code") { }
            column(AssetStatus; Status) { }
            column(AssetCondition; Condition) { }
            column(Cout; "No.")
            {
                Method = Count;
            }
            column(TotalPurchasePrice; "Purchase Price")
            {
                Method = Sum;
            }
        }
    }

    trigger OnBeforeOpen()
    begin
        // No default filter — returns all assets grouped
    end;
}