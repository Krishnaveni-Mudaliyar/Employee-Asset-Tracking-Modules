page 50104 "AST Company Asset Card"
{
    PageType = Card;
    SourceTable = "AST Company Asset";
    Caption = 'Company Asset';
    UsageCategory = None;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
<<<<<<< HEAD

=======
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique asset number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the asset.';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category code.';
                }
                field("Category Description"; Rec."Category Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category description.';
                    Editable = false;
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial number of the asset.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the asset.';
                    Editable = false;
                    // Status is always system-controlled — never allow manual edit
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the physical condition of the asset.';
                }
            }

            group(Assignment)
            {
                Caption = 'Assignment Information';
                Visible = IsAssigned;
                // This entire FastTab is hidden when asset is not Assigned
                // OnAfterGetRecord sets IsAssigned based on Status

                field("Assigned to Employee No."; Rec."Assigned to Employee No.")
                {
                    ApplicationArea = All;
<<<<<<< HEAD
                    ToolTip = 'Specifies the employee this asset is assigned to.';
=======
                    ToolTip = 'Specifies the employee this asset is asssigned to.';
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
                    Editable = false;
                }
                field("Assigned to Employee Name"; Rec."Assigned to Employee Name")
                {
                    ApplicationArea = All;
<<<<<<< HEAD
                    ToolTip = 'Specifies the name of the assigned employee.';
=======
                    ToolTip = 'Specifies the name of the assigned employee';
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
                    Editable = false;
                }
                field("Last Assignment Date"; Rec."Last Assignment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date this asset was last assigned.';
                    Editable = false;
                }
            }

            group(Purchase)
            {
                Caption = 'Purchase Details';

                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the asset was purchased.';
                }
                field("Purchase Price"; Rec."Purchase Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the original purchase price of the asset.';
                }
                field("Warranty Expiry Date"; Rec."Warranty Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date the warranty expires.';
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor this asset was purchased from.';
                }
            }

            group(Notes)
            {
                Caption = 'Notes';

                field(Notes; Rec.Notes)
                {
                    ApplicationArea = All;
<<<<<<< HEAD
                    ToolTip = 'Specifies any additional notes or remarks about this asset.';
=======
                    ToolTip = 'Specifies any additional notes or remark about the asset.';
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
                    MultiLine = true;
                }
            }

            group(Audit)
            {
                Caption = 'Audit Information';

                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who created this record.';
                    Editable = false;
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date this record was created.';
                    Editable = false;
                }
                field("Last Modified By"; Rec."Last Modified By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who last modified this record.';
                    Editable = false;
                }
                field("Last Modified Date"; Rec."Last Modified Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date this record was last modified.';
                    Editable = false;
                }
            }
        }
<<<<<<< HEAD

        // ── TASK 1 FIX ────────────────────────────────────────────────────────
        // Added area(FactBoxes) — was completely missing from this page.
        // FactBoxes appear as panels on the right side of the Card page.
        // They show related information without requiring navigation away.
        // SubPageLink ties the FactBox to the current asset record.
        // ─────────────────────────────────────────────────────────────────────
=======
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
        area(FactBoxes)
        {
            part(AssetHistory; "AST Asset History Factbox")
            {
                ApplicationArea = All;
                Caption = 'Asset History';
                SubPageLink = "Asset No." = field("No.");
<<<<<<< HEAD
                // Every log entry where Asset No. = current record No.
                // Shows all assignments, returns, status changes for this asset
            }

            part(SystemInfo; "System Information FactBox")
            {
                ApplicationArea = All;
                // Standard BC FactBox — shows record ID, modified by, etc.
                // Always good practice to include on Card pages.
=======
            }
            part(SystemInfo; "Workflow Status FactBox")
            {
                ApplicationArea = All;

>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreateAssignment)
            {
                Caption = 'Create Assignment';
                Image = Allocations;
                ApplicationArea = All;
                ToolTip = 'Creates a new asset assignment document for this asset.';
                Enabled = IsAvailable;
<<<<<<< HEAD
                // Only enabled when asset Status = Available
                // Greyed out if Assigned, Under Maintenance, Disposed, or Lost
=======
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17

                trigger OnAction()
                var
                    lRecHeader: Record "AST Asset Assignment Header";
                    lRecLine: Record "AST Asset Assignment Line";
                    lPageAssignment: Page "AST Asset Assignment";
                begin
<<<<<<< HEAD
                    // Create a new assignment header
                    lRecHeader.Init();
                    lRecHeader.Insert(true);
                    // OnInsert handles: No. Series, Status = Open, Assignment Date, defaults

                    // Pre-populate first line with this asset
=======
                    lRecHeader.Init();
                    lRecHeader.Insert(true);

>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
                    lRecLine.Init();
                    lRecLine."Document No." := lRecHeader."No.";
                    lRecLine."Asset No." := Rec."No.";
                    lRecLine."Condition at Handover" := Rec.Condition;
                    lRecLine.Insert(true);

<<<<<<< HEAD
                    // Open the assignment document for user to complete
=======
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
                    lPageAssignment.SetRecord(lRecHeader);
                    lPageAssignment.Run();
                end;
            }
        }
<<<<<<< HEAD

=======
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
        area(Navigation)
        {
            action(ViewHistory)
            {
                Caption = 'Asset Log';
                Image = Log;
                ApplicationArea = All;
<<<<<<< HEAD
                ToolTip = 'View the complete history of this asset — all assignments, returns, and status changes.';
=======
                ToolTip = 'View the complete history of this asset - all assignments, returns and status changes.';
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17

                trigger OnAction()
                var
                    lRecLog: Record "AST Asset Log Entry";
                begin
                    lRecLog.SetRange("Asset No.", Rec."No.");
                    Page.Run(0, lRecLog);
                end;
            }
        }
<<<<<<< HEAD

        // BC 21+ ActionRef — promotes actions to top action bar
        actionref(CreateAssignment_Promoted; CreateAssignment) { }
=======
        area(Promoted)
        {
            actionref(CreateAssignment_Promoted; CreateAssignment) { }
        }
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
    }

    var
        IsAssigned: Boolean;
        IsAvailable: Boolean;

    trigger OnAfterGetRecord()
    // Fires every time a record loads — keeps Boolean vars in sync with Status.
    // These vars drive Visible= and Enabled= throughout the page.
    begin
        IsAssigned := Rec.Status = Rec.Status::Assigned;
        IsAvailable := Rec.Status = Rec.Status::Available;
    end;
}
