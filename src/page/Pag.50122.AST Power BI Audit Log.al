page 50122 "AST Power BI Audit Log"
{
    PageType = API; APIPublisher = 'KrishnaveniMudaliyar'; APIGroup = 'assetTracking';
    APIVersion = 'v1.0'; EntityName = 'astPbiLogEntry'; EntitySetName = 'astPbiLogEntries';
    SourceTable = "AST Asset Log Entry"; ODataKeyFields = "Entry No.";
    InsertAllowed = false; ModifyAllowed = false; DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(entryNo;        Rec."Entry No.")           { }
                field(assetNo;        Rec."Asset No.")           { }
                field(transType;      Rec."Transaction Type")    { }
                field(documentNo;     Rec."Document No.")        { }
                field(employeeNo;     Rec."Employee No.")        { }
                field(employeeName;   Rec."Employee Name")       { }
                field(logDate;        Rec."Log Date")            { }
                field(logTime;        Rec."Log Time")            { }
                field(statusBefore;   Rec."Asset Status Before") { }
                field(statusAfter;    Rec."Asset Status After")  { }
                field(condBefore;     Rec."Condition Before")    { }
                field(condAfter;      Rec."Condition After")     { }
                field(notes;          Rec.Notes)                 { }
                field(createdBy;      Rec."Created By")          { }
            }
        }
    }
}
