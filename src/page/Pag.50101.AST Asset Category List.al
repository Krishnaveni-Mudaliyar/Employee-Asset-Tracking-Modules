page 50101 "AST Asset Category List"
{
    PageType = List;
    SourceTable = "AST Asset Category";
    Caption = 'Asset Categories';
    CardPageId = "AST Asset Category Card";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category description.';
                }
                field("Category Type"; Rec."Category Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category type.';
                }
                field("No. of Assets"; Rec."No. of Assets")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of assets in this category.';
                }
            }
        }
    }
}
