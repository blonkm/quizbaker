<%Option Explicit
' This Source Code Form is subject to the terms of the Mozilla Public
' License, v. 2.0. If a copy of the MPL was not distributed with this file,
' You can obtain one at http://mozilla.org/MPL/2.0/.
'

%>
<!--#include virtual="/DB/config.asp"-->
<!--#include virtual="/DB/adovbs.asp"-->
<!--#include virtual="/DB/utils.asp"-->
<!--#include virtual="/DB/debug.asp"-->
<!--#include virtual="/DB/database.asp"-->
<!--#include virtual="/DB/quizdata.asp"-->
<!--#include virtual="/DB/quiz.asp"-->

<%
Dim oQuiz
set oQuiz = new Quiz

Function DBOK()
	Dim db
	Dim rs
	Dim sql

	set db = oQuiz.getDB()
	if not db is nothing then
		DBOK = "OK"
	else
		DBOK = "Error"
	end if
End Function

Function QuizCount()
	Dim db
	Dim rs
	Dim sql

	set db = oQuiz.getDB()

	sql = "SELECT COUNT(*) AS QuizCount FROM quiz"
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	QuizCount = rs("QuizCount")
End Function

Function StudentCount()
	Dim db
	Dim rs
	Dim sql

	set db = oQuiz.getDB()

	sql = "SELECT COUNT(*) AS StudentCount FROM Quiz_Summary"
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	StudentCount = rs("StudentCount")
End Function

Function QuestionCount()
	Dim db
	Dim rs
	Dim sql

	set db = oQuiz.getDB()

	sql = "SELECT COUNT(*) AS QuestionCount FROM Quiz_Detail"
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	QuestionCount = rs("QuestionCount")
End Function

Function QuestionsTodayCount()
	Dim db
	Dim rs
	Dim sql

	set db = oQuiz.getDB()

	sql = "SELECT COUNT(*) AS QuestionCount FROM Quiz_Audit WHERE CONVERT(date,LastModified)=CONVERT(date,getdate())"
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
	QuestionsTodayCount = rs("QuestionCount")
End Function

Function UserName(networkId)
	Dim parts

	parts = split(networkId, "\")
	if ubound(parts)>0 then
		UserName = parts(1)
	else
		UserName = networkId
	end if
End Function

Function Cut(s, n)
	if len(s)<=n then
		Cut = s
	else
		Cut = left(s,n) & "..."
	end if
End Function

Sub ShowLastResults(n)
	Dim db
	Dim rs
	Dim sql
	Dim nl

	nl = vbNewline
	set db = oQuiz.getDB()

	sql = "SELECT TOP 5 * FROM Quiz_Audit ORDER BY ID DESC"
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)

	if rs.eof then
		%><p>Wachten op antwoorden...</p><%
		Exit Sub
	end if

	%><table id="liveResults">
	<tr>
		<th>timestamp</th>
		<th>student</th>
		<th>question</th>
		<th>response</th>
		<th>result</th>
		<th>score</th>
		<th>type</th>
	</tr>

	<%
	do until rs.eof
		print "<tr>"
		print td(rs("timestamp")) & nl
		print td(UserName(rs("network_id"))) & nl
		print td(cut(rs("question"),20)) & nl
		print td(cut(rs("student_response"),20)) & nl
		print td(rs("result")) & nl
		print td(rs("score")) & nl
		print td(rs("interaction_type")) & nl
		print "</tr>"
		rs.moveNext
	loop
	%></table><%
End Sub

Sub ShowLiveView
	Dim db
	Dim rs
	Dim sql
	Dim nl

	nl = vbNewline
	set db = oQuiz.getDB()

	sql = "SELECT TOP 5 * FROM Quiz_Audit ORDER BY ID DESC"
	sql = "SELECT max(network_id) as student, COUNT(DISTINCT question) as num_questions"
	sql = sql & " FROM Quiz_Audit"
	sql = sql & " WHERE timestamp < DATEADD(minute, -260, GETDATE()-1)"
	sql = sql & " AND CAST(timestamp as DATE) = CAST(GETDATE()-1 as DATE)"
	sql = sql & " GROUP BY network_id"
	sql = sql & " ORDER BY 2 DESC"

	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)

	if rs.eof then
		%><p>Wachten op antwoorden...</p><%
		Exit Sub
	end if

	%>
	<!-- <table id="liveView">
	<tr>
		<th>Student</th>
		<th>Questions Answered</th>
	</tr>
	-->
	<%
	do until rs.eof
		'print "<tr>"
		'print td(rs("student")) & nl
		'print td(rs("num_questions")) & nl
		'print "</tr>"
		rs.moveNext
	loop
	%></table><br/>
	<div id="liveView">
	<h1>Live view</h1>
	<%
	dim title
	rs.moveFirst
	do until rs.eof
		title = rs("student") & " - " & rs("num_questions") & " antwoorden"
		%><img class="livedot" src="images/dot.png" title="<%=title%>" width="<%=rs("num_questions")*2%>" height="1" /><%
		rs.moveNext
	loop
	%></div><%
End Sub
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta http-equiv="refresh" content="5" />
	<title>Server status</title>
	<link rel="stylesheet" type="text/css" href="report.css" media="screen" />

    <style type="text/css">
    body { font: 1em Calibri, Arial, Helvetica, sans-serif}
    .livedot { display:block; line-height:4px; height:4px; margin-bottom:1px; }
    #liveView { position:absolute; top:20px; left: 400px; width:200px; height:320px; border:1px solid green; padding:5px; }
    </style>
</head>

<body>
<h1>Statistieken</h1>
<!-- <p id="count"><%=CLNG(Application("QuestionCount"))%> vragen</p> -->
<p id="quizcount"><%=CLNG(QuizCount())%> toetsen</p>
<p id="studentcount"><%=CLNG(StudentCount())%> toetsen gemaakt</p>
<p id="questioncount"><%=CLNG(QuestionCount())%> vragen beantwoord</p>
<p id="todaycount"><%=CLNG(QuestionsTodayCount())%> vandaag beantwoord</p>
<p id="web">Webserver: OK</p>
<p id="db">Database server: <%=DBOK()%></p>
<p id="timestamp"><%=Now()%>
<div id="live">
<h2>Laatste 5 antwoorden (live)</h2>
<%showLastResults(5)%>
<p>&nbsp;</p>
<%showLiveView()%>
</div>
</body>
</html>