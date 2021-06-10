<%--
    Document   : Close
    Created on : Mar 4, 2010, 1:13:55 PM
    Author     : Chiu Ping
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" href="../favicon.ico"/>
        <title>Flo' Dashboard</title>

        <script>
            function fnClose(){
                window.opener.location="redirect.jsp";
                this.window.close();
            }
        </script>
    </head>
    <body onLoad="fnClose()">
    </body>
</html>
