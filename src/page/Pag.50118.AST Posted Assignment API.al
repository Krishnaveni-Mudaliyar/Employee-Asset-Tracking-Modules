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
                field(documentNo; Rec."Document No.") { }
                field(lineNo; Rec."Line No.") { }
                field(assetNo; Rec."Asset No.") { }
                field(assetDescription; Rec."Asset Description") { }
                field(serialNo; Rec."Serial No.") { }
                field(categoryCode; Rec."Category Code") { }
                field(conditionAtHandover; Rec."Condition at Handover") { }
            }
        }
    }
}