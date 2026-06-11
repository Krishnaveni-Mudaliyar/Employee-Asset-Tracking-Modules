codeunit 50111 "Excel Export"
{
    procedure ExportAssetsToExcel()
    var
        lRecAsset: Record "Company Asset";
        lTmpExcelBuf: Record "Excel Buffer" temporary;
        lIntRow: Integer;
        lTxtSheetName: Text[250];
    begin
        lTxtSheetName := 'Asset Register';
        lIntRow := 1;

        // Row 1: Column headers
        AddHeader(lTmpExcelBuf, lIntRow, 1, 'Asset No.');
        AddHeader(lTmpExcelBuf, lIntRow, 2, 'Description');
        AddHeader(lTmpExcelBuf, lIntRow, 3, 'Category Code');
        AddHeader(lTmpExcelBuf, lIntRow, 4, 'Serial No.');
        AddHeader(lTmpExcelBuf, lIntRow, 5, 'Status');
        AddHeader(lTmpExcelBuf, lIntRow, 6, 'Condition');
        AddHeader(lTmpExcelBuf, lIntRow, 7, 'Purchase Date');
        AddHeader(lTmpExcelBuf, lIntRow, 8, 'Purchase Price');
        AddHeader(lTmpExcelBuf, lIntRow, 9, 'Assigned Employee');

        lRecAsset.SetLoadFields("No.", Description, "Category Code", "Serial No.", Status,
    Condition, "Purchase Date", "Purchase Price", "Assigned to Employee No.");

        if lRecAsset.FindSet() then
            repeat
                lIntRow += 1;
                AddText(lTmpExcelBuf, lIntRow, 1, lRecAsset."No.");
                AddText(lTmpExcelBuf, lIntRow, 2, lRecAsset.Description);
                AddText(lTmpExcelBuf, lIntRow, 3, lRecAsset."Category Code");
                AddText(lTmpExcelBuf, lIntRow, 4, lRecAsset."Serial No.");
                AddText(lTmpExcelBuf, lIntRow, 5, Format(lRecAsset.Status));
                AddText(lTmpExcelBuf, lIntRow, 6, Format(lRecAsset.Condition));
                AddDate(lTmpExcelBuf, lIntRow, 7, lRecAsset."Purchase Date");
                AddDecimal(lTmpExcelBuf, lIntRow, 8, lRecAsset."Purchase Price");
                AddText(lTmpExcelBuf, lIntRow, 9, lRecAsset."Assigned to Employee No.");
            until lRecAsset.Next() = 0;

        // Create and download Excel file
        lTmpExcelBuf.CreateNewBook(lTxtSheetName);
        lTmpExcelBuf.WriteSheet(lTxtSheetName, CompanyName(), UserId());
        lTmpExcelBuf.CloseBook();
        lTmpExcelBuf.SetFriendlyFilename('AssetRegister_' + Format(Today, 0, '<Year4><Month,2><Day,2>'));
        lTmpExcelBuf.OpenExcel();
    end;

    local procedure AddHeader(var pTmpBuf: Record "Excel Buffer" temporary; pRow: Integer; pCol: Integer; pTxt: Text)
    begin
        pTmpBuf.Init();
        pTmpBuf.Validate("Row No.", pRow);
        pTmpBuf.Validate("Column No.", pCol);
        pTmpBuf."Cell Type" := pTmpBuf."Cell Type"::Text;
        pTmpBuf."Cell Value as Text" := CopyStr(pTxt, 1, 250);
        pTmpBuf.Bold := true;
        pTmpBuf.Insert();
    end;

    local procedure AddText(var pTmpBuf: Record "Excel Buffer" temporary; pRow: Integer; pCol: Integer; pTxt: Text)
    begin
        pTmpBuf.Init();
        pTmpBuf.Validate("Row No.", pRow);
        pTmpBuf.Validate("Column No.", pCol);
        pTmpBuf."Cell Type" := pTmpBuf."Cell Type"::Text;
        pTmpBuf."Cell Value as Text" := CopyStr(pTxt, 1, 250);
        pTmpBuf.Insert();
    end;

    local procedure AddDate(var pTmpBuf: Record "Excel Buffer" temporary; pRow: Integer; pCol: Integer; pDat: Date)
    begin
        pTmpBuf.Init();
        pTmpBuf.Validate("Row No.", pRow);
        pTmpBuf.Validate("Column No.", pCol);
        pTmpBuf."Cell Type" := pTmpBuf."Cell Type"::Date;
        pTmpBuf."Cell Value as Text" := Format(pDat);
        pTmpBuf.Insert();
    end;

    local procedure AddDecimal(var pTmpBuf: Record "Excel Buffer" temporary; pRow: Integer; pCol: Integer; pDec: Decimal)
    begin
        pTmpBuf.Init();
        pTmpBuf.Validate("Row No.", pRow);
        pTmpBuf.Validate("Column No.", pCol);
        pTmpBuf."Cell Type" := pTmpBuf."Cell Type"::Number;
        pTmpBuf."Cell Value as Text" := Format(pDec);
        pTmpBuf.Insert();
    end;
}