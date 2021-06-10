<%-- 
    Document   : redirect
    Created on : Jul 17, 2009, 4:24:37 PM
    Author     : Hnaye
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@ page import = "org.apache.commons.validator.routines.UrlValidator" 
         import="org.apache.shiro.SecurityUtils"
         import="org.apache.shiro.authc.AuthenticationException"
         import="org.apache.shiro.authc.IncorrectCredentialsException"
         import="org.apache.shiro.authc.LockedAccountException"
         import="org.apache.shiro.authc.UnknownAccountException"
         import="org.apache.shiro.authc.UsernamePasswordToken"
         import="org.apache.shiro.subject.Subject" %>

<%

    boolean hasUser = false;

    // get the currently executing user:
    Subject currentUser = SecurityUtils.getSubject();

    if (currentUser != null && (currentUser.isAuthenticated() || currentUser.isRemembered()))
    {
        hasUser = true;
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">

        <script type="text/javascript">
            javascript:window.history.forward(1);

            function fnLoad() {
            <% if (!hasUser)
                { %>
                alert("Session timeout");
            <% }%>
                this.location = "../login.jsp";
            }

        </script>
    </head>
    <body onload="fnLoad()">
    </body>

</html>
