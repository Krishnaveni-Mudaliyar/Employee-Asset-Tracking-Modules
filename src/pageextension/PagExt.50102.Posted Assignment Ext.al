// Extends the Posted Assignment page (read-only document) with:
//   - Return Details group showing new extension fields.
//   - Enriched "Process Return with Condition" action.
pageextension 50102 "Posted Assignment Ext" extends "Posted Assignment"
{
    layout
    {
        addafter(PostingDetails)
        {
            group(ReturnDetails)
            {
                Caption = 'Return Details';
                field("Return Date"; Rec."Return Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Return Processed By"; Rec."Return Processed By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Return Notes"; Rec."Return Notes")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Days on Loan"; Rec."Days on Loan")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Is Overdue"; Rec."Is Overdue")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = ReturnOverdueStyle;
                }
                field("Overdue Days"; Rec."Overdue Days")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(ProcessReturnWithCondition)
            {
                Caption = 'Process Return (with Condition)';
                ApplicationArea = All;
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Process return and capture condition at return for each asset.';
                Enabled = CanReturn;
                trigger OnAction()
                var
                    lRetMgt: Codeunit "Asset Return Mgt.";
                    lEnrich: Codeunit "Return Enrichment";
                begin
                    if not Confirm('Process return for assignment %1?\n\nAll assets will be set to Available. You can capture condition per line before confirming.', true, Rec."No.") then
                        exit;
                    // Step 1: Original return (sets assets to Available, logs)
                    lRetMgt.ProcessReturn(Rec);
                    // Step 2: Stamp return date, days on loan, clear overdue flag
                    lEnrich.FinaliseReturn(Rec, Today, '');
                    Message('Return processed. Assets set to Available.');
                    CurrPage.Update(false);
                end;
            }
        }
    }
    var
        ReturnOverdueStyle: Text;
        CanReturn: Boolean;

    trigger OnAfterGetRecord()
    begin
        if Rec."Is Overdue"
        then
            ReturnOverdueStyle := 'Unfavorable'
        else
            ReturnOverdueStyle := 'None';

        CanReturn := (Rec."Transaction Type" = Rec."Transaction Type"::Assignment)
        and (Rec."Return Date" = 0D);
    end;
}
