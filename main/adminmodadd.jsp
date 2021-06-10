<%-- 
    Document   : adminmodadd
    Created on : Jul 4, 2014, 4:31:02 PM
    Author     : SOE HTIKE
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.flowchart.controller.*"
         import = "com.bizmann.poi.controller.*"
         import = "com.bizmann.poi.entity.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.flowchart.entity.*"
         import = "com.bizmann.diy.admin.controller.*"
         import = "com.bizmann.diy.admin.entity.*"
         import = "java.io.*"
         import = "com.bizmann.product.resources.*" %>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    String adminModName = "";
    String action = "";
    String msg = "";

    String type = request.getParameter("type");
    if (type == null) {
        type = "";
    }
    String subtype = request.getParameter("subtype");
    if (subtype == null) {
        subtype = "";
    }

    adminModName = request.getParameter("txtAdminModName");
    if (adminModName == null) {
        adminModName = "";
    }
    action = request.getParameter("hidAction");
    if (action == null) {
        action = "";
    }

    com.bizmann.product.controller.UserController uCtrl = new com.bizmann.product.controller.UserController();
    String loginid = (String) session.getAttribute("user");
    int userId = uCtrl.getUserIdByLoginId(loginid);

    if (action.equalsIgnoreCase("add")) {
        AdminHeader adminHeader = new AdminHeader();
        adminHeader.setName(adminModName);
        adminHeader.setActivated(false);
        adminHeader.setDeleted(false);
        adminHeader.setCreated_by(userId);

        int headerId = new AdminModController().insertAdminHeader(adminHeader);
        if (headerId > 0) {
            msg = "";
            response.sendRedirect("adminmoddetail.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + headerId);
        } else {
            msg = "New Administrative Module Creation FAILED! Please contact Site Admin or Try Again.";
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
        <style>
            .selected{
                background:#ACD6F5;
                border:1px solid grey;
            }
        </style>
        <script>

            var action = "<%=action%>";
            var type = "<%=type%>";
            var subtype = "<%=subtype%>"

            function fnOnLoad(){
                if(action == "add"){
                    if(subtype == "null"){
                        parent.document.location.href = "adminmoddesigner.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "adminmoddesigner.jsp?type="+type+"&subtype="+subtype;
                    }
                }
                if(document.getElementById("msg").value != "" && document.getElementById("msg").value != "null"){
                    parent.frames.alertMessage("<%=msg%>");
                    document.location.href = "adminmoddesigner.jsp?type="+type+"&subtype="+subtype;
                }
            }

            function flowChartValidated(){
                if(document.getElementById("txtAdminModName").value == ""){
                    parent.frames.alertMessage("Please give the module name.");
                    return false;
                }else{
                    return true;
                }
            }

            function fnSubmit(){
                if(flowChartValidated() == true){
                    document.getElementById("hidAction").value="add";
                    document.getElementById("type").value= "<%=type%>";
                    document.getElementById("subtype").value= "<%=subtype%>";
                    document.frmAdminMod.method = "post";
                    document.frmAdminMod.submit();
                }
            }
        </script>
    </head>
    <body onload="fnOnLoad()" class="yui-skin-sam" background="../images/background.png" style="width:650px">
        <div align="center" valign="top">
            <form name="frmAdminMod" action="adminmodadd.jsp">
                <table>
                    <tr>
                        <td class="orgtable" valign="top" align="center">
                            <br><table>
                                <tr>
                                    <th colspan="2">
                                        <div class="psadtitle">
                                            <br>Add Administrative Module<br><br>
                                        </div>
                                    </th>
                                </tr>
                                <tr>
                                    <td width=150 align="right"><b>Name:</b></td>
                                    <td width=350 align="left">
                                        &nbsp;<input type="text" id="txtAdminModName" name="txtAdminModName" size="30" class="psadtext">
                                    </td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;<input type="button" value="Continue" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()"></td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                                <input type="hidden" id="hidAction" name="hidAction">
                                <input type="hidden" id="type" name="type">
                                <input type="hidden" id="subtype" name="subtype">
                                <input type="hidden" value="<%=msg%>" name="msg" id="msg" />
                            </table>
                        </td>
                    </tr>
                </table>
            </form>
            <br><br><br><br>
        </div>
    </body>
</html>

