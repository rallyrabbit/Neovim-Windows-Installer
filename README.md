# Neovim Windows Installer

<div align="center"><p>
    <a href="https://github.com/rallyrabbit/Neovim-Windows-Installer/releases/latest">
      <img alt="Latest release" src="https://img.shields.io/github/v/release/rallyrabbit/Neovim-Windows-Installer" />
    </a>
    <a href="https://github.com/rallyrabbit/Neovim-Windows-Installer/pulse">
      <img alt="Last commit" src="https://img.shields.io/github/last-commit/rallyrabbit/Neovim-Windows-Installer"/>
    </a>
</p></div>

## Purpose
Create a good NSIS installer for Neovim (https://github.com/neovim/neovim)

My Goal is to create standard (runnable) installers for Neovim for x86 and x64 version of Microsoft Windows.

My goal is to create installer packges of the pre-release Neovim regularly and release versions as the versions are released.

## Background
I liked both VIM (actually gVim for Win32) and the idea of Neovim (being massiovely extensible using optional Lua and the ease of use of plugins.  However, I really like Vim in how there was a Gui version of Vim (gVim) and almost out of the box vimrc with the basics of adaptions for Microsoft Windows.

I becasme a little disappointed with many comments in the Neovim community telling Windows users that they don't need an installer, the should hack the registry themselves, and they were unwilling to move on those opinions.

So, I went to create my own installer.  This was originally just for me.  I wanted an easy way to install Neovim, get the Windows Explorer Menu items, get something in Start Menu, and get Neovim added to my path to use in Cmd.exe or Powershell.

At that point, I thought, why not provide installable items for Windows users on a regualr basis.

## Use At Your Risk
I have tried to make a basic installer.  However, I cannot test this in every scenario on Windows.  Each installer I make has been attempted to be tested on Windows XP, Windows 7, Windows 10, and Windows 11.  This should work ion other versions of Windows, but know, this is freely available.  You can take my NSIS script and use it to base your own installer on or you can offer me some feedback and I can improve this script.  But I cannot guarantee it is flawless and works under every variation.

## Neovim License
As of 23 September 2021, Neovim is licensed under Apache 2.0 License: https://github.com/neovim/neovim/blob/master/LICENSE

## What's Inside
### x86 Windows
Installs Neovim compiled for 32-bit into your Program Files directory for 32-bit Windows or Program Files (x86) on 64-bit Windows.

### x64 Windows
Installs Neovim compiled for 64-bit into your Program Files directory on 64-bit Windows.

### Common Items
1. Creates regsitry entry in 32-bit and 64-bit Windows that allow the program to show up in Add/Remove Programs.
2. Adds "Open With Neovim" to Windows Explorer menu when right click on empty space in a directory.
3. Adds "Open with Neovim" to Windows Explore menu when right click on file a file in Windows Explorer.
4. Includes the Neovim icon in the Windows Explorer menus for "Open with Neovim".
5. Includes the path to Neovim in the user's path environment.
6. Includes a VimScript vimrc that can work with VIM and Neovim.  This base init.vim will only be installed if an init.vim is not already present.  The information on this file is included below.
7. Includes an uninstall.exe.
8. Includes removing all registry entries on uninstall.

## NSIS
The Nullsoft Sciptable Install System, otherwise known as NSIS, is used to produce the binary install executables (https://sourceforge.net/projects/nsis/).  To use this NSIS script, it requires the use of the EnVar plugin (https://nsis.sourceforge.io/EnVar_plug-in).

## Init.vim
The base init.vim is a Vimscript file that can be used with both Vim and Neovim.  The goal is to cover keeping Vim and Neovim as traditional as possible while being able to use some of the more basic Windows functions and hotkeys.

### Basic items
1. Keep 200 lines of command history
2. Set Ruler to show the cursor position at all times
3. Display incomplete commands
4. Display completion matches in the status line
5. Wait 100ms after Escape for special keystrokes
6. Show a few lines of context around the cursor (scroll 5 lines if you click within 5 lines of the top of bottom of window).
7. Perform incremental searching when searching times out on the whole file.
8. Do not attempt to recognize octal numbers.
9. Turn on syntax highlighting.
10. Set tabstop at 4 characters rather than a tab character.
11. Set soft tab stop at 4 characters rather than a tab character.
12. Set to show the ruler
13. Turn on detection of syntax highlighting by file type.
14. Set up Drools files to interpret as javascript.
15. Set up a standard diff tool.

### Windows Improvements
1. CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, so that you can undo CTRL-U after inserting a line break.
2. Allow text selection in insert or visual mode with mouse selection (click and drag).
3. Ctrl-C will copy text in insert or visual mode.
4. Ctrl-V will paste text in insert mode.
5. Disable auto-backup.
6. Set selection, selectmode, mousemodel, keymodel for Miscrosoft Windows.
7. Write files as Unix style end of line rather than Windows style.
8. Use of the Windows clipboard for cut and paste using Ctrl-C/Ctrl-V (but not standard Vi anchoring).
9. Ctrl-Z is Undo.
10. Ctrl-Y is Redo.
11. Strl-A is select all.
12. Ctrl-Tab goes to next window.
13. Ctrl-F4 is for close window.

## Plans for Future
1. Figure out how to set up and configure Windows Printing through Neovim to allow this to be configured with Neovim as part of the installation.
2. Convert Vimscript init.vim to Lua.
3. Include Lunarvim as part of the installation in Windows.
