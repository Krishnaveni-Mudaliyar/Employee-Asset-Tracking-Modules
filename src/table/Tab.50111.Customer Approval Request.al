// table 50111 "Customer Approval Request"
// {
//     Caption = 'Customer Approval Request';
//     DataClassification = ToBeClassified;
//     LookupPageId = "Customer Approval List";

//     fields
//     {
//         field(1; "Customer No."; Code[20])
//         {
//             Caption = 'Customer No.';
//             DataClassification = ToBeClassified;
//             TableRelation = Customer."No.";
//         }

//         field(2; "Customer Name"; Text[100])
//         {
//             Caption = 'Customer Name';
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }

//         field(3; Status; Enum "Customer Approval Status")
//         {
//             Caption = 'Status';
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }

//         field(4; "Requested Date"; Date)
//         {
//             Caption = 'Requested Date';
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }

//         field(5; "Requested By"; Code[50])
//         {
//             Caption = 'Requested By';
//             DataClassification = ToBeClassified;
//             Editable = false;
//             TableRelation = User."User Name";
//         }

//         field(6; "Approved Date"; Date)
//         {
//             Caption = 'Approved Date';
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }

//         field(7; "Approved By"; Code[50])
//         {
//             Caption = 'Approved By';
//             DataClassification = ToBeClassified;
//             Editable = false;
//             TableRelation = User."User Name";
//         }

//         field(8; "Rejected Date"; Date)
//         {
//             Caption = 'Rejected Date';
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }

//         field(9; "Rejected By"; Code[50])
//         {
//             Caption = 'Rejected By';
//             DataClassification = ToBeClassified;
//             Editable = false;
//             TableRelation = User."User Name";
//         }

//         field(10; "Rejection Reason"; Text[250])
//         {
//             Caption = 'Rejection Reason';
//             DataClassification = ToBeClassified;
//             Editable = false;
//         }

//         field(11; Comments; Text[500])
//         {
//             Caption = 'Comments';
//             DataClassification = ToBeClassified;
//         }
//     }

//     keys
//     {
//         key(PK; "Customer No.")
//         {
//             Clustered = true;
//         }

//         key(Status; Status, "Requested Date")
//         {
//         }
//     }

//     trigger OnInsert()
//     var
//         Customer: Record Customer;
//     begin
//         if Customer.Get("Customer No.") then
//             "Customer Name" := Customer.Name;
//     end;

//     trigger OnModify()
//     begin
//         if Status = Status::"Pending for Approval" then
//             Error('Status cannot be modified for pending approvals. Use the approval process.');
//     end;
// }
