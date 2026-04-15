codeunit 50107 "AST Upgrade"
{
    Subtype = Upgrade;
    // Subtype = Upgrade → runs when a new version is deployed over existing.
    // Unlike Install (runs once on first install), Upgrade runs on every
    // version bump. Use UpgradeTag to prevent running the same migration twice.

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

        // UpgradeTag prevents this migration running again on future upgrades
        if lCodUpgradeTag.HasUpgradeTag(lUpgradeTag) then
            exit;

        // Add upgrade logic here when v2.0 is released.
        // Example: migrate data, add default values for new fields, etc.
        // SetDefaultConditionOnExistingAssets();

        lCodUpgradeTag.SetUpgradeTag(lUpgradeTag);
    end;

    local procedure GetV1toV2UpgradeTag(): Text
    begin
        // Unique tag — never change this string once deployed
        exit('AST-V1-TO-V2-20240101');
    end;
}
