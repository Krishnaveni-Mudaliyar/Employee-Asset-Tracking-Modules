codeunit 50108 "AST Asset Validation Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        lCodValidation: Codeunit "AST Asset Validation";
        lCodAssert: Codeunit Assert;

    procedure TestValidateHeader_NoEmployee_ShouldError()
    var
        lRecHeader: Record "AST Asset Assignment Header";
    begin
        lRecHeader.Init();
        lRecHeader."No." := 'TEST-001';
        lRecHeader."Assignment Date" := Today;

        asserterror lCodValidation.ValidateAssignmentHeader(lRecHeader);
        lCodAssert.ExpectedError('');
    end;

    procedure TestValidateHeader_NoDate_ShouldError()
    var
        lRecHeader: Record "AST Asset Assignment Header";
    begin
        lRecHeader.Init();
        lRecHeader."No." := 'TEST-001';
        lRecHeader."Employee No." := 'EMP001';

        asserterror lCodValidation.ValidateAssignmentHeader(lRecHeader);
    end;

    procedure TestValidateLine_AssetNotAvailable_ShouldError()
    var
        lRecHeader: Record "AST Asset Assignment Header";
        lRecLine: Record "AST Asset Assignment Line";
        lRecAsset: Record "AST Company Asset";

    begin
        if not lRecAsset.Get('AST-001') then begin
            lRecAsset.Init();
            lRecAsset."No." := 'AST-TEST-VALIDATE';
            lRecAsset.Status := lRecAsset.Status::Assigned;
            lRecAsset.Insert();
        end else
            lRecAsset.Status := lRecAsset.Status::Assigned;

        lRecLine.Init();
        lRecLine."Asset No." := lRecAsset."No.";

        asserterror lCodValidation.ValidateAssignmentLine(lRecLine, lRecHeader);
    end;
}