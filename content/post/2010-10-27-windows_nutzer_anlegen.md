---
layout: post
title: Nutzer anlegen im Active Directory
date: 2010-10-27
categories:
- Programmieren
- sonstiges
- Tools
tags:
- Active Directory
- Nutzer
- Passwort
- Skript
- vbs
- Windows
---

Ich habe vor einigen Tagen mich mit dem [Active Directory](http://www.rrzn.uni-hannover.de/fileadmin/it_sicherheit/pdf/SiTaWS05-ActiveDir.pdf)
beschäftigen müssen. Für mich als Solaris-User ist das eine ganz andere Welt. Deswegen habe ich mich sehr schwer getan,
ohne [Martin](https://meet-unix.org/) wär dieser Artikel nicht möglich gewesen. Er stand mir mit Rat und Tat eine
Stunde telefonisch zur Verfügung. Danke noch einmal!


Nun zu meinen Problem: Ich wollte Nutzer aus einer spool-Datei automatisch in das Active Directory eintragen. Weiterhin mussten die Benutzer in die
[Organizational Unit](https://en.wikipedia.org/wiki/Organizational_Unit) `peter_lustig_user` verschoben werden. Das anlegen der Nutzer habe ich noch
alleine hinbekommen. Dazu habe ich aus zahlreichen Skripten Codezeilen kopiert. Aber das Verschieben habe ich nicht hinbekommen.
[Martin](https://meet-unix.org/)  hat mich auf die Active Directory Tools von Microsoft hingeweisen. Diese fangen alle mit __ds__ an. 
Mit [dsquery *](http://ss64.com/nt/dsquery.html) habe ich mich durch die Struktur des Active Directory gewühlt. Das grafische Frontend ist zwar
schön, aber da habe ich nicht mitbekommen, aber da weiß ich nicht wie der [Distinguished Name](http://www.comptechdoc.org/os/windows/win2k/win2kadname.html) aussieht...


Zum Schluss bin ich zu folgen Skript gekommen:

~~~ vb.net
Set args = WScript.Arguments
profile_pfad = "\odin\homes\%username%\profile"
gruppe_neu = "benutzer"
if args.count <> 1 then
	MsgBox "Es muss genau eine spool-Datei angegeben werden"
	Wscript.quit
End If
Randomize
protokoll = "C:\Dokumente und Einstellungen\Administrator\Desktop\skripte\protokoll.txt"
Set fs = CreateObject("Scripting.FileSystemObject")
' Das WScript.Network-Objekt liefert den Namen des Computers
Set net = CreateObject("WScript.Network")
' Protokolldatei öffnen
Set output = fs.CreateTextFile(protokoll, True)
'Holt den Namen des Computers aus dem net Objekt
name = net.ComputerName
Set computer = GetObject("WinNT://" & name)
' Datei öffnen
dateiname = args(0)
If Not fs.FileExists(dateiname) Then
	MsgBox "Die Datei (" & dateiname & ") existiert am angegebenen Ort nicht!"
	WScript.Quit
End If
Set infos = fs.OpenTextFile(dateiname)
' Datei zeilenweise bis zum Ende (atEndOfStream) lesen:
Do Until infos.AtEndOfStream
	' eine Zeile einlesen
	zeile = infos.ReadLine
	' Informationen durch Semikola splitten
	details = Split(zeile, ";")
	username = Trim(details(0))
	' Konto anlegen
	Set kontoneu = computer.Create("User", Trim(details(0)))
	kontoneu.FullName = Trim(details(1))
	kontoneu.Profile = profile_pfad
	' Passwort auslesen, wenn es das default-Passwort ist, dann generiere ein Passwort
	passwort =  Trim(details(2))
	if passwort = "du34!$7_.4-@" then
		passwort = Trim(genPasswort)
		kontoneu.PasswordExpired = CLng(1)
	end if
	kontoneu.SetPassword passwort
	' Ablaufdatum setzten
	if trim(details(3)) <> "never" then
		kontoneu.AccountExpirationDate = Trim(details(3))
	end if
	' Normales Benutzerkonto
	kontoneu.UserFlags = 512
	if not fs.FolderExists("\odin\homes\" & username) then
		set folder = fs.CreateFolder("\odin\homes\" & username)
		set folder_files = fs.createfolder("\odin\homes\" & username & "\files")
		set folder_profile = fs.createfolder("\odin\homes\" & username & "\profile")
		set IShellDispatch2 = CreateObject("Shell.Application")
		Call IShellDispatch2.ShellExecute("C:\skripte\subinacl", "/file \odin\homes\" & username & " /setowner=" & username, , , 0)
		Call IShellDispatch2.ShellExecute("c:\skripte\subinacl", "/subdirectories \odin\homes\" & username & " /setowner=" & username, , , 0)
		Call IShellDispatch2.ShellExecute("C:\skripte\cacls", "\odin\homes\" & username & " /T /G Administratoren:F " & username & ":F System:F < echo j", , , 0)
	end if
	err.clear
	On Error Resume Next
	kontoneu.SetInfo
	if Err.number = 0 then
		WriteLog "Benutzername:  " & username & "   Passwort: " & passwort
		AddToGroup gruppe_neu, kontoneu.ADsPath
		' User in die ou peter_lustig_user verschieben
		set dsMove = CreateObject("Shell.Application")
		dsMoveArg = " " & Chr(34) & "CN=" & username & ",CN=Users,DC=w2k8-pool,DC=windows,DC=0rpheus,DC=net" & Chr(34) & _
	                       " -newparent " & Chr(34) & "OU=peter_lustig_user,DC=w2k8-pool,DC=windows,DC=0rpheus,DC=net" & Chr(34)
		Call dsMove.ShellExecute("dsmove", dsMoveArg, , ,0)
	else
		if Err.number = -2147022672 then
			WriteLog "Fehler beim Anlegen von " & username & ": Nutzer existiert bereits"
		else
			WriteLog "Fehler beim Anlegen von " & username & ": " & Err.Number
		end if
	end if
	Err.Clear
Loop
' Dateien schließen
infos.Close
output.Close
' Protokoll anzeigen:
'SYS: Microsoft (r) Script Runtime
Set wshshell = CreateObject("WScript.Shell")
wshshell.Run """" & protokoll & """"
Sub AddToGroup(gruppenname, kontoname)
	On Error Resume Next
	Set gruppe = GetObject("WinNT://" & ComputerName & "/" & gruppenname & ",group")
	gruppe.Add kontoname
	gruppe.SetInfo
	If Err.number = 0 Then
		'WriteLog "Konto ist Mitglied in Gruppe " & gruppenname
	Else
		'WriteLog "Konto konnte nicht zum Mitglied in Gruppe " & gruppenname & " gemacht werden."
	End If
	Err.Clear
End Sub

Sub WriteLog(text)
	' eine Zeile ins Protokoll schreiben und Leerzeile einfügen
	output.WriteLine text & vbCrLf & vbCrLf
End Sub

function genPasswort()
	password = ""
	for i=1 to 12
		if Int(100*Rnd mod 2 ) = 1 then
			password = password & chr(Int(61*Rnd+33))
		else
			password = password & chr(Int(29*Rnd+97))
		end if
	next
	genPasswort = password
end function
~~~

Der AD-Guru oder Windows-Hardcore User wird sicher sagen, wie dumm ist das denn, das geht in einen 3-Zeiler.
Aber ich kann kein Windows und will es eigentlich auch nicht lernen :P Wenn ich Zeit hätte wüsste ich wie man
mit den `ds`*-Tools das ganze schöner machen könnte. Ich habe das komplette Skript hier rein gestellt, da
man sicher die ein oder andere Zeile klauen kann *g*. Der Passwortgenerator ist schlecht,
es war aber die schnellste Lösung.
