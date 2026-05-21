page 50121 "AST Power BI Assignment Lines"
{
    PageType = API;
    APIPublisher = 'KrishnaveniMudaliyar';
    APIGroup = 'assetTracking';
    APIVersion = 'v1.0';
    EntityName = 'astPbiAssignmentLine';
    EntitySetName = 'astPbiAssignmentLines';
    SourceTable = "AST Posted Assignment Line";
    ODataKeyFields = "Document No.", "Line No.";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
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
                field(conditionAtReturn; Rec."Condition at Return") { }
                field(conditionDegraded; Rec."Condition Degraded") { }
                field(returnNotes; Rec."Return Notes") { }
            }
        }
    }
}
