<%-- 
    Document   : externaladmintaskadd
    Created on : Jan 27, 2015, 11:00:44 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<%@ page
    import = "java.util.*"
    import = "java.lang.*"
    import = "com.bizmann.product.controller.*"
    import = "com.bizmann.product.entity.*"
%>

<%
    UserController uCtrl = new UserController();
    String loginid = (String) session.getAttribute("user");
    int userId = uCtrl.getUserIdByLoginId(loginid);

    String action = request.getParameter("action");
    if(action == null){
        action = "";
    }

    if(action.equals("add")){

        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");

        //get the form data
        String adminTaskName = request.getParameter("adminTaskName");
        String adminTaskPath = request.getParameter("adminTaskPath");

        //check whether the name exists
        AdminTaskController adminTaskCtrl = new AdminTaskController();
        boolean isDuplicate = adminTaskCtrl.isDuplicateAdminTaskName(adminTaskName);
        System.out.println(adminTaskName + ": "+isDuplicate);

        if(isDuplicate){
            //do not update the database
            action = "duplicatemsg";
        }
        else{
            //update the database
            AdminTask adminTask  = new AdminTask(adminTaskName, adminTaskPath);
            adminTaskCtrl.addNewAdminTask(adminTask, userId);
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
        <script type="text/javascript" src="../include/js/url.js"></script>
        <script>

            var action = "<%=action%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"

            function fnOnLoad(){
                if(action == "add"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "externaladmintask.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "externaladmintask.jsp?type="+type+"&subtype="+subtype;
                    }
                }
                else if(action == "duplicatemsg"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.frames.alertMessage("The name is duplicated.");
                        //parent.document.location.href = "admintask.jsp?type="+type;
                        
                    }
                    else{
                        parent.frames.alertMessage("The name is duplicated.");
                        //parent.document.location.href = "admintask.jsp?type="+type+"&subtype="+subtype;
                        
                    }
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

            function fnSubmit(){
                if(formValidated() == true){
                    //get the form data
                    var adminTaskName = fnURLEncode(document.getElementById("txtAdminTaskName").value);
                    var adminTaskPath = fnURLEncode(document.getElementById("txtAdminTaskPath").value);

                    //update the form in the database
                    document.location.href = "externaladmintaskadd.jsp?type="+type+"&subtype="+subtype+"&action=add&adminTaskName="+adminTaskName+"&adminTaskPath="+adminTaskPath;
                }
            }
        </script>

    </head>
    <body onload="fnOnLoad()" class="yui-skin-sam" background="../images/background.png" style="width:650px">
        <!-- alert message -->
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br><table>
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Add External Admin Task<br><br>
                                </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtAdminTaskName" name="txtAdminTaskName" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>External File Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtAdminTaskPath" name="txtAdminTaskPath" size="30" class="psadtext"></td>
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
                                <td width=350 align="left">&nbsp;<input type="button" value="Add" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()"></td>
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
    </body>
</html>