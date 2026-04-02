page 50111 "AST Asset History Factbox"
{
    PageType = ListPart;
    SourceTable = "AST Asset Log Entry";
    Caption = 'Asset History';
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique number of the asset.';
                }
                field("Transaction Type"; Rec."Transaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the transaction type of the asset.';
                }
                field("Log Date"; Rec."Log Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the log date of the asset.';
                }
                field("Employee No."; Rec."Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee number.';
                }
                field("Asset Status Before"; Rec."Asset Status Before")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset status before.';
                }
                field("Asset Status After"; Rec."Asset Status After")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the asset status after.';
                }

            }
        }
    }
}
