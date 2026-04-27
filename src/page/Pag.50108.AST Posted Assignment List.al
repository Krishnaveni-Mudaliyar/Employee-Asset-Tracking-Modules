page 50108 "AST Posted Assignment List"
{
    PageType = List;
    SourceTable = "AST Posted Assignment Header";
    CardPageId = "AST Posted Assignment";
    UsageCategory = Documents;
    AboutTitle = 'Posted Asset Assignments';
    AboutText = 'Permanent records of all assignment and return transactions. Use the filter actions to show only Assignments or only Returns. Overdue rows are highlighted.';
    Caption = 'Posted Asset Assignment';
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique number of the asset.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Employee name.';
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assignment date of the asset.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date of the asset.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction type of the asset.';
                }
                field("No. of Lines"; Rec."No. of Lines")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of lines.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected date for asset return. Shown in red when overdue.';
                    StyleExpr = ReturnDateStyle;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ShowAssignments)
            {
                Caption = 'Assignments Only';
                Image = Allocations;
                ApplicationArea = All;
                ToolTip = 'Show only Assignment documents.';

                trigger OnAction()
                begin
                    Rec.SetRange("Transaction Type", Rec."Transaction Type"::Assignment);
                    CurrPage.Update(false);
                end;
            }
            action(ShowReturns)
            {
                Caption = 'Returns Only';
                Image = Return;
                ApplicationArea = All;
                ToolTip = 'Show only return documents.';

                trigger onaction()
                begin
                    Rec.SetRange("Transaction Type", Rec."Transaction Type"::Return);
                    CurrPage.Update(false);
                end;
            }
            action(ClearTypeFilter)
            {
                Caption = 'Show All';
                Image = ClearFilter;
                ApplicationArea = All;
                ToolTip = 'Remove the transaction type filter.';

                trigger OnAction()
                begin
                    Rec.SetRange("Transaction Type");
                    CurrPage.Update(false);
                end;
            }
        }
        area(Reporting)
        {
            action(HandoverLetter)
            {
                Caption = 'Handover Letter';
                Image = Report;
                ApplicationArea = All;
                ToolTip = 'Print the asset handover letter.';
                RunObject = report "AST Asset Handover Letter";
            }
            action(OverdueReport)
            {
                Caption = 'Overdue Returns';
                Image = Report;
                ApplicationArea = All;
                ToolTip = 'Print the overdue asset return report.';
                RunObject = report "AST Overdue Asset Return";
            }
        }
        area(Promoted)
        {
            actionref(ShowAssignments_Promoted; ShowAssignments) { }
            actionref(HandoverLetter_Promoted; HandoverLetter) { }
        }
    }

    var
        ReturnDateStyle: Text;

    trigger OnAfterGetRecord()
    begin
        if (Rec."Transaction Type" = Rec."Transaction Type"::Assignment) and
           (Rec."Expected Return Date" <> 0D) and
           (Rec."Expected Return Date" < Today)
        then
            ReturnDateStyle := 'Unfavorable'
        else
            ReturnDateStyle := 'None';
    end;
}