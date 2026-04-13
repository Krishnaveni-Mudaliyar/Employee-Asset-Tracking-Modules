codeunit 50111 "AST Excel Export"
{
    procedure ExportAssetsToExcel()
    var
        lRecAsset: Record "AST Company Asset";
        lTmpExcelBuff: Record "Excel Buffer" temporary;
        lIntRow: Integer;
        lTxtSheetName: Text[250];

    begin
        lTxtSheetName := 'Asset Register';
        lIntRow := 1;

        //Row 1: Column Headers
        AddHeader(lTmpExcelBuff, lIntRow, 1, 'Asset No.');
        AddHeader(lTmpExcelBuff, lIntRow, 2, 'Description');
        AddHeader(lTmpExcelBuff, lIntRow, 3, 'Category Code');
        AddHeader(lTmpExcelBuff, lIntRow, 4, 'Serial No.');
        AddHeader(lTmpExcelBuff, lIntRow, 5, 'Status');
        AddHeader(lTmpExcelBuff, lIntRow, 6, 'Condition');
        AddHeader(lTmpExcelBuff, lIntRow, 7, 'Purchase Date');
        AddHeader(lTmpExcelBuff, lIntRow, 8, 'Purchase Price');
        AddHeader(lTmpExcelBuff, lIntRow, 9, 'Assigned Employee');

        //Data Rows

        if lRecAsset.FindSet() then
            repeat
                lIntRow += 1;
                AddText(lTmpExcelBuff, lIntRow, 1, lRecAsset."No.");
                AddText(lTmpExcelBuff, lIntRow, 2, lRecAsset.Description);
                AddText(lTmpExcelBuff, lIntRow, 3, lRecAsset."Category Code");
                AddText(lTmpExcelBuff, lIntRow, 4, lRecAsset."Serial No.");
                AddText(lTmpExcelBuff, lIntRow, 5, lRecAsset.Status);
                AddText(lTmpExcelBuff, lIntRow, 6, lRecAsset.Condition);
                AddText(lTmpExcelBuff, lIntRow, 7, lRecAsset."Purchase Date");
                AddText(lTmpExcelBuff, lIntRow, 8, lRecAsset."Purchase Price");
                AddText(lTmpExcelBuff, lIntRow, 9, lRecAsset."Assigned to Employee No.");

            until lRecAsset.Next() = 0;

        // Create and download Excel File
        lTmpExcelBuff.CreateNewBook(lTxtSheetName);
        lTmpExcelBuff.WriteSheet(lTxtSheetName, CompanyName(), UserId());
        lTmpExcelBuff.CloseBook();
        lTmpExcelBuff.SetFriendlyFilename('AssetRegister_' + Format(Today, 0, '<Year4><Month,2><Day,2>'));
        lTmpExcelBuff.OpenExcel();
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
        pTmpBuf."Cell Type" := pTmpBuf."Cell Type"::Text;
        pTmpBuf."Cell Value as Text" := Format(pDec);
        pTmpBuf.Insert();
    end;
}