page 50103 "Company Asset List"
{
    PageType = List;
    SourceTable = "Company Asset";
    Caption = 'Company Assets';
    CardPageId = "Company Asset Card";
    UsageCategory = Lists;
    AboutTitle = 'Company Assets';
    AboutText = 'Full register of all company-owned assets. Use Import Assets to load from CSV. Use Export to Excel for reporting. Colour coding shows current status at a glance.';
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
            part(AssetHistory; "Asset History Factbox")
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
                    lXmlPort: XmlPort "Asset Migration";
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
                    lCodExcelExport: Codeunit "Excel Export";
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
                    lRecPostedHeader: Record "Posted Assignment Header";
                    lRecPostedLine: Record "Posted Assignment Line";
                begin
                    lRecPostedLine.SetRange("Asset No.", Rec."No.");
                    if lRecPostedLine.FindSet() then begin
                        repeat
                            if
                            lRecPostedHeader.GetFilter("No.") = '' then
                                lRecPostedHeader.SetRange("No.", lRecPostedLine."Document No.")
                            else
                                lRecPostedHeader.SetFilter("No.",
                                    lRecPostedHeader.GetFilter("No.") + '|' + lRecPostedLine."Document No.");
                        until lRecPostedLine.Next() = 0;
                        Page.Run(Page::"Posted Assignment List", lRecPostedHeader);
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
                    lRecLog: Record "Asset Log Entry";
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
                RunObject = report "Asset Register";
            }
        }
        area(Promoted)
        {
            actionref(ImportAssets_Promoted; ImportAssets) { }
        }
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