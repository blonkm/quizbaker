<%@LANGUAGE="VBSCRIPT"%>
<%
   Option Explicit
   On Error Resume Next

   ' this section is optional - it just denies anonymous access
   If Request.ServerVariables("LOGON_USER")="" Then
      Response.Status = "401 Access Denied"
   End If

   ' declare variables
   Dim objFSO, objFolder
   Dim objCollection, objItem

   Dim strPhysicalPath, strTitle, strServerName
   Dim strPath, strTemp
   Dim strName, strFile, strExt, strAttr
   Dim intSizeB, intSizeK, intAttr, dtmDate
	Dim item

   Function getSubfolders()
	Dim FSO
	Dim folder
	Dim f
	Dim path
	Dim c

	set c = CreateObject("Scripting.Dictionary")

   ' get the current folder URL path
   strTemp = Mid(Request.ServerVariables("URL"),2)
   strPath = ""

   Do While Instr(strTemp,"/")
      strPath = strPath & Left(strTemp,Instr(strTemp,"/"))
      strTemp = Mid(strTemp,Instr(strTemp,"/")+1)
   Loop

   strPath = "/" & strPath
		set FSO = CreateObject("Scripting.FileSystemObject")
		set folder = FSO.getFolder(Server.MapPath(strPath))
		for each f in folder.SubFolders
			c.add f.name, f.name
		next
	set getSubfolders = c
  End Function




%>


<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8" />

<title>Elektronische toetsen</title>
<style>
body { font: .76em arial; margin:1em; }
h1,h2,h3 {font-size:1.2em; color: teal}
h1 {font-size:1.6em}
td, th {border:1px solid silver; padding:.2em}
table {border-collapse:collapse}
tr:nth-child(odd) { background-color: #e2f7f7;}
input {width:10em}
label {width:12em; display:inline-block;}
#main {width:80%; margin: 0 auto}
.field {margin:1em 0}
.field span {color: gray}
.error {color:red; background: silver; font-size:1.2em; margin:1em; padding:1em; }
div.hidden {display:none}
.link {text-decoration: underline; cursor:pointer;}
#showNewFolder {display:inline}
#newFolder {margin:.2em 0}

</style>

</head>
<body>
<div id="main">
<img src="/DB/logoEPI.png" width="200" alt="EPI" />

<h1>Elektronische toetsen</h1>
<p>Kies een vak:</p>
			<%
			Dim vakken
			set vakken = getSubfolders()
			for each item in vakken
			 %><h2><a href="./<%=item%>"><%=UCase(item)%></a></h2><%
			next

%>
</div>
</body>

</html>