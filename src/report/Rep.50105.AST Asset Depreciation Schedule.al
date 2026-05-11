report 50105 "AST Asset Depreciation Schedule"
{
    Caption = 'Asset Depreciation Schedule';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    dataset
    {
        dataitem(Asset; "AST Company Asset")
        {
            RequestFilterFields = "No.", "Category Code", Status, "Purchase Date";
            PrintOnlyIfDetail = false;

            column(AssetNo;         "No.")                  { }
            column(Description;     Description)            { }
            column(CategoryCode;    "Category Code")        { }
            column(Status;          Status)                 { }
            column(PurchaseDate;    "Purchase Date")        { }
            column(PurchasePrice;   "Purchase Price")       { }
            column(DeprecRate;      "Depreciation Rate %")  { }
            column(BookValue;       "Book Value")           { }
            column(AccumDeprec;     AccumDeprecAmt)         { }
            column(AssetAge;        AssetAgeYears)          { }
            column(Yr1Proj;         Yr1Projected)           { }
            column(Yr2Proj;         Yr2Projected)           { }
            column(Yr3Proj;         Yr3Projected)           { }
            column(CompanyName;     CompanyName())          { }
            column(ReportDate;      Today)                  { }

            trigger OnAfterGetRecord()
            begin
                RecalcBookValue();
                AccumDeprecAmt := "Purchase Price" - "Book Value";
                AssetAgeYears  := Round((Today - "Purchase Date") / 365, 0.01);
                if "Depreciation Rate %" > 0 then begin
                    Yr1Projected := "Book Value" * (1 - "Depreciation Rate %" / 100);
                    Yr2Projected := Yr1Projected  * (1 - "Depreciation Rate %" / 100);
                    Yr3Projected := Yr2Projected  * (1 - "Depreciation Rate %" / 100);
                end else begin
                    Yr1Projected := "Book Value";
                    Yr2Projected := "Book Value";
                    Yr3Projected := "Book Value";
                end;
            end;
        }
    }
    var
        AccumDeprecAmt: Decimal;
        AssetAgeYears:  Decimal;
        Yr1Projected:   Decimal;
        Yr2Projected:   Decimal;
        Yr3Projected:   Decimal;
}
