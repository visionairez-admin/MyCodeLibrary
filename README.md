# Python Machine Learning Lab Code Library

A read-only PowerShell launcher for browsing Python ML lab programs stored in this repository.

## Requirements
- Windows PowerShell 5.1 or PowerShell 7+
- Internet connection
- Python only if you want to run a downloaded program
- **Git is not required**

## Start
Open PowerShell and run:

```powershell
irm https://raw.githubusercontent.com/visionairez-admin/MyCodeLibrary/main/ML-Library.ps1 | iex
```

The launcher reads the repository's `Week*` folders, lets you choose a week and program, and displays the selected Python source in the terminal. It does not install software or modify your files.

## Add programs
Add each lab program as a `.py` file inside its week folder, for example:

```text
Week-01/
  program-01.py
  program-02.py
Week-02/
  program-01.py
```

Upload the files to GitHub, then rerun the PowerShell command.

## Current status
The launcher and initial folder structure are set up. The original complete program listings still need to be added; this repository did not contain them when setup began.