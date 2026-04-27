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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(CategoryCode; Rec."Category Code")
                {
                    ApplicationArea = All;
                    Caption = 'Category Code';
                }
                field(CategoryDescription; Rec."Category Description")
                {
                    ApplicationArea = All;
                    Caption = 'Category Description';
                }
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Caption = 'Serial No.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    Caption = 'Condition';
                }
                field(PurchaseDate; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Date';
                }
                field(PurchasePrice; Rec."Purchase Price")
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Price';
                }
                field(WarrantyExpiryDate; Rec."Warranty Expiry Date")
                {
                    ApplicationArea = All;
                    Caption = 'Warranty Expiry Date';
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.';
                }
                field(AssignedToEmployeeNo; Rec."Assigned to Employee No.")
                {
                    ApplicationArea = All;
                    Caption = 'Assigned to Employee No.';
                }
                field(AssignedToEmployeeName; Rec."Assigned to Employee Name")
                {
                    ApplicationArea = All;
                    Caption = 'Assigned to Employee Name';
                }
                field(LastAssignmentDate; Rec."Last Assignment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Last Assignment Date';
                }
            }
        }
    }
}
