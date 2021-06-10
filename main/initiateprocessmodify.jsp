<%--
    Document   : initiateprocessmodify
    Created on : Jul 2, 2009, 6:01:42 PM
    Author     : Nilar
--%>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.product.resources.*" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%
    EngineFlowChartController engineFlowChartCtrl = new EngineFlowChartController();

    OrgUnitController ouCtrl = new OrgUnitController();
    UserController uCtrl = new UserController();
    InitiateProcessController iCtrl = new InitiateProcessController();
    ReportController rCtrl = new ReportController();
    SearchController sCtrl = new SearchController();
    MonitorController mCtrl = new MonitorController();
    ExternalReportController eCtrl = new ExternalReportController();
    AdminTaskController aCtrl = new AdminTaskController();

    ArrayList list = engineFlowChartCtrl.getAllFlowCharts();
    EngineFlowChart engineFlowChart = new EngineFlowChart();

    OrgUnit orgunit = new OrgUnit();
    ArrayList listOrgUnit = ouCtrl.getOrgUnitName();
    User user = new User();
    ArrayList listUser = uCtrl.getUserName();
    ArrayList listOrigUnit = ouCtrl.getOrgUnitName();

    String iniProId = request.getParameter("iniProId");

    ArrayList listUName = uCtrl.getUserName();
    ArrayList listOName = ouCtrl.getOrgUnitName();

    String loginid = (String) session.getAttribute("user");
    int userId = uCtrl.getUserIdByLoginId(loginid);

    boolean isDuplicate = false;
    boolean isDuplicatePermission = false;
    String msg = "";
    String msgPermission = "";

    if (iniProId == null) {
        iniProId = "";
    }

    String action = request.getParameter("action");

    if (action == null) {
        action = "";
    }

    if (action.equals("modify")) {
        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");
        session.setAttribute("action", action);
        //get the form data
        String formName = request.getParameter("formId");
        if (formName == null) {
            formName = "0";
        }
        formName = formName.trim();
        if (formName.equals("")) {
            formName = "0";
        }

        int formId = Integer.parseInt(formName);
        String name = request.getParameter("name");
        session.setAttribute("name", name);
        String hidName = request.getParameter("hidName");
        session.setAttribute("hidName", hidName);
        String accessTypeString = request.getParameter("prima");
        String perType = request.getParameter("perType");
        session.setAttribute("perType", perType);
        String perIdString = request.getParameter("perId");
        int accessType = new Integer(accessTypeString).intValue();
        int perId = new Integer(perIdString).intValue();
        String idString = request.getParameter("iniProId");
        int id = new Integer(idString).intValue();
        String parentId = request.getParameter("parentId");

        //update the database
        if (parentId.equals("0")) {
            if (hidName.equals(name)) {
                iCtrl.modifyInitAccess(id, name, formId, accessType, perId, perType, userId);
            } else {
                InitiateProcessController ipCtrl = new InitiateProcessController();
                isDuplicate = ipCtrl.isDuplicateName(name);
                isDuplicatePermission = ipCtrl.isDuplicatePermission(formId, accessType, perId, perType);
                if (isDuplicate) {
                    msg = "This Initiate Process Name already exists.";
                } else {
                    msg = "";
                    iCtrl.modifyInitAccess(id, name, formId, accessType, perId, perType, userId);
                }
            }

        } else if (parentId.equals("1")) {
            if (hidName.equals(name)) {
                rCtrl.modifyReportAccess(id, name, formName, accessType, perId, perType, userId);
            } else {
                isDuplicate = rCtrl.isDuplicateName(name);
                if (isDuplicate) {
                    msg = "This Report Name already exists.";
                } else {
                    msg = "";
                    rCtrl.modifyReportAccess(id, name, formName, accessType, perId, perType, userId);
                }
            }

        } else if (parentId.equals("2")) {
            if (hidName.equals(name)) {
                sCtrl.modifySearchAccess(id, name, formName, accessType, perId, perType, userId);
            } else {
                isDuplicate = sCtrl.isDuplicateName(name);
                if (isDuplicate) {
                    msg = "This Search Process Name already exists.";
                } else {
                    msg = "";
                    sCtrl.modifySearchAccess(id, name, formName, accessType, perId, perType, userId);
                }
            }

        } else if (parentId.equals("3")) {
            if (hidName.equals(name)) {
                mCtrl.modifyMonitorAccess(id, name, formName, accessType, perId, perType, userId);
            } else {
                isDuplicate = mCtrl.isDuplicateName(name);
                if (isDuplicate) {
                    msg = "This Audit Trail Name already exists.";
                } else {
                    msg = "";
                    mCtrl.modifyMonitorAccess(id, name, formName, accessType, perId, perType, userId);
                }
            }

        } else if (parentId.equals("4")) {
            if (hidName.equals(name)) {
                eCtrl.modifyExternalReportAccess(id, name, formName, accessType, perId, perType, userId);
            } else {
                isDuplicate = eCtrl.isDuplicateName(name);
                if (isDuplicate) {
                    msg = "This External Report Name already exists.";
                } else {
                    msg = "";
                    eCtrl.modifyExternalReportAccess(id, name, formName, accessType, perId, perType, userId);
                }
            }
        } else if (parentId.equals("5")) {
            if (hidName.equals(name)) {
                aCtrl.modifyAdminTaskAccess(id, name, formName, accessType, perId, perType, userId);
            } else {
                isDuplicate = aCtrl.isDuplicateName(name);
                if (isDuplicate) {
                    msg = "This Admin Task Name already exists.";
                } else {
                    msg = "";
                    aCtrl.modifyAdminTaskAccess(id, name, formName, accessType, perId, perType, userId);
                }
            }

        }
    }

%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <title>bmFLO</title>

        <script type='text/javascript' src='/prosesadv/dwr/interface/Helper.js'></script>
        <script type='text/javascript' src='/prosesadv/dwr/util.js'></script>
        <script type='text/javascript' src='/prosesadv/dwr/engine.js'></script>
        <script type="text/javascript" src="../include/js/url.js"></script>
        <script>
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>";
            var iniProId= "<%=request.getParameter("iniProId")%>";
            

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

            function onModifiedPTypeChange(){
                var action = "<%=(String) session.getAttribute("action")%>";
                var perIdString = "<%=(String) session.getAttribute("perType")%>";
                if(perIdString=="Organisation Unit" && action=="modify")
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
            function fnOnLoad(){
                if(action == "modify"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.location.href = "flowchartpermission.jsp?type="+type;
                    }
                    else{
                        if(document.getElementById("msg").value != "" && document.getElementById("msg").value != "null"){
                            onPermittedTypeChange(document.getElementById('pertype').value);
                            parent.frames.alertMessage("<%=msg%>");
                            document.location.href = "initiateprocessmodify.jsp?type="+type+"&subtype="+subtype+"&action=modify&formId="+formId+"&prima="+prima+"&perId="+perId+"&perType="+perType+"&iniProId="+iniProId+"&parentId="+parentId+"&name="+name;
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
                    var formId = fnURLEncode(document.getElementById("formid").value);
                    var perType=document.getElementById("pertype").value;
                    //var perId=document.getElementById("perid").value;
                    var perId = "";
                    var iniProId= "<%=request.getParameter("iniProId")%>";
                    var parentId= "<%=session.getAttribute("parentId")%>";
                    var name=fnURLEncode(document.getElementById("txtName").value);
                    var hidName=fnURLEncode(document.getElementById("hidName").value);

                    var prima = document.getElementById("accessType").value;

                    //update the form in the database
                    if(perType=="User"){
                        perId=document.getElementById("selUser").value;
                    }else if(perType=="Organisation Unit"){
                        perId=document.getElementById("selOrgunit").value;
                    }
                    document.location.href = "initiateprocessmodify.jsp?type="+type+"&subtype="+subtype+"&action=modify&formId="+formId+"&prima="+prima+"&perId="+perId+"&perType="+perType+"&iniProId="+iniProId+"&parentId="+parentId+"&name="+name+"&hidName="+hidName;
                }
            }
        </script>
    </head>

    <body onload="fnOnLoad();onPermittedTypeChange(document.getElementById('pertype').value);" background="../images/background.png">
        <% if (iniProId.equals("") || iniProId.equals("0")) {%>
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
                                        Modify Initiate Process<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getIAVersionFormat(initAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadtext" value="<%=initAccess.getName()%>"></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="formid" name="formid" style="" >
                                        <option value="0"> </option>
                                        //to load the form to dropdown
                                        <%

                                            for (int j = 0; j < list.size(); j++) {
                                                engineFlowChart = (EngineFlowChart) list.get(j);

                                        %>
                                        <option value="<%=engineFlowChart.getId()%>"
                                                <%
                                                    if (engineFlowChart.getName().equals(initAccess.getFlowChartName())) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><%= engineFlowChart.getName()%></option>
                                        <%
                                            }
                                        %>

                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="pertype" name="pertype" style="" onChange="onPermittedTypeChange(this.value);">
                                        <option> </option>
                                        <option value="User"
                                                <%
                                                    if (initAccess.getPermittedtype().equals("User")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><b>User</b></option>
                                        <option value="Organisation Unit"
                                                <%
                                                    if (initAccess.getPermittedtype().equals("Organisation Unit")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>
                                                ><b>Organisation Unit</b></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <div id="user" style="display:inline">
                                        <select size="1" id="selUser" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listUName.size(); j++) {
                                                    user = (User) listUName.get(j);
                                            %>
                                            <option value="<%=user.getUserId()%>"
                                                    <%

                                                        if (user.getUserId() == initAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %>><%= user.getFullName()%></option>
                                            <%
                                                }//end for

                                            %>
                                        </select>
                                    </div>
                                    <div id="orgunit" style="visibility:hidden;display:none">
                                        <select size="1" id="selOrgunit" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listOName.size(); j++) {
                                                    orgunit = (OrgUnit) listOName.get(j);
                                            %>
                                            <option value="<%=orgunit.getId()%>"
                                                    <%
                                                        int oid = orgunit.getId();
                                                        int pid = initAccess.getPermittedId();

                                                        if (orgunit.getId() == initAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %> ><%= orgunit.getName()%></option>
                                            <%
                                                }
                                            %>
                                        </select>
                                    </div>
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
                                <td align="right">&nbsp;
                                    <input type="hidden" value="<%=msg%>" name="msg" id="msg" >
                                    <input type="hidden" id="hidName" name="txtName" size="19" class="psadtext" value="<%=initAccess.getName()%>">
                                </td>
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Modify" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit();onModifiedPTypeChange();">
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
                                        Modify Report<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getRAVersionFormat(reportAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadtext" value="<%=reportAccess.getName()%>"></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="formid" name="formid" style="" >
                                        <option> </option>
                                        //to load the form to dropdown
                                        <%

                                            for (int j = 0; j < list.size(); j++) {
                                                engineFlowChart = (EngineFlowChart) list.get(j);

                                        %>
                                        <option value="<%=engineFlowChart.getId()%>"
                                                <%
                                                    if (engineFlowChart.getName().equals(reportAccess.getFlowChartName())) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><%= engineFlowChart.getName()%></option>
                                        <%
                                            }
                                        %>

                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="pertype" name="pertype" style="" onChange="onPermittedTypeChange(this.value);">
                                        <option> </option>
                                        <option value="User"
                                                <%
                                                    if (reportAccess.getPermittedType().equals("User")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><b>User</b></option>
                                        <option value="Organisation Unit"
                                                <%
                                                    if (reportAccess.getPermittedType().equals("Organisation Unit")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>
                                                ><b>Organisation Unit</b></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <div id="user" style="display:inline">
                                        <select size="1" id="selUser" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listUName.size(); j++) {
                                                    user = (User) listUName.get(j);
                                            %>
                                            <option value="<%=user.getUserId()%>"
                                                    <%
                                                        if (user.getUserId() == reportAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %>><%= user.getFullName()%></option>
                                            <%
                                                }//end for

                                            %>

                                        </select>
                                    </div>
                                    <div id="orgunit" style="visibility:hidden;display:none">
                                        <select size="1" id="selOrgunit" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listOName.size(); j++) {
                                                    orgunit = (OrgUnit) listOName.get(j);
                                            %>
                                            <option value="<%=orgunit.getId()%>"
                                                    <%
                                                        if (orgunit.getId() == reportAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %> ><%= orgunit.getName()%></option>
                                            <%
                                                }

                                            %>
                                        </select>
                                    </div>
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
                                <td align="right">&nbsp;
                                    <input type="hidden" value="<%=msg%>" name="msg" id="msg" >
                                    <input type="hidden" id="hidName" name="txtName" size="19" class="psadtext" value="<%=reportAccess.getName()%>">
                                </td>
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Modify" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
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
                                        Modify Search Process<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getSPVersionFormat(searchAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadtext" value="<%=searchAccess.getName()%>"></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="formid" name="formid" style="" >
                                        <option> </option>
                                        //to load the form to dropdown
                                        <%

                                            for (int j = 0; j < list.size(); j++) {
                                                engineFlowChart = (EngineFlowChart) list.get(j);

                                        %>
                                        <option value="<%=engineFlowChart.getId()%>"
                                                <%
                                                    if (engineFlowChart.getName().equals(searchAccess.getFlowChartName())) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><%= engineFlowChart.getName()%></option>
                                        <%
                                            }
                                        %>

                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="pertype" name="pertype" style="" onChange="onPermittedTypeChange(this.value);">
                                        <option> </option>
                                        <option value="User"
                                                <%
                                                    if (searchAccess.getPermittedType().equals("User")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><b>User</b></option>
                                        <option value="Organisation Unit"
                                                <%
                                                    if (searchAccess.getPermittedType().equals("Organisation Unit")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>
                                                ><b>Organisation Unit</b></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <div id="user" style="display:inline">
                                        <select size="1" id="selUser" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listUName.size(); j++) {
                                                    user = (User) listUName.get(j);
                                            %>
                                            <option value="<%=user.getUserId()%>"
                                                    <%
                                                        if (user.getUserId() == searchAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %>><%= user.getFullName()%></option>
                                            <%
                                                }//end for

                                            %>

                                        </select>
                                    </div>
                                    <div id="orgunit" style="visibility:hidden;display:none">
                                        <select size="1" id="selOrgunit" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listOName.size(); j++) {
                                                    orgunit = (OrgUnit) listOName.get(j);
                                            %>
                                            <option value="<%=orgunit.getId()%>"
                                                    <%
                                                        if (orgunit.getId() == searchAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %> ><%= orgunit.getName()%></option>
                                            <%
                                                }

                                            %>
                                        </select>
                                    </div>
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
                                <td align="right">&nbsp;
                                    <input type="hidden" value="<%=msg%>" name="msg" id="msg" >
                                    <input type="hidden" id="hidName" name="txtName" size="19" class="psadtext" value="<%=searchAccess.getName()%>">
                                </td>
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Modify" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
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
                                        Modify Audit Trail<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getATVersionFormat(monitorAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadtext" value="<%=monitorAccess.getName()%>"></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="formid" name="formid" style="" >
                                        <option> </option>
                                        //to load the form to dropdown
                                        <%

                                            for (int j = 0; j < list.size(); j++) {
                                                engineFlowChart = (EngineFlowChart) list.get(j);

                                        %>
                                        <option value="<%=engineFlowChart.getId()%>"
                                                <%
                                                    if (engineFlowChart.getName().equals(monitorAccess.getFlowChartName())) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><%= engineFlowChart.getName()%></option>
                                        <%
                                            }
                                        %>

                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="pertype" name="pertype" style="" onChange="onPermittedTypeChange(this.value);">
                                        <option> </option>
                                        <option value="User"
                                                <%
                                                    if (monitorAccess.getPermittedType().equals("User")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><b>User</b></option>
                                        <option value="Organisation Unit"
                                                <%
                                                    if (monitorAccess.getPermittedType().equals("Organisation Unit")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>
                                                ><b>Organisation Unit</b></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <div id="user" style="display:inline">
                                        <select size="1" id="selUser" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listUName.size(); j++) {
                                                    user = (User) listUName.get(j);
                                            %>
                                            <option value="<%=user.getUserId()%>"
                                                    <%
                                                        if (user.getUserId() == monitorAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %>><%= user.getFullName()%></option>
                                            <%
                                                }//end for

                                            %>

                                        </select>
                                    </div>
                                    <div id="orgunit" style="visibility:hidden;display:none">
                                        <select size="1" id="selOrgunit" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listOName.size(); j++) {
                                                    orgunit = (OrgUnit) listOName.get(j);
                                            %>
                                            <option value="<%=orgunit.getId()%>"
                                                    <%
                                                        if (orgunit.getId() == monitorAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %> ><%= orgunit.getName()%></option>
                                            <%
                                                }

                                            %>
                                        </select>
                                    </div>
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
                                <td align="right">&nbsp;
                                    <input type="hidden" value="<%=msg%>" name="msg" id="msg" >
                                    <input type="hidden" id="hidName" name="txtName" size="19" class="psadtext" value="<%=monitorAccess.getName()%>">
                                </td>
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Modify" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
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
            ArrayList fNameEPList = eCtrl.getAllReportNameFromEP();
            ExternalReport exreport = new ExternalReport();
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
                                        Modify External Report<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getERVersionFormat(exReportAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadtext" value="<%=exReportAccess.getName()%>"></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="formid" name="formid" style="" >
                                        <option> </option>
                                        //to load the form to dropdown
                                        <%

                                            for (int j = 0; j < fNameEPList.size(); j++) {
                                                exreport = (ExternalReport) fNameEPList.get(j);

                                        %>
                                        <option value="<%=exreport.getName()%>"
                                                <%
                                                    if (exreport.getName().equals(exReportAccess.getFlowChartName())) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><%= exreport.getName()%></option>
                                        <%
                                            }
                                        %>

                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="pertype" name="pertype" style="" onChange="onPermittedTypeChange(this.value);">
                                        <option> </option>
                                        <option value="User"
                                                <%
                                                    if (exReportAccess.getPermittedType().equals("User")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><b>User</b></option>
                                        <option value="Organisation Unit"
                                                <%
                                                    if (exReportAccess.getPermittedType().equals("Organisation Unit")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>
                                                ><b>Organisation Unit</b></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <div id="user" style="display:inline">
                                        <select size="1" id="selUser" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listUName.size(); j++) {
                                                    user = (User) listUName.get(j);
                                            %>
                                            <option value="<%=user.getUserId()%>"
                                                    <%
                                                        if (user.getUserId() == exReportAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %>><%= user.getFullName()%></option>
                                            <%
                                                }//end for

                                            %>

                                        </select>
                                    </div>
                                    <div id="orgunit" style="visibility:hidden;display:none">
                                        <select size="1" id="selOrgunit" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listOName.size(); j++) {
                                                    orgunit = (OrgUnit) listOName.get(j);
                                            %>
                                            <option value="<%=orgunit.getId()%>"
                                                    <%
                                                        if (orgunit.getId() == exReportAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %> ><%= orgunit.getName()%></option>
                                            <%
                                                }

                                            %>
                                        </select>
                                    </div>
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
                                <td align="right">&nbsp;
                                    <input type="hidden" value="<%=msg%>" name="msg" id="msg" >
                                    <input type="hidden" id="hidName" name="txtName" size="19" class="psadtext" value="<%=exReportAccess.getName()%>">
                                </td>
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Modify" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
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
            ArrayList fNameEPList = eCtrl.getAllReportNameFromEP();
            ArrayList fNameAPList = aCtrl.getAllAdminTasksfromEP();
            AdminTask adminTask = new AdminTask();
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
                                        Modify Admin Task<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td align="right"><b>ID :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtId" name="txtId" size="30" class="psadview" value="<%=ResourceUtil.getADVersionFormat(adminTaskAccess.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Form Permission Name :</b></td>
                                <td align="left">&nbsp;&nbsp;<input type="text" id="txtName" name="txtName" size="30" class="psadtext" value="<%=adminTaskAccess.getName()%>"></td>
                            </tr>
                            <tr>
                                <td align="right"><b>Name :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="formid" name="formid" style="" >
                                        <option> </option>
                                        //to load the form to dropdown
                                        <%

                                            for (int j = 0; j < fNameAPList.size(); j++) {
                                                adminTask = (AdminTask) fNameAPList.get(j);

                                        %>
                                        <option value="<%=adminTask.getId()%>"
                                                <%
                                                    if ((adminTask.getId())==(adminTaskAccess.getAdminHeaderId())) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><%= adminTask.getName()%></option>
                                        <%
                                            }
                                        %>

                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted To :</b></td>
                                <td align="left">&nbsp;
                                    <select size="1" id="pertype" name="pertype" style="" onChange="onPermittedTypeChange(this.value);">
                                        <option> </option>
                                        <option value="User"
                                                <%
                                                    if (adminTaskAccess.getPermittedType().equals("User")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><b>User</b></option>
                                        <option value="Organisation Unit"
                                                <%
                                                    if (adminTaskAccess.getPermittedType().equals("Organisation Unit")) {
                                                        out.print("SELECTED");
                                                    }
                                                %>
                                                ><b>Organisation Unit</b></option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td align="right"><b>Permitted Name :</b></td>
                                <td align="left">&nbsp;
                                    <div id="user" style="display:inline">
                                        <select size="1" id="selUser" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listUName.size(); j++) {
                                                    user = (User) listUName.get(j);
                                            %>
                                            <option value="<%=user.getUserId()%>"
                                                    <%
                                                        if (user.getUserId() == adminTaskAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %>><%= user.getFullName()%></option>
                                            <%
                                                }//end for

                                            %>

                                        </select>
                                    </div>
                                    <div id="orgunit" style="visibility:hidden;display:none">
                                        <select size="1" id="selOrgunit" name="perid" style="" >
                                            <option> </option>
                                            <%

                                                for (int j = 0; j < listOName.size(); j++) {
                                                    orgunit = (OrgUnit) listOName.get(j);
                                            %>
                                            <option value="<%=orgunit.getId()%>"
                                                    <%
                                                        if (orgunit.getId() == adminTaskAccess.getPermittedId()) {
                                                            out.print("SELECTED");
                                                        }
                                                    %> ><%= orgunit.getName()%></option>
                                            <%
                                                }

                                            %>
                                        </select>
                                    </div>
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
                                <td align="right">&nbsp;
                                    <input type="hidden" value="<%=msg%>" name="msg" id="msg" >
                                    <input type="hidden" id="hidName" name="txtName" size="19" class="psadtext" value="<%=adminTaskAccess.getName()%>">
                                </td>
                                <td align="left">&nbsp;
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Modify" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <% }
            }
        %>
        <input type="hidden" name="accessType" value="0" id="accessType"/>
        <input type="hidden" value="<%=msgPermission%>" name="msg" id="msgPermission" >
    </body>
</html>
