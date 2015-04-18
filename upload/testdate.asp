<%Option Explicit%>

<!DOCTYPE html>
<html>
<body>
<div id="main">
<%
Public Function FormatDate( sFormat, dDateValue )
    Dim oStringBuilder
    Dim sSbFormatString
    Dim dDate

    If Not IsDate( dDateValue ) Then
        FormatDate = vbNullString
        Exit Function
    End If

    On Error Resume Next

    dDate = CDate(dDateValue)
    If Err.number <> 0 Then
        FormatDate = vbNullString
        Exit Function
    End If

    If Len(sFormat & vbNullString) = 0 Then
        sSbFormatString = "{0:d}"
    Else
        sSbFormatString = "{0:" & sFormat & "}"
    End If

    Set oStringBuilder = CreateObject("System.Text.StringBuilder")
    Call oStringBuilder.AppendFormat(sSbFormatString, dDate)
    FormatDate = oStringBuilder.ToString()
    Set oStringBuilder = Nothing
End Function

Response.Write FormatDate("yyyy-MM-dd", Date())
dim s

s = "2012-12-11 14:20:00.000"
Response.Write Date()-1
Response.Write Datevalue(left(s, len(s)-4))
%>
</div>
</body>
</html>
