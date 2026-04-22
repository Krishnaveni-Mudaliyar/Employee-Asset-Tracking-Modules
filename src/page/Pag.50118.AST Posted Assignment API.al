page 50118 "AST Posted Assignment API"
{
    PageType = API;
    APIPublisher = 'KrishnaveniMudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'postedAssignmentLine';
    EntitySetName = 'postedAssignmentLines';
    SourceTable = "AST Posted Assignment Line";
    ODataKeyFields = "Document No.", "Line No.";
    // Composite OData key for line table
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(documentNo; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.';
                }
                field(assetNo; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    Caption = 'Asset No.';
                }
                field(assetDescription; Rec."Asset Description")
                {
                    ApplicationArea = All;
                    Caption = 'Asset Description';
                }
                field(serialNo; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    Caption = 'Serial No.';
                }
                field(categoryCode; Rec."Category Code")
                {
                    ApplicationArea = All;
                    Caption = 'Category Code';
                }
                field(conditionAtHandover; Rec."Condition at Handover")
                {
                    ApplicationArea = All;
                    Caption = 'Condition at Handover';
                }
                field(notes; Rec.Notes)
                {
                    ApplicationArea = All;
                    Caption = 'Notes';
                }
            }
        }
    }
}
