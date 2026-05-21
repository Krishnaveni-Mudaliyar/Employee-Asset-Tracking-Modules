// Power BI–optimised asset query with date, status, category, location filters.
query 50102 "AST PBI Asset Query"
{
    Caption = 'PBI Asset Query';
    QueryType = Normal;
    elements
    {
        dataitem(Asset; "AST Company Asset")
        {
            filter(StatusFilter; Status) { }
            filter(CategoryFilter; "Category Code") { }
            filter(PurchaseDateFrom; "Purchase Date") { }
            filter(PurchaseDateTo; "Purchase Date") { }
            filter(LocationFilter; "Location Code") { }
            filter(IsOverdueFilter; "Is Overdue") { }
            column(AssetNo; "No.") { }
            column(Description; Description) { }
            column(CategoryCode; "Category Code") { }
            column(Status; Status) { }
            column(Condition; Condition) { }
            column(LocationCode; "Location Code") { }
            column(Building; Building) { }
            column(PurchaseDate; "Purchase Date") { }
            column(PurchasePrice; "Purchase Price") { }
            column(BookValue; "Book Value") { }
            column(DepreciationRate; "Depreciation Rate %") { }
            column(WarrantyExpiry; "Warranty Expiry Date") { }
            column(AssignedEmpNo; "Assigned to Employee No.") { }
            column(AssignedEmpName; "Assigned to Employee Name") { }
            column(LastAssignDate; "Last Assignment Date") { }
            column(LastReturnDate; "Last Return Date") { }
            column(IsOverdue; "Is Overdue") { }
            column(CreatedDate; "Created Date") { }
        }
    }
}
