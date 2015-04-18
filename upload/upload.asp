<%
Dim message
Dim uploadSuccess

Function getFormDetails()
    Dim docent
    Dim unit
    Dim vak
    Dim soort
    Dim file
    Dim klas
    Dim studenten
    Dim datum
    Dim startTijd
    Dim lengte
    Dim surv
    Dim out
    Dim key

    'docent = Req("docent")
    'unit = Req("unit")
    'vak = Req("vak")
    'soort = Req("soort")
    'file = Req("uploadify")
    'klas = Req("klas")
    'studenten = Req("studenten")
    'datum = Req("datum")
    'startTijd = Req("startTijd")
    'lengte = Req("lengte")
    'surv = Req("surv")

    out = "<table>"
    For each key in Request.Form
        if key<>"action" then
            out = out & tr(th(key) & td(Request(key)))
        end if
    Next
    out = out & "</table>"
    getFormDetails = out
End Function

Sub sendmail()
	Dim iMsg
	Dim iConf
	Dim cfg
    Dim Flds
    Dim recipient

	if req("action")<>"" then
		if req("docent")="" then
			message = "Graag het hele formulier invullen"
			exit sub
		end if
	end if

	Set iMsg = CreateObject("CDO.Message")
	Set iConf = CreateObject("CDO.Configuration")
	cfg = "http://schemas.microsoft.com/cdo/configuration/"

	iConf.Load -1 ' CDO Source Defaults
	Set Flds = iConf.Fields

	Flds.Item(cfg & "sendusing") = 2 ' using port
	Flds.Item(cfg & "smtpserver") = "smtp.setarnet.aw"
	Flds.Item(cfg & "smtpserverport") = 25
	Flds.Update

    recipient = "pmvanderblonk@epiaruba.com"

	With iMsg
		Set .Configuration = iConf
		.To = recipient
		.CC = ""
'		.BCC = ""
		.From = "Toets <toets@epiaruba.com>"
		.Subject = "Upload of electronic test received"
		.TextBody = ""
		.HTMLBody = getFormDetails
        if fileExists("/upload/quiz/" & Req("quiz")) then
            .addAttachment FilePath("/upload/quiz/" & Req("quiz"))
        end if
		.Send
	End With
End Sub

Function getVakken(unit)
	Dim FSO
	Dim folder
	Dim f
	Dim path
	Dim c

	set c = CreateObject("Scripting.Dictionary")

	if not (Request("unit")="") then
		path = "c:\inetpub\wwwroot\cp\" & Request("unit") & "\"

		set FSO = CreateObject("Scripting.FileSystemObject")
		set folder = FSO.getFolder(path)
		for each f in folder.SubFolders
			c.add f.name, f.name
		next
	end if
	set getVakken = c
End Function

Function getQuizFolders()
	Dim FSO
	Dim folder
	Dim f
	Dim path
	Dim item
	Dim c

	on error resume next

	set c = CreateObject("Scripting.Dictionary")
	if not (Request("unit")="" or Request("vak")="") then
		path = "c:\inetpub\wwwroot\cp\" & Request("unit") & "\" & Request("vak")

		set FSO = CreateObject("Scripting.FileSystemObject")
		if fso.FolderExists(path) then
			set folder = FSO.getFolder(path)
			for each f in folder.SubFolders
				c.add f.name, f.name
			next
		end if
	end if
	set getQuizFolders = c
End Function

Sub doActions
	if Req("action")<>"" then
        sendmail
		uploadSuccess = true
    end if
end sub

' MAIN '
uploadSuccess = false
doActions

dim oFolders
dim item
dim i

application("sessionID")=Session.SessionID
application("uploadpath") = "/upload/quiz"
%>
