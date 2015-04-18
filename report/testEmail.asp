<%

Sub sendmail()
	Dim iMsg
	Dim iConf
	Dim cfg

	Set iMsg = CreateObject("CDO.Message")
	Set iConf = CreateObject("CDO.Configuration")
	cfg = "http://schemas.microsoft.com/cdo/configuration/"

	iConf.Load -1 ' CDO Source Defaults
	Set Flds = iConf.Fields

	Flds.Item(cfg&"smtpusessl") = True
	Flds.Item(cfg&"sendusing") = 2 ' using port
	Flds.Item(cfg&"smtpserver") = "smtp.gmail.com"
	Flds.Item(cfg&"sendusername") = "ColegioEPI@gmail.com"
	Flds.Item(cfg&"sendpassword") = "michelline"
	Flds.Item(cfg&"smtpauthenticate") = 1
	Flds.Item(cfg&"smtpserverport") = 465
	Flds.Update


	With iMsg
		Set .Configuration = iConf
		.To = "pmvanderblonk@epiaruba.com"
		.CC = ""
		.BCC = ""
		.From = "Colegio EPI <ColegioEPI@gmail.com>"
		.Subject = "Test email sent from EPI"
		.TextBody = "This is a test email sent using hotmail"
		.AddAttachment "C:\inetpub\wwwroot\cp\students\output\t07-0029.html"
		.Send
	End With
End Sub

sendmail

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US">

<head profile="http://gmpg.org/xfn/11">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<title>Resultaten</title>
<link rel="stylesheet" type="text/css" href="/report/lightbox/css/jquery.lightbox-0.5.css" media="screen" />
<link rel="stylesheet" type="text/css" href="tooltips.css" media="screen" />
<link rel="stylesheet" type="text/css" href="report.css" media="screen" />
</head>
<body>
<h1>Mail sent</h1>
</body>
</html>