page 50109 "AST Posted Assignment"
{
    PageType = Document;
    SourceTable = "AST Posted Assignment Header";
    Caption = 'Posted Asset Assignment';
    UsageCategory = None;

    // Posted documents are READ ONLY — user can never edit posted data
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posted assignment number.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number associated with this assignment.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the employee.';
                }
                field("Assignment Date"; Rec."Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when assets were assigned.';
                }
                field("Expected Return Date"; Rec."Expected Return Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected date for asset return.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department the asset was assigned to.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = All;
<<<<<<< HEAD
                    ToolTip = 'Specifies the stated purpose of this assignment.';
=======
                    ToolTip = 'Specifies the purpose of the asset assignment.';
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
                    MultiLine = true;
                }
            }

            group(PostingDetails)
            {
                Caption = 'Posting Details';

                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date this assignment was posted.';
                }
                field("Posted By"; Rec."Posted By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who posted this assignment.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this is an Assignment or Return transaction.';
                }
            }

            part(Lines; "AST Posted Assign Line Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
<<<<<<< HEAD
                // Only shows lines belonging to this posted document
            }
        }

        // FactBox — Asset History linked to the employee on this document
=======
            }
        }
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
        area(FactBoxes)
        {
            part(SystemInfo; "System Information FactBox")
            {
                ApplicationArea = All;
            }
        }
    }
<<<<<<< HEAD

    actions
    {
        // ── TASK 2 FIX ────────────────────────────────────────────────────────
        // Added area(Processing) with ProcessReturn action.
        // Was completely missing — user had no way to trigger a return
        // from the Posted Assignment page.
        //
        // Design decision: Return action lives on the POSTED document page
        // because that is the source of truth for what was assigned.
        // The return codeunit reads the posted lines to know which assets
        // to set back to Available.
        //
        // Enabled = IsAssignmentType ensures Return is only available on
        // Assignment transactions — not on Return transactions that are
        // already recorded (prevents double-return).
        // ─────────────────────────────────────────────────────────────────────
=======
    actions
    {
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
        area(Processing)
        {
            action(ProcessReturn)
            {
                Caption = 'Process Return';
                Image = Return;
                ApplicationArea = All;
<<<<<<< HEAD
                ToolTip = 'Process the return of all assets in this assignment. Assets will be set back to Available status and a return log entry will be created.';
                Enabled = IsAssignmentType;
                // Only enabled on Assignment transactions.
                // If this is already a Return record, the button is greyed out.
=======
                ToolTip = 'Process the return of all assets in this assignment. Assets will be set back to available status and a return log wntry will be created.';
                Enabled = IsAssignmentType;
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17

                trigger OnAction()
                var
                    lCodReturnMgt: Codeunit "AST Asset Return Mgt.";
                begin
<<<<<<< HEAD
                    // Confirmation dialog before executing — production standard.
                    // Never run destructive/important operations without confirmation.
                    if not Confirm(
                        'Process return for assignment %1?\n\nAll %2 assets will be set back to Available status.',
                        true,
                        Rec."No.",
                        Rec."No. of Lines")
                    then
                        exit;

                    // Call the Return codeunit — passes the full posted header.
                    // The codeunit loops through posted lines internally.
                    lCodReturnMgt.ProcessReturn(Rec);

                    Message('Return processed successfully. Assets are now available.');

                    // Refresh the page so Transaction Type updates visually
=======
                    if not confirm(
                        'Process return for assignment %1\n\nAll %2 assets will be set back to available status.',
                        true,
                        Rec."No.",
                        Rec."No. of Lines")
                         then
                        exit;
                    lCodReturnMgt.ProcessReturn(Rec);
                    Message('Return processed successfully. Assets are now available.');
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
                    CurrPage.Update(false);
                end;
            }
        }
<<<<<<< HEAD

=======
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
        area(Navigation)
        {
            action(ViewAssetLog)
            {
                Caption = 'Asset Log';
                Image = Log;
                ApplicationArea = All;
                ToolTip = 'View all log entries related to this assignment.';

                trigger OnAction()
                var
                    lRecLog: Record "AST Asset Log Entry";
                begin
                    lRecLog.SetRange("Document No.", Rec."No.");
                    Page.Run(0, lRecLog);
                end;
            }
        }
<<<<<<< HEAD

        // Promote ProcessReturn to top action bar (BC 21+)
        actionref(ProcessReturn_Promoted; ProcessReturn) { }
    }

=======
        area(Promoted)
        {
            actionref(ProcessReturn_promoted; ProcessReturn) { }
        }
    }
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
    var
        IsAssignmentType: Boolean;

    trigger OnAfterGetRecord()
<<<<<<< HEAD
    // Fires on every record load.
    // IsAssignmentType controls whether ProcessReturn action is enabled.
    // A Return document should not have another Return triggered on it.
    begin
        IsAssignmentType :=
            Rec."Transaction Type" = Rec."Transaction Type"::Assignment;
    end;
}
=======
    begin
        IsAssignmentType := Rec."Transaction Type" = Rec."Transaction Type"::Assignment;
    end;
}
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
