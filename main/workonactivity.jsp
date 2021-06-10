<%-- 
    Document   : workonactivity
    Created on : Nov 11, 2009, 10:05:04 AM
    Author     : Joryn
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@page import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.resources.*"
        import = "com.bizmann.product.entity.*"
        import = "com.bizmann.external.form.controller.*" %>

<%@ include file="helper/formsessioncheck.jsp" %>
<%
    String userId = request.getParameter("userId");
    if (userId == null) {
        String loginid = (String) session.getAttribute("user");
        userId = Integer.toString(new UserController().getActiveUserIdByLoginId(loginid));
    }

    String flowChartName = request.getParameter("flowChartName");
    if (flowChartName == null) {
        flowChartName = "";
    }

    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    String processId = request.getParameter("processId");
    if (processId == null) {
        processId = "";
    } else {
        processId = processId.replaceAll("P", "");
        processId = "" + Integer.parseInt(processId);
    }

    EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();
    NewEngineController newEngineCtrl = new NewEngineController();
    EngineFormController engineFormCtrl = new EngineFormController();

    int flowChartId = engineFlowChartCtrl.getFlowChartId(flowChartName);
    int actionId = newEngineCtrl.getCurrentActionIdForWorkonActivity(flowChartId, Integer.parseInt(processId));

    String javaLocation = new ExternalFormController().isExternalForm(flowChartId, actionId);
    if (javaLocation != null && !javaLocation.equals("")) {
        response.sendRedirect("../externalform/" + javaLocation + "?processId=" + processId + "&flowChartId=" + flowChartId + "&actionId=" + actionId + "&userId=" + userId);
    } else {
        javaLocation = "formaction.jsp?processId=" + processId + "&flowChartId=" + flowChartId + "&actionId=" + actionId + "&userId=" + userId;
    }
    //String formName = engineFormCtrl.getName(actionId);
    //response.sendRedirect("formaction.jsp?processId=" + processId + "&flowChartId=" + flowChartId + "&actionId=" + actionId + "&userId=" + userId);
    //response.sendRedirect("application/" + formName + "?processId=" + Integer.parseInt(processId) + "&flowChartId=" + flowChartId + "&actionId=" + actionId + "&userId=" + userId);
%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <script>
            var processId = <%=processId%>;
            var flowChartId = <%=flowChartId%>;
            var actionId = <%=actionId%>;
            var userId = <%=userId%>;
            var location = "<%=javaLocation%>";
            function doRedirect(){
                if (!<%=newEngineCtrl.isUserCorrectAction(actionId, Integer.parseInt(userId), Integer.parseInt(processId))%>)  {
                    alert('The Current User do not have the permission to act on this form!');
                    self.close();
                    window.close();
                }else{
                    window.open(location, '_self');
                }
            }
        </script>
    </head>
    <body onload="doRedirect()">
    </body>
</html>
