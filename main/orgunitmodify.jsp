<%--
    Document   : orgunitmodify
    Created on : Jul 2, 2009, 5:57:00 PM
    Author     : NooNYUki
--%>

<%@ page import = "java.util.ArrayList"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.OrgUnitController"
         import = "com.bizmann.product.controller.UserOUDesignationController"
         import = "com.bizmann.product.controller.OrgChartController"
         import = "com.bizmann.product.controller.UserController"
         import = "com.bizmann.product.entity.OrgUnit"
         import = "com.bizmann.product.entity.User"
         import = "com.bizmann.product.entity.UserOUDesignation"
         import = "com.bizmann.product.resources.ResourceUtil" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%
    String orgunitId = request.getParameter("orgunitId");
    int ouId = 0;
    String msg = "";
    String parentId = "";
    boolean isDuplicate = false;


    if (orgunitId == null || orgunitId.equals("0")) {
        orgunitId = "0";
        ouId = 0;
        msg = "Please select an organization unit to delete.";
    } else {
        ouId = Integer.parseInt(orgunitId);
        msg = "";
    }

    if (parentId == null || parentId.equals("")) {
        parentId = "0";
    }
    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    if (action.equals("modify")) {
        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");

        //get the form data
        String orgunitName = request.getParameter("orgunitName");
        if (orgunitName == null) {
            orgunitName = "";
        }
        orgunitName = orgunitName.trim();

        String orgunitCode = request.getParameter("txtOrgUnitCode");
        if (orgunitCode == null) {
            orgunitCode = "";
        }
        orgunitCode = orgunitCode.trim();
        System.out.println("orgunitCode : " + orgunitCode);
        
        parentId = request.getParameter("parentId");
        String managerId = request.getParameter("managerId");
        String initOrgName = request.getParameter("initOrgName");
        int oumanager = 1;

        if (managerId.equals("a") || managerId.equals("0")) {
            oumanager = 0;
        } else {
            oumanager = Integer.parseInt(managerId);
        }

        //get the modifier id
        UserController nuCtrl = new UserController();
        String modloginid = (String) session.getAttribute("user");
        int moduserId = nuCtrl.getUserIdByLoginId(modloginid);

        //update the database
        OrgUnitController orgunitCtrl = new OrgUnitController();
        UserOUDesignationController useroudesignationCtrl = new UserOUDesignationController();

        if (initOrgName.equals(orgunitName)) {
            isDuplicate = false;
        } else {
            isDuplicate = orgunitCtrl.isDuplicateOrgUnitNameOrCode(orgunitName, orgunitCode); //isDuplicateOrgUnit(orgunitName);
        }

        if (isDuplicate) {
            msg = "This organization unit name/code already exists.";
        } else {
            msg = "";
            orgunitCtrl.updateOrgUnitByIdAndCode(Integer.parseInt(orgunitId), orgunitCode, orgunitName, oumanager, Integer.parseInt(parentId), moduserId); //updateOrgUnitById(Integer.parseInt(orgunitId), orgunitName, oumanager, Integer.parseInt(parentId), moduserId);
        }
    } else if (action.equals("UpdateCombo")) {
        parentId = request.getParameter("parentId");

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

            //var formName;
            var orgunitId;
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"
            var parentId = "<%=request.getParameter("parentId")%>"
            var msg = "<%= msg%>";
            var ouId = "<%=ouId%>";

            function fnOnLoad(){
                if(msg != "" && msg != null){
                    if(ouId == "0"){
                        //  leave it blank;
                    }
                    else
                    {    parent.frames.alertMessage(msg);    }
                }
                else if(action == "modify"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "orgunit.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "orgunit.jsp?type="+type+"&subtype="+subtype;
                    }
                }
                else if(action=="UpdateCombo"){
                    document.getElementById("cmbParentOrgUnit").value = parentId;
                }
            }

            function fnSubmit(){
                if(formValidated()==true){
                    orgunitName = fnURLEncode(document.getElementById("txtOrgUnitName").value);
                    orgunitCode = fnURLEncode(document.getElementById("txtOrgUnitCode").value);
                    orgunitId= "<%=orgunitId%>";
                    parentId = document.getElementById("cmbParentOrgUnit").value;
                    managerId = document.getElementById("cmbOrgUnitManager").value;
                    initOrgName = fnURLEncode(document.getElementById("initName").value);

                    document.location.href = "orgunitmodify.jsp?type="+type+"&subtype="+subtype+"&action=modify&orgunitName="+orgunitName+"&orgunitId="+orgunitId+"&parentId="+
                        parentId+"&managerId="+managerId+"&initOrgName="+initOrgName+"&txtOrgUnitCode="+orgunitCode;
                        //+"&orgunitCode="+orgunitCode;
                }
            }

            function formValidated(){
                if(document.getElementById("txtOrgUnitName").value == ""){
                    parent.frames.alertMessage("Please enter organization unit name.");
                    return false;
                }
                else if((document.getElementById("txtOrgUnitName").value).length > 100){
                    parent.frames.alertMessage("Please enter a name with 100 characters or less.");
                    document.getElementById("txtOrgUnitName").value = "";
                    return false;
                }
//                else if((document.getElementById("txtOrgUnitCode").value).length > 10){
//                    parent.frames.alertMessage("Please enter a code with 10 characters or less.");
//                    document.getElementById("txtOrgUnitCode").value = "";
//                    return false;
//                }
                else{
                    return true;
                }
            }

            function fnUpdateValues(combo){
                parentId = combo.value;
                orgunitId="<%=orgunitId%>";
                document.location.href = "orgunitmodify.jsp?type="+type+"&subtype="+subtype+"&action=UpdateCombo&parentId="+parentId+"&orgunitId="+orgunitId;
            }



        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png">
        <% if (orgunitId.equals("") || orgunitId.equals("0") || ouId == 0) {%>
        <!-- Leave it blank -->
        <%} else {
            OrgUnitController orgunitCtrl = new OrgUnitController();
            OrgUnit orgunit = orgunitCtrl.getOrgUnitById(Integer.parseInt(orgunitId));
            OrgUnit listorgunit = new OrgUnit();
            UserController uCtrl = new UserController();
            OrgChartController orgchartCtrl = new OrgChartController();

            if (parentId == null || parentId.equals("") || parentId.equals("0")) {
                parentId = Integer.toString(orgunit.getParentId());

            }
            ArrayList orgunitlist = orgunitCtrl.getAllPotentialParentUnit(Integer.parseInt(orgunitId));

            ArrayList managerlist = uCtrl.getValidManagers(Integer.parseInt(orgunitId), Integer.parseInt(parentId));
            User user = new User();

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
                                        <b>Modify Organization Unit</b><br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitId" name="txtOrgUnitId" size="30" class="psadview" value="OU<%=ResourceUtil.getVersionFormat(orgunit.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Unit Code:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitCode" name="txtOrgUnitCode" size="30" class="psadtext" value="<%=orgunit.getCode()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Unit Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitName" name="txtOrgUnitName" size="30" class="psadtext" value="<%=orgunit.getName()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Parent Unit:</b></td>
                                <td width=350 align="left">&nbsp;<select size="1" id="cmbParentOrgUnit" name="cmbParentOrgUnit" style="width:200px" align="top"  onchange ="fnUpdateValues(this)" class="psadselect">

                                        <option class="psadselect option" value="0"
                                                <% if (orgunit.getParentId() == 0) {
                                                        out.print("SELECTED");
                                                    }
                                                %>
                                                ><b><%=orgchartCtrl.getActiveOC()%> </b></option>
                                        <%

                                            for (int j = 0; j < orgunitlist.size(); j++) {
                                                listorgunit = (OrgUnit) orgunitlist.get(j);

                                        %>
                                        <option class="psadselect option" value="<%=listorgunit.getId()%>"
                                                <% if (listorgunit.getId() == orgunit.getParentId()) {
                                                        out.print("SELECTED");
                                                    }
                                                %>
                                                ><%= listorgunit.getName()%>
                                        </option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Manager:</b></td>
                                <td width=350 align="left">&nbsp;<select size="1" id="cmbOrgUnitManager" name="cmbOrgUnitManager" style="width:200px" align="top" class="psadselect">
                                        <option value="a"></option>
                                        <%

                                            if (managerlist.size() == 0) {%>
                                        <option value ="0">NA</option>
                                        <%                                        } else {
                                            for (int k = 0; k < managerlist.size(); k++) {
                                                user = (User) managerlist.get(k);


                                        %>
                                        <option class="psadselect option" value="<%=user.getUserId()%>"
                                                <% if (user.getUserId() == orgunit.getManager()) {
                                                        out.print("SELECTED");
                                                    }
                                                %>
                                                ><%=user.getFirstName() + " " + user.getMiddleName() + " " + user.getLastName()%>
                                        </option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Organization Chart:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitOrgChartId" name="txtOrgUnitOrgChartId" size="30" class="psadview" value="<%=orgchartCtrl.getOCNameById(orgunit.getOrgChartId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitCreatedDate" name="txtOrgUnitCreatedDate" size="30" class="psadview" value="<%=orgunit.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitCreatedBy" name="txtOrgUnitCreatedBy" size="30" class="psadview" value="<%=uCtrl.getUserNameById(orgunit.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitModifiedDate" name="txtOrgUnitModifiedDate" size="30" class="psadview" value="<%=orgunit.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitModifiedBy" name="txtOrgUnitModifiedBy" size="30" class="psadview" value="<%=uCtrl.getUserNameById(orgunit.getModifiedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><input type="hidden" value="<%=msg%>" name="msg" id="msg" ></input></td>
                                <td width=150 align="left"><input type="hidden" value="<%=orgunit.getName()%>" name="initName" id="initName"></input></td>
                            </tr>
                            <tr>
                                <td width=150 align="left"><input type="hidden" value="<%=orgunit.getManager()%>" name="initManager" id="initManager"></input></td>
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


