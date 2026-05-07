# WhatsAppDesktopUninstaller

Language: English | [Português (Brasil)](README.pt-BR.md)

PowerShell script that detects and removes the Microsoft Store versions of
WhatsApp Desktop for Windows.

## What It Removes

- Installed AppX packages for all users:
  - `5319275A.WhatsAppDesktop`
  - `5319275A.WhatsAppDesktopBeta`
- Provisioned AppX packages from the Windows image.
- Local package data folders under user profiles.

## Requirements

- Windows 10/11.
- PowerShell running as Administrator.
- Permission to remove AppX packages for all users.

## Usage

```powershell
.\WA_Detect_Remove.ps1
```

The script prints the packages it finds, attempts removal, and continues when a
specific user profile or package cleanup step fails.

## Notes

- Review the script before running it in production or deploying it through RMM,
  Intune, GPO, or another endpoint management tool.
- Test with a small group before broad deployment.
- This script targets Microsoft Store packages only.
