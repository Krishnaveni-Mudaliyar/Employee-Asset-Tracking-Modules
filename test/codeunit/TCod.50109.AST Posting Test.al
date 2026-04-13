codeunit 50109 "AST Posting Test"
{
    Subtype = Test;
    TestPermissions = Disabled;

    procedure TestPostAssignment_CreatesPostedHeader()
    var
        lRecHeader: Record "AST Asset Assignment Header";
        lRecPostedHeader: Record "AST Posted Assignment Header";
        lCodPostingMgt: Codeunit "AST Asset Posting Mgt.";
        lDocNo: Code[20];
    begin

    end;

    procedure TestPostAssignment_SetAssetStatusAssigned()
    begin
    end;

    procedure TestPostAssignment_CreatesLogEntry()
    begin

    end;

}
