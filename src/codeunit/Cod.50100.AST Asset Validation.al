codeunit 50100 "AST Asset Validation"
{
    // PURPOSE:
    // Central place for all validation logic
    // Called by Posting Codeunit before posting
    // Called by pages for real-time checks
    procedure ValidateAssignmentHeader(
        var pRecHeader: Record "AST Asset Assignment Header")
    begin
        // Check 1 : Employee No. must be filled
        pRecHeader.TestField("Employee No.");

        //Check 2 : Assignment Date must be filled
        pRecHeader.TestField("Assignment Date");

        //Check 3 : Must have atleast one line
        CheckLinesExist(pRecHeader);

        //Check 4 : Status must be Open or Approved
        if not (pRecHeader.Status in
        [pRecHeader.Status::Open,
        pRecHeader.Status::Approved]) then
            Error('Assignment %1 cannot be posted with status %2.',
            pRecHeader."No.", pRecHeader.Status);
    end;

    procedure ValidateAssignmentLine(
        var pRecLine: Record "AST Asset Assignment Line";
        var pRecHeader: Record "AST Asset Assignment Header")
    var
        lRecAsset: Record "AST Company Asset";

    begin
        //Check 1 : Asset No. must be filled
        pRecLine.TestField("Asset No.");

        //Check 2 : Asset must exist
        lRecAsset.Get(pRecLine."Asset No.");

        //Check 3 : Asset must be Available
        if lRecAsset.Status <> lRecAsset.Status::Available then
            Error('Asset %1 is not available.Status: %2.',
            pRecLine."Asset No.", lRecAsset.Status);

        //Check 4 : Asset not already on another line in same document
        CheckDuplicateAsset(pRecLine, pRecHeader);
    end;

    local procedure CheckLinesExist(
        var pRecHeader: Record "AST Asset Assignment Header")
    var
        lRecLine: Record "AST Asset Assignment Line";
    begin
        lRecLine.SetRange("Document No.", pRecHeader."No.");
        if not lRecLine.FindFirst() then
            Error('Assignment %1 has no lines. Add at least one asset.',
            pRecHeader."No.");
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
            Error('Asset %1 already exists on line %2 of this assignment.',
            pRecLine."Asset No.", lRecLine."Line No.");
    end;
}