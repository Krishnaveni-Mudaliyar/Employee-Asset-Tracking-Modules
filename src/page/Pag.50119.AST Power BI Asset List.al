// OData API page for Power BI. Exposes all asset fields including extensions.
// Endpoint: /api/KrishnaveniMudaliyar/assetTracking/v1.0/companies({id})/astPbiAssets
page 50119 "AST Power BI Asset List"
{
    PageType = API; APIPublisher = 'KrishnaveniMudaliyar'; APIGroup = 'assetTracking';
    APIVersion = 'v1.0'; EntityName = 'astPbiAsset'; EntitySetName = 'astPbiAssets';
    SourceTable = "AST Company Asset"; ODataKeyFields = "No.";
    InsertAllowed = false; ModifyAllowed = false; DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(assetNo;          Rec."No.")                              { }
                field(description;      Rec.Description)                        { }
                field(categoryCode;     Rec."Category Code")                    { }
                field(status;           Rec.Status)                             { }
                field(condition;        Rec.Condition)                          { }
                field(locationCode;     Rec."Location Code")                    { }
                field(locationDesc;     Rec."Location Description")             { }
                field(building;         Rec.Building)                           { }
                field(floorRoom;        Rec."Floor / Room")                     { }
                field(serialNo;         Rec."Serial No.")                       { }
                field(assetTagNo;       Rec."Asset Tag No.")                    { }
                field(purchaseDate;     Rec."Purchase Date")                    { }
                field(purchasePrice;    Rec."Purchase Price")                   { }
                field(bookValue;        Rec."Book Value")                       { }
                field(depreciationRate; Rec."Depreciation Rate %")              { }
                field(warrantyExpiry;   Rec."Warranty Expiry Date")             { }
                field(vendorNo;         Rec."Vendor No.")                       { }
                field(assignedEmpNo;    Rec."Assigned to Employee No.")         { }
                field(assignedEmpName;  Rec."Assigned to Employee Name")        { }
                field(lastAssignDate;   Rec."Last Assignment Date")             { }
                field(lastReturnDate;   Rec."Last Return Date")                 { }
                field(currExpReturn;    Rec."Current Expected Return Date")     { }
                field(isOverdue;        Rec."Is Overdue")                       { }
                field(createdDate;      Rec."Created Date")                     { }
                field(lastModifiedDate; Rec."Last Modified Date")               { }
            }
        }
    }
}
