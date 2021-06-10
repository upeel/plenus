<%--
    Document   : designationdelete
    Created on : Jun 30, 2009, 11:53:34 AM
    Author     : Ella
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
    String designationId = request.getParameter("designationId");
    int desId = 0;
    String msg = "";
    boolean desAssignedToUser = true;

    if (designationId == null || designationId.equals("0")) {
        designationId = "0";
        desId = 0;
        msg = "Please select a designation to delete.";
    } else {
        desId = Integer.parseInt(designationId);
        msg = "";
    }
    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    if (action.equals("delete")) {
        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");

        //update the database
        DesignationController designationCtrl = new DesignationController();
        UserOUDesignationController useroudesignationCtrl = new UserOUDesignationController();
        desAssignedToUser = useroudesignationCtrl.userAssignedtoDesignation(desId);

        //get the current user name for modified by field.
        UserController nuCtrl = new UserController();
        String modloginid = (String) session.getAttribute("user");
        int moduserId = nuCtrl.getUserIdByLoginId(modloginid);

        if (desAssignedToUser) {
            msg = "This job designation is currently in use.";
        } else {
            msg = "";
            designationCtrl.deleteDesignationById(Integer.parseInt(designationId), moduserId);
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
            var formName;
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"
            var msg = "<%= msg%>"
            var desId = "<%=desId%>"
            function fnOnLoad(){
                //  alert(msg);
                if(msg != "" && msg != null){
                    if(desId == "0"){
                        //  alert("Please choose a designation to delete.");
                    }
                    else
                    {    parent.frames.alertMessage(msg);    }
                }
                else if(action == "delete"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "designation.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "designation.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }
            function fnDelete(){
                parent.frames.promptMessage(type, subtype, "delete", "Are you sure you want to delete this job designation?");
            }

        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png">
        <% if (designationId.equals("") || designationId.equals("0") || desId == 0) {%>
        <!-- Leave it blank -->
        <%} else {
            DesignationController designationCtrl = new DesignationController();
            Designation designation = designationCtrl.getDesignationById(Integer.parseInt(designationId));
            UserController uCtrl = new UserController();
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
                                        Delete Job Designation<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationId" name="txtDesignationId" size="30" class="psadview" value="JD<%=ResourceUtil.getVersionFormat(designation.getDesignationId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationName" name="txtDesignationName" size="30" class="psadview" value="<%=designation.getName()%>" readonly></td>
                            </tr>

                            <tr>
                                <td width=150 align="right"><b>Created Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationCreatedDate" name="txtDesignationCreatedDate" size="30" class="psadview" value="<%=designation.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationCreatedBy" name="txtDesignationCreatedBy" size="30" class="psadview" value="<%=uCtrl.getUserNameById(designation.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationModifiedDate" name="txtDesignationModifiedDate" size="30" class="psadview" value="<%=designation.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationModifiedBy" name="txtDesignationModifiedBy" size="30" class="psadview" value="<%=uCtrl.getUserNameById(designation.getModifiedBy())%>" readonly></td>
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
                                <td width=350 align="left">
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Delete" name="btnDelete" class="psadbutton" width="100" onclick="fnDelete()"></input>
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
