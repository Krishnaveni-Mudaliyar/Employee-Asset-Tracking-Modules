page 50002 "Asset List Page"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Asset Table";
    Caption = 'Asset Page';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Asset ID"; Rec."Asset ID") { }
                field("Asset Name"; Rec."Asset Name") { }
                field("Asset Type"; Rec."Asset Type") { }
                field("Purchase Date"; Rec."Purchase Date") { }
                field("Asset Status"; Rec."Asset Status") { }
            }
        }
    }
}