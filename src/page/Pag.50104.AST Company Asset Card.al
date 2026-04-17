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

                field("Assigned to Employee No."; Rec."Assigned to Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee this asset is assigned to.';
                    Editable = false;
                }
                field("Assigned to Employee Name"; Rec."Assigned to Employee Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the assigned employee.';
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
                    ToolTip = 'Specifies any additional notes or remarks about this asset.';
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
        area(FactBoxes)
        {
            part(AssetHistory; "AST Asset History Factbox")
            {
                ApplicationArea = All;
                Caption = 'Asset History';
                SubPageLink = "Asset No." = field("No.");
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

                trigger OnAction()
                var
                    lRecHeader: Record "AST Asset Assignment Header";
                    lRecLine: Record "AST Asset Assignment Line";
                    lPageAssignment: Page "AST Asset Assignment";
                begin
                    lRecHeader.Init();
                    lRecHeader.Insert(true);

                    lRecLine.Init();
                    lRecLine."Document No." := lRecHeader."No.";
                    lRecLine."Asset No." := Rec."No.";
                    lRecLine."Condition at Handover" := Rec.Condition;
                    lRecLine.Insert(true);

                    lPageAssignment.SetRecord(lRecHeader);
                    lPageAssignment.Run();
                end;
            }
        }
        area(Navigation)
        {
            action(ViewHistory)
            {
                Caption = 'Asset Log';
                Image = Log;
                ApplicationArea = All;
                ToolTip = 'View the complete history of this asset.';

                trigger OnAction()
                var
                    lRecLog: Record "AST Asset Log Entry";
                begin
                    lRecLog.SetRange("Asset No.", Rec."No.");
                    Page.Run(0, lRecLog);
                end;
            }
        }
        actionref(CreateAssignment_Promoted; CreateAssignment) { }
    }

    var
        IsAssigned: Boolean;
        IsAvailable: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsAssigned := Rec.Status = Rec.Status::Assigned;
        IsAvailable := Rec.Status = Rec.Status::Available;
    end;
}
