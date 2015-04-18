<%
' classes: options, score and response
 
Class QuizOptions
	Public showUserScore
	Public showPassingScore
	Public showShowPassFail
	Public showQuizReview
	Public result
	Public username
	
	Function toString()
		Dim out
		
		out = ""
		out = out & "showUserScore: " & showUserScore & "<br/>"
		out = out & "showPassingScore:" & showPassingScore & "<br/>"
		out = out & "showShowPassFail:" & showShowPassFail & "<br/>"
		out = out & "showQuizReview:" & showQuizReview & "<br/>"
		out = out & "result: " & result & "<br/>"
		out = out & "username:" & username & "<br/>"
		toString = out
	End Function
End Class

Class QuizScore
	Public result
	Public score
	Public passingScore
	Public minScore
	Public maxScore
	Public ptScore
	Public ptMax

	Function toString()
		Dim out
		
		out = ""
		out = out & "result: " & result & "<br/>"
		out = out & "score:" & score & "<br/>"
		out = out & "passingScore:" & passingScore & "<br/>"
		out = out & "minScore:" & minScore & "<br/>"
		out = out & "maxScore: " & maxScore & "<br/>"
		out = out & "ptScore:" & ptScore & "<br/>"
		out = out & "ptMax:" & ptMax & "<br/>"
		toString = out
	End Function
End Class

Class QuizResponse
	Public questionNum
	Public question
	Public correctResponse
	Public studentResponse
	Public result
	Public points
	Public found
	Public interactionId
	Public objectiveId
	Public questionType
	Public latency
	
	Function toString()
		Dim out
		
		out = ""
		out = out & "questionNum: " & questionNum & "<br/>"
		out = out & "question:" & question & "<br/>"
		out = out & "correctResponse:" & correctResponse & "<br/>"
		out = out & "studentResponse:" & studentResponse & "<br/>"
		out = out & "result: " & result & "<br/>"
		out = out & "points:" & points & "<br/>"
		out = out & "found:" & found & "<br/>"
		out = out & "interactionId:" & interactionId & "<br/>"
		out = out & "objectiveId:" & objectiveId & "<br/>"
		out = out & "questionType:" & questionType & "<br/>"
		out = out & "latency:" & latency & "<br/>"
		toString = out
	End Function	
End Class
%>