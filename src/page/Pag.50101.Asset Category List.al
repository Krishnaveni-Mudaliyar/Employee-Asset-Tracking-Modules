page 50101 "Asset Category List"
{
    PageType = List;
    SourceTable = "Asset Category";
    Caption = 'Asset Categories';
    CardPageId = "Asset Category Card";
    UsageCategory = Lists;
    AboutTitle = 'Asset Categories';
    AboutText = 'Define and manage asset categories. Each asset must belong to a category. The No. of Assets count shows how many assets are in each category — click it to drill down.';
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

                    trigger OnDrillDown()
                    var
                        lRecAsset: Record "Company Asset";
                    begin
                        lRecAsset.SetRange("Category Code", Rec.Code);
                        Page.Run(Page::"Company Asset List", lRecAsset);
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
                    lRecAsset: Record "Company Asset";
                    lPageAsset: Page "Company Asset Card";
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
                    lRecAsset: Record "Company Asset";
                begin
                    lRecAsset.SetRange("Category Code", Rec.Code);
                    Page.Run(Page::"Company Asset List", lRecAsset);
                end;
            }
        }
        area(Promoted)
        {
            actionref(NewAsset_Promoted; NewAsset) { }
        }
    }
}