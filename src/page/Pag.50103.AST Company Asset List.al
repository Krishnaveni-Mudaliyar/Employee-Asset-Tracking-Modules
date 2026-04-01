page 50103 "AST Company Asset List"
{
    PageType = List;
    SourceTable = "AST Company Asset";
    Caption = 'Company Assets';
    CardPageId = "AST Company Asset Card";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique asset number.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category description.';
                }
                field("Category Code"; Rec."Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the category code.';
                }
                field("Category Description"; Rec."Category Description")
{
    ApplicationArea = All;
    Editable = false;
    ToolTip = 'Specifies the category description.';
}
field("Serial No."; Rec."Serial No.")
{
    ApplicationArea = All;
    ToolTip = 'Specifies the serial number of the asset.';
}
field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status.';
                }
                field(Condition; Rec.Condition)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the condition.';
                }
                field("Purchase Date"; Rec."Purchase Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase date.';
                }
                field("Purchase Price"; Rec."Purchase Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchase price.';
                }
                                field("Assigned to Employee No."; Rec."Assigned to Employee No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the assigned to employee number.';
                }
                           }
        }
    }
    actions
    {
        area(Processing)
        {
            action(NewAssignment)
            {
                Caption = 'Create Assignment';
                Image = Allocations;
                ApplicationArea = All;
                ToolTip = 'Creates a new assignment document for the selected asset.';

                trigger OnAction()
                begin
Message('Assignment creation will be implemented in the posting codeunit session.');
                end;
            }
        }
    }
}
