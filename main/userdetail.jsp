<%-- 
    Document   : userdetail
    Created on : Jul 15, 2009, 11:56:11 AM
    Author     : NooNYUki

//needs to add authgrp for the user.
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
    if (parentId == null) {
        parentId = "";
    } else if (childId == null) {
        childId = "";
    }

    //parentid 0 means it s the root -org name. So, it's child is an orgunit.
    if (parentId.equals("0")) {
        if (childId.startsWith("O")) {
            childId = childId.substring(1);

            uorgunitId = Integer.parseInt(childId);

        } else {
            uorgunitId = 0;
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
        </script>
    </head>
    <body background="../images/background.png" style="width:650px">
        <%
            if (childId.equals("") || childId.equals("0") || parentId.equals("") || parentId.equals("0") || userId == 0) {%>
        <!-- Leave it blank -->
        <%} else {
            DesignationController designationCtrl = new DesignationController();
            AuthGrpController authgrpCtrl = new AuthGrpController();

            UserAuthGrpController userauthgrpCtrl = new UserAuthGrpController();
            int userauthgrpId = userauthgrpCtrl.getAuthGrpIdByUserId(userId);
            UserController uCtrl = new UserController();
            User user = uCtrl.getUserById(userId);

            UserOUDesignationController useroudesCtrl = new UserOUDesignationController();
            boolean isPrimary = useroudesCtrl.checkPrimary(userId, uorgunitId);
            int desId = useroudesCtrl.getUserOUDesignationById(userId, uorgunitId);
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
                                        User Details<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserId" name="txtUserId" size="30" class="psadview" value="U<%=ResourceUtil.getVersionFormat(user.getUserId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>First Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFirstName" name="txtFirstName" size="30" class="psadview" value="<%=user.getFirstName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Middle Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtMiddleName" name="txtMiddleName" size="30" class="psadview" value="<%=user.getMiddleName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Last Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtLastName" name="txtLastName" size="30" class="psadview" value="<%=user.getLastName()%>" readonly></td>
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
                                <td width=150 align="right"><b>Designation:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserDesignation" name="txtUserDesignation" size="30" class="psadview" value="<%=designationCtrl.getDesignationNameById(desId)%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Is Primary:</b></td>
                                <td width=350 align="left">&nbsp;<input type="checkbox" value="1" name="chkPrimary" id="chkPrimary" align="top" class="psadview" disabled
                                                                        <%
                                                                            if (isPrimary == true) {
                                                                                out.print("CHECKED");
                                                                            }
                                                                        %>
                                                                        ></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Authority Group:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserAuthGrp" name="txtUserAuthGrp" size="30" class="psadview" value="<%=authgrpCtrl.getAuthGrpNameById(userauthgrpId)%>" readonly></td>
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
                                <td width=150 align="right">&nbsp;</td>
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
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%}%>
    </body>
</html>



