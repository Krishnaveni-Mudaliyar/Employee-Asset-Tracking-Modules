report 50106 "Warranty Expiry Report"
{
    Caption = 'Warranty Expiry Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Asset; "Company Asset")
        {
            RequestFilterFields = "Warranty Expiry Date", "Category Code", Status;

            column(AssetNo; "No.") { }
            column(Description; Description) { }
            column(CategoryCode; "Category Code") { }
            column(SerialNo; "Serial No.") { }
            column(AssetTagNo; "Asset Tag No.") { }
            column(Status; Status) { }
            column(VendorNo; "Vendor No.") { }
            column(WarrantyExpiry; "Warranty Expiry Date") { }
            column(DaysRemaining; DaysRem) { }
            column(WarrantyStatus; WStatus) { }
            column(AssignedEmpName; "Assigned to Employee Name") { }
            column(CompanyName; CompanyName()) { }
            column(ReportDate; Today) { }

            trigger OnAfterGetRecord()
            begin
                if "Warranty Expiry Date" = 0D then begin
                    DaysRem := 0;
                    WStatus := 'No Warranty';
                end else begin
                    DaysRem := "Warranty Expiry Date" - Today;
                    if DaysRem < 0 then
                        WStatus := 'EXPIRED'
                    else if DaysRem <= 7 then
                        WStatus := 'CRITICAL – Expires this week'
                    else if DaysRem <= 30 then
                        WStatus := 'Expiring Soon'
                    else
                        WStatus := 'Active';
                end;
            end;
        }
    }
    var
        DaysRem: Integer;
        WStatus: Text[40];
}
