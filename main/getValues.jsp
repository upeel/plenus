<%-- 
    Document   : getValues
    Created on : Oct 19, 2013, 4:05:24 PM
    Author     : Veronica
--%>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.gen.controller.*"
         import = "com.bizmann.gen.entity.*"
         %>
<%
    String genId = request.getParameter("genId");
    if (genId == null) {
        genId = "0";
    }

    String mode = request.getParameter("mode");
    if (mode == null) {
        mode = "";
    }

    GenController gCtrl = new GenController();
    if (mode.equals("gen")) {
        GenHeader gHeader = gCtrl.getGenById(Integer.parseInt(genId));
%>
[{"txtGenName":"<%=gHeader.getGen_name()%>","txtGenDigit":"<%=gHeader.getDigit()%>","txtGenStart":"<%=gHeader.getStart_no()%>"}]
<%}%>