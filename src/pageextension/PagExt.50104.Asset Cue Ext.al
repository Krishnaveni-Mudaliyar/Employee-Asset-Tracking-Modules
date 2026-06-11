pageextension 50104 AssetCueExt extends "Asset Cue"
{
    layout
    {
        addlast(Assignments)
        {
            field(OverdueByFlag; OverdueByFlag)
            {
                ApplicationArea = All;
                Caption = 'Overdue (Flagged)';
                ToolTip = 'Assets flagged as overdue by the daily job. Click to view.';
                StyleExpr = 'Unfavorable';
                trigger OnDrillDown()
                var
                    lHdr: Record "Posted Assignment Header";
                begin
                    lHdr.SetRange("Is Overdue", true);
                    lHdr.SetRange("Return Date", 0D);
                    Page.Run(Page::"Posted Assignment List", lHdr);
                end;
            }
            field(WarrantyExpiring; WarrantyExpiring)
            {
                ApplicationArea = All;
                Caption = 'Warranty Expiring (30d)';
                ToolTip = 'Assets with warranty expiring within 30 days.';
                StyleExpr = WarrantyStyle;
                trigger OnDrillDown()
                var
                    lAsset: Record "Company Asset";
                begin
                    lAsset.SetFilter("Warranty Expiry Date", '>=%1&<=%2', Today, Today + 30);
                    Page.Run(Page::"Company Asset List", lAsset);
                end;
            }
            field(ActiveReservations; ActiveReservations)
            {
                ApplicationArea = All;
                Caption = 'Active Reservations';
                ToolTip = 'Number of active asset reservations.';
                trigger OnDrillDown()
                var
                    lRes: Record "Asset Reservation";
                begin
                    lRes.SetRange(Status, Enum::"Asset Reservation Status"::Open);
                    Page.Run(Page::"Asset Reservation List", lRes);
                end;
            }
            field(OpenTransfers; OpenTransfers)
            {
                ApplicationArea = All;
                Caption = 'Open Transfers';
                ToolTip = 'Number of asset transfer documents in Open status.';
                trigger OnDrillDown()
                var
                    lTrf: Record "Asset Transfer Header";
                begin
                    lTrf.SetRange(Status, lTrf.Status::Open);
                    Page.Run(Page::"Asset Transfer List", lTrf);
                end;
            }
        }
    }
    actions
    {
        addlast(Processing)
        {
            action(RunOverdueCheckExt)
            {
                Caption = 'Run Overdue Check Now';
                ApplicationArea = All;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    lOvd: Codeunit "Overdue Management";
                begin
                    lOvd.RunManual();
                    CurrPage.Update(false);
                end;
            }
            action(RunDepreciationExt)
            {
                Caption = 'Update Book Values';
                ApplicationArea = All;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    // Fallback when the Depreciation codeunit is not present in this repo/package
                    Message('The depreciation update functionality is not available in this build.');
                    CurrPage.Update(false);
                end;
            }
        }
    }
    var
        OverdueByFlag: Integer;
        WarrantyExpiring: Integer;
        ActiveReservations: Integer;
        OpenTransfers: Integer;
        WarrantyStyle: Text;

    trigger OnAfterGetCurrRecord()
    var
        lHdr: Record "Posted Assignment Header";
        lAsset: Record "Company Asset";
        lRes: Record "Asset Reservation";
        lTrf: Record "Asset Transfer Header";
    begin
        lHdr.SetRange("Is Overdue", true);
        lHdr.SetRange("Return Date", 0D);
        OverdueByFlag := lHdr.Count();

        lAsset.SetFilter("Warranty Expiry Date", '>=%1&<=%2', Today, Today + 30);
        WarrantyExpiring := lAsset.Count();

        lRes.SetRange(Status, Enum::"Asset Reservation Status"::Open);
        ActiveReservations := lRes.Count();

        lTrf.SetRange(Status, "Transfer Status"::Open);
        OpenTransfers := lTrf.Count();

        if WarrantyExpiring > 0 then WarrantyStyle := 'Attention' else WarrantyStyle := 'None';
    end;
}
