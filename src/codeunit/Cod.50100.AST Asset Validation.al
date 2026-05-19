codeunit 50100 "AST Asset Validation"
{
    procedure ValidateAssignmentHeader(
    var pRecHeader: Record "AST Asset Assignment Header")

    var
        lRecSetup: Record "AST Asset Tracking Setup";
    begin
        pRecHeader.TestField("Employee No.");
        pRecHeader.TestField("Assignment Date");
        CheckLinesExist(pRecHeader);

        if not (pRecHeader.Status in
         [pRecHeader.Status::Open,
         pRecHeader.Status::Approved]) then
            Error('Assignment %1 cannot be posted with status %2.', pRecHeader."No.", pRecHeader.Status);
    end;

    procedure ValidateAssignmentLine(
        var pRecLine: Record "AST Asset Assignment Line";
        var pRecHeader: Record "AST Asset Assignment Header")

    var
        lRecAsset: Record "AST Company Asset";

    begin
        pRecLine.TestField("Asset No.");
        lRecAsset.Get(pRecLine."Asset No.");
        if lRecAsset.Status <> lRecAsset.Status::Available then
            Error('Asset %1 is not available. Current status: %2.', pRecLine."Asset No.", lRecAsset.Status);
        CheckDuplicateAsset(pRecLine, pRecHeader);
    end;

    local procedure CheckLinesExist(
        var pRecHeader: Record "AST Asset Assignment Header")
    var
        lRecLine: Record "AST Asset Assignment Line";
    begin
        lRecLine.SetRange("Document No.", pRecHeader."No.");
        if not lRecLine.FindFirst() then
            Error('Assignment %1 has no lines. Add at least one asset.', pRecHeader."No.");
    end;

    local procedure CheckDuplicateAsset(
        var pRecLine: Record "AST Asset Assignment Line";
        var pRecHeader: Record "AST Asset Assignment Header")

    var
        lRecLine: Record "AST Asset Assignment Line";
    begin
        lRecLine.SetRange("Document No.", pRecHeader."No.");
        lRecLine.SetRange("Asset No.", pRecLine."Asset No.");
        lRecLine.SetFilter("Line No.", '<>%1', pRecLine."Line No.");
        if lRecLine.FindFirst() then
            Error('Asset %1 already exists on line %2 of this assignment.', pRecLine."Asset No.", lRecLine."Line No.");
    end;
}