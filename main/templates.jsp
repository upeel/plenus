<%-- 
    Document   : templates
    Created on : Jan 21, 2015, 3:13:35 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%@ page import = "java.util.*"
         import = "java.lang.*" %>
<%
    String msg = "";

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null)
    {
        todoaction = "";
    }

    if (todoaction.equals("activate"))
    {

    }
    else if (todoaction.equals("success"))
    {
        msg = "alert('Module has been added successful! Please check the respective modules!');";
    }
    else if (todoaction.equals("error"))
    {
        msg = "alert('Module Activation Failed! Please contact the site admin for details!');";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <title>Templates</title>
    </head>
    <body>
        <div id="dvLoading"></div>
        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td>
                        <p>Templates</p>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>
<script type="text/javascript"><%=msg%></script>
<%@ include file="../include/footer.jsp" %>