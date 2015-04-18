<!-- #include file="uploaderCLS.asp" -->
<%
'security
on error resume next
if application("sessionID")<>request.querystring("sId") then response.end
if application("sessionID")="" then response.end
if request.querystring("sId")="" then response.end
if err.number<>0 then response.end 
on error goto 0

dim UploadiFyPath,UploadiFyFolder,UploadifyObject

UploadiFyPath = Request.ServerVariables("PATH_TRANSLATED")
UploadiFyPath = Replace(UploadiFyPath,"uploader214.asp","",1,-1,1)

UploadiFyFolder=application("uploadpath")

Set UploadifyObject = New FreeASPUpload
UploadifyObject.Save(Server.MapPath(UploadiFyFolder))

Response.Write("<HTML><HEAD></HEAD><BODY></BODY></HTML>")

%>