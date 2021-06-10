<%-- 
    Document   : orgunitmove
    Created on : Jul 10, 2009, 10:17:09 AM
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
    String orgunitId = request.getParameter("orgunitId");
    String msg = "";
    if (orgunitId == null) {
        orgunitId = "0";
    }
    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }
    OrgUnitController orgunitCtrl = new OrgUnitController();
    ArrayList orgunitlist = orgunitCtrl.getAllPotentialParentUnit(Integer.parseInt(orgunitId));

    if (action.equals("move")) {
        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");
        String parentunitId = request.getParameter("parentunitId");
        int ouId = Integer.parseInt(orgunitId);
        int parentouId = Integer.parseInt(parentunitId);

        //update the database
        msg = "";
        if (ouId == parentouId) {
            orgunitCtrl.moveOrgUnitById(ouId, 0, 11);
        } else {
            orgunitCtrl.moveOrgUnitById(ouId, parentouId, 11);
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
            var orgunitId;
            var parentunitId;
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"

            function fnOnLoad(){
                if(document.getElementById("msg").value != "" && document.getElementById("msg").value != "null"){
                    alert(document.getElementById("msg").value);
                }
                if(action == "move"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "orgunit.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "orgunit.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }

            function fnMove(){
                //get the form data
                orgunitId= "<%=orgunitId%>";
                parentunitId = document.getElementById("cmbParentOrgUnit").value;
                //update the form in the database
                document.location.href = "orgunitmove.jsp?type="+type+"&subtype="+subtype+"&action=move&orgunitId="+orgunitId+"&parentunitId="+parentunitId;
            }

        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png">
        <% if (orgunitId.equals("")) {%>
        <%} else {
            OrgUnit orgunit = orgunitCtrl.getOrgUnitById(Integer.parseInt(orgunitId));
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
                                        Move Organization Unit<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitId" name="txtOrgUnitId" size="30" class="psadview" value="OU<%=ResourceUtil.getVersionFormat(orgunit.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Org Unit Code:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitCode" name="txtOrgUnitCode" size="30" class="psadtext" value="<%=orgunit.getCode()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Org Unit Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitName" name="txtOrgUnitName" size="30" class="psadtext" value="<%=orgunit.getName()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Parent Unit:</b></td>
                                <td width=350 align="left">
                                    &nbsp;<select size="1" id="cmbParentOrgUnit" name="cmbParentOrgUnit" style="width:150px" align="left">
                                        <option> </option>
                                        <%
                                            for (int j = 0; j < orgunitlist.size(); j++) {
                                                orgunit = (OrgUnit) orgunitlist.get(j);
                                        %>
                                        <option value="<%=orgunit.getId()%>" ><%= orgunit.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select> <br><br><br>
                                </td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><input type="hidden" value="<%=msg%>" name="msg" id="msg" ></input></td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">
                                    &nbsp;<input type="button" value="Move" name="btnMove" class="psadbutton" width="100" onclick="fnMove()"></input>
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
