<%-- 
    Document   : flowchartlibrarymodify
    Created on : Apr 30, 2009, 3:36:13 PM
    Author     : Tan Chiu Ping
--%>

<%@ page
    import = "java.util.*"
    import = "java.lang.*"
    import = "com.bizmann.product.controller.*"
    import = "com.bizmann.product.entity.*"
    import = "com.bizmann.product.resources.*"
    %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<%
        UserController uCtrl = new UserController();
        String loginid = (String) session.getAttribute("user");
        int userId = uCtrl.getUserIdByLoginId(loginid);

        String flowChartId = request.getParameter("flowChartId");
        if (flowChartId == null) {
            flowChartId = "";
        }
        
        String action = request.getParameter("action");
        if(action == null){
            action = "";
        }

        if(action.equals("modify")){
            //get the current type and subtype
            String type = request.getParameter("type");
            String subtype = request.getParameter("subtype");

            //get the flowchart data
            String flowChartName = request.getParameter("flowChartName");

            //update the permissions
            EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();
            String existingFormName = engineFlowChartCtrl.getFlowChartName(Integer.parseInt(flowChartId));

            //no longer needed
            //rename the flowchart name in the permission table
            //InitiateProcessController initProcessCtrl = new InitiateProcessController();
            //initProcessCtrl.renameFlowChartName(flowChartName, existingFormName);
            //ExternalReportController extRptCtrl = new ExternalReportController();
            //extRptCtrl.renameFlowChartName(flowChartName, existingFormName);
            //ReportController rptCtrl = new ReportController();
            //rptCtrl.renameFlowChartName(flowChartName, existingFormName);
            //SearchController searchCtrl = new SearchController();
            //searchCtrl.renameFlowChartName(flowChartName, existingFormName);
            //MonitorController monCtrl = new MonitorController();
            //monCtrl.renameFlowChartName(flowChartName, existingFormName);

             //update the database
            engineFlowChartCtrl.updateFlowChart(flowChartName, Integer.parseInt(flowChartId), userId);
            
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
        <script type="text/javascript" src="../include/js/url.js"></script>
        
        <script>

            var formName;
            var formId;
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"

            function fnOnLoad(){
                if(action == "modify"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "flowchartlibrary.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "flowchartlibrary.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }

            function fnSubmit(){
                if(flowChartValidated() == true){
                    var flowChartName = fnURLEncode(document.getElementById("txtFlowChartName").value);
                    flowChartId= "<%=flowChartId%>";
                    document.location.href = "flowchartlibrarymodify.jsp?type="+type+"&subtype="+subtype+"&action=modify&flowChartName="+flowChartName+"&flowChartId="+flowChartId;
                }
            }

            function flowChartValidated(){
                if(document.getElementById("txtFlowChartName").value == ""){
                     parent.frames.alertMessage("Please enter form name.");
                     return false;
                }
                else if((document.getElementById("txtFlowChartName").value).length >100){
                    parent.frames.alertMessage("Please enter form name with 100 characters or less.");
                    return false;
                }
                else{
                    return true;
                }
            }
            
        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png" style="width:650px">
        <% if(flowChartId.equals("")){%>
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
                                        Modify Flowchart<br><br>
                                </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtId" name="txtFormId" size="30" class="psadview" value="F<%=ResourceUtil.getVersionFormat(engineFlowChart.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFlowChartName" name="txtFormName" size="30" class="psadtext" value="<%=engineFlowChart.getName()%>"></td>
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
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Modify" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%}%>
    </body>
</html>

