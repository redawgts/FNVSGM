;subroutines for FNVSGM



;----------------------------
subScanForNewProfiles:

		Gui, +Disabled
	
		lstSavegames := doScanForSavegameNames(SAVEGAMESFOLDER)
		lstLIVEFoldernames := doScanForLIVEFolderNames(SAVEGAMESFOLDER)
			
		;create savegame (character) folders and LIVE subfolders
		doCreateSavegameFolders( SAVEGAMESFOLDER, lstSavegames, lstLIVEFoldernames, PROFILESSUBFOLDER)
			
		;copy all files to the approtiate folders (incl. LIVE folders)
		doCopySavegames( SAVEGAMESFOLDER, lstSavegames, lstLIVEFoldernames, PROFILESSUBFOLDER)

		doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
		
		Gui, -Disabled
		
;subScanForNewProfiles
Return



;---------------------
subSetupFNVSGM:

	;check if INI file exists
	IfNotExist, %FNVSGMINIFILENAME%
	{
		MsgBox, 0, ERROR, The INI file doesn't exist!`n(%FNVSGMINIFILENAME%)`n`nCreating new INI file...! 
		gosub subCreateNewINI		
	}

	
	;get the path of the savegame folder
	IniRead, SAVEGAMESFOLDER, %FNVSGMINIFILENAME%, general, FalloutNVsavegames,
	
	;IF not setup already
	If SAVEGAMESFOLDER =
	{
		;try to find at standard location
		SAVEGAMESFOLDER = %A_MyDocuments%\My Games\FalloutNV
		IfNotExist, %SAVEGAMESFOLDER%\Saves
		{
			MsgBox, 0, Critical Failure, Fallout New Vegas Savegame folder NOT FOUND`n(usually in ..My Documents\My Games\FalloutNV),
			FileSelectFolder, SAVEGAMESFOLDER,,,Critical Failure`nFallout New Vegas Savegame folder NOT FOUNDPlease select Fallout New Vegas Savegame folder... `n(usually in ..My Documents\My Games\FalloutNV)
			If ErrorLevel = 1
			{
				SAVEGAMESFOLDER = 	
			}
		}

		;store the "my games\FalloutNV" location
		IniWrite, %SAVEGAMESFOLDER%, %FNVSGMINIFILENAME%, general, FalloutNVsavegames
		
		;get (from registry) and store the FalloutNV.exe location
		strFalloutNVPath=
		RegRead, strFalloutNVPath, HKEY_LOCAL_MACHINE, Software\Bethesda Softworks\FalloutNV, Installed Path
		
		IniWrite, %strFalloutNVPath%FalloutNV.exe, %FNVSGMINIFILENAME%, advanced, playbuttonlink
	}
	
	;get the active profile and active/display
	IniRead, ACTIVE, %FNVSGMINIFILENAME%, general, active
	lstProfiles := doUpdateProfileDDL(SAVEGAMESFOLDER,PROFILESSUBFOLDER,ACTIVE)
	
	
;subSetupFNVSGM:
Return




;-------------------
subRunFalloutNV:
	
	IniRead, strRunfile, %FNVSGMINIFILENAME%, advanced, playbuttonlink
	SplitPath, strRunfile,, strRunfilepath
	Run, %strRunfile%, %strRunfilepath%

;subRunFalloutNV
Return


;-----------------------
subActivateProfile:

	if ACTIVE =
	{
		ACTIVE = STANDARD
	}
	

	FileSetAttrib, -R, %SAVEGAMESFOLDER%\Fallout.ini

	;activate new profile
	;
	
	;only when profile folder exists
	IfExist, %SAVEGAMESFOLDER%\%PROFILESSUBFOLDER%\%ddlCharacter%
	{	
		;activate profile
		IniWrite, %PROFILESSUBFOLDER%\%ACTIVE%\, %SAVEGAMESFOLDER%\Fallout.ini, General, SLocalSavePath
	}
	else
	{
		ACTIVE=STANDARD
	}

	if ACTIVE = STANDARD
	{
		;activate standard profile
		IniWrite, Saves\, %SAVEGAMESFOLDER%\Fallout.ini, General, SLocalSavePath
	}
	
	
	;update FNVSGM ini
	IniWrite, %ddlCharacter%, %FNVSGMINIFILENAME%, general, active	

;subActivateProfile
Return


;-------------------------
subCreateNewINI:

	FileAppend,
(
[general]
active=                                                         
FalloutNVsavegames=

[advanced]
playbuttonlink=
), %FNVSGMINIFILENAME%

;subCreateNewINI
Return

;--------------------------
subLaunchNexus:
	Run, www.newvegasnexus.com
;subLaunchNexus
Return