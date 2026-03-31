page 50102 "AST Asset Category Card"
{
    PageType = Card;
    SourceTable = "AST Asset Category";
    Caption = 'Asset Category';
    UsageCategory = None;
    ApplicationArea = All;


    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies Category Description.';
                }
                field("Category Type"; Rec."Category Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category type.';
                }
                field("Require Approval"; Rec."Require Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this asset category requires approval before assignment.';
                }
                field("Default Condition"; Rec."Default Condition")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the condition of assets.';
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';

                field("No. of Assets"; Rec."No. of Assets")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    ToolTip = 'Specifies the number of assets in this category.';
                }
            }
        }
    }
}
