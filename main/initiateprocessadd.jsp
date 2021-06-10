<%--
    Document   : initiateprocessadd
    Created on : Jun 30, 2009, 10:52:26 AM
    Author     : Nilar
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*" %>

<%
    EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();

    OrgUnitController ouCtrl = new OrgUnitController();
    UserController uCtrl = new UserController();
    InitiateProcessController iCtrl = new InitiateProcessController();
    //ReportController rCtrl = new ReportController();
    SearchController sCtrl = new SearchController();
    MonitorController mCtrl = new MonitorController();
    //ExternalReportController eCtrl = new ExternalReportController();
    AdminTaskController aCtrl = new AdminTaskController();
    //ArrayList fNameEPList = eCtrl.getAllReportNameFromEP();
    ArrayList fNameAPList = aCtrl.getAllAdminTasksfromEP();

    ArrayList list = engineFlowChartCtrl.getAllFlowCharts();
    EngineFlowChart engineFlowChart = new EngineFlowChart();

    ExternalReport exreport = new ExternalReport();
    AdminTask adminTask = new AdminTask();
    OrgUnit orgunit = new OrgUnit();
    ArrayList listOrgUnit = ouCtrl.getOrgUnitName();
    User user = new User();
    ArrayList listUser = uCtrl.getUserName();
    String typePerName = "";

    String loginid = (String) session.getAttribute("user");
    int userId = uCtrl.getUserIdByLoginId(loginid);

    String pertype = request.getParameter("pertype");
    session.setAttribute("pertype", pertype);

    String permtype = request.getParameter("permissionType");
    session.setAttribute("permtype", permtype);

    String accessname = request.getParameter("accessName");
    session.setAttribute("accessname", accessname);

    ArrayList listUserName = uCtrl.getUserName();
    ArrayList listOrgName = ouCtrl.getOrgUnitName();

    boolean isDuplicate = false;
    boolean isDuplicatePermission = false;
    boolean isDuplicateOuPermission = false;
    String msg = "";
    String msgPermission = "";

    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    if (action.equals("add")) {
        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");

        //get the form data
        String formName = request.getParameter("formName");
        if (formName == null) {
            formName = "0";
        }
        formName = formName.trim();
        if (formName.equals("")) {
            formName = "0";
        }

        int formId = Integer.parseInt(formName);

        String accessTypeString = request.getParameter("prima");
        String perType = request.getParameter("perType");
        String perIdString = request.getParameter("perId");
        int accessType = new Integer(accessTypeString).intValue();
        int perId = new Integer(perIdString).intValue();
        String permissionType = request.getParameter("permissionType");
        String accessName = request.getParameter("accessName");

        //update the database
        if (permissionType.equals("iniProcess")) {
            InitiateProcessController ipCtrl = new InitiateProcessController();
            isDuplicate = ipCtrl.isDuplicateName(accessName);
            isDuplicatePermission = ipCtrl.isDuplicatePermission(formId, accessType, perId, perType);
            if (isDuplicate) {
                msg = "This Initiate Process Name already exists.";
            } else if (isDuplicatePermission) {
                msgPermission = "This Initiate Process Permission already exists.";
            } else {
                msg = "";
                msgPermission = "";
                InitAccess initAccess = new InitAccess(accessName, formName, accessType, perId, perType);
                initAccess.setFlowChartId(formId);
                iCtrl.addInitAccess(initAccess, userId);
            }
        } else if (permissionType.equals("report")) {
            //isDuplicate = rCtrl.isDuplicateName(accessName);
            //isDuplicatePermission = rCtrl.isDuplicatePermission(formName, accessType, perId, perType);

            if (isDuplicate) {
                msg = "This Report Name already exists.";
            } else if (isDuplicatePermission) {
                msgPermission = "This Report Process Permission already exists.";
            } else {
                msg = "";
                msgPermission = "";
                ReportAccess reportAccess = new ReportAccess(accessName, formName, accessType, perId, perType);
                //rCtrl.addReportAccess(reportAccess, userId);
            }
        } else if (permissionType.equals("searchProcess")) {
            isDuplicate = sCtrl.isDuplicateName(accessName);
            isDuplicatePermission = sCtrl.isDuplicatePermission(formName, accessType, perId, perType);
            if (isDuplicate) {
                msg = "This Search Process Name already exists.";
            } else if (isDuplicatePermission) {
                msgPermission = "This Search Process Permission already exists.";
            } else {
                msg = "";
                msgPermission = "";
                SearchAccess searchAccess = new SearchAccess(accessName, formName, accessType, perId, perType);
                sCtrl.addSearchAccess(searchAccess, userId);
            }
        } else if (permissionType.equals("monitor")) {
            isDuplicate = mCtrl.isDuplicateName(accessName);
            isDuplicatePermission = mCtrl.isDuplicatePermission(formName, accessType, perId, perType);
            if (isDuplicate) {
                msg = "This Audit Trail Name already exists.";
            } else if (isDuplicatePermission) {
                msgPermission = "This Audit Trail Process Permission already exists.";
            } else {
                msg = "";
                msgPermission = "";
                MonitorAccess monitorAccess = new MonitorAccess(accessName, formName, accessType, perId, perType);
                mCtrl.addMonitorAccess(monitorAccess, userId);
            }
        } else if (permissionType.equals("exReport")) {
            ExternalReportController erCtrl = new ExternalReportController();
            isDuplicate = erCtrl.isDuplicateName(accessName);
            isDuplicatePermission = erCtrl.isDuplicatePermission(formName, accessType, perId, perType);
            if (isDuplicate) {
                msg = "This External Report Name already exists.";
            } else if (isDuplicatePermission) {
                msgPermission = "This External Report Process Permission already exists.";
            } else {
                msg = "";
                msgPermission = "";
                ExternalReportAccess exReportAccess = new ExternalReportAccess(accessName, formName, accessType, perId, perType);
                //eCtrl.addExReportAccess(exReportAccess, userId);
            }
        } else if (permissionType.equals("adminTask")) {
            AdminTaskController arCtrl = new AdminTaskController();
            isDuplicate = arCtrl.isDuplicateName(accessName);
            isDuplicatePermission = arCtrl.isDuplicatePermission(formName, accessType, perId, perType);
            if (isDuplicate) {
                msg = "This Admin Task Name already exists.";
            } else if (isDuplicatePermission) {
                msgPermission = "This Admin Task Process Permission already exists.";
            } else {
                msg = "";
                msgPermission = "";
                AdminTaskAccess adminTaskAccess = new AdminTaskAccess(accessName, formName, accessType, perId, perType);
                aCtrl.addAdminTaskAccess(adminTaskAccess, userId);
            }
        }
    }
%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
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

        <script type='text/javascript' src='/prosesadv/dwr/interface/Helper.js'></script>
        <script type='text/javascript' src='/prosesadv/dwr/util.js'></script>
        <script type='text/javascript' src='/prosesadv/dwr/engine.js'></script>
        <script type="text/javascript" src="../include/js/url.js"></script>
        <script>

            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"
            function onPermittedTypeChange(typePerName){

                if(typePerName=="User")
                {
                    document.getElementById("user").style.visibility="visible";
                    document.getElementById("user").style.display="inline";
                    document.getElementById("orgunit").style.visibility="hidden";
                    document.getElementById("orgunit").style.display="none";
                    document.getElementById("selOrgunit").disabled=true;
                    document.getElementById("selUser").disabled=false;
                }
                if(typePerName=="Organisation Unit")
                {
                    document.getElementById("orgunit").style.visibility="visible";
                    document.getElementById("orgunit").style.display="inline";
                    document.getElementById("user").style.visibility="hidden";
                    document.getElementById("user").style.display="none";
                    document.getElementById("selOrgunit").disabled=false;
                    document.getElementById("selUser").disabled=true;
                }
            }

            function getCheckedValue(radioObj) {
                if(!radioObj)
                    return "";
                var radioLength = radioObj.length;
                if(radioLength == undefined)
                    if(radioObj.checked)
                        return radioObj.value;
                else
                    return "";
                for(var i = 0; i < radioLength; i++) {
                    if(radioObj[i].checked) {
                        return radioObj[i].value;
                    }
                }
                return "";
            }

            function changeNameByPerType(pertype){
                var pertype;
                var accessName=fnURLEncode(document.getElementById("txtName").value);
                var permissionType=document.getElementById("permissiontype").value;
                document.location.href = "initiateprocessadd.jsp?type="+type+"&subtype="+subtype+"&pertype="+pertype+"&permissionType="+permissionType+"&accessName="+accessName;
            }

            function fnOnLoad(){

                if(action == "add"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.location.href = "flowchartpermission.jsp?type="+type;
                    }
                    else{
                        if(document.getElementById("msg").value != "" && document.getElementById("msg").value != "null"){
                            parent.frames.alertMessage("<%=msg%>");
                            document.location.href = "initiateprocessadd.jsp?type="+type+"&subtype="+subtype;
                        }
                        else if(document.getElementById("msgPermission").value != "" && document.getElementById("msgPermission").value != "null"){
                            parent.frames.alertMessage("<%=msgPermission%>");
                            document.location.href = "initiateprocessadd.jsp?type="+type+"&subtype="+subtype;
                        }
                        else{
                            parent.location.href = "flowchartpermission.jsp?type="+type+"&subtype="+subtype;
                        }
                    }
                }
            }

            function formValidated(){
                var perType=document.getElementById("pertype").value;
                var perId="";
                if(perType=="User"){
                    var perId=document.getElementById("selUser").value;
                }else if(perType=="Organisation Unit"){
                    var perId=document.getElementById("selOrgunit").value;
                }
                if(fnURLEncode(document.getElementById("txtName").value)==""){
                    parent.frames.alertMessage("Please provide form permission name.");
                    return false;
                }
                else if((fnURLEncode(document.getElementById("txtName").value)).length > 100){
                    parent.frames.alertMessage("Please provide form permission name with 100 characters or less.");
                    return false;
                }
                if(document.getElementById("permissiontype").value==""){
                    parent.frames.alertMessage("Please select permission type.");
                    return false;
                }
                if(document.getElementById("formid").value == "0"){
                    parent.frames.alertMessage("Please select form name.");
                    return false;
                }
                if(perType== ""){
                    parent.frames.alertMessage("Please select permitted to.");
                    return false;
                }
                if(perId==""){
                    parent.frames.alertMessage("Please select permitted name.");
                    return false;
                }
                else{
                    return true;
                }
            }

            function fnSubmit(){
                if(formValidated() == true){
                    //get the form data
                    var formName = fnURLEncode(document.getElementById("formid").value);
                    var perType=document.getElementById("pertype").value;
                    var permissionType=document.getElementById("permissiontype").value;
                    var accessName=fnURLEncode(document.getElementById("txtName").value);

                    var prima = document.getElementById("accessType").value;
                    if(perType=="User"){
                        var perId=document.getElementById("selUser").value;
                    }else if(perType=="Organisation Unit"){
                        var perId=document.getElementById("selOrgunit").value;
                    }
                    document.location.href = "initiateprocessadd.jsp?type="+type+"&subtype="+subtype+"&action=add&formName="+formName+"&prima="+prima+"&perId="+perId+"&perType="+perType+"&permissionType="+permissionType+"&accessName="+accessName;
                }
            }

        </script>
    </head>

    <body onload="fnOnLoad()" class="yui-skin-sam" background="../images/background.png">
        <!-- alert message -->
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br><table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Add Form Permission<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;
                                    <input type="text" id="txtName" name="txtName"
                                           <%
                                               String sessionAccessName = (String) session.getAttribute("accessname");
                                               if (sessionAccessName == null) {
                                                   sessionAccessName = "0";
                                               }
                                               String sessionPerMType = (String) session.getAttribute("permtype");
                                               if (sessionPerMType == null) {
                                                   sessionPerMType = "0";
                                               }
                                               if (sessionPerMType.equals("iniProcess") || sessionPerMType.equals("report") || sessionPerMType.equals("searchProcess") || sessionPerMType.equals("monitor") || sessionPerMType.equals("exReport") || sessionPerMType.equals("adminTask")) {
                                           %>value="<%=sessionAccessName%>"
                                           <%
                                               }
                                           %>
                                           size="30" class="psadtext">
                                    <input type="hidden" id="txtName" name="txtName">
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permission Type :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="permissiontype" name="permissiontype" style="" onchange="changeNameByPerType(this.value);">
                                        <option> </option>
                                        <%
                                            sessionPerMType = (String) session.getAttribute("permtype");
                                            if (sessionPerMType == null) {
                                                sessionPerMType = "0";
                                            }
                                        %>
                                        <option value="iniProcess"
                                                <%
                                                    if (sessionPerMType.equals("iniProcess")) {
                                                        out.print("SELECTED");
                                                %>
                                                ><b>Initiate Process</b></option>
                                        <%
                                        } else {
                                        %>
                                        ><b>Initiate Process</b></option>
                                        <%                            }
                                        %>
                                        <option value="searchProcess"
                                                <%
                                                    if (sessionPerMType.equals("searchProcess")) {
                                                        out.print("SELECTED");
                                                %>
                                                ><b>Search Process</b></option>
                                        <%
                                        } else {
                                        %>
                                        ><b>Search Process</b></option>
                                        <%                            }
                                        %>
                                        <option value="monitor"
                                                <%
                                                    if (sessionPerMType.equals("monitor")) {
                                                        out.print("SELECTED");
                                                %>
                                                ><b>Audit Trail</b></option>
                                        <% } else {%>
                                        ><b>Audit Trail</b></option>
                                        <% }%>

                                        <option value="adminTask"searchProcess
                                                <%
                                                    if (sessionPerMType.equals("adminTask")) {
                                                        out.print("SELECTED");
                                                %>
                                                ><b>Admin Task</b></option>
                                        <%
                                        } else {
                                        %>
                                        ><b>Admin Task</b></option>
                                        <%                            }
                                        %>
                                    </select>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="formid" name="formid" style="" >
                                        <option value="0"> </option>
                                        <%
                                            String sessionPerType = (String) session.getAttribute("pertype");
                                            if (sessionPerType == null) {
                                                sessionPerType = "0";
                                            }
                                            if (sessionPerType.equals("iniProcess") || sessionPerType.equals("report") || sessionPerType.equals("searchProcess") || sessionPerType.equals("monitor")) {
                                                for (int j = 0; j < list.size(); j++) {
                                                    //form = (Form) list.get(j);    //Nilar's codes
                                                    engineFlowChart = (EngineFlowChart) list.get(j);

                                        %>
                                        <!-- Change the form.getName() to engineFlowChart.getName() -->
                                        <option value="<%= engineFlowChart.getId()%>" ><%= engineFlowChart.getName()%></option>
                                        <%}
                                        } else if (sessionPerType.equals("adminTask")) {
                                            for (int j = 0; j < fNameAPList.size(); j++) {
                                                adminTask = (AdminTask) fNameAPList.get(j);
                                        %>
                                        <option value="<%=adminTask.getId()%>" ><%= adminTask.getName()%></option>
                                        <%
                                            }
                                        }%>
                                    </select>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select class="psadtext" size="1" id="pertype" name="pertype" style="" onChange="onPermittedTypeChange(this.value);">
                                        <option> </option>
                                        <option value="User"><b>User</b></option>
                                        <option value="Organisation Unit"><b>Organisation Unit</b></option>
                                    </select>
                            </tr>
                            <tr>
                                </td>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <div id="user" style="display:inline">
                                        <select size="1" id="selUser" name="perid" style="" >
                                            <option> </option>
                                            <%
                                                for (int j = 0; j < listUserName.size(); j++) {
                                                    user = (User) listUserName.get(j);
                                            %>
                                            <option value="<%=user.getUserId()%>" ><%= user.getFullName()%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                    <div id="orgunit" style="visibility:hidden;display:none">
                                        <select size="1" id="selOrgunit" name="perid" style="" >
                                            <option> </option>
                                            <%
                                                for (int j = 0; j < listOrgName.size(); j++) {
                                                    orgunit = (OrgUnit) listOrgName.get(j);
                                            %>
                                            <option value="<%=orgunit.getId()%>" ><%= orgunit.getName()%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">&nbsp;</td>
                                <td align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="right">&nbsp;</td>
                                <td align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="right">&nbsp;</td>
                                <td align="left">&nbsp;<input type="button" value="Add" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()"></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <input type="hidden" name="accessType" value="0" id="accessType"/>
        <input type="hidden" value="<%=msg%>" name="msg" id="msg" />
        <input type="hidden" value="<%=msgPermission%>" name="msg" id="msgPermission" />
    </body>
</html>
