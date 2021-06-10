<%-- 
    Document   : message
    Created on : Jul 10, 2017, 4:08:00 PM
    Author     : See Rong
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Message</title>
    </head>
    <body>
        <!--this will fire when the message is passed via request forwarding-->
        <!--E.g. request.setAttribute("message", "some message");-->
        <c:if test="${not empty message}">
            <c:out value="${message}"/>
            <script type="text/javascript">
                alert("<c:out value="${message}"/>");
                self.close();
            </script>
        </c:if>

        <!--this will fire when the message is passed via response redirect-->
        <!--E.g. message.jsp?message=some message-->
        <c:if test="${not empty param.message}">
            <c:out value="${param.message}"/>
            <script type="text/javascript">
                alert("<c:out value="${param.message}"/>");
                self.close();
            </script>
        </c:if>
    </body>
</html>
