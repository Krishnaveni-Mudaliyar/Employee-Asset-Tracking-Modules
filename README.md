# Employee Asset Tracking Module
**Publisher:** Krishnaveni Mudaliyar
**Version:** 1.0.0.0
**BC Version:** 27.0+

## What This Module Does
Tracks company assets assigned to employees.
Manages the full lifecycle: assign, approve,
post, return, audit.

## Installation
1. Publish extension via VS Code (F5)
   or upload .app file via Extension Management
2. Install Codeunit runs automatically and creates:
   - Default Setup record
   - AST-ASSET number series
   - AST-ASSIGN number series
   - Default categories (IT Equipment, Furniture, Vehicle)

## First Time Setup
1. Search "Asset Tracking Setup" in BC
2. Verify Number Series fields are populated
3. Configure: Default Return Days, Require Approval,
   Email Notification settings

## How to Use
### Create Assets
Search "Company Assets" → New → Fill details → Save

### Create Assignment
Search "Asset Assignments" → New
→ Select Employee → Add asset lines → Post

### Process Return
Go to Posted Asset Assignments
→ Select posted document → Process Return

### View History
Open any Company Asset → Asset History FactBox
shows all events for that asset

## Object ID Range
50100 – 50199

## Permission Sets
| Set        | Who Gets It              |
|------------|--------------------------|
| AST-ADMIN  | IT Admin — full access   |
| AST-VIEW   | All staff — read only    |
| AST-ASSIGN | HR Team — assign/return  |
| AST-SETUP  | System Admin — setup     |

## Known Limitations
- Approval workflow → placeholder (Session 17 pending)
- Power BI integration → not yet built
- XMLport data migration → not yet built
- Email sending → notification structure ready,
  SMTP configuration required
=======
# Employee-Asset-Tracking-Modules
Track and manage company assets assigned to employees
