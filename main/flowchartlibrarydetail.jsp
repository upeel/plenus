<%--
    Document   : formlibrarysub
    Created on : Apr 29, 2009, 4:56:55 PM
    Author     : Tan Chiu Ping
--%>

<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.entity.*"
        import = "com.bizmann.product.resources.*"
        import = "com.bizmann.flowchart.controller.*"
        import = "com.bizmann.admin.controller.AdminFormLimitController" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%
    UserController uCtrl = new UserController();
    String loginid = (String) session.getAttribute("user");
    int userId = uCtrl.getUserIdByLoginId(loginid);

    String flowChartId = request.getParameter("flowChartId");
    if (flowChartId == null) {
        flowChartId = "0";
    }
    String formId = request.getParameter("formId");
    if (formId == null) {
        formId = "0";
    }

    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    String errMessage = "";
    if (action.equals("activate")) {
        AdminFormLimitController aflCtrl = new AdminFormLimitController();
        if (aflCtrl.checkFormActivationLimitReached()) {
            errMessage = "formLimitReached();";
        } else {
            EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();
            boolean isActivated = engineFlowChartCtrl.activateFlowChart(Integer.parseInt(flowChartId), Integer.parseInt(formId), userId);
            if(!isActivated){
                errMessage = "activationFailed();";
            }
        }
    } else if (action.equals("deactivate")) {
        FlowChartActivationController fcActivationCtrl = new FlowChartActivationController();
        if (fcActivationCtrl.isDeactivatable(Integer.parseInt(flowChartId))) {
            EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();
            engineFlowChartCtrl.deactivateFlowChart(Integer.parseInt(flowChartId), Integer.parseInt(formId), userId);
        } else {
            errMessage = "unableToDeactivate();";
        }
    }
%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <title>bmFLO</title>

        <script>
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"

            function fnOnLoad(){
                if(action == "version"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "flowchartlibrary.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "flowchartlibrary.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }

            function fnActivate(){
                if(formValidated() == true){
                    flowChartId= "<%=flowChartId%>";
                    var formId = document.getElementById("txtFormId").value;
                    document.location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&action=activate&flowChartId="+flowChartId+"&formId="+formId;
                }
            }

            function fnDeactivate(){
                flowChartId= "<%=flowChartId%>";
                var formId = document.getElementById("txtFormId").value;
                document.location.href = "flowchartlibrarydetail.jsp?type="+type+"&subtype="+subtype+"&action=deactivate&flowChartId="+flowChartId+"&formId="+formId;
            }

            function fnProperties(){
                flowChartId= "<%=flowChartId%>";
                document.location.href = "flowchartlibraryproperties.jsp?type="+type+"&subtype="+subtype+"&action=showproperties&flowChartId="+flowChartId;
            }
                
            function fnAttributes(){
                flowChartId= "<%=flowChartId%>";
                var formId = document.getElementById("txtFormId").value;
                //window.open('flowchartlibraryattributes.jsp?flowChartId='+flowChartId+"&formId="+formId);
                document.location.href = "flowchartlibraryactions.jsp?type="+type+"&subtype="+subtype+"&action=showattributes&flowChartId="+flowChartId+"&formId="+formId;
            }
                
            function fnAutoGen(){
                flowChartId= "<%=flowChartId%>";
                var formId = document.getElementById("txtFormId").value;
                //window.open('flowchartlibraryattributes.jsp?flowChartId='+flowChartId+"&formId="+formId);
                document.location.href = "genassignform.jsp?type="+type+"&subtype="+subtype+"&action=showattributes&flowChartId="+flowChartId+"&formId="+formId;
            }
            
            function fnDashboard(){
                flowChartId= "<%=flowChartId%>";
                var formId = document.getElementById("txtFormId").value;
                //window.open('flowchartlibraryattributes.jsp?flowChartId='+flowChartId+"&formId="+formId);
                document.location.href = "workcolumn.jsp?type="+type+"&subtype="+subtype+"&action=showattributes&flowChartId="+flowChartId+"&formId="+formId;
            }

            function formValidated(){
                if(document.getElementById("txtFlowChartIsActivated").value == "Yes"){
                    parent.frames.alertMessage("The flow chart is already activated.");
                    return false;
                }
                else{
                    return true;
                }
            }
            
            function formLimitReached(){
                parent.frames.alertMessage("Flowchart Activation Limit has Reached!");
            }
            
            function unableToDeactivate(){
                parent.frames.alertMessage("Unable to Deactivate! Oustanding processes remaining!");
            }
            
            function activationFailed(){
                 parent.frames.alertMessage("Flowchart Activation Failed! Please contact the Site Administrator!");
            }
        </script>

    </head>
    <body onload="fnOnLoad()" background="../images/background.png" style="width:650px">
        <% if (flowChartId.equals("0")) {%>
        <!-- Leave it blank -->
        <%} else {
            EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();
            EngineFlowChart engineFlowChart = engineFlowChartCtrl.getEngineFlowChart(Integer.parseInt(flowChartId));
            UserController userCtrl = new UserController();
        %>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br>
                        <table>
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Flow Chart Details<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFlowChartId" name="txtFormId" size="30" class="psadview" value="F<%=ResourceUtil.getVersionFormat(engineFlowChart.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFlowChartName" name="txtFormName" size="30" class="psadview" value="<%=engineFlowChart.getName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Form Name:</b></td>
                                <td width=350 align="left">&nbsp;
                                    <input type="text" id="txtFormName" name="txtFormName" size="30" class="psadview" value="<%=engineFlowChart.getFormName()%>" readonly>
                                    <input type="hidden" id="txtFormId" name="txtFormId" size="30" class="psadview" value="<%=engineFlowChart.getFormId()%>" readonly>
                                </td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Is Activated:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFlowChartIsActivated" name="txtFormIsActivated" size="30" class="psadview" value="<%=FlowChartUtil.getIsPublishedString(engineFlowChart.getIspublished())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFlowChartCreatedDate" name="txtFormCreatedDate" size="30" class="psadview" value="<%=engineFlowChart.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFlowChartCreatedBy" name="txtFormCreatedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(engineFlowChart.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFlowChartModifiedDate" name="txtFormModifiedDate" size="30" class="psadview" value="<%=engineFlowChart.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFlowChartModifiedBy" name="txtFormModifiedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(engineFlowChart.getModifiedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr align="center">
                                <td colspan="2" align="center">                                       
                                    <% if (engineFlowChart.getIspublished() == 0) {%>
                                    &nbsp;<input type="button" value="Activate" name="btnActivate" class="psadbutton" width="100" onclick="fnActivate()">
                                    <%} else {%>
                                    &nbsp;<input type="button" value="Deactivate" name="btnDeactivate" class="psadbutton" width="100" onclick="fnDeactivate()">
                                    <%}%>
                                    &nbsp;<input type="button" value="Properties" name="btnProperties" class="psadbutton" width="100" onclick="fnProperties()">
                                    &nbsp;<input type="button" value="Form Attributes" name="btnAttributes" class="psadbutton" width="100" onclick="fnAttributes()">
                                    &nbsp;<input type="button" value="Auto Gen # Assign" id="btnAutoGen" name="btnAutoGen" class="psadbutton" width="100" onclick="fnAutoGen()">
                                    &nbsp;<input type="button" value="Dashboard" id="btnDashboard" name="btnDashboard" class="psadbutton" width="100" onclick="fnDashboard()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%}%>
        <script>
            <%=errMessage%>
        </script>
    </body>
</html>
