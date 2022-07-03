#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Persistent
#NoTrayIcon
;@Ahk2Exe-ExeName SpotTheBlockInstaller
Global 7z := "C:\Program Files\7-Zip\7z.exe"
Global DefaultSpotifyPath := A_AppData "\Spotify"
Global DefaultSpotifyEXEPath := DefaultSpotifyPath "\Spotify.exe"

if A_IsCompiled
{
	if !FileExist("config.ini")
	{
		if !FileExist("Spotify.exe")
		{
			if !FileExist(DefaultSpotifyEXEPath)
			{
				msgbox, , SpotTheBlock, SpotTheBlock is not in Spotify's directory and was not found in default path. `nCan not install automatically.`n`n Spot the block will now exit.
				ExitApp
			}
			else
			{
				msgbox, 4132, SpotTheBlock, SpotTheBlock is not in Spotify's directory, but has found where Spotify is installed.`nWould you like to automatically install SpotTheBlock in the right directory and start over?
				IfMsgBox, Yes
				{
					Process, Close, SpotTheBlock.exe
					Process, WaitClose, SpotTheBlock.exe
					sleep 750
					Filecopy, % A_ScriptFullPath, %DefaultSpotifyPath%\SpotTheBlock.exe, 1
					sleep 750
					Run, %DefaultSpotifyPath%\SpotTheBlock.exe
					ExitApp					
				}
				IfMsgBox, No
				{
					MsgBox Goodbye.
					ExitApp
				}
				
			}
		}
		else
		{
			if !FileExist("chrome_elf_bak.dll")
			{
				MsgBox, 4132, SpotTheBlock, SpotTheBlock seems to be in the right directory, but did not detect BlockTheSpot.`n`n Would you like to install the latest BlockTheSpot now?`n`nIf you press no, SpotTheBlock will run in its default mode and offer to install BlockTheSpot on the first detected Advertisement.
				IfMsgBox, Yes
				{
					CloseSpotify()
					InstallPrep()
					UpdateToLatest()
					MsgBox, 4132, SpotTheBlock, BlockTheSpot is now installed. Start Spotify now?
					IfMsgBox, Yes
					{
						RunSpotify()
					}
					;Goto StartChecker
					;return
				}
				IfMsgBox, No
				{
					;Goto StartChecker
					;return
				}
			}
		}
	}

ScriptQuotes := A_ScriptFullPath
ScriptQuotes = \"%ScriptQuotes%\"
FileAppend, @echo off `n`nFOR /F `"tokens=* USEBACKQ`" `%`%F IN (``schtasks /query /tn SpotTheBlock /fo csv``) DO ( `nSET var=`%`%F `n) `nIF NOT DEFINED var ( `n    echo notask > notask `n) , taskgen.bat
sleep 750
run, %comspec% /c taskgen.bat,,hide
sleep 750
FileDelete, taskgen.bat
IfExist, notask
	{
		msgbox, 4132, SpotTheBlock, SpotTheBlock is not set up to launch at login, press yes to make a scheduled task.
		IfMsgBox Yes
		{
			Run *RunAs schtasks.exe /Create /SC onlogon /TN SpotTheBlock /TR "%ScriptQuotes%" /F,, hide
		}
		FileDelete, notask
	}
	
}
else
{
	msgbox Please compile this script with right click before using it.
	ExitApp
}

If FileExist("chrome_elf_bak.dll")
{
	if FileExist("config.ini")
	{
		IniRead, InstalledBTSTag, config.ini, Version, Tag, 0
		IniRead, InstalledBTSVer, config.ini, Version, Release, 0
		IniRead, InstalledBTSDate, config.ini, Version, Date, 0
		Global InstalledBTSTag
		Global InstalledBTSVer
		Global InstalledBTSDate
		if (InstalledBTSTag = 0)
		{
			msgbox, 4132, SpotTheBlock, BlockTheSpot Was detected, but SpotTheBlock has no version information stored. for updates to work properly, you'll have to reinstall BlockTheSpot via this updater.`n`nPress yes to enable automatic updating, and no to exit.
			IfMsgBox Yes
			{
				UpdateToLatest()
			}
			IfMsgBox no
			{
				ExitApp
			}
		}
	}
}
SetTimer, CheckForUpdate, 21600000

Goto StartChecker






return
;;;;;;;;;;;;;;;;;;;;;;;functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CheckForUpdate:
jurl := "https://api.github.com/repos/mrpond/BlockTheSpot/releases/latest"
Global response := URLDownloadToVar(jurl)
LatestTag := ReadFromResponse("tag_name")
LatestDL := ReadFromResponse("browser_download_url")
TagLen := StrLen(LatestTag)
if (TagLen > 3)
{
	LDateEnd := InStr(LatestTag, ".", CaseSensitive := false, StartingPos := 1, Occurrence := 3) -1
	LatestDate := SubStr(LatestTag, 1, LDateEnd)
	LVerStart := LDateEnd + 2
	LatestVers := SubStr(LatestTag, LVerStart)
}
else
{
	LatestDate = null
	LatestVers := LatestTag
}
IniRead, InstalledBTSTag, config.ini, Version, Tag, 0
IniRead, InstalledBTSVer, config.ini, Version, Release, 0
IniRead, InstalledBTSDate, config.ini, Version, Date, 0
Global InstalledBTSTag
Global InstalledBTSVer
Global InstalledBTSDate

if (InstalledBTSVer < LatestVers)
{
	msgbox, 4132, SpotTheBlock, An Update to BlockTheSpot was found. `n`nWould you like to close spotify and (re)Install the latest BlockTheSpot? 
	IfMsgBox, Yes
	{
	;MsgBox you pressed Yes
	CloseSpotify()
	;InstallPrep()
	UpdateToLatest()
	RunSpotify()
	}
	IfMsgBox, No
	{
		;SetTimer, CheckState, 1000
		
	}
}
else
{
return
}

return



StartChecker:
SetTimer, CheckState, 1000

return

CheckState:
WinGet, id, List, Advertisement
Loop, %id%
{
	this_id := id%A_Index%
	WinGetClass, this_class, ahk_id %this_id%
	if (%this_class% = Chrome_WidgetWin_0)
	{
		SetTimer, CheckState, off
		;MsgBox  Text, Timeout
		msgbox, 4132, SpotTheBlock, Spotify advert detected. `n`nWould you like to close spotify and (re)Install the latest BlockTheSpot? 
		IfMsgBox, Yes
		{
		;MsgBox you pressed Yes
		CloseSpotify()
		InstallPrep()
		UpdateToLatest()
		RunSpotify()
		}
		IfMsgBox, No
		{
			SetTimer, CheckState, 1000
			break
		}
		SetTimer, CheckState, 1000
		break
	}
}
return

RunSpotify()
{
Run, Spotify.exe
return
}


CloseSpotify()
{
Process, Close, Spotify.exe
return
}

DateTest()
{
jurl := "https://api.github.com/repos/mrpond/BlockTheSpot/releases/tag/42"
Global response := URLDownloadToVar(jurl)
LatestDL := ReadFromResponse("browser_download_url")
LatestTag := ReadFromResponse("tag_name")
TagLen := StrLen(LatestTag)
if (TagLen > 3)
{
	LDateEnd := InStr(LatestTag, ".", CaseSensitive := false, StartingPos := 1, Occurrence := 3) -1
	LatestDate := SubStr(LatestTag, 1, LDateEnd)
	LVerStart := LDateEnd + 2
	LatestVers := SubStr(LatestTag, LVerStart)
}
else
{
	LatestDate = null
	LatestVers := LatestTag
}


msgbox Latest Tag Name is %LatestTag% `nLatest DL Url is %LatestDL%`nDate: %LatestDate%`nVersion: %LatestVers%
return
}


UpdateToLatest()
{
jurl := "https://api.github.com/repos/mrpond/BlockTheSpot/releases/latest"
Global response := URLDownloadToVar(jurl)
;msgbox % response
LatestTag := ReadFromResponse("tag_name")
LatestDL := ReadFromResponse("browser_download_url")
TagLen := StrLen(LatestTag)
if (TagLen > 3)
{
	LDateEnd := InStr(LatestTag, ".", CaseSensitive := false, StartingPos := 1, Occurrence := 3) -1
	LatestDate := SubStr(LatestTag, 1, LDateEnd)
	LVerStart := LDateEnd + 2
	LatestVers := SubStr(LatestTag, LVerStart)
}
else
{
	LatestDate = null
	LatestVers := LatestTag
}
;msgbox Latest Tag Name is %LatestTag% `nLatest DL Url is %LatestDL%
UrlDownloadToFile, %LatestDL%, chrome_elf_%LatestTag%.zip

RunWait, "%7z%" "x" "-y" "%A_ScriptDir%\chrome_elf_%LatestTag%.zip" chrome_elf.dll
if !FileExist("config.ini")
	RunWait, "%7z%" "x" "-y" "%A_ScriptDir%\chrome_elf_%LatestTag%.zip" config.ini
sleep 750

;IniWrite
IniWrite, % LatestTag, config.ini, Version, Tag
IniWrite, % LatestVers, config.ini, Version, Release
IniWrite, % LatestDate, config.ini, Version, Date
Global InstalledBTSTag := LatestTag
Global InstalledBTSVer := LatestVers
Global InstalledBTSDate := LatestDate

return
}

InstallPrep()
{
FileMove, chrome_elf_bak.dll, chrome_elf_bak_old.dll, 1
FileMove, chrome_elf.dll, chrome_elf_bak.dll, 1
sleep 1000
return
}


ReadFromResponse(KeyName)
{
jurl := "https://api.github.com/repos/mrpond/BlockTheSpot/releases/latest"
Global response := URLDownloadToVar(jurl)
PairPosBegin := RegExMatch(response, KeyName, OutputVar) - 1
PairPosEnd := InStr(response, ",", CaseSensitive := false, StartingPos := PairPosBegin, Occurrence := 1)
PairLen := Abs(PairPosEnd - PairPosBegin)
PairFull := SubStr(response, PairPosBegin , PairLen)
ValStart := InStr(PairFull, """", CaseSensitive := false, StartingPos := 1, Occurrence := 3) + 1
ValEnd := InStr(PairFull, """", CaseSensitive := false, StartingPos := 1, Occurrence := 4)
ValLen := Abs(ValEnd - ValStart)
Value := SubStr(PairFull, ValStart, ValLen)
return Value
}


URLDownloadToVar(url){
	hObject:=ComObjCreate("WinHttp.WinHttpRequest.5.1")
	hObject.Open("GET",url)
	hObject.Send()
	return hObject.ResponseText
}