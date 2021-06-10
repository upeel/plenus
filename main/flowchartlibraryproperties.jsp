<%-- 
    Document   : flowchartlibraryproperties
    Created on : Nov 13, 2009, 9:58:09 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.flowchart.controller.*"
         import = "com.bizmann.flowchart.entity.*"
         import = "java.io.*" %>

<%
    int noOfAction = 1;

    String flowChartId = request.getParameter("flowChartId");
    if (flowChartId == null)
    {
        flowChartId = "0";
    }
//Get the current type and subtype
    String type = request.getParameter("type");
    if (type == null)
    {
        type = "";
    }
    String subtype = request.getParameter("subtype");
    if (subtype == null)
    {
        subtype = "";
    }
    String action = request.getParameter("action");
    if (action == null)
    {
        action = "";
    }

    FlowChartActionController fcaCtrl = new FlowChartActionController();
    EngineFlowChartController efcCtrl = new EngineFlowChartController();

    ArrayList engineActionList = fcaCtrl.getActionsByFlowChartId(Integer.parseInt(flowChartId));
    EngineFlowChart engineFlowChart = efcCtrl.getEngineFlowChart(Integer.parseInt(flowChartId));

    engineFlowChart = efcCtrl.getEngineFlowChart(Integer.parseInt(flowChartId));
    engineActionList = fcaCtrl.getActionsByFlowChartId(Integer.parseInt(flowChartId));
    //ArrayList engineFormList = new EngineFormController().getEngineForms(Integer.parseInt(flowChartId));
    ArrayList engineResponseList = new EngineResponseController().getEngineResponses(Integer.parseInt(flowChartId));

    ArrayList participantRuleList = new ArrayList();
    //ArrayList formList = new ArrayList();

    String status = "";
    if (engineFlowChart.getIspublished() == 1)
    {
        status = "disabled";
    }

    ArrayList actionList = fcaCtrl.getActionsByFlowChartId(Integer.parseInt(flowChartId));
    if (actionList.size() > 0)
    {
        noOfAction = actionList.size();
    }

    String deleteRowIndex = request.getParameter("deleteRow");
    if (deleteRowIndex == null)
    {
        deleteRowIndex = "";
    }

    String strnoOfAction = request.getParameter("noOfAction");
    if (strnoOfAction != null)
    {
        noOfAction = Integer.parseInt(strnoOfAction);
    }

    String[] txtActionName = new String[noOfAction];
    String[] cbActionType = new String[noOfAction];
    String[] cbParticipantType = new String[noOfAction];
    String[] cbParticipant = new String[noOfAction];
    String[] cbParticipantRule = new String[noOfAction];
    String[] txtActionId = new String[noOfAction];

    ArrayList userList = new ArrayList();
    ArrayList orgUnitList = new ArrayList();
    ArrayList desList = new ArrayList();

    UserController userCtrl = new UserController();
    OrgUnitController orgUnitCtrl = new OrgUnitController();
    DesignationController desCtrl = new DesignationController();

    userList = userCtrl.getAllUserName();
    orgUnitList = orgUnitCtrl.getAllOrgUnits();
    desList = desCtrl.getAllDesignation();

    int tempIndex = 0;

    for (int i = 0; i < noOfAction; i++)
    {
        FlowChartAction fca = new FlowChartAction();
        if (actionList.size() > i)
        {
            fca = (FlowChartAction) actionList.get(i);
        }

        String strActionName = request.getParameter("txtActionName" + i);
        txtActionName[tempIndex] = strActionName;
        if (txtActionName[tempIndex] == null)
        {
            if (fca.getName() == null)
            {
                txtActionName[tempIndex] = "";
            }
            else
            {
                txtActionName[tempIndex] = fca.getName();
            }
        }

        String strActionType = request.getParameter("cbActionType" + i);
        cbActionType[tempIndex] = strActionType;
        if (cbActionType[tempIndex] == null)
        {
            if (fca.getType() == null)
            {
                cbActionType[tempIndex] = "";
            }
            else
            {
                cbActionType[tempIndex] = fca.getType();
            }
        }

        String strParticipantType = request.getParameter("cbParticipantType" + i);
        cbParticipantType[tempIndex] = strParticipantType;
        if (cbParticipantType[tempIndex] == null)
        {
            if (fca.getParticipant_type() == null)
            {
                cbParticipantType[tempIndex] = "";
            }
            else
            {
                cbParticipantType[tempIndex] = fca.getParticipant_type();
            }
        }

        String strParticipant = request.getParameter("cbParticipant" + i);
        cbParticipant[tempIndex] = strParticipant;
        if (cbParticipant[tempIndex] == null)
        {
            if (fca.getParticipant() == null)
            {
                cbParticipant[tempIndex] = "";
            }
            else
            {
                cbParticipant[tempIndex] = fca.getParticipant();
            }
        }

        String strParticipantRule = request.getParameter("cbParticipantRule" + i);
        cbParticipantRule[tempIndex] = strParticipantRule;
        if (cbParticipantRule[tempIndex] == null)
        {
            if (fca.getParticipant_rule() == null)
            {
                cbParticipantRule[tempIndex] = "";
            }
            else
            {
                cbParticipantRule[tempIndex] = fca.getParticipant_rule();
            }
        }

        if (!deleteRowIndex.equals(Integer.toString(i)))
        { //if deleteRowIndex != current index
            tempIndex++;
        }
        else
        {  // if deleteRowIndex == current index

        }
    }

    if (!deleteRowIndex.equals(""))
    {
        noOfAction -= 1;
    }
    if (action.equalsIgnoreCase("update"))
    {
        ArrayList toInsertList = new ArrayList();
        for (int i = 0; i < noOfAction; i++)
        {
            FlowChartAction fcaToInsert = new FlowChartAction();
            //System.out.println(txtActionName[i]);
            if (txtActionName[i] != null && !txtActionName[i].equals(""))
            {
                //System.out.println(txtActionName[i]);
                fcaToInsert.setName(txtActionName[i]);
                fcaToInsert.setType(cbActionType[i]);
                fcaToInsert.setParticipant_type(cbParticipantType[i]);
                fcaToInsert.setParticipant(cbParticipant[i]);
                fcaToInsert.setParticipant_rule(cbParticipantRule[i]);
                fcaToInsert.setForm_id(Integer.parseInt("0"));
                fcaToInsert.setFlowchart_id(Integer.parseInt(flowChartId));
                fcaToInsert.setIs_start_action(false);
                toInsertList.add(fcaToInsert);
            }
        }
        fcaCtrl.updateAllActions(toInsertList, Integer.parseInt(flowChartId));
        response.sendRedirect("flowchartlibraryflow.jsp?type=" + type + "&subtype=" + subtype + "&flowChartId=" + flowChartId + "&flowFormId=0&action=add");
    }
%>


<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/layout.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/menu/assets/skins/sam/menu.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />
        <script type="text/javascript" src="../include/js/url.js"></script>
        <script type="text/javascript" src="../include/js/jquery-1.10.2.js"></script>
        <title>bmFLO</title>
        <style>
            .selected{
                background:#ACD6F5;
                border:1px solid grey;
            }
        </style>
        <script>
            var action = "<%=action%>";
            var type = "<%=type%>";
            var subtype = "<%=subtype%>"
            var flowChartId = "<%=flowChartId%>";

            function fnContinue() {
                document.location.href = "flowchartlibraryflow.jsp?type=" + type + "&subtype=" + subtype + "&flowChartId=" + flowChartId;
            }

            function fnAddCashIn() {
                var noOfCashIn = parseInt(document.getElementById("noOfAction").value);
                document.getElementById("noOfAction").value = noOfCashIn + 1;

                document.frmFlowChart.method = "POST";
                document.frmFlowChart.action = "flowchartlibraryproperties.jsp?action=edit";
                document.frmFlowChart.submit();
            }

            function fnRemoveCashIn() {
                var selectedIndex = document.getElementById("selectedRow").value;
                document.frmFlowChart.method = "post";
                document.frmFlowChart.action = "flowchartlibraryproperties.jsp?action=edit&deleteRow=" + selectedIndex;
                document.frmFlowChart.submit();
            }

            function fnSelectRow(index) {
                fnUnSelectRow();
                document.getElementById("rowActionName" + index).className = "selected";
                document.getElementById("rowActionType" + index).className = "selected";
                document.getElementById("rowParticipantType" + index).className = "selected";
                document.getElementById("rowParticipant" + index).className = "selected";
                document.getElementById("rowParticipantRule" + index).className = "selected";
                document.getElementById("selectedRow").value = index;
            }

            function fnUnSelectRow() {
                for (var i = 0; document.getElementById("rowActionName" + i) != null; i++) {
                    document.getElementById("rowActionName" + i).className = "cellcontent";
                    document.getElementById("rowActionType" + i).className = "cellcontent";
                    document.getElementById("rowParticipantType" + i).className = "cellcontent";
                    document.getElementById("rowParticipant" + i).className = "cellcontent";
                    document.getElementById("rowParticipantRule" + i).className = "cellcontent";
                }
            }

            function fnDocumentReady() {
                $("#btnPreview").click(function () {
                    fnPreview();
                });
            }

        </script>
    </head>
    <body onload="fnDocumentReady()" background="../images/background.png" style="width:650px">
        <br><br>
        <div align="center" valign="top">
            <form name="frmFlowChart" id="frmFlowChart" action="flowchartlibraryproperties.jsp">
                <table>
                    <tr>
                        <td>
                            <table border="1" cellpadding="2px" style="text-align:left;font:80% arial,helvetica,clean,sans-serif;border-collapse:collapse;" width="95%">
                                <tr style="background:#333333; text-align:left; color:#ffffff; border:1px solid #fff; border-right:none">
                                    <td colspan="6" style="font:120% arial,helvetica,clean,sans-serif"><b><%=engineFlowChart.getName()%></b></td>
                                </tr>
                                <%if (engineFlowChart.getIspublished() != 1)
                                    {%>
                                <tr>
                                    <td colspan="5">
                                        <a href="#" onclick="fnAddCashIn()">[add]</a>
                                        <a href="#" onclick="fnRemoveCashIn()">[delete]</a>
                                        <input type="hidden" id="noOfAction" name="noOfAction" value="<%=noOfAction%>">
                                        <input type="hidden" id="flowChartId" name="flowChartId" value="<%=flowChartId%>">
                                        <input type="hidden" id="txtFlowForm" name="txtFlowForm" value="0">
                                        <input type="hidden" id="selectedRow" name="selectedRow" value=""/>
                                    </td>
                                </tr>
                                <tr style="background-color:#cccccc">
                                    <td><b>Names</b></td>
                                    <td><b>Type</b></td>
                                    <td><b>Participant Type</b></td>
                                    <td><b>Participants</b></td>
                                    <td><b>Participant Rules</b></td>
                                </tr>
                                <!-- new codes STARTS -->
                                <%
                                    for (int i = 0; i < noOfAction; i++)
                                    {%>
                                <tr onclick="fnSelectRow(<%=i%>)" style="background-color:white">
                                    <td class="cellcontent" id="rowActionName<%=i%>">
                                        <input type="text" id="txtActionName<%=i%>" name="txtActionName<%=i%>" value="<%=txtActionName[i]%>"/>
                                        <input type="hidden" id="txtActionId<%=i%>" name="txtActionId<%=i%>" value="<%=txtActionId[i]%>"/>
                                    </td>
                                    <td class="cellcontent" id="rowActionType<%=i%>">
                                        <select id="cbActionType<%=i%>" name="cbActionType<%=i%>">
                                            <%
                                                String selectedActionType = cbActionType[i];
                                                String bpSelected = "";
                                                String endSelected = "";
                                                String decSelected = "";
                                                if (selectedActionType.equalsIgnoreCase("BusinessProcess"))
                                                {
                                                    bpSelected = "selected";
                                                }
                                                else if (selectedActionType.equalsIgnoreCase("End"))
                                                {
                                                    endSelected = "selected";
                                                }
                                                else if (selectedActionType.equalsIgnoreCase("Decision"))
                                                {
                                                    decSelected = "selected";
                                                }
                                            %>
                                            <option value="BusinessProcess" <%=bpSelected%> >Business Process</option>
                                            <option value="End" <%=endSelected%> >End</option>
                                            <option value="Decision" <%=decSelected%> >Decision</option>
                                        </select>
                                    </td>
                                    <td class="cellcontent" id="rowParticipantType<%=i%>">
                                        <select id="cbParticipantType<%=i%>" name="cbParticipantType<%=i%>" onchange="fnpopulateParticipant(this.value, <%=i%>)">
                                            <%
                                                ArrayList participantList = new ArrayList();
                                                String selectedParticipantType = cbParticipantType[i];
                                                String noneSelected = "";
                                                String userSelected = "";
                                                String orgSelected = "";
                                                String desSelected = "";
                                                String managerSelected = "";
                                                String initiatorSelected = "";
                                                if (selectedParticipantType.equalsIgnoreCase("User"))
                                                {
                                                    userSelected = "selected";
                                                    participantList = userList;
                                                }
                                                else if (selectedParticipantType.equalsIgnoreCase("OrgUnit"))
                                                {
                                                    orgSelected = "selected";
                                                    participantList = orgUnitList;
                                                }
                                                else if (selectedParticipantType.equalsIgnoreCase("Designation"))
                                                {
                                                    desSelected = "selected";
                                                    participantList = desList;
                                                }
                                                else if (selectedParticipantType.equalsIgnoreCase("Manager"))
                                                {
                                                    managerSelected = "selected";
                                                }
                                                else if (selectedParticipantType.equalsIgnoreCase("Initiator"))
                                                {
                                                    initiatorSelected = "selected";
                                                }
                                                else
                                                {
                                                    noneSelected = "selected";
                                                }
                                            %>
                                            <option value="None" <%=noneSelected%> >None</option>
                                            <option value="User" <%=userSelected%> >User</option>
                                            <option value="OrgUnit" <%=orgSelected%> >Organisation Unit</option>
                                            <option value="Designation" <%=desSelected%> >Designation</option>
                                            <option value="Manager" <%=managerSelected%> >Manager</option>
                                            <option value="Initiator" <%=initiatorSelected%> >Initiator</option>
                                        </select>
                                    </td>
                                    <td class="cellcontent" id="rowParticipant<%=i%>">
                                        <select id="cbParticipant<%=i%>" name="cbParticipant<%=i%>">
                                            <%
                                                String selectedParticipant = cbParticipant[i];
                                                if (selectedParticipant.equals(""))
                                                {
                                                    selectedParticipant = "0";
                                                }
                                                for (int a = 0; a < participantList.size(); a++)
                                                {
                                                    int id = 0;
                                                    String name = "";
                                                    String participantSelected = "";
                                                    if (selectedParticipantType.equalsIgnoreCase("User"))
                                                    {
                                                        User tmpuser = (User) participantList.get(a);
                                                        id = tmpuser.getUserId();
                                                        name = tmpuser.getFullName();
                                                    }
                                                    else if (selectedParticipantType.equalsIgnoreCase("OrgUnit"))
                                                    {
                                                        OrgUnit tmporgunit = (OrgUnit) participantList.get(a);
                                                        id = tmporgunit.getId();
                                                        name = tmporgunit.getName();
                                                    }
                                                    else if (selectedParticipantType.equalsIgnoreCase("Designation"))
                                                    {
                                                        Designation tmpdesignation = (Designation) participantList.get(a);
                                                        id = tmpdesignation.getDesignationId();
                                                        name = tmpdesignation.getName();
                                                    }
                                                    if (Integer.parseInt(selectedParticipant) == id)
                                                    {
                                                        participantSelected = "selected";
                                                    }
                                            %>
                                            <option value="<%=id%>" <%=participantSelected%> ><%=name%></option>
                                            <%}%>
                                        </select>
                                    </td>
                                    <td class="cellcontent" id="rowParticipantRule<%=i%>">
                                        <select id="cbParticipantRule<%=i%>" name="cbParticipantRule<%=i%>">
                                            <%
                                                String selectedRule = cbParticipantRule[i];
                                                String individualSelected = "";
                                                String groupSelected = "";
                                                if (selectedRule.equalsIgnoreCase("Individual"))
                                                {
                                                    individualSelected = "selected";
                                                }
                                                else if (selectedRule.equalsIgnoreCase("Group"))
                                                {
                                                    groupSelected = "selected";
                                                }
                                            %>
                                            <option value="Individual" <%=individualSelected%> >Individual</option>
                                            <option value="Group" <%=groupSelected%> >Group</option>
                                        </select>
                                    </td>
                                <tr>
                                    <%}%>
                                    <!-- new codes ENDS-->
                                <tr style="background-color:#cccccc">
                                    <td colspan="3" style="font:110% arial,helvetica,clean,sans-serif;color:blue;text-align:center;cursor:pointer" onclick="fnUpdate()"><b><u>Update Modified</u></b></td>
                                    <td colspan="3" style="font:110% arial,helvetica,clean,sans-serif;color:blue;text-align:center;cursor:pointer" onclick="fnContinue()"><b><u>Define Flow</u></b></td>
                                </tr>
                                <%}
                                else
                                {%>
                                <tr style="background-color:#cccccc">
                                    <td><b>Names</b></td>
                                    <td><b>Type</b></td>
                                    <td><b>Participant Type</b></td>
                                    <td><b>Participants</b></td>
                                    <td><b>Participant Rules</b></td>
                                    <td><b>Responses</b></td>
                                </tr>
                                <% for (int i = 0; i < engineActionList.size(); i++)
                                    {
                                        FlowChartAction engineAction = (FlowChartAction) engineActionList.get(i);
                                %>
                                <tr style="background-color:white">
                                    <td><%=engineAction.getName()%></td>
                                    <td><%=engineAction.getType()%></td>
                                    <td><%=engineAction.getParticipant_type()%></td>
                                    <td><%=engineAction.getParticipant_name()%></td>
                                    <td>
                                        <%if (engineAction.getParticipant_rule() != null)
                                            {
                                                participantRuleList.add("cbRule_" + engineAction.getName());
                                        %>
                                        <select size="1" id="cbRule_<%=engineAction.getName()%>" name="cbRule_<%=engineAction.getName()%>" style="font:90% arial,helvetica,clean,sans-serif" <%=status%>>
                                            <% if (engineAction.getParticipant_rule().equals("Group"))
                                                {%>
                                            <option value=""></option>
                                            <option value="Group" selected>Group</option>
                                            <option value="Individual">Individual</option>
                                            <%}
                                            else if (engineAction.getParticipant_rule().equals("Individual"))
                                            {%>
                                            <option value=""></option>
                                            <option value="Group">Group</option>
                                            <option value="Individual" selected>Individual</option>
                                            <%}
                                            else
                                            {%>
                                            <option value=""></option>
                                            <option value="Group">Group</option>
                                            <option value="Individual">Individual</option>
                                            <%}%>
                                        </select>
                                        <%}%>
                                    </td>
                                    <td>
                                        <%
                                            String responseGroup = "";
                                            for (int j = 0; j < engineResponseList.size(); j++)
                                            {
                                                EngineResponse engineResponse = (EngineResponse) engineResponseList.get(j);
                                                if (engineResponse.getEngineActionId() == engineAction.getId())
                                                {
                                                    if (responseGroup.equals(""))
                                                    {
                                                        responseGroup = engineResponse.getName();
                                                    }
                                                    else
                                                    {
                                                        responseGroup = responseGroup + ", <br/>" + engineResponse.getName();
                                                    }
                                                }
                                        %>
                                        <%}
                                            if (engineAction.getType().equalsIgnoreCase("Decision"))
                                            {
                                                responseGroup = fcaCtrl.getConditionsByActionByFlowchart(engineAction.getId(), engineAction.getFlowchart_id());
                                            }%>
                                        <%=responseGroup%>
                                    </td>
                                </tr>
                                <%}%>
                                <%}%>
                                <!--                                <tr>
                                                                    <td colspan="6" align="center">&nbsp;
                                                                                                                <input type="button" value="Preview" name="btnPreview" class="psadbutton" width="100" onclick="fnPreview()">
                                                                                                                <input name="btnPreview" id="btnPreview" type="image" src="images/flowchartpreview.png" alt="Preview" style="cursor:pointer"/>
                                                                    </td>
                                                                </tr>-->
                            </table>
                        </td>
                    </tr>
                </table>
            </form>
            <table><tr><td>
                        <input name="btnPreview" id="btnPreview" type="image" src="images/flowchartpreview.png" alt="Preview" style="cursor:pointer"/>
                    </td></tr></table>
                    <%if (action.equals("update"))
                        {
                    %>
            <label style="color:red">The Flowchart properties are updated!</label>
            <%}%>
        </div>
    </body>


    <script>
        var type = "<%=request.getParameter("type")%>";
        var subtype = "<%=request.getParameter("subtype")%>"

        function fnPreview() {
            window.open('flowchartpreview.jsp?flowChartId=<%=flowChartId%>');
        }

        function fnpopulateParticipant(selected, index) {
            document.getElementById("cbParticipant" + index).options.length = 0;
            if (selected == 'User') {
        <%
            for (int a = 0; a < userList.size(); a++)
            {
                User tmpuser = (User) userList.get(a);
                int id = tmpuser.getUserId();
                String name = tmpuser.getFullName();
        %>
                document.getElementById("cbParticipant" + index).options[<%=a%>] = new Option("<%=name%>", "<%=id%>");
        <% }%>
            } else if (selected == 'OrgUnit') {
        <%
            for (int a = 0; a < orgUnitList.size(); a++)
            {
                OrgUnit tmporgunit = (OrgUnit) orgUnitList.get(a);
                int id = tmporgunit.getId();
                String name = tmporgunit.getName();

        %>
                document.getElementById("cbParticipant" + index).options[<%=a%>] = new Option("<%=name%>", "<%=id%>");
        <% }%>
            } else if (selected == 'Designation') {
        <%
            for (int a = 0; a < desList.size(); a++)
            {
                Designation tmpdesignation = (Designation) desList.get(a);
                int id = tmpdesignation.getDesignationId();
                String name = tmpdesignation.getName();
        %>
                document.getElementById("cbParticipant" + index).options[<%=a%>] = new Option("<%=name%>", "<%=id%>");
        <% }%>
            }
        }

        function fnFlowChartValidated() {
            isFormValidated = true;
            return isFormValidated;
        }

        function fnParticipantValidated() {
            isParticipantValidated = true;
            //ensure that all the combo boxes are selected
        <%for (int i = 0; i < participantRuleList.size(); i++)
            {
                String participantRuleBox = (String) participantRuleList.get(i);
        %>
            if (document.getElementById("<%=participantRuleBox%>").value == "") {
                isParticipantValidated = false;
            }
        <%}%>
            return isParticipantValidated;
        }

        function fnUpdate() {
            var r = confirm("Editing Activities would clear all existing defined flow, responses and routing rules! \n\r Are you sure you want to continue?");
            if (r == true)
            {
                if (fnParticipantValidated() == false) {
                    parent.frames.alertMessage("Please select the Participant Rules");
                } else if (fnFlowChartValidated() == false) {
                    parent.frames.alertMessage("Please enter the Forms");
                } else {
                    //get all the rules and forms which the user fills in
                    participantRules = "";
        <% for (int i = 0; i < participantRuleList.size(); i++)
            {
                String participantRuleBox = (String) participantRuleList.get(i);
        %>
                    participantRuleValue = fnURLEncode(document.getElementById("<%=participantRuleBox%>").value);
                    participantRules = participantRules + "&<%=participantRuleBox%>=" + participantRuleValue;
        <%}%>

                    document.frmFlowChart.method = "POST";
                    document.frmFlowChart.action = "flowchartlibraryproperties.jsp?type=" + type + "&subtype=" + subtype + "&action=update";
                    document.frmFlowChart.submit();
                    //document.location.href = "flowchartlibraryproperties.jsp?type="+type+"&subtype="+subtype+"&action=update&flowChartId=<flowChartId%>&flowFile="+participantRules;
                }
            } else {
                //document.location.href = "flowchartlibraryproperties.jsp?type="+type+"&subtype="+subtype+"&flowChartId=<flowChartId%>";
                //do nth
            }
        }

    </script>
</html>
