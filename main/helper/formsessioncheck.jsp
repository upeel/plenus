<%-- 
    Document   : formsessioncheck
    Created on : Mar 3, 2014, 11:27:29 AM
    Author     : SOE HTIKE
--%>
<%
    String ssid = (String) session.getAttribute("user");
    if (ssid == null || ssid.equals("")) {
        String requestURL = request.getRequestURL().toString();
        if (request.getQueryString() != null) {
            String requestQuery = request.getQueryString().toString();
            //System.out.println("requestURL: " + requestURL);
            //System.out.println("requestQuery: " + requestQuery);
            session.setAttribute("url", requestURL + "?" + requestQuery);
        }
        response.sendRedirect("../include/redirect.jsp");
        return;
    }
%>