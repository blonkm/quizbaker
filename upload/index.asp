<%Option Explicit%>
<!--#include virtual="/DB/config.asp"-->
<!--#include virtual="/DB/adovbs.asp"-->
<!--#include virtual="/DB/utils.asp"-->
<!--#include virtual="/DB/debug.asp"-->
<!--#include virtual="/DB/database.asp"-->
<!--#include virtual="/DB/quizdata.asp"-->
<!--#include virtual="/DB/quiz.asp"-->
<!--#include virtual="/upload/upload.asp"-->

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8" />

<title>Upload elektronische toets</title>
<link rel="stylesheet" type="text/css" href="style.css" media="all" />
<script type="text/javascript" src="/DB/jquery.min.js"></script>

<link href="uploadify/css/default.css" rel="stylesheet" type="text/css" />
<link href="uploadify/css/uploadify.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/DB/jquery.min.js"></script>
<script type="text/javascript" src="uploadify/swfobject.js"></script>
<script type="text/javascript" src="uploadify/jquery.uploadify.v2.1.4.min.js"></script>
<script type="text/javascript">

$(function() {
    $('#sending').click(function() {
        $('#uploadify').uploadifyUpload();
    });

    $("#unit,#vak").change(function() {
	    var vakField = $("#vak");
	    var unitField = $("#unit");
	    var url = 'index.asp?';
	    url += 'unit='+unitField.val();
	    url += '&vak='+vakField.val();
	    location.href = url;
    });

	$("#showNewFolder").click(function() {
        $("#newFolder").removeClass("hidden");
    });

	$("#uploadify").uploadify({
		'uploader'       : 'uploadify/uploadify.swf',
		'script'         : 'uploadify/uploader.asp?sId=<%=session.sessionID%>',
		'cancelImg'      : 'uploadify/cancel.png',
		'fileDesc'		 : 'Articulate Quiz (*.quiz)',
		'fileExt'		 : '*.quiz;',
		'folder'         : '<%=application("uploadpath")%>',
		'multi'          : true,
		onError: function (a, b, c, d) {
         if (d.status == 404)
            alert('Could not find upload script. Use a path relative to: '+'<?= getcwd() ?>');
         else if (d.type === "HTTP")
            alert('error aaa'+d.type+": "+d.status);
         else if (d.type ==="File Size")
            alert(c.name+' '+d.type+' Limit: '+Math.round(d.sizeLimit/1024)+'KB');
         else
            alert('error '+d.type+": "+d.text);
        },
		onComplete		 : function(event, queueID, fileObj, response, data) {
     							var path = escape(fileObj.filePath);
								$('#filesUploaded').append('<div class=\'uploadifyQueueItem\'>File <em>'+fileObj.name+'</em> succesfully uploaded</div>');
                                $('#quiz').val(fileObj.name);
							}
	});
});

</script>
</head>
<body>
<div id="main">
<img src="/DB/logoEPI.png" width="200" alt="EPI"/>

<h1>Upload Elektronische Toets</h1>
<%if message<>"" then%>
<div class="error"><%=message%></div>
<%end if%>

<%if uploadSuccess then%>
		<h2>Thank you for submitting this quiz:</h2>
		<%=getFormDetails()%>
<%else%>
<form method="post" action="index.asp">
<h2>Toets</h2>
	<div class="field">
		<label>Docent:</label>
		<input name="docent" id="docent" type="text" value="<%=getUser()%>" /><br/>
		<span>Gebruik inlognaam EPI</span>
	</div>
	<div class="field">
		<label>Unit:</label>
		<select name="unit" id="unit">
			<option value="">selecteer</option>
			<option value="cnt" <%=selected("unit", "cnt")%>>C&T</option>
			<option value="eco" <%=selected("unit", "eco")%>>ECO</option>
			<option value="hnt" <%=selected("unit", "hnt")%>>H&T</option>
			<option value="sns" <%=selected("unit", "sns")%>>S&S</option>
		</select>
	</div>
	<div class="field">
		<label>Vak:</label>
		<select name="vak" id="vak">
		<option value="">selecteer</option>
		<%
			Dim vakken
			set vakken = getVakken("cnt")
			for each item in vakken
			 %><option value="<%=item%>" <%=selected("vak", item)%>><%=item%></option><%
			next
		%>
		</select>
		<div id="showNewFolder" class="link">nieuw vak</div>
		<div id="newFolder" class="hidden">
			Maak nieuwe folder:
			<input name="nieuwVak" id="nieuwVak" type="text" value="" /><br/>
			<span>Gebruik offici&euml;le afkorting van het vak</span>
		</div>
	</div>
	<div class="field">
		<label>Soort toets:</label>
		<select name="soort" id="soort">
			<option value="">selecteer</option>
			<option value="CP" <%=selected("soort", "CP")%>>CP</option>
			<option value="Herkansing" <%=selected("soort", "Herkansing")%>>Herkansing</option>
			<option value="Oefentoets" <%=selected("soort", "Oefentoets")%>>Oefentoets</option>
			<option value="Anders" <%=selected("soort", "Anders")%>>Anders</option>
		</select>
	</div>

    <h2>Uploaden quiz file</h2>
    <div class="field" id="uploadBox">
        <p><input class="text-input" name="uploadify" id="uploadify" type="file" size="20" /></p>
        <div id="filesUploaded"></div>

        <div id="sending" name="sending">Upload</div>
        <p><em>Bestanden worden geplaatst in de folder \\epiweb\wwwroot\cp\upload\quiz</em></p>
    </div>


<h2>Studenten</h2>
    <div class="field">
		<label>Klas(sen):</label>
		<input name="klas" id="klas" type="text" value="" /><br/>
		<span>Bijv. 1A1,1A2,1A3</span>
	</div>
	<div class="field">
		<label>Aantal studenten:</label>
		<input name="studenten" id="studenten" type="number" min="1" max="400" step="1" value="" /><br/>
		<span>Geef maximaal aantal studenten aan</span>
	</div>

<h2>Afname</h2>
	<div class="field">
		<label>Startdatum:</label>
		<input name="datum" id="datum" type="date" value="" min="<%=FormatDate("yyyy-MM-dd", Date()+7)%>" /><br/>
		<span>Geef de eerste dag waarop de toets wordt afgenomen.<br/>Minimaal 1 week (5 werkdagen) van tevoren</span>
	</div>

	<div class="field">
		<label>Starttijd:</label>
		<input name="startTijd" id="startTijd" type="time" value="" /><br/>
		<span>Bijv. 9:00 AM</span>
	</div>

	<div class="field">
		<label>Lengte:</label>
		<input name="lengte" id="lengte" type="number" min="15" max="180" step="15" value="" /><br/>
		<span>Lengte in minuten, bijv. 120 minuten</span>
	</div>

	<div class="field">
		<label>Surveillant(en):</label>
		<input name="surv" id="surv" type="text" value="" /><br/>
		<span>Bijv. AB,CD,EF (niet verplicht)</span>
	</div>

    <h2>Opmerkingen</h2>
	<div class="field">
		<label>Opmerkingen:</label>
		<div><textarea name="opmerkingen" id="opmerkingen" cols="40" rows="8"></textarea></div>
		<span>Noteer hier vragen of opmerkingen voor de beheerders</span>
	</div>

    <input type="hidden" name="quiz" id="quiz" />
    <input type="submit" id="action" name="action" />

</form>
<%end if%>
</div>
</body>
</html>
