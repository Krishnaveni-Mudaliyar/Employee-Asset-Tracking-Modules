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
                    ToolTip = 'Specifies the unique category code.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category description.';
                }
                field("Category Type"; Rec."Category Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of assets in this category.';
                }
                field("Require Approval"; Rec."Require Approval")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether assignments in this category require approval.';
                }
                field("No. of Assets"; Rec."No. of Assets")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of assets in this category. Click to view them.';
                    DrillDown = true;
                    // DrillDown opens filtered Company Asset List for this category
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
        area(Processing)
        {
            action(NewAsset)
            {
                Caption = 'New Asset';
                Image = New;
                ApplicationArea = All;
                ToolTip = 'Create a new asset in this category.';

                trigger OnAction()
                var
                    lRecAsset: Record "AST Company Asset";
                    lPageAsset: Page "AST Company Asset Card";
                begin
                    lRecAsset.Init();
                    lRecAsset."Category Code" := Rec.Code;
                    lPageAsset.SetRecord(lRecAsset);
                    lPageAsset.Run();
                end;
            }
        }
        area(Navigation)
        {
            action(ViewAssets)
            {
                Caption = 'Assets';
                Image = Item;
                ApplicationArea = All;
                ToolTip = 'View all assets in this category.';

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
            actionref(NewAsset_Promoted; NewAsset) { }
        }
    }
}