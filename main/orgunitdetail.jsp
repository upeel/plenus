<%--
    Document   : orgunitdetail
    Created on : Jul 2, 2009, 4:47:31 PM
    Author     : NooNYUki
--%>

<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "com.bizmann.product.controller.OrgUnitController"
        import = "com.bizmann.product.controller.OrgChartController"
        import = "com.bizmann.product.controller.UserController"
        import = "com.bizmann.product.entity.OrgUnit"
        import = "com.bizmann.product.resources.ResourceUtil" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%
    String orgunitId = request.getParameter("orgunitId");
    String parentorgunitId = request.getParameter("orgunitId");
    if (orgunitId == null) {
        orgunitId = "";

    }
    if (parentorgunitId == null) {
        parentorgunitId = "0";
    }

    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    session.setAttribute("parentorgunitId", parentorgunitId);
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
    <body background="../images/background.png">
        <% if (orgunitId.equals("") || orgunitId.equals("0")) {%>
        <!-- Leave it blank -->
        <%} else {
            OrgUnitController orgunitCtrl = new OrgUnitController();
            OrgUnit orgunit = orgunitCtrl.getOrgUnitById(Integer.parseInt(orgunitId));
            UserController uCtrl = new UserController();
            OrgChartController orgchartCtrl = new OrgChartController();
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
                                        Organization Unit Details<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitId" name="txtOrgUnitId" size="30" class="psadview" value="OU<%=ResourceUtil.getVersionFormat(orgunit.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Code:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitCode" name="txtOrgUnitCode" size="30" class="psadview" value="<%=orgunit.getCode()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitName" name="txtOrgUnitName" size="30" class="psadview" value="<%=orgunit.getName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Parent Unit:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitParentId" name="txtOrgUnitName" size="30" class="psadview" value="<%=orgunitCtrl.getOUNameById(orgunit.getParentId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Manager:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitManager" name="txtOrgUnitManager" size="30" class="psadview" value="<%=uCtrl.getUserNameById(orgunit.getManager())%>" readonly></td>
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

