// Extends AST Company Asset Card with:
//   - Location tab (Location Code, Building, Floor/Room, Asset Tag)
//   - Financial tab extension (Depreciation Rate %, Book Value)
//   - Photo field
//   - Is Overdue indicator
//   - Return info (Current Expected Return, Last Return Date)
//   - Action: Recalculate Book Value
pageextension 50100 "AST Company Asset Card Ext" extends "AST Company Asset Card"
{
    layout
    {
        addafter(Purchase)
        {
            group(Location)
            {
                Caption = 'Location';
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Location Description"; Rec."Location Description") { ApplicationArea = All; }
                field(Building; Rec.Building) { ApplicationArea = All; }
                field("Floor / Room"; Rec."Floor / Room") { ApplicationArea = All; }
                field("Asset Tag No."; Rec."Asset Tag No.") { ApplicationArea = All; }
            }
            group(Depreciation)
            {
                Caption = 'Depreciation';
                field("Depreciation Rate %"; Rec."Depreciation Rate %") { ApplicationArea = All; }
                field("Book Value"; Rec."Book Value") { ApplicationArea = All; Editable = false; }
            }
            group(ReturnInfo)
            {
                Caption = 'Return Info';
                field("Current Expected Return Date"; Rec."Current Expected Return Date") { ApplicationArea = All; Editable = false; }
                field("Last Return Date"; Rec."Last Return Date") { ApplicationArea = All; Editable = false; }
                field("Is Overdue"; Rec."Is Overdue") { ApplicationArea = All; Editable = false; StyleExpr = OverdueStyle; }
            }
            group(PhotoGroup)
            {
                Caption = 'Photo';
                field(Photo; Rec.Photo) { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(RecalcBookValue)
            {
                Caption = 'Recalculate Book Value'; ApplicationArea = All;
                Image = Calculate; Promoted = true; PromotedCategory = Process;
                ToolTip = 'Recalculates the depreciated book value based on purchase price and depreciation rate.';
                trigger OnAction()
                begin
                    Rec.RecalcBookValue();
                    Rec.Modify(true);
                    Message('Book Value updated to ₹%1', Rec."Book Value");
                end;
            }
            action(PrintLabel)
            {
                Caption = 'Print Asset Label'; ApplicationArea = All;
                Image = Print; Promoted = true; PromotedCategory = Process;
                ToolTip = 'Print a QR/barcode label for this asset.';
                trigger OnAction()
                begin
                    Report.Run(Report::"AST Asset QR Label", true, false, Rec);
                end;
            }
        }
    }
    var OverdueStyle: Text;
    trigger OnAfterGetRecord()
    begin
        if Rec."Is Overdue" then OverdueStyle := 'Unfavorable' else OverdueStyle := 'None';
    end;
}
