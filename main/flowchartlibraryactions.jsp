<%-- 
    Document   : flowchartlibraryactions
    Created on : Jan 27, 2014, 4:38:45 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.flowchart.controller.*"
         import = "com.bizmann.flowchart.entity.*"
         import = "java.io.*" %>
<%

    String strflowChartId = request.getParameter("flowChartId");
    if (strflowChartId == null) {
        strflowChartId = "0";
    }
    strflowChartId = strflowChartId.trim();
    if (strflowChartId.equals("")) {
        strflowChartId = "0";
    }
    int flowChartId = Integer.parseInt(strflowChartId);

    String strformId = request.getParameter("formId");
    if (strformId == null) {
        strformId = "0";
    }
    strformId = strformId.trim();
    if (strformId.equals("")) {
        strformId = "0";
    }
    int formId = Integer.parseInt(strformId);

//Get the current type and subtype
    String type = request.getParameter("type");
    if (type == null) {
        type = "";
    }
    String subtype = request.getParameter("subtype");
    if (subtype == null) {
        subtype = "";
    }
    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    FlowChartActionController fcaCtrl = new FlowChartActionController();
    EngineFlowChartController efcCtrl = new EngineFlowChartController();

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }

    if (todoaction.equals("emailnotifychange")) {
        String strActionId = request.getParameter("actionId");
        if (strActionId == null) {
            strActionId = "0";
        }
        strActionId = strActionId.trim();
        if (strActionId.equals("")) {
            strActionId = "0";
        }
        int actionId = Integer.parseInt(strActionId);

        String strDoSendEmail = request.getParameter("doSendEmail");
        if (strDoSendEmail == null) {
            strDoSendEmail = "true";
        }
        strDoSendEmail = strDoSendEmail.trim();
        if (strDoSendEmail.equals("")) {
            strDoSendEmail = "true";
        }
        if (!strDoSendEmail.equalsIgnoreCase("false")) {
            strDoSendEmail = "true";
        }
        boolean doSendEmail = Boolean.parseBoolean(strDoSendEmail);

        fcaCtrl.doUpdateEmailNotify(actionId, doSendEmail);
    }

    ArrayList engineActionList = fcaCtrl.getBPActionsByFlowChartId((flowChartId));
    EngineFlowChart engineFlowChart = efcCtrl.getEngineFlowChart((flowChartId));
%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/layout.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/menu/assets/skins/sam/menu.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />
        <script type="text/javascript" src="../include/js/url.js"></script>
        <title>bmFLO</title>
        <script>
            var action = "<%=action%>";
            var type = "<%=type%>";
            var subtype = "<%=subtype%>"
            var flowChartId = "<%=flowChartId%>";
            var formId = "<%=formId%>";
            
            function fnopensesame(vaid){
                window.open('flowchartlibraryattributes.jsp?flowChartId='+flowChartId+'&formId='+formId+'&actionId='+vaid);
            }
            
            function fnEmailNotifyChange(option){
                document.location.href="flowchartlibraryactions.jsp?todoaction=emailnotifychange&action="+action+"&type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId+"&formId="+formId+"&actionId="+option.id+"&doSendEmail="+option.value;
            }
            
            function fnopenescalation(vaid){
                document.location.href="flowchartescalation.jsp?todoaction=load&type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId+"&formId="+formId+"&actionId="+vaid;
            }
        </script>
    </head>
    <body background="../images/background.png" style="width:650px">
        <br><br>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td>
                        <table border="1" cellpadding="2px" style="text-align:left;font:80% arial,helvetica,clean,sans-serif;border-collapse:collapse;" width="95%">
                            <tr style="background:#333333; text-align:left; color:#ffffff; border:1px solid #fff; border-right:none">
                                <td colspan="6" style="font:120% arial,helvetica,clean,sans-serif"><b><%=engineFlowChart.getName()%></b></td>
                            </tr>
                            <tr style="background-color:#cccccc">
                                <td><b>Names</b></td>
                                <td><b>Participant Type</b></td>
                                <td><b>Participants</b></td>
                                <td><b>Participant Rules</b></td>
                                <td><b>Send Email Notification</b></td>
                                <td><b>Escalation Rules</b></td>
                            </tr>
                            <% for (int i = 0; i < engineActionList.size(); i++) {
                                    FlowChartAction engineAction = (FlowChartAction) engineActionList.get(i);
                            %>
                            <tr style="background-color:white">
                                <td onclick="fnopensesame(<%=engineAction.getId()%>)" style="cursor:pointer"><a href="#"><%=engineAction.getName()%></a></td>
                                <td><%=engineAction.getParticipant_type()%></td>
                                <td><%=engineAction.getParticipant_name()%></td>
                                <td>
                                    <%if (engineAction.getParticipant_rule() != null) {%>
                                    <select size="1" id="cbRule_<%=engineAction.getName()%>" name="cbRule_<%=engineAction.getName()%>" style="font:90% arial,helvetica,clean,sans-serif" disabled>
                                        <% if (engineAction.getParticipant_rule().equals("Group")) {%>
                                        <option value=""></option>
                                        <option value="Group" selected>Group</option>
                                        <option value="Individual">Individual</option>
                                        <%} else if (engineAction.getParticipant_rule().equals("Individual")) {%>
                                        <option value=""></option>
                                        <option value="Group">Group</option>
                                        <option value="Individual" selected>Individual</option>
                                        <%} else {%>
                                        <option value=""></option>
                                        <option value="Group">Group</option>
                                        <option value="Individual">Individual</option>
                                        <%}%>
                                    </select>
                                    <%}%>
                                </td>
                                <td>
                                    <%
                                        String trueSelected = "";
                                        String falseSelected = "";
                                        if (engineAction.isSend_email()) {
                                            trueSelected = "selected";
                                        } else {
                                            falseSelected = "selected";
                                        }
                                    %>
                                    <select size="1" id="<%=engineAction.getId()%>" name="<%=engineAction.getId()%>" onchange="fnEmailNotifyChange(this)" style="font:90% arial,helvetica,clean,sans-serif">
                                        <option value="true" <%=trueSelected%>>YES</option>
                                        <option value="false" <%=falseSelected%>>NO</option>
                                    </select>
                                </td>
                                <td>
                                    <% if (engineAction.isIs_start_action()) {%>
                                    &nbsp;
                                    <% } else {%>
                                    <input type="button" id="escalationBtn" name="escalationBtn" value="Setup Escalation" onclick="fnopenescalation(<%=engineAction.getId()%>)"/>
                                    <% }%>
                                </td>
                            </tr>
                            <%}%>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>
