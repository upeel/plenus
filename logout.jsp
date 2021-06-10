<%-- 
    Document   : logout
    Created on : Nov 28, 2016, 11:16:47 AM
    Author     : Soe
--%>


<%@ page import="org.apache.shiro.SecurityUtils" %>
<%@ page import="com.bizmann.poi.resource.PropProcessor" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String authenticationMethod = PropProcessor.getPropertyValue("auth.method");

    if (authenticationMethod.equalsIgnoreCase("saml")) {
        session.invalidate();
        request.logout();
//        response.sendRedirect("login.jsp?LLO=true");
    } else {
        SecurityUtils.getSubject().logout();
        response.sendRedirect("login.jsp");
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" href="favicon.ico"/>

        <title>Logout</title>
    </head>
    <body>
        You have successfully logged out.
    </body>
</html>
