<%
Class Quiz
	Public quizId
	Public summaryId
	Public quizData
	Public title
	Public options
	Public score
	Public responses

	Sub save()
		loadQuizData
		createQuiz
		createSummary
		CreateDetails
'		ExportDetails
	End Sub

	Sub loadQuizData()
		Dim n
		Dim qr
		Dim prefix
		Dim postfix

		Set options = New QuizOptions
		options.showUserScore = Req("quiz[oOptions][bShowUserScore]")
		options.showPassingScore = Req("quiz[oOptions][bShowPassingScore]")
		options.showShowPassFail = Req("quiz[oOptions][bShowShowPassFail]")
		options.showQuizReview = Req("quiz[oOptions][bShowQuizReview]")
		options.result = Req("quiz[oOptions][strResult]")
		' if the network user is known, use that name
		options.username = Request.ServerVariables("LOGON_USER")
		' otherwise, use the name given at the end of the test
		If options.username = "" Then
			options.username = Req("quiz[oOptions][strName]")
		End If
		' otherwise, use the session ID as an identifying name
		' in this case, the student cannot be tracked!
		If options.username = "" Then
			options.username = "Session-" & Session.SessionID
		End If

		Set score = New QuizScore
		score.result = Req("quiz[strResult]")
		score.score = Req("quiz[strScore]")
		score.passingScore = Req("quiz[strPassingScore]")
		score.minScore = Req("quiz[strMinScore]")
		score.maxScore = Req("quiz[strMaxScore]")
		score.ptScore = Req("quiz[strPtScore]")
		score.ptMax = Req("quiz[strPtMax]")

		Set responses = server.CreateObject("Scripting.Dictionary")
		n = 0
		Do While ExistsResponse(n)
			Set qr = New QuizResponse
			prefix = "responses" & "[" & n & "]["
			postfix = "]"
			qr.questionNum = Req(prefix & "nQuestionNum" & postfix)
			qr.question = Req(prefix & "strQuestion" & postfix)
			qr.correctResponse = Req(prefix & "strCorrectResponse" & postfix)
			qr.studentResponse = Req(prefix & "strStudentResponse" & postfix)
			qr.result = Req(prefix & "strResult" & postfix)
			qr.points = Req(prefix & "nPoints" & postfix)
			qr.found = Req(prefix & "bFound" & postfix)
			qr.interactionId = Req(prefix & "strInteractionId" & postfix)
			qr.objectiveId = Req(prefix & "strObjectiveId" & postfix)
			qr.questionType = Req(prefix & "strType" & postfix)
			qr.latency = Req(prefix & "strLatency" & postfix)
			responses.Add "response" & n, qr
			n = n + 1
		Loop

	End Sub

	Function ExistsResponse(n)
		If Req("responses" & "[" & n & "][nQuestionNum]") <> "" Then
			ExistsResponse = True
		Else
			ExistsResponse = False
		End If
	End Function

	Function createQuiz()
		Dim p
		Dim db
		Dim rs
		Dim name

		Set db = getDB()

		' create quiz record
		name = Req("quiz[strTitle]")
		quizId = getQuiz(name)
		If quizId < 0 Then
			Set rs = db.getRs("SELECT * FROM quiz WHERE id = -1", adOpenKeyset, adLockOptimistic)
			If rs.EOF Then
				rs.addNew
			End If
			rs("quizname") = name
			rs.Update
			quizId = rs("id")
			rs.Close
			db.CloseConn
		End If
		createQuiz = quizId
	End Function

	' if quiz already exists, find its id
	Function getQuiz(name)
		Dim sql
		Dim db
		Dim rs

		Set db = getDB()

		sql = "SELECT * FROM quiz WHERE quizname='@name'"
		sql = Replace(sql, "@name", clean(name))
		Set rs = db.getRsReadOnly(sql)
		If rs.EOF Then
			getQuiz = -1
		Else
			getQuiz = rs("id")
		End If
		rs.Close
		db.CloseConn
	End Function

	' create user record with summary of results
	Sub createSummary()
		Dim db
		Dim username
		Dim userId
		Dim rs

		Set db = getDB()

		username = options.username
		userId = getSummaryId(quizId, username)
		If userId < 0 Then
			Set rs = db.getRs("SELECT * FROM quiz_summary WHERE id=-1", adOpenKeyset, adLockOptimistic)
			If rs.EOF Then
				rs.addNew
				rs.Update
			End If
			updateSummary rs("id"), username
			rs.Close
			db.CloseConn
		Else
			summaryId = userId
		End If
	End Sub

	Sub updateSummary(id, username)
		Dim db
		Dim rs
		Set db = getDB()

		Set rs = db.getRs("SELECT * FROM quiz_summary WHERE id=" & Clng(id), adOpenKeyset, adLockOptimistic)
		rs("quiz_id") = quizId
		rs("lastmodified") = Now()
		rs("network_id") = options.username
		rs("status") = score.result
		rs("raw_score") = score.score
		rs("passing_score") = score.passingScore
		rs("max_score") = score.maxScore
		rs("min_score") = score.minScore
		rs("time") = Now()

	REM get current student klas
	Dim sql
	Dim rsStudent
	Dim klas
	Dim studentId
	studentId = replace(options.username, "COLEGIO-EPI\", "")

	klas = ""
	sql = "SELECT Klas FROM Students WHERE Nummer = " & sq(studentId)
	set rsStudent = db.getRsReadOnly(sql)
	if not rsStudent.eof then
		klas = nvl(rsStudent("klas"))
	end if
	rsStudent.close

	rs("klas") = klas
		rs.Update
		summaryId = rs("id")
		rs.Close
		db.CloseConn
	End Sub

	' if user already exists, find id
	Function getSummaryId(quizId, username)
		Dim db
		Dim sql
		Dim rs

		assert username <> "", "username not set"
		assert quizId <> 0, "quizId not set"

		Set db = getDB()

		sql = "SELECT * FROM quiz_summary WHERE network_id='@username' AND quiz_id=@quizId"
		sql = Replace(sql, "@quizId", quizId)
		sql = Replace(sql, "@username", username)

		Set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
		If rs.EOF Then
			getSummaryId = -1
		Else
			getSummaryId = rs("id")
		End If
		rs.Close
		db.CloseConn
	End Function

	Function CountDetails()
		Dim db
		Dim sql
		Dim rs

		assert quizId <> 0, "quizId not set"
		assert summaryId > 0, "summaryId not set"

		Set db = getDB()

		sql = "SELECT COUNT(*) num FROM quiz_detail WHERE summary_id=@summaryId"
		sql = Replace(sql, "@summaryId", summaryId)

		Set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
		CountDetails = 0
		If Not rs.EOF Then
			CountDetails = Int(rs("num"))
		End If
		rs.Close
		db.CloseConn
	End Function

	' create result records
	Sub CreateDetails()
		Dim line
		Dim key
		Dim db
		Dim rs
		Dim num

		assert quizId <> 0, "quizId not set"
		assert summaryId > 0, "summaryId not set"

		Set db = getDB()

		' check if details already saved
		num = CountDetails
		If CountDetails > 0 Then
			Exit Sub
		End If

		' save results
		Set rs = db.getRs("SELECT * FROM quiz_detail WHERE id=-1", adOpenKeyset, adLockOptimistic)
		For Each key In responses
			Set line = responses(key)
			rs.addNew
			rs("summary_id") = summaryId
			rs("lastmodified") = Now()
			rs("timestamp") = Now()
			rs("score") = line.points
			rs("question") = line.question
			rs("interaction_id") = line.interactionId
			rs("objective_id") = line.objectiveId
			rs("interaction_type") = line.questionType
			rs("student_response") = line.studentResponse
			rs("result") = line.result
			rs("weight") = 1
			rs("latency") = line.latency
			rs.Update
		Next
	End Sub

	Sub ExportDetails()
		Dim line
		Dim key
		Dim db
		Dim rs
		Dim num

		assert quizId <> 0, "quizId not set"

		Set db = getDB()

		' show results
		Set rs = db.getRs("SELECT * FROM quiz_summary S, quiz_detail D WHERE S.id = D.summary_id AND S.quiz_id = " & quizId, adOpenForwardOnly, adLockReadOnly)
		print "id,student,question,response,result,score,type" & vbNewline
		Do until rs.eof
			print quizId & ","
			print q(rs("network_id")) & ","
			print q(rs("timestamp")) & ","
			print q(rs("question")) & ","
			print q(rs("student_response")) & ","
			print q(rs("result")) & ","
			print q(rs("score")) & ","
			print q(rs("interaction_type"))
			print vbNewline
			rs.MoveNext
		Loop
	End Sub

	Function GetName(id)
		Dim sql
		Dim rs
		Dim db

		Set db = getDB()
		' get quiz name
		sql = "SELECT * FROM Quiz "
		sql = sql & "WHERE ID=" & id & " "
		set rs = db.getRs(sql, adOpenForwardOnly, adLockReadOnly)
		GetName = rs("quizname")
	End Function

	Function getDB()
		Dim db
		Set db = New Database
		db.dbname = config.dbname
		db.appName = "QuizMakerDatabase"
		db.serverName = config.dbserver
		'db.OpenConn
		Set getDB = db
	End Function


End Class
%>