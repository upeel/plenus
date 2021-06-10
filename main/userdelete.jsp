<%-- 
    Document   : userdelete
    Created on : Jul 20, 2009, 10:45:07 AM
    Author     : NooNYUki

    
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
    String parentId = request.getParameter("parentId");
    String childId = request.getParameter("childId");
    int uorgunitId = 0;
    int userId = 0;
    String msg = "";
    boolean userHasActivities = true;
    UserOUDesignationController uoudesCtrl = new UserOUDesignationController();

    if (parentId == null || parentId.equals("0")) {
        parentId = "0";

    } else if (childId == null || childId.equals("0")) {
        childId = "0";
    }

    if (parentId.equals("0")) {
        if (childId.startsWith("O")) {
            childId = childId.substring(1);
            uorgunitId = Integer.parseInt(childId);

        } else {
            uorgunitId = 0;
            userId = 0;
        }
    } else {
        if (parentId.startsWith("O") && childId.startsWith("U")) {
            parentId = parentId.substring(1);
            uorgunitId = Integer.parseInt(parentId);
            childId = childId.substring(1);
            userId = Integer.parseInt(childId);
        }
    }

    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    if (action.equals("delete")) {
        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");
        String modloginid = (String) session.getAttribute("user");

        //check if the user has pending activities.
        ActivityController activityCtrl = new ActivityController();
        userHasActivities = activityCtrl.userHasPendingActivities(userId);
        UserController uCtrl = new UserController();
        int moduserId = uCtrl.getUserIdByLoginId(modloginid);
        if (moduserId == userId) {
            msg = "Sorry, you cannot delete your own account.";
        } else if (userHasActivities) {
            msg = "Sorry, this user is involved in outstanding process(es)!";
        } else {
            msg = "";
            //get the current user name.
            uCtrl.deleteUserById(userId, moduserId);
        }
    }
    if (action.equals("deletefromOU")) {
        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");
        String modloginid = (String) session.getAttribute("user");

        //userHasActivities = activityCtrl.userHasPendingActivities(userId);
        UserController uCtrl = new UserController();
        int moduserId = uCtrl.getUserIdByLoginId(modloginid);
        if (moduserId == userId) {
            msg = "Sorry, you cannot remove yourself from a department.";
        } else {
            msg = "";
            uoudesCtrl.removeUserOUDesignation(userId, uorgunitId);
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
        <script>
            var userId;
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"
            var msg = "<%= msg%>";
            var uorgunitId = "<%=uorgunitId%>";
            function fnOnLoad(){
                if(msg != "" && msg != null){
                    if(uorgunitId == "0"){
                        //  leave it blank
                    }
                    else
                    {    parent.frames.alertMessage(msg);    }
                }
                else if(action == "delete"|| action == "deletefromOU"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "user.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "user.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }

            function fnDelete(){
                parent.frames.promptMessage(type, subtype, "delete", "Are you sure you want to delete this user?");
            }

            function fnDeletefrmOU(){
                parent.frames.promptMessage(type, subtype, "deletefromOU", "Are you sure you want to delete this user from the selected unit?");
            }

        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png" style="width:650px">
        <%
            if (userId == 0 || uorgunitId == 0) {%>
        <!-- Leave it blank -->
        <%} else {
            DesignationController designationCtrl = new DesignationController();
            AuthGrpController authgrpCtrl = new AuthGrpController();

            UserAuthGrpController userauthgrpCtrl = new UserAuthGrpController();
            int userauthgrpId = userauthgrpCtrl.getAuthGrpIdByUserId(userId);
            UserController uCtrl = new UserController();
            User user = uCtrl.getUserById(userId);

            UserOUDesignationController useroudesCtrl = new UserOUDesignationController();
            int desId = useroudesCtrl.getUserOUDesignationById(userId, uorgunitId);
            int priOUId = useroudesCtrl.getPrimaryOUByUserId(userId);
            OrgUnitController orgunitCtrl = new OrgUnitController();
            String priOrgUnit = orgunitCtrl.getOUNameById(priOUId);

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
                                        <b>Delete User</b><br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserId" name="txtUserId" size="30" class="psadview" value="U<%=ResourceUtil.getVersionFormat(user.getUserId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>First Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFirstName" name="txtFirstName" size="30" class="psadview" value="<%=user.getFirstName()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Middle Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtMiddleName" name="txtMiddleName" size="30" class="psadview" value="<%=user.getMiddleName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Last Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtLastName" name="txtLastName" size="30" class="psadview" value="<%=user.getLastName()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Contact No:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtContactNo" name="txtContactNo" size="30" class="psadview" value="<%=user.getContactNo()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Mobile No:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtMobileNo" name="txtMobileNo" size="30" class="psadview" value="<%=user.getMobileNo()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Fax No:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFaxNo" name="txtFaxNo" size="30" class="psadview" value="<%=user.getFaxNo()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Email:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtEmail" name="txtEmail" size="30" class="psadview" value="<%=user.getEmail()%>" readonly></td>
                            </tr>
                            <%
                                String field1 = user.getField1();
                                if (field1 == null) {
                                    field1 = "";
                                }
                            %>
                            <tr>
                                <td width=150 align="right"><b>Custom Field 1:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtField1" name="txtField1" size="30" class="psadview" value="<%=field1%>" readonly></td>
                            </tr>
                            <%
                                String field2 = user.getField2();
                                if (field2 == null) {
                                    field2 = "";
                                }
                            %>
                            <tr>
                                <td width=150 align="right"><b>Custom Field 2:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtField2" name="txtField2" size="30" class="psadview" value="<%=field2%>" readonly></td>
                            </tr>
                            <%
                                String field3 = user.getField3();
                                if (field3 == null) {
                                    field3 = "";
                                }
                            %>
                            <tr>
                                <td width=150 align="right"><b>Custom Field 3:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtField3" name="txtField3" size="30" class="psadview" value="<%=field3%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Login ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtLoginID" name="txtLoginID" size="30" class="psadview" value="<%=user.getLoginId()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserCreatedDate" name="txtUserCreatedDate" size="30" class="psadview" value="<%=user.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserCreatedBy" name="txtUserCreatedBy" size="30" class="psadview" value="<%=uCtrl.getUserNameById(user.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserModifiedDate" name="txtUserModifiedDate" size="30" class="psadview" value="<%=user.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserModifiedBy" name="txtUserModifiedBy" size="30" class="psadview" value="<%=uCtrl.getUserNameById(user.getModifiedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Primary Designation:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserDesignation" name="txtUserDesignation" size="30" class="psadview" value="<%=designationCtrl.getDesignationNameById(desId)%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Primary Organization</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtPrimaryOrg" name="txtPrimaryOrg" size="30" class="psadview" value="<%=priOrgUnit%>" </td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Authority Group:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserAuthGrp" name="txtUserAuthGrp" size="30" class="psadview" value="<%=authgrpCtrl.getAuthGrpNameById(userauthgrpId)%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><input type="hidden" value="<%=msg%>" name="msg" id="msg" ></input></td>
                                <td width=350 align="left">&nbsp;</td>
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
                                    &nbsp;<input type="button" value="Delete" name="btnDelete" class="psadbutton" width="100" onclick="fnDelete()"></input>
                                    <% if (priOUId != uorgunitId) {%>
                                    <input type="button" value="Remove" name="btnDeletefrmOU" class="psadbutton" width="100" onclick="fnDeletefrmOU()"></input>
                                    <%}%>
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
