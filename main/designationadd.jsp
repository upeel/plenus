<%--
    Document   : designationadd
    Created on : Jun 30, 2009, 11:20:55 AM
    Author     : NooNYUki
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.entity.*" %>
<%
    String msg = "";
    boolean isDuplicate = false;
    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    if (action.equals("add")) {
        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");

        //get the form data
        String designationName = request.getParameter("designationName");

        //update the database
        DesignationController designationCtrl = new DesignationController();

        //get the current user name for modified by field.
        UserController uCtrl = new UserController();
        String modloginid = (String) session.getAttribute("user");
        int moduserId = uCtrl.getUserIdByLoginId(modloginid);

        isDuplicate = designationCtrl.isDuplicateDesignation(designationName);
        if (isDuplicate) {
            msg = "This job designation already exists.";

        } else {
            msg = "";
            Designation designation = new Designation(designationName);
            designationCtrl.addNewDesignation(designation, moduserId);
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
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
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
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"
            function fnOnLoad(){
                if(document.getElementById("msg").value != "" && document.getElementById("msg").value != "null"){
                    parent.frames.alertMessage(document.getElementById("msg").value);
                }
                else if(action == "add"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "designation.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "designation.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }

            function formValidated(){
                if(document.getElementById("txtDesignationName").value == ""){
                    parent.frames.alertMessage("Please enter job designation name.");
                    return false;
                }
                else if((document.getElementById("txtDesignationName").value).length > 100){
                    parent.frames.alertMessage("Please enter designation with 100 characters or less.");
                    document.getElementById("txtDesignationName").value = "";
                    return false;
                }
                else{
                    return true;
                }
            }

            function fnSubmit(){
                if(formValidated() == true){
                    //get the form data
                    var designationName = fnURLEncode(document.getElementById("txtDesignationName").value);
                    //update the form in the database
                    document.location.href = "designationadd.jsp?type="+type+"&subtype="+subtype+"&action=add&designationName="+ designationName;
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
                                        Add Job Designation<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationName" name="txtDesignationName" size="30" class="psadtext"></td>
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
                                <td width=150 align="right"><input type="hidden" value="<%=msg%>" name="msg" id="msg" ></input></td>
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

