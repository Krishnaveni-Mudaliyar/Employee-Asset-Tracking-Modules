page 50103 "AST Company Asset List"
{
    PageType = List;
    SourceTable = "AST Company Asset";
    Caption = 'Company Assets';
    CardPageId = "AST Company Asset Card";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
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
                    Editable = false;
                    ToolTip = 'Specifies the category description.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the serial number of the asset.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
<<<<<<< HEAD
                    ToolTip = 'Specifies the current status of the asset.';
=======
                    ToolTip = 'Specifies the status.';
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
                    StyleExpr = StatusStyle;
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the physical condition of the asset.';
                }
                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase date.';
                }
                field("Purchase Price"; Rec."Purchase Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase price.';
                }
                field("Assigned to Employee No."; Rec."Assigned to Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee this asset is currently assigned to.';
                }
            }
        }
<<<<<<< HEAD

=======
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
        area(FactBoxes)
        {
            part(AssetHistory; "AST Asset History Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Asset No." = field("No.");
            }
<<<<<<< HEAD
            part(SystemInfo; "Workflow Status FactBox")
=======
<<<<<<< HEAD

=======
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
            part(SystemInfo; "System Information FactBox")
>>>>>>> afa2e756daee14a41b8e75ad7f4b337b3c415e47
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportAssets)
            {
                Caption = 'Import Assets';
                Image = Import;
                ApplicationArea = All;
<<<<<<< HEAD
                ToolTip = 'Import company assets from a CSV file using the Asset Migration XMLport.';

                trigger OnAction()
                var
                    lXmlPort: XmlPort "AST Asset Migration";
                begin
                    lXmlPort.Run();
                end;
            }
        }

        area(Navigation)
        {
            action(AssetAssignments)
=======
                ToolTip = 'Import company assets from a CSV file usinf the asset migration XMLPort.';

                trigger OnAction()
                var
                    lxmlport: XmlPort "AST Asset Migration";
                begin
                    lxmlport.Run();
                end;
            }
        }
        area(Navigation)
        {
            action(AssetAssignment)
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
            {
                Caption = 'Assignments';
                Image = Allocations;
                ApplicationArea = All;
                ToolTip = 'View all assignment documents for the selected asset.';

                trigger OnAction()
                var
                    lRecPostedHeader: Record "AST Posted Assignment Header";
                    lRecPostedLine: Record "AST Posted Assignment Line";
                begin
                    // Filter posted lines to this asset then open posted headers
                    lRecPostedLine.SetRange("Asset No.", Rec."No.");
                    if lRecPostedLine.FindFirst() then begin
                        lRecPostedHeader.SetRange("No.", lRecPostedLine."Document No.");
                        Page.Run(Page::"AST Posted Assignment List", lRecPostedHeader);
                    end else
                        Message('No posted assignments found for asset %1.', Rec."No.");
                end;
            }
<<<<<<< HEAD

=======
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
            action(AssetLog)
            {
                Caption = 'Asset Log';
                Image = Log;
                ApplicationArea = All;
                ToolTip = 'View the full audit log for the selected asset.';

                trigger OnAction()
                var
                    lRecLog: Record "AST Asset Log Entry";
                begin
                    lRecLog.SetRange("Asset No.", Rec."No.");
                    Page.Run(0, lRecLog);
                end;
            }
        }

        area(Reporting)
        {
            action(AssetRegister)
            {
                Caption = 'Asset Register';
                Image = Report;
                ApplicationArea = All;
                ToolTip = 'Print or preview the full asset register report.';
                RunObject = report "AST Asset Register";
            }
        }
<<<<<<< HEAD

        // BC 21+ — promote key actions to top bar
        actionref(ImportAssets_Promoted; ImportAssets) { }
    }

=======
        area(Promoted)
        {
            actionref(ImportAssets_Promoted; ImportAssets) { }
        }
    }
>>>>>>> 19481db02111f54469b6ac07e83bd12d14a5ac17
    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        // StyleExpr — drives row colouring in the list
        case Rec.Status of
            Rec.Status::Available:
                StatusStyle := 'Favorable';     // Green text
            Rec.Status::Assigned:
                StatusStyle := 'Strong';        // Bold text
            Rec.Status::UnderMaintenance:
                StatusStyle := 'Ambiguous';     // Orange/amber text
            Rec.Status::Lost:
                StatusStyle := 'Unfavorable';   // Red text
            Rec.Status::Disposed:
                StatusStyle := 'Subordinate';   // Grey text
            else
                StatusStyle := 'None';
        end;
    end;
}
