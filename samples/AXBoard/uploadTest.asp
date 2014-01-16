<%@ language="javascript" CODEPAGE="65001" %>
<%
Session.CodePage  = 65001;
Response.CharSet  = "UTF-8";
Response.AddHeader("Pragma","no-cache");
Response.AddHeader("cache-control", "no-staff");
Response.Expires  = -1;
%>

<form name="ffrom" id="fform" method="post" action="proc/uploadFile.asp" enctype="multipart/form-data">
  <input type="file" name="file1" /><br/>
  <input type="file" name="file2" /><br/>
  <input type="file" name="file3" /><br/>
  <input type="submit">
</form>