<%-- 
    Document   : externaladmintaskmodify
    Created on : Jan 27, 2015, 11:00:54 AM
    Author     : SOE HTIKE
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

        String adminTaskId = request.getParameter("adminTaskId");
        if (adminTaskId == null) {
            adminTaskId = "";
        }

        String action = request.getParameter("action");
        if(action == null){
            action = "";
        }

        if(action.equals("modify")){
            //get the current type and subtype
            String type = request.getParameter("type");
            String subtype = request.getParameter("subtype");

            //get the form data
            String adminTaskName = request.getParameter("adminTaskName");
            String adminTaskPath = request.getParameter("adminTaskPath");

            //update the database
            AdminTaskController adminTaskCtrl = new AdminTaskController();
            adminTaskCtrl.updateAdminTaskById(Integer.parseInt(adminTaskId), adminTaskName, adminTaskPath, userId);
        }
%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <script type="text/javascript" src="../include/js/url.js"></script>
        <script>

            var formName;
            var footerId;
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"

            function fnOnLoad(){
                if(action == "modify"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "externaladmintask.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "externaladmintask.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }

            function fnSubmit(){
                if(formValidated() == true){
                    //get the form data
                    var adminTaskName = fnURLEncode(document.getElementById("txtAdminTaskName").value);
                    var adminTaskPath = fnURLEncode(document.getElementById("txtAdminTaskPath").value);
                    var adminTaskId = "<%=adminTaskId%>";
                    document.location.href = "externaladmintaskmodify.jsp?type="+type+"&subtype="+subtype+"&action=modify&adminTaskName="+adminTaskName+"&adminTaskPath="+adminTaskPath+"&adminTaskId="+adminTaskId;
                }
            }

            function formValidated(){
                if(document.getElementById("txtAdminTaskName").value == ""){
                    parent.frames.alertMessage("Please enter admin task name.");
                    return false;
                }
                else if((document.getElementById("txtAdminTaskName").value).length >100){
                    parent.frames.alertMessage("Please enter admin task name with 100 characters or less.");
                    return false;
                }
                else if(document.getElementById("txtAdminTaskPath").value == ""){
                    parent.frames.alertMessage("Please enter admin task path.");
                    return false;
                }
                else if((document.getElementById("txtAdminTaskPath").value).length >200){
                    parent.frames.alertMessage("Please enter admin task path with 200 characters or less.");
                    return false;
                }
                else{
                    return true;
                }
            }

        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png" style="width:650px">
        <% if(adminTaskId.equals("")){%>
            <!-- Leave it blank -->
        <%} else {
            AdminTaskController adminTaskCtrl = new AdminTaskController();
            AdminTask adminTask = adminTaskCtrl.getAdminTaskById(Integer.parseInt(adminTaskId));
            UserController userCtrl = new UserController();
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
                                        Modify External Admin Task<br><br>
                                </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtAdminTaskId" name="txtAdminTaskId" size="30" class="psadview" value="AT<%=ResourceUtil.getVersionFormat(adminTask.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtAdminTaskName" name="txtAdminTaskName" size="30" class="psadtext" value="<%=adminTask.getName()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>External File Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtAdminTaskPath" name="txtAdminTaskPath" size="30" class="psadtext" value="<%=adminTask.getPath()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtAdminTaskCreatedDate" name="txtAdminTaskCreatedDate" size="30" class="psadview" value="<%=adminTask.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtAdminTaskCreatedBy" name="txtAdminTaskCreatedBy" size="30" class="psadview" value="<%=userCtrl.getUserNameById(adminTask.getCreatedBy())%>" readonly></td>
                            </tr>
<!--                            <tr>
                                <td width=150 align="right"><b>Modified Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtAdminTaskModifiedDate" name="txtAdminTaskModifiedDate" size="30" class="psadview" value="<=adminTask.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtAdminTaskModifiedBy" name="txtAdminTaskModifiedBy" size="30" class="psadview" value="<=userCtrl.getUserNameById(adminTask.getModifiedBy())%>" readonly></td>
                            </tr>-->
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

