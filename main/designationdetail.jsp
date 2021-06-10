<%--
    Document   : designationdetail
    Created on : Jun 30, 2009, 10:39:21 AM
    Author     : NooNYUki
--%>
<%@page import = "java.util.*"
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
    if (designationId == null || designationId.equals("0")) {
        designationId = "0";
        desId = 0;
    } else {
        desId = Integer.parseInt(designationId);
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
            var designationId = <%=request.getParameter("designationId")%>;
        </script>
    </head>
    <body background="../images/background.png">
        <%
            if (designationId.equals("") || designationId.equals("0") || desId == 0) {%>
        <%} else {
            DesignationController designationCtrl = new DesignationController();
            Designation designation = designationCtrl.getDesignationById(desId);
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
                                        Job Designation Details<br><br>
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


