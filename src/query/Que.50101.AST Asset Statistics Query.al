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
            column(Count) { Method = Count; }
            column(TotalPurchasePrice; "Purchase Price") { Method = Sum; }
        }
    }

    trigger OnBeforeOpen()
    begin
    end;
}
