codeunit 50107 "AST Upgrade"
{
    Subtype = Upgrade;

    trigger OnUpgradePerCompany()
    begin
        UpgradeV1toV2();
    end;

    local procedure UpgradeV1toV2()
    var
        lCodUpgradeTag: Codeunit "Upgrade Tag";
        lUpgradeTag: Text;
    begin
        lUpgradeTag := GetV1toV2UpgradeTag();
        if lCodUpgradeTag.HasUpgradeTag(lUpgradeTag) then
            exit;
        lCodUpgradeTag.SetUpgradeTag(lUpgradeTag);
    end;

    local procedure GetV1toV2UpgradeTag(): Text
    begin
        exit('AST-V1-TO-V2-20240101');
    end;
}
