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

; Uncomment the next line if you want to create a 64-bit installer.
 !define WIN64

; v0.6.0 baselines
!define INSTALLSIZE 91856
!define VERS "v0.6.0-dev+642-g07223fae5"

; v0.5.0 basilines
;!define INSTALLSIZE 87689
;!define VERS "v0.5.1"

!ifdef WIN64
; The name of the installer
!define PRODUCT "Neovim (x64) ${VERS}"

; The file to write
OutFile "nvim-x64.exe"
!else
; The name of the installer
!define PRODUCT "Neovim (x86) ${VERS}"

; The file to write
OutFile "nvim-x86.exe"
!endif

Name "${PRODUCT}"


; Request application privileges for Windows Vista
RequestExecutionLevel admin

; Build Unicode installer
Unicode True

; The default installation directory
!ifdef WIN64
InstallDir $PROGRAMFILES64\neovim
!else
InstallDir $PROGRAMFILES\neovim
!endif

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
  ; between VIM and Neovim (do not allow overwrite if the file exists)
  SetOverWrite off
  SetOutPath $LOCALAPPDATA\nvim
  FILE init.vim
  SetOverWrite on
  ;CreateShortCut $APPDATA\nvim\init.vim.lnk $PROFILE\_vimrc

  ; Write uninstall executable
  WriteUninstaller $INSTDIR\uninstall.exe

  ; Start Menu
  createDirectory "$SMPROGRAMS\Neovim"
  createShortCut "$SMPROGRAMS\Neovim\Neovim.lnk" "$INSTDIR\bin\nvim-qt.exe" "" "$INSTDIR\bin\nvim-qt.exe"

  ; Register the Application
!ifdef WIN64
  SetRegView 64
!else
  SetRegView 32
!endif

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

!ifdef WIN64
  ; Create the 64-bit register area stuff for Add/Remove programs
  SetRegView 64
!else
  ; Create the 32-bit register area stuff for Add/Remove programs
  SetRegView 32
!endif
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "DisplayName" "${PRODUCT}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "DisplayVersion" "${VERS}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "Publisher" "Neovim (Adam Oldham)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
  ; There is no option for modifying or repairing the install
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "NoRepair" 1
  # Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim" "EstimatedSize" ${INSTALLSIZE}

  ; Set Envar Plugin to HKey Current User in Registry
  EnVar::SetHKCU
;  DetailPrint "EnVar::SetHKCU"

  EnVar::AddValue "Path" "$INSTDIR\bin"
;  Pop $0
;  DetailPrint "EnVar::AddValue returned=|$0|"

SectionEnd ; end the section
 
Section "Uninstall"
  ; Only deletes the install directory, does not delete the nvim data or user directory at the time....
  Delete $INSTDIR\Uninstall.exe ; delete self (see explanation below why this works)
  RMDir /r $INSTDIR

  ; Remove Start Menu launcher
  delete "$SMPROGRAMS\Neovim\Neovim.lnk"
  ; Try to remove the Start Menu folder - this will only happen if it is empty
  rmDir "$SMPROGRAMS\Neovim"

  ; Remove Application References
  DeleteRegKey HKCR "*\OpenWithList\nvim-qt.exe"
  DeleteRegKey HKCR "directory\shell\Open with NeoVim"
  DeleteRegKey HKCR "directory\background\shell\Open with NeoVim"
  DeleteRegKey HKCR "*\shell\Open with NeoVim"

!ifdef WIN64
  ; Create the 64-bit register area stuff for Add/Remove programs
  SetRegView 64
!else
  ; Create the 32-bit register area stuff for Add/Remove programs
  SetRegView 32
!endif
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Neovim"

!ifdef WIN64
  ; Remove Registered Applicatuion
  SetRegView 64
!else
  ; Remove Registered Applicatuion
  SetRegView 32
!endif
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
