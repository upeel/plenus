<%-- 
    Document   : performancedelete
    Created on : Mar 6, 2014, 3:02:36 PM
    Author     : SOE HTIKE
--%>
<%@ include file="helper/sessioncheck.jsp" %>
<%@page import="com.bizmann.product.controller.PerformanceController" %>
<%
    String strId = request.getParameter("id");
    if (strId == null) {
        strId = "0";
    }
    strId = strId.trim();
    if (strId.equals("")) {
        strId = "0";
    }
    int id = Integer.parseInt(strId);
    if (id != 0) {
        new PerformanceController().deletePerformanceEntity(id);
    }
%>