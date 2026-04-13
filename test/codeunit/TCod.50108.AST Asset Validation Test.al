codeunit 50108 "AST Asset Validation Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    var
        lCodValidation: Codeunit "AST Asset Validation";

    [Test]
    procedure TestValidateHeader_NoEmployee_ShouldError()
    var
        lRecHeader: Record "AST Asset Assignment Header";
    begin
        lRecHeader.Init();
        lRecHeader."No." := 'TEST-001';
        lRecHeader."Assignment Date" := Today;

        asserterror lCodValidation.ValidateAssignmentHeader(lRecHeader);
    end;

    [Test]
    procedure TestValidateHeader_NoDate_ShouldError()
    var
        lRecHeader: Record "AST Asset Assignment Header";
    begin
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

        lRecAsset.Init();
        lRecAsset."No." := 'AST-TEST-VALIDATE';
        lRecAsset.Description := 'Test Asset';
        lRecAsset.Status := lRecAsset.Status::Assigned;
        if not lRecAsset.Insert() then begin

            lRecAsset.Get('AST-TEST-VALIDATE');
            lRecAsset.Status := lRecAsset.Status::Assigned;
            lRecAsset.Modify();
        end;


        lRecLine.Init();
        lRecLine."Document No." := 'TEST-001';
        lRecLine."Line No." := 10000;
        lRecLine."Asset No." := lRecAsset."No.";

        asserterror lCodValidation.ValidateAssignmentLine(lRecLine, lRecHeader);
    end;
}