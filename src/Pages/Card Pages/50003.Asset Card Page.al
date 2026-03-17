page 50004 "Asset Card Page"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Asset Table";

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