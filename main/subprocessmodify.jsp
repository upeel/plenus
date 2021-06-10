<%-- 
    Document   : subprocessmodify
    Created on : Jul 16, 2014, 2:56:08 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%
    String adminModName = "";
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

    adminModName = request.getParameter("txtAdminModName");
    if (adminModName == null) {
        adminModName = "";
    }
    action = request.getParameter("hidAction");
    if (action == null) {
        action = "";
    }
    String parentId = request.getParameter("parentId");

    if (parentId == null) {
        parentId = "0";
    }
    parentId = parentId.trim();
    if (parentId.equalsIgnoreCase("")) {
        parentId = "0";
    }

    int intParentId = Integer.parseInt(parentId);

    SubProcessController subProcCtrl = new SubProcessController();
    SubProcessHeader subProc = subProcCtrl.getSubProcessHeaderInfoByHeaderId(intParentId);

    String subProcessName = request.getParameter("txtSubProcessName");
    if (subProcessName == null) {
        subProcessName = "";
    }

    String strActionid = request.getParameter("cbActionId");
    if (strActionid == null) {
        strActionid = "0";
    }
    strActionid = strActionid.trim();
    if (strActionid.equals("")) {
        strActionid = "0";
    }
    int actionId = Integer.parseInt(strActionid);

    ArrayList<com.bizmann.product.entity.Action> actionList = new ArrayList<com.bizmann.product.entity.Action>();
    if (subProc.getFlowchart_id() > 0) {
        actionList = subProcCtrl.getAllActionNotInUseByFlowchartIdByHeaderId(subProc.getFlowchart_id(), intParentId);
    }

    com.bizmann.product.controller.UserController uCtrl = new com.bizmann.product.controller.UserController();
    String loginid = (String) session.getAttribute("user");
    int userId = uCtrl.getUserIdByLoginId(loginid);

    if (subProcessName.equals("")) {
        subProcessName = subProc.getName();
    }

    if (actionId == 0) {
        actionId = subProc.getTrigger_action_id();
    }

    if (action.equalsIgnoreCase("update")) {
        subProcCtrl.updateSubProcessHeader(intParentId, subProcessName, actionId, userId);
        msg="Sub Process Properties have been updated!";
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
                    parent.document.location.href = "subprocessdesigner.jsp?type="+type+"&subtype="+subtype;
                }
            }

            function flowChartValidated(){
                if(document.getElementById("txtSubProcessName").value == ""){
                    parent.frames.alertMessage("Please give the module name.");
                    return false;
                }else if(document.getElementById("cbActionId").value == '0') {
                    parent.frames.alertMessage("Please select an action to trigger process.");
                    return false;
                }else{
                    return true;
                }
            }

            function fnUpdate(){
                if(flowChartValidated() == true){
                    document.getElementById("hidAction").value="update";
                    document.getElementById("type").value= "<%=type%>";
                    document.getElementById("subtype").value= "<%=subtype%>";
                    document.frmSubProc.method = "post";
                    document.frmSubProc.submit();
                }
            }
        </script>
    </head>
    <body onload="fnOnLoad()">
        <div align="center" valign="top">
            <form name="frmSubProc" method="POST" action="subprocessmodify.jsp">
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
                            <input type="hidden" id="parentId" name="parentId" value="<%=parentId%>">
                            &nbsp;<input type="text" id="txtSubProcessName" name="txtSubProcessName" value="<%=subProcessName%>" size="30" class="psadtext">
                        </td>
                    </tr>
                    <tr>
                        <td width=150 align="right"><b>Main Flowchart: </b></td>
                        <td width=350 align="left">
                            &nbsp;
                            <select id="cbFlowchartId" name="cbFlowchartId" class="psadtext" disabled>
                                <!--                                            <option value="0">--- Please select a Process ---</option>-->
                                <option value="<%=subProc.getFlowchart_id()%>" selected><%=StringEscapeUtils.escapeHtml(subProc.getFlowchart_name())%></option>
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
                            <select id="cbSubFlowchartId" name="cbSubFlowchartId" class="psadtext" disabled>
                                <!--                                            <option value="0">--- Please select a Process ---</option>-->
                                <option value="<%=subProc.getSub_flowchart_id()%>" selected><%=StringEscapeUtils.escapeHtml(subProc.getSub_flowchart_name())%></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td width=150 align="right">&nbsp;</td>
                        <td width=350 align="left">&nbsp;</td>
                    </tr>
                    <tr>
                        <td width=150 align="right">&nbsp;</td>
                        <td width=350 align="left">&nbsp;
                            <input type="button" value="Update" name="btnUpdate" id="btnUpdate" class="psadbutton" width="100" onclick="fnUpdate()">
                        </td>
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
