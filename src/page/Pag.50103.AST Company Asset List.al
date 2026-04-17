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
                    ToolTip = 'Specifies the current status of the asset.';
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
        area(FactBoxes)
        {
            part(AssetHistory; "AST Asset History Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Asset No." = field("No.");
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
                ToolTip = 'Import company assets from a CSV file using the Asset Migration XMLport.';

                trigger OnAction()
                var
                    lXmlPort: XmlPort "AST Asset Migration";
                begin
                    lXmlPort.Run();
                end;
            }

            action(ExportToExcel)
            {
                Caption = 'Export to Excel';
                Image = ExportToExcel;
                ApplicationArea = All;
                ToolTip = 'Export the current asset list to an Excel file.';

                trigger OnAction()
                var
                    lCodExcelExport: Codeunit "AST Excel Export";
                begin
                    lCodExcelExport.ExportAssetsToExcel();
                end;
            }
        }
        area(Navigation)
        {
            action(AssetAssignment)
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
                    // FIX: Original code used FindFirst() then filtered header to ONE document.
                    // If an asset was assigned 5 times, this only ever showed the first assignment.
                    // Correct: collect all Document Nos for this asset, filter header to all of them.
                    lRecPostedLine.SetRange("Asset No.", Rec."No.");
                    if lRecPostedLine.FindSet() then begin
                        // Build filter string covering all document numbers for this asset
                        repeat
                            if lRecPostedHeader.GetFilter("No.") = '' then
                                lRecPostedHeader.SetRange("No.", lRecPostedLine."Document No.")
                            else
                                lRecPostedHeader.SetFilter("No.",
                                    lRecPostedHeader.GetFilter("No.") + '|' + lRecPostedLine."Document No.");
                        until lRecPostedLine.Next() = 0;
                        Page.Run(Page::"AST Posted Assignment List", lRecPostedHeader);
                    end else
                        Message('No posted assignments found for asset %1.', Rec."No.");
                end;
            }
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
        // BC 21+ — promote to top bar
        actionref(ImportAssets_Promoted; ImportAssets) { }
    }

    var
        StatusStyle: Text;

    trigger OnAfterGetRecord()
    begin
        case Rec.Status of
            Rec.Status::Available:
                StatusStyle := 'Favorable';
            Rec.Status::Assigned:
                StatusStyle := 'Strong';
            Rec.Status::UnderMaintenance:
                StatusStyle := 'Ambiguous';
            Rec.Status::Lost:
                StatusStyle := 'Unfavorable';
            Rec.Status::Disposed:
                StatusStyle := 'Subordinate';
            else
                StatusStyle := 'None';
        end;
    end;
}
