// OData API page exposing per-asset data enriched with category description for Power BI
// category-level charts (bar / pie / treemap).
// Endpoint: /api/KrishnaveniMudaliyar/assetTracking/v1.0/companies({id})/astPbiCategoryAssets
page 50128 "AST Power BI Category Analytics"
{
    PageType = API;
    APIPublisher = 'KrishnaveniMudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'astPbiCategoryAsset';
    EntitySetName = 'astPbiCategoryAssets';
    SourceTable = "AST Company Asset";
    ODataKeyFields = "No.";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(assetNo; Rec."No.") { }
                field(description; Rec.Description) { }
                field(categoryCode; Rec."Category Code") { }
                field(categoryDescription; Rec."Category Description") { }
                field(status; Rec.Status) { }
                field(condition; Rec.Condition) { }
                field(locationCode; Rec."Location Code") { }
                field(building; Rec.Building) { }
                field(purchaseDate; Rec."Purchase Date") { }
                field(purchasePrice; Rec."Purchase Price") { }
                field(bookValue; Rec."Book Value") { }
                field(depreciationRate; Rec."Depreciation Rate %") { }
                field(warrantyExpiry; Rec."Warranty Expiry Date") { }
                field(isOverdue; Rec."Is Overdue") { }
                field(assignedEmpNo; Rec."Assigned to Employee No.") { }
                field(assignedEmpName; Rec."Assigned to Employee Name") { }
                field(lastAssignDate; Rec."Last Assignment Date") { }
            }
        }
    }
}
