<%-- 
    Document   : flowchartescalation
    Created on : Apr 25, 2014, 12:18:58 PM
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
         import = "com.bizmann.escalation.controller.*"
         import = "com.bizmann.escalation.entity.*"
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

    String stractionId = request.getParameter("actionId");
    if (stractionId == null) {
        stractionId = "0";
    }
    stractionId = stractionId.trim();
    if (stractionId.equals("")) {
        stractionId = "0";
    }
    int actionId = Integer.parseInt(stractionId);

    String type = request.getParameter("type");
    if (type == null) {
        type = "";
    }
    String subtype = request.getParameter("subtype");
    if (subtype == null) {
        subtype = "";
    }
    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }

    ArrayList userList = new ArrayList();
    ArrayList orgUnitList = new ArrayList();
    ArrayList desList = new ArrayList();

    UserController userCtrl = new UserController();
    OrgUnitController orgUnitCtrl = new OrgUnitController();
    DesignationController desCtrl = new DesignationController();

    userList = userCtrl.getAllUserName();
    orgUnitList = orgUnitCtrl.getAllOrgUnits();
    desList = desCtrl.getAllDesignation();

    ActionController actCtrl = new ActionController();
    String actionName = actCtrl.getActionNameById(actionId);
    EscalationController escCtrl = new EscalationController();

    if (todoaction.equalsIgnoreCase("addNew")) {
        String participantType = request.getParameter("participantType");
        if (participantType == null) {
            participantType = "";
        }

        String strcbParticipant = request.getParameter("cbParticipant");
        if (strcbParticipant == null) {
            strcbParticipant = "0";
        }
        strcbParticipant = strcbParticipant.trim();
        if (strcbParticipant.equals("")) {
            strcbParticipant = "0";
        }
        int cbParticipant = Integer.parseInt(strcbParticipant);

        String txtDay = request.getParameter("txtDay");
        if (txtDay == null) {
            txtDay = "0";
        }
        txtDay = txtDay.trim();
        if (txtDay.equals("")) {
            txtDay = "0";
        }
        int day = Integer.parseInt(txtDay);

        String txtHour = request.getParameter("txtHour");
        if (txtHour == null) {
            txtHour = "0";
        }
        txtHour = txtHour.trim();
        if (txtHour.equals("")) {
            txtHour = "0";
        }
        int hour = Integer.parseInt(txtHour);

        String txtMinute = request.getParameter("txtMinute");
        if (txtMinute == null) {
            txtMinute = "0";
        }
        txtMinute = txtMinute.trim();
        if (txtMinute.equals("")) {
            txtMinute = "0";
        }
        int minute = Integer.parseInt(txtMinute);

        String notifyOwner = request.getParameter("notifyOwner");
        if (notifyOwner == null) {
            notifyOwner = "true";
        }
        notifyOwner = notifyOwner.trim();
        if (notifyOwner.equals("")) {
            notifyOwner = "true";
        }
        if (!notifyOwner.equalsIgnoreCase("false")) {
            notifyOwner = "true";
        }
        boolean doNotifyOwner = Boolean.parseBoolean(notifyOwner);

        String notifyEscalated = request.getParameter("notifyEscalated");
        if (notifyEscalated == null) {
            notifyEscalated = "true";
        }
        notifyEscalated = notifyEscalated.trim();
        if (notifyEscalated.equals("")) {
            notifyEscalated = "true";
        }
        if (!notifyEscalated.equalsIgnoreCase("false")) {
            notifyEscalated = "true";
        }
        boolean doNotifyEscalated = Boolean.parseBoolean(notifyEscalated);

        String additionalEmailArea = request.getParameter("additionalEmailArea");
        if (additionalEmailArea == null) {
            additionalEmailArea = "";
        }
        /*
        System.out.println("actionId : " + actionId);
        System.out.println("flowChartId : " + flowChartId);
        System.out.println("cbParticipant : " + cbParticipant);
        System.out.println("participantType : " + participantType);
        System.out.println("hour : " + hour);
        System.out.println("doNotifyOwner : " + doNotifyOwner);
        System.out.println("doNotifyEscalated : " + doNotifyEscalated);
        System.out.println("additionalEmailArea : " + additionalEmailArea);
        * */
        escCtrl.insertNewEscalation(actionId, flowChartId, cbParticipant, participantType, hour, doNotifyOwner, doNotifyEscalated, additionalEmailArea);

        response.sendRedirect("flowchartescalation.jsp?flowChartId=" + flowChartId + "&actionId=" + actionId + "&type=" + type + "&subtype=" + subtype);
    }

    ArrayList<Escalation> escalationList = escCtrl.getAllEscalationByActionByFlowchart(actionId, flowChartId);
    String eIdList = "";
    StringBuffer eIdSbf = new StringBuffer();
    for (int a = 0; a < escalationList.size(); a++) {
        Escalation tmpe = (Escalation) escalationList.get(a);
        int tmpeId = tmpe.getId();
        eIdSbf.append(tmpeId + ",");
    }
    eIdList = eIdSbf.toString();
    if (eIdList.equals("")) {
    } else {
        eIdList = eIdList.substring(0, eIdList.length() - 1);
    }

    if (todoaction.equalsIgnoreCase("reorder")) {
        String escalationIds = request.getParameter("escalationIds");
        if (escalationIds == null) {
            escalationIds = "";
        }

        String new_position = request.getParameter("new_position");
        if (new_position == null) {
            new_position = "";
        }
        if (!escalationIds.equals("") && !new_position.equals("")) {
            String[] arr_new_position = new_position.split(",");
            String[] arr_escalationIds = escalationIds.split(",");

            if (arr_new_position.length == arr_escalationIds.length) {
                escCtrl.doReOrder(arr_new_position, arr_escalationIds);
                response.sendRedirect("flowchartescalation.jsp?flowChartId=" + flowChartId + "&actionId=" + actionId + "&type=" + type + "&subtype=" + subtype);
            }
        }
    }
    
    if(todoaction.equalsIgnoreCase("delete")){
        String strdelId = request.getParameter("delId");
        if(strdelId == null){
            strdelId = "0";
        }
        strdelId = strdelId.trim();
        if(strdelId.equals("")){
            strdelId = "0";
        }
        
        int delId = Integer.parseInt(strdelId);
        if(delId > 0){
            escCtrl.doDelete(actionId, flowChartId, delId);
            response.sendRedirect("flowchartescalation.jsp?flowChartId=" + flowChartId + "&actionId=" + actionId + "&type=" + type + "&subtype=" + subtype);
        }
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/js/url.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <script src="../include/time/jquery.timeentry.js"></script>
        <script type="text/javascript" src="../include/js/jquery.validationEngine-en.js" charset="utf-8"></script>
        <script type="text/javascript" src="../include/js/jquery.validationEngine.js"></script>
        <script type="text/javascript" src="../include/js/jquery.signaturepad.min.js"></script>
        <script type="text/javascript" src="include/js/autosaveform.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/css/jquery.signaturepad.css"/>
        <link rel="stylesheet" type="text/css" href="../include/css/validationEngine.jquery.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/time/jquery.timeentry.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />

        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/layout.css" />
        <script type="text/javascript" src="../include/js/url.js"></script>
        <title>bmFLO</title>
        <style>
            input[type="number"] {
                width:50px;
            }
        </style>
        <script>
            var type = "<%=type%>";
            var subtype = "<%=subtype%>"
            var flowChartId = "<%=flowChartId%>";
            var actionId = "<%=actionId%>";
            
            var old_position;
            var new_position;
            function delBtnClicked(escId){
                document.location.href = "flowchartescalation.jsp?flowChartId="+flowChartId+"&actionId="+actionId+"&todoaction=delete&delId="+escId;
            }
            
            function fndoreorder(){
                var veIdList = "<%=eIdList%>";
                document.location.href = "flowchartescalation.jsp?flowChartId="+flowChartId+"&actionId="+actionId+"&todoaction=reorder&new_position="+fnURLEncode(new_position)+"&escalationIds="+fnURLEncode(veIdList);
            }
            
            function fnAddNewBtnClicked(){
                document.frmEscalation.submit();
            }
            
            $(document).ready(function (){
                $('.sort').sortable({
                    create: function( event, ui ) {
                        new_position = $(this).sortable('toArray');
                    },
                    start: function(e, ui) {
                        old_position = $(this).sortable('toArray');
                    },
                    update: function(e, ui) {
                        new_position = $(this).sortable('toArray');
                    },
                    stop: function(event, ui) { new_position = $(this).sortable('toArray'); }
                });
            });
            
            function fnpopulateParticipant(selected){
                document.getElementById("cbParticipant").options.length=0;
                if(selected  == 'User'){
            <%
                for (int a = 0; a < userList.size(); a++) {
                    User tmpuser = (User) userList.get(a);
                    int id = tmpuser.getUserId();
                    String name = tmpuser.getFullName();
            %>
                        document.getElementById("cbParticipant").options[<%=a%>]=new Option("<%=name%>", "<%=id%>");
            <% }%>
                    }else if(selected  == 'OrgUnit'){
            <%
                for (int a = 0; a < orgUnitList.size(); a++) {
                    OrgUnit tmporgunit = (OrgUnit) orgUnitList.get(a);
                    int id = tmporgunit.getId();
                    String name = tmporgunit.getName();

            %>
                        document.getElementById("cbParticipant").options[<%=a%>]=new Option("<%=name%>", "<%=id%>");
            <% }%>
                    }else if(selected  == 'Designation'){
            <%
                for (int a = 0; a < desList.size(); a++) {
                    Designation tmpdesignation = (Designation) desList.get(a);
                    int id = tmpdesignation.getDesignationId();
                    String name = tmpdesignation.getName();
            %>
                        document.getElementById("cbParticipant").options[<%=a%>]=new Option("<%=name%>", "<%=id%>");
            <% }%>
                    }
                }
        </script>
    </head>
    <body background="../images/background.png" style="width:650px">
        <br><br>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td>
                        Escalation Rules for "<%=actionName%>"
                    </td>
                </tr>
                <tr>
                    <td>
                        <form id="frmEscalation" name="frmEscalation" action="flowchartescalation.jsp" method="POST">
                            <table border="1" width="100%"  cellpadding="3" style="border-collapse:collapse; table-layout: fixed"  bordercolor="#C0C0C0">
                                <tr style="background:#333333; text-align:left; color:#ffffff; border:1px solid #fff; border-right:none">
                                    <td align="left" width="130px"><label>Participant Type</label></td>
                                    <td align="left" width="150px"><label>Assign To</label></td>
                                    <td align="left" width="115px"><label>Escalate In</label></td>
                                    <td align="left" width="81px"><label>Notify Owner</label></td>
                                    <td align="left" width="100px"><label>Notify New User</label></td>
                                    <td align="left" width="160px"><label>Other Emails</label></td>
                                </tr>
                                <tr>
                                    <td>
                                        <input type="hidden" id="type" name="type" value="<%=type%>" />
                                        <input type="hidden" id="subtype" name="subtype" value="<%=subtype%>" />
                                        <input type="hidden" id="flowChartId" name="flowChartId" value="<%=flowChartId%>" />
                                        <input type="hidden" id="actionId" name="actionId" value="<%=actionId%>" />
                                        <input type="hidden" id="todoaction" name="todoaction" value="addNew" />

                                        <select id="participantType" name="participantType" onchange="fnpopulateParticipant(this.value)">
                                            <option value="User" selected>User</option>
                                            <option value="OrgUnit">Organisation Unit</option>
                                            <option value="Designation">Designation</option>
                                            <option value="Manager">Manager</option>
                                            <option value="Initiator">Initiator</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select id="cbParticipant" name="cbParticipant">
                                            <%
                                                for (int a = 0; a < userList.size(); a++) {
                                                    User tmpuser = (User) userList.get(a);
                                                    int tmpId = tmpuser.getUserId();
                                                    String tmpName = tmpuser.getFullName();
                                            %>
                                            <option value="<%=tmpId%>"><%=tmpName%></option>
                                            <% }%>
                                        </select>
                                    </td>
                                    <td>
                                        <!--                                        <label for="txtDay" align="right">Day : </label>
                                                                                <input type="number" id="txtDay" name="txtDay" value="0"/>-->

                                        <label for="txtHour" align="right">Hour(s) : </label>
                                        <input type="number" size="2" id="txtHour" name="txtHour" value="0"/>

                                        <!--                                        <label for="txtMinute" align="right">Minute : </label>
                                                                                <input type="number" id="txtMinute" name="txtMinute" value="0"/>-->
                                    </td>
                                    <td>
                                        <select size="1" id="notifyOwner" name="notifyOwner" style="font:90% arial,helvetica,clean,sans-serif">
                                            <option value="true">YES</option>
                                            <option value="false">NO</option>
                                        </select>
                                    </td>
                                    <td>
                                        <select size="1" id="notifyEscalated" name="notifyEscalated" style="font:90% arial,helvetica,clean,sans-serif">
                                            <option value="true">YES</option>
                                            <option value="false">NO</option>
                                        </select>
                                    </td>
                                    <td><textarea id="additionalEmailArea" name="additionalEmailArea" rows="2" cols="22"></textarea></td>
                                </tr>
                                <tr>
                                    <td colspan="6">
                                        <input type="button" id="AddNewBtn" name="AddNewBtn" value="Add" onclick="fnAddNewBtnClicked()" />
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </td>
                </tr>
                <tr>
                    <td>
                        <table border="1" width="100%"  cellpadding="3" style="border-collapse:collapse"  bordercolor="#C0C0C0">
                            <tr style="background:#333333; text-align:left; color:#ffffff; border:1px solid #fff; border-right:none">
                                <td align="right"><label>Order</label></td>
                                <td align="left"><label>Participant Type</label></td>
                                <td align="left"><label>Assign To</label></td>
                                <td align="left"><label>Escalate In</label></td>
                                <td align="left"><label>Notify Owner</label></td>
                                <td align="left"><label>Notify New User</label></td>
                                <td align="left"><label>Other Emails</label></td>
                                <td align="left"><label>&nbsp;</label></td>
                            </tr>
                            <tbody class="sort">
                                <%
                                    for (int i = 0; i < escalationList.size(); i++) {
                                        Escalation escalation = escalationList.get(i);
                                %>
                                <tr id="<%=i%>">
                                    <td><%=escalation.getOrder()%></td>
                                    <td><%=escalation.getParticipant_type()%></td>
                                    <td><%=escalation.getParticipant_name()%></td>
                                    <td><%=escalation.getTime_limit()%> hour(s)</td>
                                    <td><%=escalation.isNotify_owner()%></td>
                                    <td><%=escalation.isNotify_escalated()%></td>
                                    <td><%=escalation.getExtra_emails()%></td>
                                    <td><input type="button" id="delBtn" name="delBtn" value="Delete" onclick="delBtnClicked(<%=escalation.getId()%>)"/></td>
                                </tr>
                                <% }%>
                            </tbody>
                            <tr>
                                <td colspan="7"><input type="button" id="reorderBtn" name="reorderBtn" value="Reorder" onclick="fndoreorder()"/></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>

    </body>
</html>
