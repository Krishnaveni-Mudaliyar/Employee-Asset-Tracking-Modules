// Extends the Posted Assignment Lines Subpage to show and allow
// editing of Condition at Return, Return Notes, and Condition Degraded flag.
pageextension 50103 "AST Posted Lines Ext" extends "AST Posted Assign Line Subpage"
{
    layout
    {
        addafter("Condition at Handover")
        {
            field("Condition at Return"; Rec."Condition at Return")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the condition of the asset when returned by the employee.';
                trigger OnValidate()
                var
                    lEnrich: Codeunit "AST Return Enrichment";
                begin
                    lEnrich.SetReturnCondition(
                        Rec."Document No.", Rec."Line No.",
                        Rec."Condition at Return", Rec."Return Notes");
                end;
            }
            field("Return Notes"; Rec."Return Notes")
            {
                ApplicationArea = All;
                ToolTip = 'Notes about the asset condition at the time of return.';
            }
            field("Condition Degraded"; Rec."Condition Degraded")
            {
                ApplicationArea = All;
                Editable = false;
                StyleExpr = DegradedStyle;
                ToolTip = 'Indicates the asset condition worsened between handover and return.';
            }
        }
    }
    var
        DegradedStyle: Text;

    trigger OnAfterGetRecord()
    begin
        if Rec."Condition Degraded" then DegradedStyle := 'Unfavorable' else DegradedStyle := 'None';
    end;
}
