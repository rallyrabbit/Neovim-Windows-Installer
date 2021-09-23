; Adam Oldham
;
; Installer for my default batch of gnuwin32 stuff that I typically put on my computers
;
; Installer
; Uninstaller
; Windows Uninstaller from Add/Remove Programs
; Adds Path/Removes Path
;
; Uses the EnVar plugin
; https://nsis.sourceforge.io/EnVar_plug-in

;--------------------------------

; The name of the installer
Name "CAO NeoVIM (x64)"

; The file to write
OutFile "nvim.exe"

; Request application privileges for Windows Vista
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
InstallDir $PROGRAMFILES64\nvim

; Show details by default
ShowInstDetails show

;--------------------------------

; Pages
;Page instfiles
;UninstPage uninstConfirm

;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  SetOutPath $INSTDIR\bin
  File /r bin\*.*

  SetOutPath $INSTDIR\lib
  File /r lib\*.*

  SetOutPath $INSTDIR\share
  File /r share\*.*

  ; Copy my vimrc to my home directory
  SetOutPath $PROFILE
  File _vimrc

  ; Create a link between vimrc and init.vim so that I can use the same configuration
  ; between VIM and Neovim
  SetOutPath $LOCALAPPDATA\nvim
  FILE init.vim
  ;CreateShortCut $APPDATA\nvim\init.vim.lnk $PROFILE\_vimrc

  ; Write uninstall executable
  WriteUninstaller $INSTDIR\uninstall.exe

  ; Register the Application
  SetRegView 64
  WriteRegStr HKLM "Software\Classes\Applications\nvim-qt.exe\shell\edit\command" "" '"$INSTDIR\bin\nvim-qt.exe" "%1"'
  WriteRegStr HKCR "Applications\nvim-qt.exe\shell\edit\commmand" "" '"$INSTDIR\bin\nvim-qt.exe" "%1"'

  ; Default Open With List
  WriteRegStr HKCR "*\OpenWithList\nvim-qt.exe" "" ""

  ; Put in Menu for right clicking into white space
  WriteRegStr HKCR "directory\shell\Open with NeoVim" "" ""
  WriteRegStr HKCR "directory\shell\Open with NeoVim" "Icon" '"$INSTDIR\bin\nvim-qt.exe"'
  WriteRegStr HKCR "directory\shell\Open with NeoVim\command" "" '"$INSTDIR\bin\nvim-qt.exe"'

  WriteRegStr HKCR "directory\background\shell\Open with NeoVim" "" ""
  WriteRegStr HKCR "directory\background\shell\Open with NeoVim" "Icon" '"$INSTDIR\bin\nvim-qt.exe"'
  WriteRegStr HKCR "directory\background\shell\Open with NeoVim\command" "" '"$INSTDIR\bin\nvim-qt.exe"'

  WriteRegStr HKCR "*\shell\Open with NeoVim" "" ""
  WriteRegStr HKCR "*\shell\Open with NeoVim" "Icon" '"$INSTDIR\bin\nvim-qt.exe"'
  WriteRegStr HKCR "*\shell\Open with NeoVim\command" "" '"$INSTDIR\bin\nvim-qt.exe" "%1"'

  ; Create the 64-bit register area stuff for Add/Remove programs
  SetRegView 64
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "DisplayName" "CAO NeoVIM0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "DisplayVersion" "0.5.0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "Publisher" "Adam Oldham/NeoVIM"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "UninstallString" '"$INSTDIR\uninstall.exe"'

  ; Set Envar Plugin to HKey Current User in Registry
  EnVar::SetHKCU
;  DetailPrint "EnVar::SetHKCU"

  EnVar::AddValue "Path" "$INSTDIR\bin"
;  Pop $0
;  DetailPrint "EnVar::AddValue returned=|$0|"

SectionEnd ; end the section
 
Section "Uninstall"
  Delete $INSTDIR\Uninstall.exe ; delete self (see explanation below why this works)
  RMDir /r $INSTDIR

  ; Remove Application References
  DeleteRegKey HKCR "*\OpenWithList\nvim-qt.exe"
  DeleteRegKey HKCR "directory\shell\Open with NeoVim"
  DeleteRegKey HKCR "directory\background\shell\Open with NeoVim"
  DeleteRegKey HKCR "*\shell\Open with NeoVim"

  ; Create the 64-bit register area stuff for Add/Remove programs
  SetRegView 64
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "DisplayName" "CAO NeoVIM0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "DisplayVersion" "0.5.0"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "Publisher" "Adam Oldham/NeoVIM"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "UninstallString" '"$INSTDIR\uninstall.exe"'

  ; Remove Registered Applicatuion
  SetRegView 64
  DeleteRegKey HKLM "Software\Classes\Applications\nvim-qt.exe"
  DeleteRegKey HKCR "Applications\nvim-qt.exe"
  
  ; Set Envar Plugin to HKey Current User in Registry
  EnVar::SetHKCU
;  DetailPrint "EnVar::SetHKCU"

  EnVar::DeleteValue "Path" "$INSTDIR\bin"
;  Pop $0
;  DetailPrint "EnVar::AddValue returned=|$0|"

  Delete $INSTDIR\Uninstall.exe ; delete self (see explanation below why this works)
  RMDir /r $INSTDIR
SectionEnd
