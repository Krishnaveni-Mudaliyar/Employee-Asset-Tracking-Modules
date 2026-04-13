page 50112 "AST Employee Asset Factbox"
{
    PageType = CardPart;
    ApplicationArea = All;
    Caption = 'Employee Assets';

    layout
    {
        area(Content)
        {
            field(TotalAssets; TotalAssets)
            {
                ApplicationArea = All;
                Caption = 'Total Assets Assigned';
                ToolTip = 'Specifies the total number of assets currently assigned to this employee.';
                Editable = false;
            }
            field(EmployeeNo; EmployeeNo)
            {
                ApplicationArea = All;
                Caption = 'Employee No.';
                ToolTip = 'Specifies the employee number.';
                Editable = false;
            }
        }
    }

    var
        TotalAssets: Integer;
        EmployeeNo: Code[20];

    procedure SetEmployee(pCodEmployeeNo: Code[20])
    var
        lRecAsset: Record "AST Company Asset";
    begin
        EmployeeNo := pCodEmployeeNo;
        lRecAsset.SetRange("Assigned to Employee No.", EmployeeNo);
        lRecAsset.SetRange(Status, lRecAsset.Status::Assigned);
        TotalAssets := lRecAsset.Count();
        CurrPage.Update(false);
    end;
}