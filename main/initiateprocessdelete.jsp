<%--
    Document   : initiateprocessdelete
    Created on : Jul 2, 2009, 2:55:12 PM
    Author     : Nilar
--%>

<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.entity.*"
        import = "com.bizmann.product.resources.*"
        %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%
    EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();
    ArrayList list = engineFlowChartCtrl.getAllFlowCharts();
    EngineFlowChart engineFlowChart = new EngineFlowChart();

    OrgUnit orgunit = new OrgUnit();
    OrgUnitController ouCtrl = new OrgUnitController();
    ArrayList listOrgUnit = ouCtrl.getOrgUnitName();
    User user = new User();
    UserController uCtrl = new UserController();
    ArrayList listUser = uCtrl.getUserName();
    InitiateProcessController iCtrl = new InitiateProcessController();
    ReportController reportController = new ReportController();
    SearchController searchController = new SearchController();
    MonitorController monitorController = new MonitorController();
    ExternalReportController exReportController = new ExternalReportController();
    AdminTaskController adminTaskController = new AdminTaskController();

    String loginid = (String) session.getAttribute("user");
    int userId = uCtrl.getUserIdByLoginId(loginid);

    String iniProId = request.getParameter("iniProId");
    if (iniProId == null) {
        iniProId = "";
    }

    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    if (action.equals("delete")) {

        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");

        //get the form data
        String idString = request.getParameter("iniProId");
        int id = new Integer(idString).intValue();
        String parentId = (String) session.getAttribute("parentId");

        session.setAttribute("parentId", parentId);

        //update the database
        if (parentId.equals("0")) {
            iCtrl.deleteInitAccess(id, userId);
        } else if (parentId.equals("1")) {
            reportController.deleteReportAccess(id, userId);
        } else if (parentId.equals("2")) {
            searchController.deleteSearchAccess(id, userId);
        } else if (parentId.equals("3")) {
            monitorController.deleteMonitorAccess(id, userId);
        } else if (parentId.equals("4")) {
            exReportController.deleteExReportAccess(id, userId);
        } else if (parentId.equals("5")) {
            adminTaskController.deleteAdminTaskAccess(id, userId);
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
            var subtype = "<%=request.getParameter("subtype")%>";
            var iniProId= "<%=request.getParameter("iniProId")%>";

            function fnOnLoad(){
                if(action == "delete"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "flowchartpermission.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "flowchartpermission.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }

            function formValidated(){
                if(document.getElementById("formid").value == ""|| document.getElementById("pertype").value=="" || document.getElementById("perid").value == ""){
                    parent.frames.alertMessage("Please select all fields.");
                    return false;
                }
                else{
                    return true;
                }
            }

            function fnSubmit(){
                if(formValidated() == true){
                    //get the form data
                    var formId = document.getElementById("formid").value;
                    var accessType=document.getElementById("accessType").value;
                    var perType=document.getElementById("pertype").value;
                    var perId=document.getElementById("perid").value;
                    var iniProId= "<%=request.getParameter("iniProId")%>";
                    var parentId= "<%=session.getAttribute("parentId")%>";

                    //update the form in the database
                    parent.frames.promptMessage(type, subtype, "delete", "Are you sure you want to delete the flow chart permission?");
                }
            }
        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png">
        <%
            if (iniProId.equals("") || iniProId.equals("0")) {%>
        <!-- Leave it blank -->
        <%} else {
            String parentId = (String) session.getAttribute("parentId");
            if (parentId.equals("0")) {
                InitAccess initAccess = iCtrl.getInitAccessById(Integer.parseInt(iniProId));
                UserController userCtrl = new UserController();
                ArrayList listUserName = uCtrl.getUserNameByPermittedId(Integer.parseInt(iniProId));
                user = new User();
                ArrayList listFormName = engineFlowChartCtrl.getFlowChartByInitAccessId(Integer.parseInt(iniProId));
                engineFlowChart = new EngineFlowChart();
                ArrayList listPermittedType = iCtrl.getPermittedTypeByInitAccessId(Integer.parseInt(iniProId));
                InitAccess iniPermittedType = new InitAccess();
                ArrayList listOrgName = ouCtrl.getOrgUnitNameByInitAccessId(Integer.parseInt(iniProId));
                OrgUnit orgUnit = new OrgUnit();
        %>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br>
                        <table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Delete Initiate Process<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getIAVersionFormat(initAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadview" value="<%=initAccess.getName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value ="formid" id="formid" name="formid" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listFormName.size(); j++) {
                                                engineFlowChart = (EngineFlowChart) listFormName.get(j);
                                        %>
                                        <option value="<%=engineFlowChart.getName()%>" ><%=engineFlowChart.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select value="pertype" id="pertype" name="pertype" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listPermittedType.size(); j++) {
                                                iniPermittedType = (InitAccess) listPermittedType.get(j);

                                        %>
                                        <option value="<%=initAccess.getPermittedtype()%>" ><%= initAccess.getPermittedtype()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value="perid" id="perid" name="perid" disabled="disabled" style="">
                                        <%
                                            String permittedType = initAccess.getPermittedtype();
                                            if (permittedType.equals("User")) {
                                                for (int j = 0; j < listUserName.size(); j++) {
                                                    user = (User) listUserName.get(j);

                                        %>
                                        <option value="<%=user.getFirstName()%>" ><%= user.getFirstName()%>&nbsp;<%= user.getMiddleName()%>&nbsp;<%= user.getLastName()%></option>
                                        <%
                                            }
                                        } else if (permittedType.equals("Organisation Unit")) {
                                            for (int j = 0; j < listOrgName.size(); j++) {
                                                orgUnit = (OrgUnit) listOrgName.get(j);
                                        %>
                                        <option value="<%=orgUnit.getName()%>" ><%=orgUnit.getName()%></option>
                                        <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedDate" name="txtFooterCreatedDate" size="30" class="psadview" value="<%=initAccess.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedBy" name="txtFooterCreatedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(initAccess.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedDate" name="txtFooterModifiedDate" size="30" class="psadview" value="<%=initAccess.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedBy" name="txtFooterModifiedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(initAccess.getModifiedBy())%>" readonly></td>
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
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Delete" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%
        } else if (parentId.equals("1")) {
            ReportController reportCtrl = new ReportController();
            ReportAccess reportAccess = reportCtrl.getReportAccessById(Integer.parseInt(iniProId));
            UserController userCtrl = new UserController();
            ArrayList listUserName = reportCtrl.getUserNameByPermittedId(Integer.parseInt(iniProId));
            user = new User();
            ArrayList listFormName = reportCtrl.getFlowChartNameByReportAccessId(Integer.parseInt(iniProId));
            engineFlowChart = new EngineFlowChart();
            ArrayList listPermittedType = reportCtrl.getPermittedTypeByReportAccessId(Integer.parseInt(iniProId));
            ReportAccess reportPermittedType = new ReportAccess();
            ArrayList listOrgName = reportCtrl.getOrgUnitNameByReportAccessId(Integer.parseInt(iniProId));
            OrgUnit orgUnit = new OrgUnit();
        %>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br>
                        <table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Delete Report<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getRAVersionFormat(reportAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadview" value="<%=reportAccess.getName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value ="formid" id="formid" name="formid" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listFormName.size(); j++) {
                                                engineFlowChart = (EngineFlowChart) listFormName.get(j);
                                        %>
                                        <option value="<%=engineFlowChart.getName()%>" ><%=engineFlowChart.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select value="pertype" id="pertype" name="pertype" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listPermittedType.size(); j++) {
                                                reportPermittedType = (ReportAccess) listPermittedType.get(j);

                                        %>
                                        <option value="<%=reportAccess.getPermittedType()%>" ><%= reportAccess.getPermittedType()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value="perid" id="perid" name="perid" disabled="disabled" style="">
                                        <%
                                            String permittedType = reportAccess.getPermittedType();
                                            if (permittedType.equals("User")) {
                                                for (int j = 0; j < listUserName.size(); j++) {
                                                    user = (User) listUserName.get(j);

                                        %>
                                        <option value="<%=user.getFirstName()%>" ><%= user.getFirstName()%>&nbsp;<%= user.getMiddleName()%>&nbsp;<%= user.getLastName()%></option>
                                        <%
                                            }
                                        } else if (permittedType.equals("Organisation Unit")) {
                                            for (int j = 0; j < listOrgName.size(); j++) {
                                                orgUnit = (OrgUnit) listOrgName.get(j);
                                        %>
                                        <option value="<%=orgUnit.getName()%>" ><%=orgUnit.getName()%></option>
                                        <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedDate" name="txtFooterCreatedDate" size="30" class="psadview" value="<%=reportAccess.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedBy" name="txtFooterCreatedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(reportAccess.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedDate" name="txtFooterModifiedDate" size="30" class="psadview" value="<%=reportAccess.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedBy" name="txtFooterModifiedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(reportAccess.getModifiedBy())%>" readonly></td>
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
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Delete" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%
        } else if (parentId.equals("2")) {
            SearchController searchCtrl = new SearchController();
            SearchAccess searchAccess = searchCtrl.getSearchById(Integer.parseInt(iniProId));
            UserController userCtrl = new UserController();
            ArrayList listUserName = searchCtrl.getUserNameByPermittedId(Integer.parseInt(iniProId));
            user = new User();
            ArrayList listFormName = searchCtrl.getFlowChartNameBySearchId(Integer.parseInt(iniProId));
            engineFlowChart = new EngineFlowChart();
            ArrayList listPermittedType = searchCtrl.getPermittedTypeBySearchId(Integer.parseInt(iniProId));
            SearchAccess searchPermittedType = new SearchAccess();
            ArrayList listOrgName = searchCtrl.getOrgUnitNameBySearchId(Integer.parseInt(iniProId));
            OrgUnit orgUnit = new OrgUnit();
        %>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br>
                        <table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Delete Search Process<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getSPVersionFormat(searchAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadview" value="<%=searchAccess.getName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value ="formid" id="formid" name="formid" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listFormName.size(); j++) {
                                                engineFlowChart = (EngineFlowChart) listFormName.get(j);
                                        %>
                                        <option value="<%=engineFlowChart.getName()%>" ><%=engineFlowChart.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select value="pertype" id="pertype" name="pertype" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listPermittedType.size(); j++) {
                                                searchPermittedType = (SearchAccess) listPermittedType.get(j);

                                        %>
                                        <option value="<%=searchAccess.getPermittedType()%>" ><%= searchAccess.getPermittedType()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value="perid" id="perid" name="perid" disabled="disabled" style="">
                                        <%
                                            String permittedType = searchAccess.getPermittedType();
                                            if (permittedType.equals("User")) {
                                                for (int j = 0; j < listUserName.size(); j++) {
                                                    user = (User) listUserName.get(j);

                                        %>
                                        <option value="<%=user.getFirstName()%>" ><%= user.getFirstName()%>&nbsp;<%= user.getMiddleName()%>&nbsp;<%= user.getLastName()%></option>
                                        <%
                                            }
                                        } else if (permittedType.equals("Organisation Unit")) {
                                            for (int j = 0; j < listOrgName.size(); j++) {
                                                orgUnit = (OrgUnit) listOrgName.get(j);
                                        %>
                                        <option value="<%=orgUnit.getName()%>" ><%=orgUnit.getName()%></option>
                                        <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedDate" name="txtFooterCreatedDate" size="30" class="psadview" value="<%=searchAccess.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedBy" name="txtFooterCreatedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(searchAccess.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedDate" name="txtFooterModifiedDate" size="30" class="psadview" value="<%=searchAccess.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedBy" name="txtFooterModifiedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(searchAccess.getModifiedBy())%>" readonly></td>
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
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Delete" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%
        } else if (parentId.equals("3")) {
            MonitorController monitorCtrl = new MonitorController();
            MonitorAccess monitorAccess = monitorCtrl.getMonitorById(Integer.parseInt(iniProId));
            UserController userCtrl = new UserController();
            ArrayList listUserName = monitorCtrl.getUserNameByPermittedId(Integer.parseInt(iniProId));
            user = new User();
            ArrayList listFormName = monitorCtrl.getFlowChartNameByMonitorId(Integer.parseInt(iniProId));
            engineFlowChart = new EngineFlowChart();
            ArrayList listPermittedType = monitorCtrl.getPermittedTypeByMonitorId(Integer.parseInt(iniProId));
            MonitorAccess monitorPermittedType = new MonitorAccess();
            ArrayList listOrgName = monitorCtrl.getOrgUnitNameByMonitorId(Integer.parseInt(iniProId));
            OrgUnit orgUnit = new OrgUnit();
        %>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br>
                        <table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Delete Audit Trail<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getATVersionFormat(monitorAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadview" value="<%=monitorAccess.getName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value ="formid" id="formid" name="formid" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listFormName.size(); j++) {
                                                engineFlowChart = (EngineFlowChart) listFormName.get(j);
                                        %>
                                        <option value="<%=engineFlowChart.getName()%>" ><%=engineFlowChart.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select value="pertype" id="pertype" name="pertype" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listPermittedType.size(); j++) {
                                                monitorPermittedType = (MonitorAccess) listPermittedType.get(j);

                                        %>
                                        <option value="<%=monitorAccess.getPermittedType()%>" ><%= monitorAccess.getPermittedType()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value="perid" id="perid" name="perid" disabled="disabled" style="">
                                        <%
                                            String permittedType = monitorAccess.getPermittedType();
                                            if (permittedType.equals("User")) {
                                                for (int j = 0; j < listUserName.size(); j++) {
                                                    user = (User) listUserName.get(j);

                                        %>
                                        <option value="<%=user.getFirstName()%>" ><%= user.getFirstName()%>&nbsp;<%= user.getMiddleName()%>&nbsp;<%= user.getLastName()%></option>
                                        <%
                                            }
                                        } else if (permittedType.equals("Organisation Unit")) {
                                            for (int j = 0; j < listOrgName.size(); j++) {
                                                orgUnit = (OrgUnit) listOrgName.get(j);
                                        %>
                                        <option value="<%=orgUnit.getName()%>" ><%=orgUnit.getName()%></option>
                                        <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedDate" name="txtFooterCreatedDate" size="30" class="psadview" value="<%=monitorAccess.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedBy" name="txtFooterCreatedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(monitorAccess.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedDate" name="txtFooterModifiedDate" size="30" class="psadview" value="<%=monitorAccess.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedBy" name="txtFooterModifiedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(monitorAccess.getModifiedBy())%>" readonly></td>
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
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Delete" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%
        } else if (parentId.equals("4")) {
            ExternalReportController exReportCtrl = new ExternalReportController();
            ExternalReportAccess exReportAccess = exReportCtrl.getExReportById(Integer.parseInt(iniProId));
            UserController userCtrl = new UserController();
            ArrayList listUserName = exReportCtrl.getUserNameByPermittedId(Integer.parseInt(iniProId));
            user = new User();
            ArrayList listFormName = exReportCtrl.getFlowChartNameByExReportId(Integer.parseInt(iniProId));
            engineFlowChart = new EngineFlowChart();
            ArrayList listPermittedType = exReportCtrl.getPermittedTypeByExReportId(Integer.parseInt(iniProId));
            ExternalReportAccess exReportPermittedType = new ExternalReportAccess();
            ArrayList listOrgName = exReportCtrl.getOrgUnitNameByExReportId(Integer.parseInt(iniProId));
            OrgUnit orgUnit = new OrgUnit();
        %>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br>
                        <table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Delete External Report<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getERVersionFormat(exReportAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadview" value="<%=exReportAccess.getName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value ="formid" id="formid" name="formid" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listFormName.size(); j++) {
                                                engineFlowChart = (EngineFlowChart) listFormName.get(j);
                                        %>
                                        <option value="<%=engineFlowChart.getName()%>" ><%=engineFlowChart.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select value="pertype" id="pertype" name="pertype" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listPermittedType.size(); j++) {
                                                exReportPermittedType = (ExternalReportAccess) listPermittedType.get(j);

                                        %>
                                        <option value="<%=exReportAccess.getPermittedType()%>" ><%= exReportAccess.getPermittedType()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value="perid" id="perid" name="perid" disabled="disabled" style="">
                                        <%
                                            String permittedType = exReportAccess.getPermittedType();
                                            if (permittedType.equals("User")) {
                                                for (int j = 0; j < listUserName.size(); j++) {
                                                    user = (User) listUserName.get(j);

                                        %>
                                        <option value="<%=user.getFirstName()%>" ><%= user.getFirstName()%>&nbsp;<%= user.getMiddleName()%>&nbsp;<%= user.getLastName()%></option>
                                        <%
                                            }
                                        } else if (permittedType.equals("Organisation Unit")) {
                                            for (int j = 0; j < listOrgName.size(); j++) {
                                                orgUnit = (OrgUnit) listOrgName.get(j);
                                        %>
                                        <option value="<%=orgUnit.getName()%>" ><%=orgUnit.getName()%></option>
                                        <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedDate" name="txtFooterCreatedDate" size="30" class="psadview" value="<%=exReportAccess.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedBy" name="txtFooterCreatedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(exReportAccess.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedDate" name="txtFooterModifiedDate" size="30" class="psadview" value="<%=exReportAccess.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedBy" name="txtFooterModifiedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(exReportAccess.getModifiedBy())%>" readonly></td>
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
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Delete" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%
        } else if (parentId.equals("5")) {
            AdminTaskController adminTaskCtrl = new AdminTaskController();
            AdminTaskAccess adminTaskAccess = adminTaskCtrl.getAdminTaskAccessById(Integer.parseInt(iniProId));
            UserController userCtrl = new UserController();
            ArrayList listUserName = adminTaskCtrl.getUserNameByPermittedId(Integer.parseInt(iniProId));
            user = new User();
            ArrayList listFormName = adminTaskCtrl.getFlowChartNameByAdminTaskId(Integer.parseInt(iniProId));
            engineFlowChart = new EngineFlowChart();
            ArrayList listPermittedType = adminTaskCtrl.getPermittedTypeByAdminTaskId(Integer.parseInt(iniProId));
            AdminTaskAccess adminTaskPermittedType = new AdminTaskAccess();
            ArrayList listOrgName = adminTaskCtrl.getOrgUnitNameByAdminTaskId(Integer.parseInt(iniProId));
            OrgUnit orgUnit = new OrgUnit();
        %>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br>
                        <table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Delete Admin Task<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getADVersionFormat(adminTaskAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadview" value="<%=adminTaskAccess.getName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value ="formid" id="formid" name="formid" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listFormName.size(); j++) {
                                                engineFlowChart = (EngineFlowChart) listFormName.get(j);
                                        %>
                                        <option value="<%=engineFlowChart.getId()%>" ><%=engineFlowChart.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select value="pertype" id="pertype" name="pertype" disabled="disabled" style="">
                                        <%
                                            for (int j = 0; j < listPermittedType.size(); j++) {
                                                adminTaskPermittedType = (AdminTaskAccess) listPermittedType.get(j);

                                        %>
                                        <option value="<%=adminTaskAccess.getPermittedType()%>" ><%= adminTaskAccess.getPermittedType()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <select value="perid" id="perid" name="perid" disabled="disabled" style="">
                                        <%
                                            String permittedType = adminTaskAccess.getPermittedType();
                                            if (permittedType.equals("User")) {
                                                for (int j = 0; j < listUserName.size(); j++) {
                                                    user = (User) listUserName.get(j);

                                        %>
                                        <option value="<%=user.getFirstName()%>" ><%= user.getFirstName()%>&nbsp;<%= user.getMiddleName()%>&nbsp;<%= user.getLastName()%></option>
                                        <%
                                            }
                                        } else if (permittedType.equals("Organisation Unit")) {
                                            for (int j = 0; j < listOrgName.size(); j++) {
                                                orgUnit = (OrgUnit) listOrgName.get(j);
                                        %>
                                        <option value="<%=orgUnit.getName()%>" ><%=orgUnit.getName()%></option>
                                        <%
                                            }
                                        }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedDate" name="txtFooterCreatedDate" size="30" class="psadview" value="<%=adminTaskAccess.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Created By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterCreatedBy" name="txtFooterCreatedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(adminTaskAccess.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified Date:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedDate" name="txtFooterModifiedDate" size="30" class="psadview" value="<%=adminTaskAccess.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Modified By:</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtFooterModifiedBy" name="txtFooterModifiedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(adminTaskAccess.getModifiedBy())%>" readonly></td>
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
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Delete" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%
                }
            }
        %>
        <input type="hidden" name="accessType" value="0" id="accessType"/>
    </body>
</html>
