<%-- 
    Document   : dataprocessing
    Created on : 1 Aug, 2018, 4:11:23 PM
    Author     : Soe
--%>

<%@page import="java.util.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            Enumeration paramValueList = request.getParameterNames();
            while (paramValueList.hasMoreElements()) {
                String name = (String) paramValueList.nextElement();
                String value = "";
                String[] checkboxArr = request.getParameterValues(name);
                if (checkboxArr != null && checkboxArr.length > 1) {
                    for (int a = 0; a < checkboxArr.length; a++) {
                        value = value + checkboxArr[a] + ",";
                    }
                    if (value.contains(",")) {
                        value = value.substring(0, value.length() - 1);
                    }
                } else {
                    value = (String) request.getParameter(name);
                }
                System.out.println(name + " - " + value);

        %>
        <%=name + " - " + value%>
        <%
            }
        %>
    </body>
</html>
