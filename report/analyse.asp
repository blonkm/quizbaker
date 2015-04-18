<%Option Explicit
' This Source Code Form is subject to the terms of the Mozilla Public
' License, v. 2.0. If a copy of the MPL was not distributed with this file,
' You can obtain one at http://mozilla.org/MPL/2.0/.

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
Dim nl
Dim c
Dim br
Dim days
Dim action
Dim quizVisible
Dim message

c = ","
nl = vbNewLine
br = "<br/>"
set oQuiz = new Quiz
quizVisible = "hidden"

Sub ShowAnalysis()

    Dim db
    Dim numResponses
    Dim percCorrect
    Dim percWrong
    Dim sql
    Dim rs
    Dim n

	set db = oQuiz.getDB()

	if Req("id")="" then
		Exit Sub
	end if

	sql = "SELECT "
	sql = sql & " ISNULL(SUM(CASE result WHEN 'correct' THEN 1 ELSE 0 END),0) AS correct," 
	sql = sql & " ISNULL(SUM(CASE result WHEN 'wrong' THEN 1 ELSE 0 END),0) AS wrong,"
	sql = sql & " REPLACE(max(question), ',',' ') question, "
	sql = sql & " questionNum nr, "
	sql = sql & " MAX(result) result"
	sql = sql & " FROM vwDetails"
	sql = sql & " WHERE quizId = @id"
	sql = sql & " AND result!='neutral'"
    sql = sql & " AND objective_id LIKE 'Question%'"
	sql = sql & " GROUP BY questionNum"
	sql = sql & " ORDER BY questionNum"

    sql = replace(sql, "@id", int(Req("id")))
	set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)

	%>
	<table id="scores" class="table-sortable table-autosort">
	<thead>
	<tr>
		<th class="table-sortable table-sortable:numeric">nr</th>
		<th class="table-sortable table-sortable:alphanumeric">question</th>
		<th class="table-sortable table-sortable:numeric">wrong</th>
		<th class="table-sortable table-sortable:numeric">correct</th>
		<th class="table-sortable table-sortable:numeric">%wrong</th>
		<th class="table-sortable table-sortable:numeric">%correct</th>
	</tr>
	</thead>
	<%
    n=0
	do until rs.eof
        n = n + 1
		%><tr id="row-<%=rs("nr")%>">
		<%
        numResponses = int(rs("correct")) + int(rs("wrong"))
		print td(rs("nr")) & nl
		print td(rs("question")) & nl
		print td(rs("wrong")) & nl
		print td(rs("correct")) & nl
        percWrong = int(rs("wrong") / numResponses * 100)
        percCorrect = int(rs("correct") / numResponses * 100)
		print td(percWrong & "%") & nl
		print td(percCorrect & "%") & nl
		print vbNewLine
		print "</tr>"
		rs.MoveNext
	loop
	%></table><%
End Sub

Function QuizTitle()
	QuizTitle = ""
    if Req("id")<>"" then
		QuizTitle = oQuiz.GetName(Req("id"))
	end if
End Function


%>

<!DOCTYPE html>
<html>

<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta charset="utf-8" />

	<title>Analyse van <%=QuizTitle()%></title>
	<link rel="stylesheet" type="text/css" href="table.css" media="all">
	<link rel="stylesheet" type="text/css" href="/report/lightbox/css/jquery.lightbox-0.5.css" media="screen" />
	<link rel="stylesheet" type="text/css" href="tooltips.css" media="screen" />
	<link rel="stylesheet" type="text/css" href="report.css" media="screen" />

	<script type="text/javascript" src="/DB/jquery.min.js"></script>
	<script type="text/javascript" src="/report/toggles/js/jquery.toggles.js"></script>
	<script type="text/javascript" src="/report/table.js" ></script>
</head>
<body>
<p id="credits"><a href="http://about.me/michiel">Help<span class="tooltip"><span></span>Vragen? Email Michiel van der Blonk : pmvanderblonk@epiaruba.com</span></a></p>
<a href="/report/"><img src="logoEPI.png" width="200" alt="EPI" /></a>
<h1>Analyse van <%=QuizTitle()%></h1>
<%
Call showAnalysis()
%>

</body>
</html>
