enum 50105 "AST Transaction Type"
{
    Extensible = true;

    value(0; " ") { Caption = ' '; }
    value(1; Assignment) { Caption = 'Assignment'; }
    value(2; Return) { Caption = 'Return'; }
    value(3; Transfer) { Caption = 'Transfer'; }
    value(4; Maintenance) { Caption = 'Maintenance'; }
    value(5; Disposal) { Caption = 'Disposal'; }
}