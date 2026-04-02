codeunit 50101 "AST Asset Posting Mgt."
{
    TableNo = "AST Asset Assignment Header";

    // TableNo = the table this codeunit operates on
    // Allows: Codeunit.Run(Codeunit::"AST Asset Posting Mgt.", Rec)
    // from a page action

    trigger OnRun()
    begin
        PostAssetAssignment(Rec);
    end;

    procedure PostAssetAssignment(
        var pRecHeader: Record "AST Asset Assignment Header")
    var
        lCodValidation: Codeunit "AST Asset Validation";
        lRecLine: Record "AST Asset Assignment Line";
    begin
        // STEP 1: Validate Header
        lCodValidation.ValidateAssignmentHeader(pRecHeader);

        //STEP 2: Validate each line
        lRecLine.SetRange("Document No.", pRecHeader."No.");
        if lRecLine.FindSet() then
            repeat
                lCodValidation.ValidateAssignmentLine(
                    lRecLine, pRecHeader);
            until lRecLine.Next() = 0;

        //STEP 3: Create posted header
        InsertPostedHeader(pRecHeader);

        //STEP 4: Created posted lines + update assets
        PostLines(pRecHeader);

        //Step 5 : Delete Original document
        DeleteOriginalDocument(pRecHeader);
    end;

    local procedure InsertPostedHeader(
        var pRecHeader: Record "AST Asset Assignment Header")
    var
        lRecPostedHeader: Record "AST Posted Assignment Header";
    begin
        lRecPostedHeader.Init();
        lRecPostedHeader.TransferFields(pRecHeader);
        lRecPostedHeader."Posting Date" := Today;
        lRecPostedHeader."Posted By" := CopyStr(UserId(), 1, 50);
        lRecPostedHeader."Transaction Type" :=
        lRecPostedHeader."Transaction Type"::Assignment;
        lRecPostedHeader."Created By" := CopyStr(UserId(), 1, 50);
        lRecPostedHeader."Created Date" := Today;
        lRecPostedHeader.Insert(true);
    end;

    local procedure PostLines(
        var pRecHeader: Record "AST Asset Assignment Header")
    var
        lRecLine: Record "AST Asset Assignment Line";
        lRecPostedLine: Record "AST Posted Assignment Line";
        lRecAsset: Record "AST Company Asset";
        lCodLogMgt: Codeunit "AST Asset Log Mgt.";
        lEnumStatusBefore: Enum "AST Asset Status";

    begin
        lRecLine.SetRange("Document No.", pRecHeader."No.");
        if lRecLine.FindSet() then
            repeat
                //Create Posted Line
                lRecPostedLine.Init();
                lRecPostedLine."Document No." := pRecHeader."No.";
                lRecPostedLine."Line No." := lRecLine."Line No.";
                lRecPostedLine."Asset No." := lRecLine."Asset No.";

                //Snapshot - copy values at posting time
                lRecAsset.Get(lRecLine."Asset No.");
                lRecPostedLine."Asset Description" := lRecAsset.Description;
                lRecPostedLine."Serial No." := lRecAsset."Serial No.";
                lRecPostedLine."Category Code" := lRecAsset."Category Code";
                lRecPostedLine."Condition at Handover" := lRecLine."Condition at Handover";
                lRecPostedLine.Notes := lRecLine.Notes;
                lRecPostedLine.Insert(true);

                //Update asset status
                lRecAsset.Status := lRecAsset.Status::Assigned;
                lRecAsset."Assigned to Employee No." :=
                pRecHeader."Employee No.";
                lRecAsset."Last Assignment Date" :=
                pRecHeader."Assignment Date";
                lRecAsset.Modify(true);

                //Create log entry
                lCodLogMgt.CreateLogEntry(
                    lRecAsset,
lEnumStatusBefore,
                    lRecAsset.Status::Assigned,
                    pRecHeader."No.",
                pRecHeader."Employee No.",
                pRecHeader."Employee Name");

            until lRecLine.Next() = 0;
    end;

    local procedure DeleteOriginalDocument(
        var pRecHeader: Record "AST Asset Assignment Header")
    var
        lRecLine: Record "AST Asset Assignment Line";

    begin
        lRecLine.SetRange("Document No.", pRecHeader."No.");
        lRecLine.DeleteAll(true);
        pRecHeader.Delete(true);
    end;
}