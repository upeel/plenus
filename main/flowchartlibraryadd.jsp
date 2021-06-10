<%-- 
    Document   : formlibraryadd
    Created on : Apr 30, 2009, 3:36:13 PM
    Author     : Tan Chiu Ping
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.flowchart.controller.*"
         import = "com.bizmann.poi.controller.*"
         import = "com.bizmann.poi.entity.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.flowchart.entity.*"
         import = "com.jenkov.servlet.multipart.MultipartEntry"
         import = "java.io.*"
         import = "com.bizmann.product.resources.*" %>
<%
    String flowName = "";
    String flowFormId = "";
    String action = "";
    int noOfAction = 1;

    String msg = "";
    ArrayList actionList = new ArrayList();

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

    //start
    //Get flowName
    flowName = request.getParameter("txtFlowName");
    //Get flowForm
    flowFormId = request.getParameter("txtFlowForm");
    //Get Action
    action = request.getParameter("hidAction");
    if (action == null)
    {
        action = "";
    }

    String actionAction = request.getParameter("action");
    if (actionAction == null)
    {
        actionAction = "";
    }

    flowName = request.getParameter("txtFlowName");
    if (flowName == null)
    {
        flowName = "";
    }

    if (flowName.equals(""))
    {
        flowName = request.getParameter("flowName");
        if (flowName == null)
        {
            flowName = "";
        }
    }

    flowFormId = request.getParameter("txtFlowForm");
    if (flowFormId == null || flowFormId.equals(""))
    {
        flowFormId = "0";
    }

    com.bizmann.product.controller.UserController uCtrl = new com.bizmann.product.controller.UserController();
    String loginid = (String) session.getAttribute("user");
    int userId = uCtrl.getUserIdByLoginId(loginid);

    boolean isError = false;
    ArrayList participantRuleList = new ArrayList();
    ArrayList formList = new FormController().getAllFormNames();

    int flowChartId = 0;
    //Initiating the neccessary controller
    EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();

    String strflowChartId = request.getParameter("flowChartId");
    if (strflowChartId != null)
    {
        if (strflowChartId.equals(""))
        {
            strflowChartId = "0";
        }
        flowChartId = Integer.parseInt(strflowChartId);
    }

    int formId = 0;
    String strformId = request.getParameter("formId");
    if (strformId != null)
    {
        if (strformId.equals(""))
        {
            strformId = "0";
        }
        formId = Integer.parseInt(strformId);
    }

    if (action.equals("showproperties"))
    {
        if (!engineFlowChartCtrl.isDupFlowChartName(flowName))
        {
            if (engineFlowChartCtrl.formIsUsed(formId) && formId != -1)
            { // Form ID -1 means External Form
                msg = "The Form has already been used to define flowchart!";
            }
            else
            {
                flowChartId = engineFlowChartCtrl.addFlowChart(flowName, userId, formId);
            }
            //action = "add";
        }
        else
        {
            msg = "Unable to insert Duplicate Flowchart Name - " + flowName;
        }
    }

    FlowChartActionController fcaCtrl = new FlowChartActionController();
    actionList = fcaCtrl.getActionsByFlowChartId(flowChartId);
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
        String strActionName = request.getParameter("txtActionName" + i);

        if (strActionName == null)
        {
            strActionName = "";
        }
        txtActionName[tempIndex] = strActionName;

        String strActionType = request.getParameter("cbActionType" + i);
        if (strActionType == null)
        {
            strActionType = "";
        }
        cbActionType[tempIndex] = strActionType;

        String strParticipantType = request.getParameter("cbParticipantType" + i);
        if (strParticipantType == null)
        {
            strParticipantType = "";
        }
        cbParticipantType[tempIndex] = strParticipantType;

        String strParticipant = request.getParameter("cbParticipant" + i);
        if (strParticipant == null)
        {
            strParticipant = "";
        }
        cbParticipant[tempIndex] = strParticipant;

        String strParticipantRule = request.getParameter("cbParticipantRule" + i);
        if (strParticipantRule == null)
        {
            strParticipantRule = "";
        }
        cbParticipantRule[tempIndex] = strParticipantRule;

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
    if (actionAction.equalsIgnoreCase("add"))
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
                fcaToInsert.setForm_id(Integer.parseInt(flowFormId));
                fcaToInsert.setFlowchart_id(flowChartId);
                fcaToInsert.setIs_start_action(false);
                toInsertList.add(fcaToInsert);
            }
        }
        fcaCtrl.insertAllActions(toInsertList);
        response.sendRedirect("flowchartlibraryflow.jsp?type=" + type + "&subtype=" + subtype + "&flowChartId=" + flowChartId + "&flowFormId=" + flowFormId + "&action=add");
    }
%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/layout.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/menu/assets/skins/sam/menu.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />

        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/imageloader/imageloader-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/container/container_core-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/menu/menu-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-beta-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/button/button-min.js"></script>
        <script type="text/javascript" src="../include/js/url.js"></script>
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

            function fnOnLoad() {
                if (action == "add") {
                    //redirect the user
                    if (subtype == "null") {
                        parent.document.location.href = "flowchartlibrary.jsp?type=" + type;
                    } else {
                        parent.document.location.href = "flowchartlibrary.jsp?type=" + type + "&subtype=" + subtype;
                    }
                }
                if (document.getElementById("msg").value != "" && document.getElementById("msg").value != "null") {
                    parent.frames.alertMessage("<%=msg%>");
                    document.location.href = "flowchartlibraryadd.jsp?type=" + type + "&subtype=" + subtype;
                }
            }

            function flowChartValidated() {
                if (document.getElementById("txtFlowName").value == "") {
                    parent.frames.alertMessage("Please give the flowchart name.");
                    return false;
                } else {
                    return true;
                }
                if ((document.getElementById("txtFlowForm").value) == "0") {
                    parent.frames.alertMessage("Please select a form.");
                    return false;
                } else {
                    return true;
                }
            }

            function fnSubmit() {
                if (flowChartValidated() == true) {
                    document.getElementById("hidAction").value = "showproperties";
                    document.getElementById("type").value = "<%=type%>";
                    document.getElementById("subtype").value = "<%=subtype%>";
                    document.frmFlowChart.method = "post";
                    document.frmFlowChart.submit();
                }
            }

            function fnAddCashIn() {
                var noOfCashIn = parseInt(document.getElementById("noOfAction").value);
                document.getElementById("noOfAction").value = noOfCashIn + 1;

                document.frmFlowChart.method = "POST";
                document.frmFlowChart.action = "flowchartlibraryadd.jsp?flowName=<%=flowName%>&action=edit";
                document.frmFlowChart.submit();
            }

            function fnRemoveCashIn() {
                var selectedIndex = document.getElementById("selectedRow").value;
                document.frmFlowChart.method = "post";
                document.frmFlowChart.action = "flowchartlibraryadd.jsp?action=edit&deleteRow=" + selectedIndex;
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

            function fnFlowChartValidated() {
                isFormValidated = true;
                return isFormValidated;
            }

            function fnStartFlow() {
                document.frmFlowChart.method = "POST";
                document.frmFlowChart.action = "flowchartlibraryadd.jsp?type=" + type + "&subtype=" + subtype + "&action=add";
                document.frmFlowChart.submit();
            }

            function fnContinue() {
                if (fnParticipantValidated() == false) {
                    parent.frames.alertMessage("Please select the Participant Rules");
                } else if (fnFlowChartValidated() == false) {
                    parent.frames.alertMessage("Please enter the Forms");
                } else {
                    var flowName = fnURLEncode("<%=flowName%>");
                    //get all the rules and forms which the user fills in
                    participantRules = "";
            <% for (int i = 0; i < participantRuleList.size(); i++)
                {
                    String participantRuleBox = (String) participantRuleList.get(i);
            %>
                    participantRuleValue = fnURLEncode(document.getElementById("<%=participantRuleBox%>").value);
                    participantRules = participantRules + "&<%=participantRuleBox%>=" + participantRuleValue;
            <%}%>
                    document.location.href = "flowchartlibraryadd.jsp?type=" + type + "&subtype=" + subtype + "&action=add&flowName=" + flowName;
                }
            }
        </script>
    </head>
    <body onload="fnOnLoad()" class="yui-skin-sam" background="../images/background.png" style="width:650px">
        <div align="center" valign="top">
            <form name="frmFlowChart" action="flowchartlibraryadd.jsp">
                <table>
                    <% if (flowChartId == 0)
                        {%>
                    <tr>
                        <td class="orgtable" valign="top" align="center">
                            <br><table>
                                <tr>
                                    <th colspan="2">
                                        <div class="psadtitle">
                                            <br>
                                            Add Flow Chart<br><br>
                                        </div>
                                    </th>
                                </tr>
                                <tr>
                                    <td width=150 align="right"><b>Name:</b></td>
                                    <td width=350 align="left">
                                        &nbsp;<input type="text" id="txtFlowName" name="txtFlowName" size="30" class="psadtext">
                                    </td>
                                </tr>
                                <tr>
                                    <td width=150 align="right"><b>Form:</b></td>
                                    <td width=350 align="left">
                                        &nbsp;
                                        <select id="formId" name="formId" class="psadtext">
                                            <option value="0">-- Please Select a Form --</option>
                                            <%
                                                for (int a = 0; a < formList.size(); a++)
                                                {
                                                    com.bizmann.poi.entity.Form tmpFrm = (com.bizmann.poi.entity.Form) formList.get(a);
                                                    int id = tmpFrm.getId();
                                                    String name = tmpFrm.getName();
                                            %>
                                            <option value="<%=id%>"><%=name%></option>
                                            <% }%>
                                            <option value="-1">External Form(Customized)</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;<input type="button" value="Continue" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()"></td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                                <input type="hidden" id="hidAction" name="hidAction">
                                <input type="hidden" id="type" name="type">
                                <input type="hidden" id="subtype" name="subtype">
                                <input type="hidden" value="<%=msg%>" name="msg" id="msg" />
                            </table>
                        </td>
                    </tr>
                    <% }%>

                    <%if (action.equals("showproperties") || flowChartId != 0)
                        {%>
                    <tr>
                        <td>
                            <table border="1" cellpadding="2px" style="text-align:left;font:80% arial,helvetica,clean,sans-serif;border-collapse:collapse;" width="95%">
                                <tr style="background:#333333; text-align:left; color:#ffffff; border:1px solid #fff; border-right:none">
                                    <td colspan="6" style="font:120% arial,helvetica,clean,sans-serif"><b><%=flowName%></b></td>
                                </tr>
                                <tr>
                                    <td colspan="5">
                                        <a href="#" onclick="fnAddCashIn()">[add]</a>
                                        <a href="#" onclick="fnRemoveCashIn()">[delete]</a>
                                        <input type="hidden" id="noOfAction" name="noOfAction" value="<%=noOfAction%>">
                                        <input type="hidden" id="flowChartId" name="flowChartId" value="<%=flowChartId%>">
                                        <input type="hidden" id="txtFlowForm" name="txtFlowForm" value="<%=flowFormId%>">
                                        <input type="hidden" id="selectedRow" name="selectedRow" value=""/>
                                    </td>
                                </tr>
                                <tr style="background-color:#cccccc">
                                    <td><b>Names</b></td>
                                    <td><b>Type</b></td>
                                    <td><b>Participant Type</b></td>
                                    <td><b>Participant</b></td>
                                    <td><b>Participant Rule</b></td>
                                </tr>
                                <%
                                    for (int i = 0; i < noOfAction; i++)
                                    {%>
                                <tr onclick="fnSelectRow(<%=i%>)">
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
                                <tr style="background-color:#cccccc">
                                    <td colspan="5" style="font:110% arial,helvetica,clean,sans-serif;color:blue;text-align:center;cursor:pointer" onclick="fnStartFlow()"><b><u>Continue</u></b></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%}%>
                </table>
            </form>
            <br><br><br><br>
        </div>
    </body>
</html>

