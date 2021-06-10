<%-- 
    Document   : subprocessadd
    Created on : Jul 16, 2014, 2:55:42 PM
    Author     : SOE HTIKE
--%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%-- 
    Document   : adminmodadd
    Created on : Jul 4, 2014, 4:31:02 PM
    Author     : SOE HTIKE
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
         import = "com.bizmann.diy.subprocess.controller.*"
         import = "com.bizmann.diy.subprocess.entity.*"
         import = "java.io.*"
         import = "com.bizmann.product.resources.*" %>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    String subProcessName = "";
    int flowchartId = 0;
    int actionId = 0;
    int subFlowchartId = 0;

    String action = "";
    String msg = "";

    String type = request.getParameter("type");
    if (type == null) {
        type = "";
    }
    String subtype = request.getParameter("subtype");
    if (subtype == null) {
        subtype = "";
    }

    action = request.getParameter("hidAction");
    if (action == null) {
        action = "";
    }

    subProcessName = request.getParameter("txtSubProcessName");
    if (subProcessName == null) {
        subProcessName = "";
    }

    String strFlowchartId = request.getParameter("cbFlowchartId");
    if (strFlowchartId == null) {
        strFlowchartId = "0";
    }
    strFlowchartId = strFlowchartId.trim();
    if (strFlowchartId.equals("")) {
        strFlowchartId = "0";
    }
    flowchartId = Integer.parseInt(strFlowchartId);

    String strActionid = request.getParameter("cbActionId");
    if (strActionid == null) {
        strActionid = "0";
    }
    strActionid = strActionid.trim();
    if (strActionid.equals("")) {
        strActionid = "0";
    }
    actionId = Integer.parseInt(strActionid);

    String strSubFlowchartId = request.getParameter("cbSubFlowchartId");
    if (strSubFlowchartId == null) {
        strSubFlowchartId = "0";
    }
    strSubFlowchartId = strSubFlowchartId.trim();
    if (strSubFlowchartId.equals("")) {
        strSubFlowchartId = "0";
    }
    subFlowchartId = Integer.parseInt(strSubFlowchartId);

    SubProcessController subProcCtrl = new SubProcessController();
    com.bizmann.product.controller.UserController uCtrl = new com.bizmann.product.controller.UserController();
    String loginid = (String) session.getAttribute("user");
    int userId = uCtrl.getUserIdByLoginId(loginid);

    ArrayList<EngineFlowChart> flowchartList = subProcCtrl.getAllFlowchartList();
    ArrayList<com.bizmann.product.entity.Action> actionList = new ArrayList<com.bizmann.product.entity.Action>();
    if (flowchartId > 0) {
        actionList = subProcCtrl.getAllActionNotInUseByFlowchartId(flowchartId);
    }

    if (action.equalsIgnoreCase("add")) {
        SubProcessHeader subPHeader = new SubProcessHeader();
        subPHeader.setName(subProcessName);
        subPHeader.setCreated_by(userId);
        subPHeader.setFlowchart_id(flowchartId);
        subPHeader.setTrigger_action_id(actionId);
        subPHeader.setSub_flowchart_id(subFlowchartId);

        int headerId = subProcCtrl.insertNewSubProcess(subPHeader);
        if (headerId > 0) {
            msg = "";
            response.sendRedirect("subprocessdetail.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + headerId);
        } else {
            msg = "New Sub-Process Mapping Creation FAILED! Please contact Site Admin or Try Again.";
        }
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

            function fnOnLoad(){
                if(action == "add"){
                    if(subtype == "null"){
                        parent.document.location.href = "subprocessdesigner.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "subprocessdesigner.jsp?type="+type+"&subtype="+subtype;
                    }
                }
                if(document.getElementById("msg").value != "" && document.getElementById("msg").value != "null"){
                    parent.frames.alertMessage("<%=msg%>");
                    document.location.href = "subprocessdesigner.jsp?type="+type+"&subtype="+subtype;
                }
            }

            function flowchartChanged(){
                document.getElementById("hidAction").value="";
                document.getElementById("type").value= "<%=type%>";
                document.getElementById("subtype").value= "<%=subtype%>";
                document.frmSubProc.method = "post";
                document.frmSubProc.submit();
            }
            function flowChartValidated(){
                if(document.getElementById("txtSubProcessName").value == ""){
                    parent.frames.alertMessage("Please give the descriptive name.");
                    return false;
                }else if(document.getElementById("cbFlowchartId").value == "0"){
                    parent.frames.alertMessage("Please select a main process.");
                    return false;
                }else if(document.getElementById("cbActionId").value == "0"){
                    parent.frames.alertMessage("Please select a triggering action.");
                    return false;
                }else if(document.getElementById("cbSubFlowchartId").value == "0"){
                    parent.frames.alertMessage("Please select a sub process to trigger.");
                    return false;
                }else{
                    return true;
                }
            }

            function fnSubmit(){
                if(flowChartValidated() == true){
                    document.getElementById("hidAction").value="add";
                    document.getElementById("type").value= "<%=type%>";
                    document.getElementById("subtype").value= "<%=subtype%>";
                    document.frmSubProc.method = "post";
                    document.frmSubProc.submit();
                }
            }
        </script>
    </head>
    <body onload="fnOnLoad()" class="yui-skin-sam" background="../images/background.png" style="width:650px">
        <div align="center" valign="top">
            <form name="frmSubProc" method="POST" action="subprocessadd.jsp">
                <table>
                    <tr>
                        <td class="orgtable" valign="top" align="center">
                            <br><table>
                                <tr>
                                    <th colspan="2">
                                        <div class="psadtitle">
                                            <br>Define New Sub-Process<br><br>
                                        </div>
                                    </th>
                                </tr>
                                <tr>
                                    <td width=150 align="right"><b>Name: </b></td>
                                    <td width=350 align="left">
                                        &nbsp;<input type="text" id="txtSubProcessName" name="txtSubProcessName" value="<%=subProcessName%>" size="30" class="psadtext">
                                    </td>
                                </tr>
                                <tr>
                                    <td width=150 align="right"><b>Main Flowchart: </b></td>
                                    <td width=350 align="left">
                                        &nbsp;
                                        <select id="cbFlowchartId" name="cbFlowchartId" class="psadtext" onchange="flowchartChanged()">
                                            <option value="0">--- Please select a Process ---</option>
                                            <%
                                                for (int a = 0; a < flowchartList.size(); a++) {
                                                    EngineFlowChart engFlowchart = flowchartList.get(a);
                                                    String flowchartSelected = "";
                                                    if (flowchartId == engFlowchart.getId()) {
                                                        flowchartSelected = "selected";
                                                    }
                                            %>
                                            <option value="<%=engFlowchart.getId()%>" <%=flowchartSelected%>><%=StringEscapeUtils.escapeHtml(engFlowchart.getName())%></option>
                                            <% }%>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td width=150 align="right"><b>Triggering Action: </b></td>
                                    <td width=350 align="left">
                                        &nbsp;
                                        <select id="cbActionId" name="cbActionId" class="psadtext">
                                            <option value="0">--- Please select an Action ---</option>
                                            <%
                                                for (int a = 0; a < actionList.size(); a++) {
                                                    com.bizmann.product.entity.Action tmpAction = actionList.get(a);
                                                    String actionSelected = "";
                                                    if (actionId == tmpAction.getId()) {
                                                        actionSelected = "selected";
                                                    }
                                            %>
                                            <option value="<%=tmpAction.getId()%>" <%=actionSelected%>><%=StringEscapeUtils.escapeHtml(tmpAction.getName())%></option>
                                            <% }%>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td width=150 align="right"><b>Sub Flowchart: </b></td>
                                    <td width=350 align="left">
                                        &nbsp;
                                        <select id="cbSubFlowchartId" name="cbSubFlowchartId" class="psadtext">
                                            <option value="0">--- Please select a Process ---</option>
                                            <%
                                                for (int a = 0; a < flowchartList.size(); a++) {
                                                    EngineFlowChart engFlowchart = flowchartList.get(a);
                                                    String subFlowchartSelected = "";
                                                    if (subFlowchartId == engFlowchart.getId()) {
                                                        subFlowchartSelected = "selected";
                                                    }
                                            %>
                                            <option value="<%=engFlowchart.getId()%>" <%=subFlowchartSelected%>><%=StringEscapeUtils.escapeHtml(engFlowchart.getName())%></option>
                                            <% }%>
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
                </table>
            </form>
            <br><br><br><br>
        </div>
    </body>
</html>