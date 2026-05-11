// Adds: Condition at Return, Return Notes, Condition Degraded.
// Fields 9-11. Original fields 1-8 untouched.
// NOTE: The original OnModify throws Error (immutable records).
//       Codeunit Cod.50116 uses Modify(false) to write these fields,
//       bypassing the trigger intentionally.
tableextension 50102 "AST Posted Assign Line Ext" extends "AST Posted Assignment Line"
{
    fields
    {
        field(9; "Condition at Return"; Enum "AST Asset Condition")
        {
            Caption = 'Condition at Return';
            DataClassification = CustomerContent;
        }
        field(10; "Return Notes"; Text[250])
        {
            Caption = 'Return Notes';
            DataClassification = CustomerContent;
        }
        field(11; "Condition Degraded"; Boolean)
        {
            Caption = 'Condition Degraded';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(ConditionDegraded; "Condition Degraded") { }
    }
}
