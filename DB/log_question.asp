<%Option Explicit%>
<!--#include virtual="/DB/config.asp"-->
<!--#include virtual="/DB/adovbs.asp"-->
<!--#include virtual="/DB/utils.asp"-->
<!--#include virtual="/DB/debug.asp"-->
<!--#include virtual="/DB/database.asp"-->
<!--#include virtual="/DB/quizdata.asp"-->
<!--#include virtual="/DB/quiz.asp"-->
<%
Application("QuestionCount") = Application("QuestionCount")+1

Dim oQuiz

Set oQuiz = new Quiz
oQuiz.CreateAudit
%>
<html>
<body>
<p>Data was logged for <%=oQuiz.options.username%></p>
</body>
</html>
