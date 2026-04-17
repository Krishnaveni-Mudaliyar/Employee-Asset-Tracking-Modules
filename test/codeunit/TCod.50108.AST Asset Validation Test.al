codeunit 50150 "AST Asset Validation Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    // FIX 1: Removed "Codeunit Assert" — does not exist in standard BC.
    //   The built-in "asserterror" keyword handles this natively.
    //   asserterror: if the next statement throws an error → test continues (pass).
    //   If no error is thrown → test fails automatically. No external lib needed.
    //
    // FIX 2: Added [Test] attribute to every procedure.
    //   Without [Test], BC test runner ignores the procedure completely.

    var
        lCodValidation: Codeunit "AST Asset Validation";

    [Test]
    procedure TestValidateHeader_NoEmployee_ShouldError()
    var
        lRecHeader: Record "AST Asset Assignment Header";
    begin
        // [SCENARIO] Header with no Employee No. must fail validation
        // [GIVEN] Header with date but no employee
        lRecHeader.Init();
        lRecHeader."No." := 'TEST-001';
        lRecHeader."Assignment Date" := Today;

        // [WHEN/THEN] asserterror catches the error from TestField("Employee No.")
        asserterror lCodValidation.ValidateAssignmentHeader(lRecHeader);
    end;

    [Test]
    procedure TestValidateHeader_NoDate_ShouldError()
    var
        lRecHeader: Record "AST Asset Assignment Header";
    begin
        // [SCENARIO] Header with no Assignment Date must fail validation
        lRecHeader.Init();
        lRecHeader."No." := 'TEST-001';
        lRecHeader."Employee No." := 'EMP001';

        asserterror lCodValidation.ValidateAssignmentHeader(lRecHeader);
    end;

    [Test]
    procedure TestValidateLine_AssetNotAvailable_ShouldError()
    var
        lRecHeader: Record "AST Asset Assignment Header";
        lRecLine: Record "AST Asset Assignment Line";
        lRecAsset: Record "AST Company Asset";
    begin
        // [SCENARIO] Line referencing an Assigned asset must fail validation
        // [GIVEN] Asset with Status = Assigned
        lRecAsset.Init();
        lRecAsset."No." := 'AST-TEST-VALIDATE';
        lRecAsset.Description := 'Test Asset';
        lRecAsset.Status := lRecAsset.Status::Assigned;
        if not lRecAsset.Insert() then begin
            lRecAsset.Get('AST-TEST-VALIDATE');
            lRecAsset.Status := lRecAsset.Status::Assigned;
            lRecAsset.Modify();
        end;

        // [GIVEN] Line referencing that unavailable asset
        lRecLine.Init();
        lRecLine."Document No." := 'TEST-001';
        lRecLine."Line No." := 10000;
        lRecLine."Asset No." := lRecAsset."No.";

        // [WHEN/THEN] Must error because asset Status <> Available
        asserterror lCodValidation.ValidateAssignmentLine(lRecLine, lRecHeader);
    end;
}
