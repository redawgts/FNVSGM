
#Persistent
#SingleInstance, Force

myVERSION=1.2

;FNVSGM ini-filename
FNVSGMINIFILENAME=FNVSGM.ini

;Location of the Savegames folder
SAVEGAMESFOLDER=

PROFILESSUBFOLDER=FNVSGM

;the name of the active profile (=foldername)
ACTIVE=

;

;------------------------------------
; G*U*I
;------------------------------------

;------------
; Sub Menus
;------------

;savegames
Menu, subMenuSG, Add, Create New Profile..., submenuSGHandler
Menu, subMenuSG, Add, Scan For New Profiles, submenuSGHandler
Menu, subMenuSG, Add	;a line -----
Menu, subMenuSG, Add, Backup Active Profile..., submenuSGHandler
Menu, subMenuSG, Add, Backup All Profiles..., submenuSGHandler
Menu, subMenuSG, Add	;a line -----
Menu, subMenuSG, Add, Open Fallout New Vegas Savegame Folder, submenuSGHandler
Menu, subMenuSG, Add, Open Active Profile Folder, submenuSGHandler

;advanced
Menu, subMenuADV, Add, Change Play-button link..., submenuADVHandler

;help
;Menu, subMenuHELP, Add, Help, submenuHELPHandler
;Menu, subMenuHELP, Add 	;a line -----
Menu, subMenuHELP, Add, About, submenuHELPHandler

;attach menus to app
Menu, menuMain, Add, Savegames, :subMenuSG
Menu, menuMain, Add, Advanced, :subMenuADV
Menu, menuMain, Add, Help, :subMenuHELP

;----------------
; Tray Menu
;----------------


;remove AHK items
Menu, Tray, NoStandard

Menu, Tray, Add		;a line ------ 
Menu, Tray, Add, Run Fallout New Vegas, submenuTrayHandler
Menu, Tray, Add		;a line ------ 
Menu, Tray, Add, Open FNVSGM window, submenuTrayHandler
Menu, Tray, Add		;a line ------ 
Menu, Tray, Add, Exit, submenuTrayHandler


;-------------------------------------
;GUI window 1
;-------------------------------------
Gui, Add, GroupBox, x6 y1 w320 h130 , 
Gui, Add, Text, x16 y11 w200 h20 , Select Profile
Gui, Add, DropDownList, x16 y31 w300 h300 vddlCharacter gguiDropdownProfile, 
Gui, Add, Text, x16 y60 w180 h20 vguiSavegameCount,
Gui, Add, Button, x16 y80 w300 h40 gsubRunFalloutNV, Play
Gui, Add, Picture, x6 y135 w320 h-1 vpic, standard.jpg
Gui, Add, Text, x16 y380 w300 h20 +Center cBlue gsubLaunchNexus, www.newvegasnexus.com

; Generated using SmartGUI Creator 4.0
Gui, Show, xCenter yCenter h420 w331, FNV Savegame Manager %myVERSION%
Gui, Menu, menuMain
GuiControl, Focus, ddlCharacter
;------------------------------------------------


;-----------------------
; MAIN
;-----------------------


Gosub subSetupFNVSGM

;Mainloop
Return

;------------
FinishApp:
GuiClose:

ExitApp


#Include FNVSGM_subroutines.ahk
#Include FNVSGM_functions.ahk
#Include FNVSGM_guihandler.ahk

