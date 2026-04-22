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
                field(number; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(categoryCode; Rec."Category Code")
                {
                    ApplicationArea = All;
                    Caption = 'Category Code';
                }
                field(categoryDescription; Rec."Category Description")
                {
                    ApplicationArea = All;
                    Caption = 'Category Description';
                }
                field(serialNo; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Caption = 'Serial No.';
                }
                field(status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
                field(condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    Caption = 'Condition';
                }
                field(purchaseDate; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Date';
                }
                field(purchasePrice; Rec."Purchase Price")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Price';
                }
                field(warrantyExpiryDate; Rec."Warranty Expiry Date")
                {
                    ApplicationArea = All;
                    Caption = 'Warranty Expiry Date';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                }
                field(assignedToEmployeeNo; Rec."Assigned to Employee No.")
                {
                    ApplicationArea = All;
                    Caption = 'Assigned to Employee No.';
                }
                field(assignedToEmployeeName; Rec."Assigned to Employee Name")
                {
                    ApplicationArea = All;
                    Caption = 'Assigned to Employee Name';
                }
                field(lastAssignmentDate; Rec."Last Assignment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Last Assignment Date';
                }
            }
        }
    }
}
