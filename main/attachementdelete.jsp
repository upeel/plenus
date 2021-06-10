<%-- 
    Document   : attachementdelete
    Created on : Apr 9, 2014, 3:57:56 PM
    Author     : SOE HTIKE
--%>
<%@page import="com.bizmann.servlet.upload.FileAttachmentController" %>
<%
    String toclose = "";
    String struserId = request.getParameter("userId");
    if (struserId == null) {
        struserId = "0";
    }
    struserId = struserId.trim();
    if (struserId.equals("")) {
        struserId = "0";
    }
    int userId = Integer.parseInt(struserId);

    String strprocessId = request.getParameter("processId");
    if (strprocessId == null) {
        strprocessId = "0";
    }
    strprocessId = strprocessId.trim();
    if (strprocessId.equals("")) {
        strprocessId = "0";
    }
    int processId = Integer.parseInt(strprocessId);

    String strflowChartId = request.getParameter("flowChartId");
    if (strflowChartId == null) {
        strflowChartId = "0";
    }
    strflowChartId = strflowChartId.trim();
    if (strflowChartId.equals("")) {
        strflowChartId = "0";
    }
    int flowChartId = Integer.parseInt(strflowChartId);

    String stractionId = request.getParameter("actionId");
    if (stractionId == null) {
        stractionId = "0";
    }
    stractionId = stractionId.trim();
    if (stractionId.equals("")) {
        stractionId = "0";
    }
    int actionId = Integer.parseInt(stractionId);

    String fileName = request.getParameter("fileName");
    if (fileName == null) {
        fileName = "";
    }
    fileName = fileName.trim();
    if (!fileName.equals("") && userId != 0 && processId != 0) {
        new FileAttachmentController().deleteAttachement(userId, processId, fileName);
        response.sendRedirect("formaction.jsp?processId="+processId+"&flowChartId="+flowChartId+"&actionId="+actionId+"&userId="+userId);
    }
%>