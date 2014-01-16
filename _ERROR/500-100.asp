<%@ language="VBScript" CODEPAGE="65001" %>
<%
  Option Explicit

  Const lngMaxFormBytes = 200

  Dim objASPError, blnErrorWritten, strServername, strServerIP, strRemoteIP
  Dim strMethod, lngPos, datNow, strQueryString, strURL

  If Response.Buffer Then
    Response.Clear
    Response.Status = "500 Internal Server Error"
    Response.ContentType = "text/html"
    Response.Expires = 0
  End If

  Set objASPError = Server.GetLastError
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<HTML><HEAD><TITLE>페이지를 표시할 수 없습니다.</TITLE>
<META HTTP-EQUIV="Content-Type" Content="text/html; charset=utf-8">
<STYLE type="text/css">
  BODY { font: 9pt/12pt verdana }
  H1 { font: 13pt/15pt verdana }
  H2 { font: 8pt/12pt verdana }
  A:link { color: red }
  A:visited { color: maroon }
</STYLE>
</HEAD><BODY><TABLE width=500 border=0 cellspacing=10><TR><TD>

<h1>페이지를 표시할 수 없습니다.</h1>
연결하려는 페이지에 문제가 있어 페이지를 표시할 수 없습니다.
<hr>
<p>다음을 시도하십시오.</p>
<ul>
<li>웹 사이트 관리자에게 연락하여 이 URL 주소에서 오류가 발생했음을 알리십시오.</li>
</ul>
<h2>HTTP 500.100 - 내부 서버 오류: ASP 오류.<br>인터넷 정보 서비스</h2>
<hr>
<p>기술 정보(고객 지원 담당자용)</p>
<ul>
<li>오류 유형:<br>
<%
  Dim bakCodepage
  on error resume next
	bakCodepage = Session.Codepage
	Session.Codepage = 1252
  on error goto 0
  Response.Write Server.HTMLEncode(objASPError.Category)
  If objASPError.ASPCode > "" Then Response.Write Server.HTMLEncode(", " & objASPError.ASPCode)
    Response.Write Server.HTMLEncode(" (0x" & Hex(objASPError.Number) & ")" ) & "<br>"
  If objASPError.ASPDescription > "" Then
	Response.Write Server.HTMLEncode(objASPError.ASPDescription) & "<br>"
  elseIf (objASPError.Description > "") Then
	Response.Write Server.HTMLEncode(objASPError.Description) & "<br>"
  end if
  blnErrorWritten = False
  ' Only show the Source if it is available and the request is from the same machine as IIS
  If objASPError.Source > "" Then
    strServername = LCase(Request.ServerVariables("SERVER_NAME"))
    strServerIP = Request.ServerVariables("LOCAL_ADDR")
    strRemoteIP =  Request.ServerVariables("REMOTE_ADDR")
    If (strServerIP = strRemoteIP) And objASPError.File <> "?" Then
      Response.Write Server.HTMLEncode(objASPError.File)
      If objASPError.Line > 0 Then Response.Write ", line " & objASPError.Line
      If objASPError.Column > 0 Then Response.Write ", column " & objASPError.Column
      Response.Write "<br>"
      Response.Write "<font style=""COLOR:000000; FONT: 8pt/11pt courier new""><b>"
      Response.Write Server.HTMLEncode(objASPError.Source) & "<br>"
      If objASPError.Column > 0 Then Response.Write String((objASPError.Column - 1), "-") & "^<br>"
      Response.Write "</b></font>"
      blnErrorWritten = True
    End If
  End If
  If Not blnErrorWritten And objASPError.File <> "?" Then
    Response.Write "<b>" & Server.HTMLEncode(  objASPError.File)
    If objASPError.Line > 0 Then Response.Write Server.HTMLEncode(", line " & objASPError.Line)
    If objASPError.Column > 0 Then Response.Write ", column " & objASPError.Column
    Response.Write "</b><br>"
  End If
%>
</li>
<li>브라우저 유형:<br>
<%= Server.HTMLEncode(Request.ServerVariables("HTTP_USER_AGENT")) %>
<br><br></li>
<li>페이지:<br>
<%
  strMethod = Request.ServerVariables("REQUEST_METHOD")
  Response.Write strMethod & " "
  If strMethod = "POST" Then
    Response.Write Request.TotalBytes & " bytes to "
  End If
  Response.Write Request.ServerVariables("SCRIPT_NAME")
  Response.Write "</li>"
  If strMethod = "POST" Then
    Response.Write "<p><li>POST Data:<br>"
    ' On Error in case Request.BinaryRead was executed in the page that triggered the error.
    On Error Resume Next
    If Request.TotalBytes > lngMaxFormBytes Then
      Response.Write Server.HTMLEncode(Left(Request.Form, lngMaxFormBytes)) & " . . ."
    Else
      Response.Write Server.HTMLEncode(Request.Form)
    End If
    On Error Goto 0
    Response.Write "</li>"
  End If
%>
<br><br></li>
<li>시간:<br>
<%
  datNow = Now()
  Response.Write Server.HTMLEncode(FormatDateTime(datNow, 1) & ", " & FormatDateTime(datNow, 3))
  on error resume next
	Session.Codepage = bakCodepage
  on error goto 0
%>
<br><br></li>
<li>추가 정보:<br>
<%
  strQueryString = "prd=iis&sbp=&pver=5.0&ID=500;100&cat=" & Server.URLEncode(objASPError.Category) & "&os=&over=&hrd=&Opt1=" & Server.URLEncode(objASPError.ASPCode)  & "&Opt2=" & Server.URLEncode(objASPError.Number) & "&Opt3=" & Server.URLEncode(objASPError.Description)
  strURL = "http://www.microsoft.com/ContentRedirect.asp?" & strQueryString
%>
  <ul>
  <li>이 오류에 대한 문서의 링크를 보려면 <a href="<%= strURL %>">Microsoft 지원</a>을 클릭하십시오.</li>
  <li><a href="http://go.microsoft.com/fwlink/?linkid=8180" target="_blank">Microsoft 기술 지원 서비스</a>에서 단어 <b>HTTP</b>와 <b>500</b>으로 제목을 검색하십시오.</li>
  <li>IIS 관리자(inetmgr)에서 액세스 가능한 <b>IIS 도움말</b>을 열고 제목이 <b>웹 사이트 관리</b> 및 <b>사용자 지정 오류 메시지 정보</b>인 항목을 검색하십시오.</li>
  <li>IIS SDK(소프트웨어 개발 키트) 또는 <a href="http://go.microsoft.com/fwlink/?LinkId=8181">MSDN Online Library</a>에서 제목이 <b>Debugging ASP Scripts</b>, <b>Debugging Components</b> 및 <b>Debugging ISAPI Extensions and Filters</b>인 항목을 검색하십시오.</li>
  </ul>
</li>
</ul>

</TD></TR></TABLE></BODY></HTML>