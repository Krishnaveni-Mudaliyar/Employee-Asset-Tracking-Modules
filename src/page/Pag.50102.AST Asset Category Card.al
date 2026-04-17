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
                    ToolTip = 'Specifies the unique code for this asset category.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the full description of the category.';
                }
                field("Category Type"; Rec."Category Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of assets in this category.';
                }
                field("Require Approval"; Rec."Require Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether assignment of assets in this category requires approval.';
                }
                field("Default Condition"; Rec."Default Condition")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the default condition applied to new assets in this category.';
                }
            }
            group(Statistics)
            {
                Caption = 'Statistics';

                field("No. of Assets"; Rec."No. of Assets")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    ToolTip = 'Specifies the total number of assets in this category. Click to view them.';

                    trigger OnDrillDown()
                    var
                        lRecAsset: Record "AST Company Asset";
                    begin
                        lRecAsset.SetRange("Category Code", Rec.Code);
                        Page.Run(Page::"AST Company Asset List", lRecAsset);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(ViewAssets)
            {
                Caption = 'Assets in Category';
                Image = Item;
                ApplicationArea = All;
                ToolTip = 'View all assets assigned to this category.';

                trigger OnAction()
                var
                    lRecAsset: Record "AST Company Asset";
                begin
                    lRecAsset.SetRange("Category Code", Rec.Code);
                    Page.Run(Page::"AST Company Asset List", lRecAsset);
                end;
            }
        }
        area(Promoted)
        {
            actionref(ViewAssets_Promoted; ViewAssets) { }
        }
    }
}