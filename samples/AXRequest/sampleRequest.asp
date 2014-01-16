<%@ language="javascript" CODEPAGE="65001" %>
<%
Session.CodePage  = 65001;
Response.CharSet  = "UTF-8";
Response.AddHeader("Pragma","no-cache");
Response.AddHeader("cache-control", "no-staff");
Response.Expires  = -1;
%>

<!--#include virtual="/_AXASP/AXJ.asp"-->

<style type="text/css" >
	html{font:malgun gothic;font-size:12px;}
</style>

<%

var AXReqTest = myAXReq.requestsObj;
var result1 = "";
var result = myAXReq.requestsObj("post", "nm", "text");
result1 = myAXReq.requestsObj("post", "sex", "text");

println("var result = AXReq(\"post\", \"nm\", \"text\");");
println(result);
println(result1);

println("<hr/>");
println("<b>AXReq</b><br/>");
//var formData = AXReq.requestsObj("post");
var formData = AXReq("post");
println("var formData = AXReq(\"post\");");
print("formData = ");
println(formData);

println("");

var formData2 = AXReq("get");
println("var formData = AXReq(\"get\");");
print("formData = ");
println(formData2);

println("");

var formData3 = AXReq();
println("var formData = AXReq();");
print("formData = ");
println(formData3);

println("<hr/>");
println("<b>AXReqsToArray</b><br/>");
var formData4 = AXReqToArray("post");
println("var formData = AXReqToArray(\"post\");");
print("formData = ");
println(formData4);

println("");

var formData5 = AXReqToArray("get");
println("var formData = AXReqToArray(\"get\");");
print("formData = ");
println(formData5);

println("");

var formData6 = AXReqToArray();
println("var formData = AXReqToArray();");
print("formData = ");
println(formData6);

println("");

var formData7 = AXReqRC("post", "ta", "text");
println("var formData = AXReqRC(\"post\", \"content\", \"text\");");
print("formData = ");
println(formData7);

%>