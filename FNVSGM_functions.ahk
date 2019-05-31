;functions for FNVSGM

;-------------------
doScanForSavegameNames( in_strSavegamefolder)
{

	lstSavegames =
	strName =
	strNameOld =

	Loop, %in_strSavegamefolder%\Saves\*.fos,0,1
	{
		strName = %A_LoopFileName%
		if strName = autosave.fos
			Continue

		else if strName = quicksave.fos
			Continue

		else
		{

			;scan for name of character
			;

			nPos := InStr(strName, "   ")
			If nPos >0
			{
				strName := SubStr(strName, nPos) ;remove the savegame prefix "Speich. "
				strName := SubStr(strName, 4) ;remove the "- "

				nPos := InStr(strName, "  ")
				If nPos >0
				{
					strName := SubStr(strName, 1, nPos-1)
				}

				;Only store char name if not in list already
				if ( strName != strNameOld)
				{
					lstSavegames = %lstSavegames%%strName%`n
				}
				strNameOld := strName


			} ;if nPos >0

		} ;else
	} ;loop

	Sort, lstSavegames, U

Return lstSavegames
} ;doScanForSavegameNames()



;------------------------
doScanForLIVEFolderNames( in_strSavegamefolder)
{
	lstFolderName=

	Loop, %in_strSavegamefolder%\Saves\*.*,2,0
	{
		strName = %A_LoopFileName%
		lstFolderName = %lstFolderName%%strName%`n
	} ;loop

	Sort, lstFolderName, U

Return lstFolderName
} ;doScanForLIVEFolderNames


;----------------------------
doCreateSavegameFolders( in_strProfileFolder, in_lstSavegameNames, in_lstLIVEFoldernames, in_strSubfolder)
{
	Loop, parse, in_lstSavegameNames, `n
	{
		if A_LoopField !=
		{
			strFoldername := A_LoopField

			;create character folders
			IfNotExist, %in_strProfileFolder%\%in_strSubfolder%\%strFoldername%
			{
				FileCreateDir, %in_strProfileFolder%\%in_strSubfolder%\%strFoldername%

				;create LIVE subfolder
				Loop, parse, in_lstLIVEFoldernames, `n
				{
					FileCreateDir, %in_strProfileFolder%\%in_strSubfolder%\%strFoldername%\%A_LoopField%
				}
			}
		}
	}

Return 0
;doCreateSavegameFolders
}


;--------------------
doCopySavegames( in_strSavegameFolder, in_lstSavegameNames, in_lstLIVEFoldernames, in_strSubfolder)
{

	;scan normal savegame folder for savegames
	Loop, parse, in_lstSavegameNames, `n
	{
		if A_LoopField !=
		{
			strFoldername := A_LoopField

			;if profile folder exist
			IfExist, %in_strSavegameFolder%\%in_strSubfolder%\%strFoldername%
			{
				;copy normal savegames to profile folder
				FileCopy, %in_strSavegameFolder%\Saves\*   %strFoldername%*.fos, %in_strSavegameFolder%\%in_strSubfolder%\%strFoldername%

				;scan LIVE savegame folder for savegames
				Loop, parse, in_lstLIVEFoldernames, `n
				{
					strLIVEFoldername := A_LoopField
					IfExist, %in_strSavegameFolder%\%in_strSubfolder%\%strFoldername%\%strLIVEFoldername%
					{
						;copy LIVE files to savegame subfolder
						FileCopy, %in_strSavegameFolder%\Saves\%strLIVEFoldername%\*   %strFoldername%*.fos, %in_strSavegameFolder%\%in_strSubfolder%\%strFoldername%\%strLIVEFoldername%
					}
				}
			}
		}
	}


	Return 0
} ;doCopySavegames


;-----------------
doUpdateProfileDDL( in_strSavegamefolder, in_strSubfolder, in_strPreSelect)
{

	;check if profile for preselection exists
	if (in_strPreSelect != STANDARD)
	{
		IfNotExist, %in_strSavegamefolder%\%in_strSubfolder%\%in_strPreSelect%
		{
			in_strPreSelect = STANDARD
		}
	}

	;clear the dropdownlist
	GuiControl, , ddlCharacter, |

	;add Standard to combobox
	if in_strPreSelect = STANDARD
	{
		;pre-select
		GuiControl, , ddlCharacter, STANDARD||
	}
	else
	{
		GuiControl, , ddlCharacter, STANDARD|
	}

	;scan all folders and add to combobox
	Loop, %in_strSavegamefolder%\%in_strSubfolder%\*.,2,0
	{
		lstProfilenames = %lstProfilenames%%A_LoopFileName%`n
		if A_LoopFileName = %in_strPreSelect%
		{
			;pre-select
			GuiControl, , ddlCharacter, %A_LoopFileName%||
		}
		else
		{
			GuiControl, , ddlCharacter, %A_LoopFileName%|
		}
	}

	iSavegamecount := doCountSavegames(in_strSavegamefolder,in_strSubfolder,in_strPreSelect)
	GuiControl, ,guiSavegameCount, Savegames: %iSavegamecount%

	Gosub, guiDropdownProfile
	;update GUI
	Gui, Show

Return lstProfilenames
} ;doUpdateProfileDDL



;-----------------
doCountSavegames( in_strProfilefolder, in_strProfilesub, in_strActiveProfile)
{
	iCount = 0

	strPath=

	if in_strActiveProfile=
	{
		iCount = 0
	}

	else
	{
		if in_strActiveProfile=STANDARD
		{
			strPath = %in_strProfilefolder%\Saves
		}

		else
		{
			strPath = %in_strProfilefolder%\%in_strProfilesub%\%in_strActiveProfile%
		}

		Loop, %strPath%\*.fos,0,1
		{
			iCount := A_Index
		}
	}


;doCountSavegames
Return iCount
}
