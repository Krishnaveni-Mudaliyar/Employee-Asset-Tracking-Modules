page 50116 "AST Company Asset API"
{
    PageType = API;
    APIPublisher = 'KrishnaveniMudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'companyAsset';
    EntitySetName = 'companyAssets';
    SourceTable = "AST Company Asset";
    ODataKeyFields = "No.";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(number; Rec."No.") { }
                field(description; Rec.Description) { }
                field(categoryCode; Rec."Category Code") { }
                field(CategoryDescription; Rec."Category Description") { }
                field(serialNo; Rec."Serial No.") { }
                field(status; Rec.Status) { }
                field(condition; Rec.Condition) { }
                field(purchaseDate; Rec."Purchase Date") { }
                field(purchasePrice; Rec."Purchase Price") { }
                field(warrantyExpiryDate; Rec."Warranty Expiry Date") { }
                field(vendorNo; Rec."Vendor No.") { }
                field(assignedToEmployeeNo; Rec."Assigned to Employee No.") { }
                field(lastAssignmentDate; Rec."Last Assignment Date") { }
            }
        }
    }
}