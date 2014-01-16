<!--METADATA TYPE= "typelib" NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll" -->
<%
Session.CodePage  = 0
Response.CharSet  = "EUC-KR"
Response.Expires  = -1440
Response.Buffer   = False
'Response.Clear

'디비 연결 커넥션 문
Dim strconn, dbcon
//strConn = "Provider=SQLOLEDB.1;Password=toxjtoxj12!@;Persist Security Info=True;User ID=setuh;Initial Catalog=setuhGroupware;Data Source=182.162.89.75;Network Library=DBMSSOCN;"
strConn = "Provider=SQLOLEDB.1;Password=dprtltm!@#$;Persist Security Info=True;User ID=axisjDB;Initial Catalog=axisj_com;Data Source=182.162.89.75;Network Library=DBMSSOCN;"
Set dbcon = server.CreateObject("ADODB.Connection")
dbcon.open(strconn)

fileName = Request.QueryString("fileName")

if fileName = "" then
	response.end
end if

query = "select * from T_fileSystem where fileName = '"&fileName&"'"

set rs = dbcon.execute(query)
if not rs.eof then
	Response.CacheControl = "public"
	Response.ContentType = "application/unknown"
	Response.AddHeader "Content-Disposition", "attachment; filename="&replace(Rs("title"), ";", "")
	Response.AddHeader "Pragma", "no-cache"

	Set objStream = Server.CreateObject("ADODB.Stream")
	objStream.Charset = "euc-kr"
	objStream.Type = 1
	objStream.Open

	objStream.LoadFromFile server.mappath("/") & Rs("path") & Rs("fileName")
	download = objStream.Read

	Response.BinaryWrite download

	objStream.Close
	Set objstream = nothing
end if

Set Rs = nothing

dbcon.close()
set dbcon = nothing
%>