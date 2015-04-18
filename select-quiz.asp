<%Option Explicit%>
<!--#include virtual="/DB/config.asp"-->
<!--#include virtual="/DB/adovbs.asp"-->
<!--#include virtual="/DB/utils.asp"-->
<!--#include virtual="/DB/debug.asp"-->
<!--#include virtual="/DB/database.asp"-->
<!--#include virtual="/DB/quizdata.asp"-->
<!--#include virtual="/DB/quiz.asp"-->
<%
sub showStartedTests
	Dim db
	Dim rs
	Dim c
	Dim quizType
	Dim started
	Dim action
	Dim quizProperties

	quizType=""
	set db = new Database
	db.serverName = config.dbserver
	db.dbname = config.dbname
	c = ","
	set rs = db.getRs("SELECT * FROM Quiz WHERE started=1 ORDER BY quizType, quizname", adOpenForwardOnly, adLockReadOnly)

	if rs.eof then
		%><p class="message">Geen toetsen gevonden</p><%
		exit sub
	end if

	dim unit
	unit = replace(rs("unit"),"&","N")
	do until rs.eof
		%><p><a href="/<%=unit%>/<%=he(rs("vak"))%>/<%=he(rs("folder"))%>/quiz.html"><%=he(rs("unit"))%> / <%=he(rs("vak"))%> / <%=he(rs("quizname"))%></a></p><%
		rs.MoveNext
	loop
	rs.close
	db.CloseConn
	set rs = nothing
	set db = nothing
end sub

%>
<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8" />

<title>Elektronische toetsen</title>
	<style type="text/css">
	body { font: .76em calibri, arial; margin:1em; }
	td, th { border:1px solid silver; padding:2px;}
	table { border-collapse:collapse; }
	/*tr:nth-child(odd) { background-color: #e2f7f7;}*/
	table tr.alternate {
		background-color:#e2f7f7;
	}
	tr:hover td {background: lightgrey; }
	td { white-space:nowrap; }
	td input { font-size:.8em; width:3em; }
	td div { display:inline; }
	td button {background-image: url("pixelistica/16x16/save.png");background-size: 100%;background-repeat:no-repeat;width: 16px;height: 16px;border:none;text-indent:-1000px;margin-left:2px;padding:0;}

	a.view, a.download, a.started-yes, a.started-no {background: url() no-repeat 0 0; height:0; display:inline-block; padding-top:16px; overflow:hidden; padding-left:2px; padding-right:2px; width:16px; }
	a.view { background-image: url("pixelistica/16x16/view.png") }
	a.quizTitle { text-decoration:none; color: black}
	a.quizTitle:hover { color:navy }
	a.download { background-image: url("pixelistica/16x16/arrow_down.png")}
	a.started-yes { background-image: url("pixelistica/16x16/stop.png") }
	a.started-no { background-image: url("pixelistica/16x16/play.png") }

	h1 { font: bold 1.4em arial; color: #003366}
	h2 { font: bold 1.2em arial; color: #003366}
	h3 { font: bold 1.1em arial; color: #003366}
	</style>

	<link rel="stylesheet" type="text/css" href="table.css" media="all">
	<script type="text/javascript" src="/DB/jquery.min.js"></script>

</head>
<body>
<img src="/report/logoEPI.png" width="200" alt="EPI"/>
<h1>Kies een toets</h1>
<%showStartedTests%>
</body>
</html>
