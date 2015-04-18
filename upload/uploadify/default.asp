<%
'This sample demonstrates how to use Uploadify in Classic ASP/VBScript

dim secure
secure=false 'needs to be true - do NOT set to true without additional security checks!

if not secure then
%>
<font color=Red><p>Important security note:</p><p>By default this script does not perform any upload. The value "secure" in default.asp needs to be set to true. It is false by default.</p></font>
<%
response.end
end if


application("sessionID")=Session.SessionID
application("uploadpath")="userfiles"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Uploadify Form</title>
<link href="uploadify214/css/default.css" rel="stylesheet" type="text/css" />
<link href="uploadify214/css/uploadify.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.min.js"></script>
<script type="text/javascript" src="uploadify214/swfobject.js"></script>
<script type="text/javascript" src="uploadify214/jquery.uploadify.js"></script>
<script type="text/javascript">
function Send_document()
{
	$('#uploadify').uploadifyUpload();
}
</script>

<script type="text/javascript">
$(document).ready(function() {
	$("#uploadify").uploadify({
		'uploader'       : 'uploadify214/uploadify.swf',
		'script'         : 'uploader214.asp?sId=<%=session.sessionID%>',
		'cancelImg'      : 'uploadify214/cancel.png',
		'fileDesc'		 : 'JPG (*.jpg), JPEG (*.jpeg), JPE (*.jpe), JP2 (*.jp2), JFIF (*.jfif), GIF (*.gif), BMP (*.bmp), PNG (*.png), PSD (*.psd), EPS (*.eps), ICO (*.ico), TIF (*.tif), TIFF (*.tiff), AI (*.ai), RAW (*.raw), TGA (*.tga), MNG (*.mng), SVG (*.svg), DOC (*.doc), RTF (*.rtf), TXT (*.txt), WPD (*.wpd), WPS (*.wps), CSV (*.csv), XML (*.xml), XSD (*.xsd), SQL (*.sql), PDF (*.pdf), XLS (*.xls), MDB (*.mdb), PPT (*.ppt), DOCX (*.docx), XLSX (*.xlsx), PPTX (*.pptx), PPSX (*.ppsx), ARTX (*.artx), MP3 (*.mp3), WMA (*.wma), MID (*.mid), MIDI (*.midi), MP4 (*.mp4), MPG (*.mpg), MPEG (*.mpeg), WAV (*.wav), RAM (*.ram), RA (*.ra), AVI (*.avi), MOV (*.mov), FLV (*.flv), M4A (*.m4a), M4V (*.m4v), HTM (*.htm), HTML (*.html), CSS (*.css), SWF (*.swf), JS (*.js), RAR (*.rar), ZIP (*.zip), TAR (*.tar), GZ (*.gz)',
		'fileExt'		 : '*.jpg;*.jpeg;*.jpe;*.jp2;*.jfif;*.gif;*.bmp;*.png;*.psd;*.eps;*.ico;*.tif;*.tiff;*.ai;*.raw;*.tga;*.mng;*.svg;*.doc;*.rtf;*.txt;*.wpd;*.wps;*.csv;*.xml;*.xsd;*.sql;*.pdf;*.xls;*.mdb;*.ppt;*.docx;*.xlsx;*.pptx;*.ppsx;*.artx;*.mp3;*.wma;*.mid;*.midi;*.mp4;*.mpg;*.mpeg;*.wav;*.ram;*.ra;*.avi;*.mov;*.flv;*.m4a;*.m4v;*.htm;*.html;*.css;*.swf;*.js;*.rar;*.zip;*.tar;*.gz',
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
								$('#filesUploaded').append('<div class=\'uploadifyQueueItem\'><a href='+path+' target=\'_blank\'>'+fileObj.name+'</a></div>');
							}
	});
});
</script>
</head>
<body>
<form id="formIDdoc" name="formIDdoc" class="form" method="post" action="default.asp">
 <p><font color=Red>DO NOT PUT THIS SCRIPT ON A LIFE SERVER, UNLESS YOU'RE SURE IT'S SAFE DOING SO!!!!</font></p>
<p>Select one or more files, next click '<b>Upload files</b>'</p>
<p>By default, files will be uploaded to the "userfiles" folder. In case you need to change that, make sure to change the variable <b>application("uploadpath")</b> to whatever folder you want.</p>
<p id="sending" name="sending"><a href="javascript:Send_document()"><b>Upload files</b></a></p>
<p><input class="text-input" name="uploadify" id="uploadify" type="file" size="20" /></p>
<div id="filesUploaded"></div>
</form>
</body>
</html>
