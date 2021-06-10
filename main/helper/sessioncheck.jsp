<%-- 
    Document   : sessioncheck
    Created on : Jan 28, 2014, 9:58:41 AM
    Author     : SOE HTIKE
--%>
<%
    String ssid = (String) session.getAttribute("user");
    if (ssid == null || ssid.equals("")) {
        response.sendRedirect("../include/redirect.jsp");
        return;
    }
%>