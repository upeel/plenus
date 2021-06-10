<%-- 
    Document   : insertflowchart
    Created on : Dec 10, 2013, 4:36:00 PM
    Author     : SOE HTIKE
--%>
<%@page import="com.bizmann.flowchart.controller.FlowChartDesignerController" %>
<%
    String flowChartName = request.getParameter("flowchartname");
    if (flowChartName == null) {
        flowChartName = "";
    }
    //System.out.println("flowChartName : " + flowChartName);
    FlowChartDesignerController flchdCtrl = new FlowChartDesignerController();
    int flowChartId = 0;
    if (!flowChartName.trim().equalsIgnoreCase("")) {
        flowChartId = flchdCtrl.insertFlowChart(flowChartName);
    }

    if (flowChartId != 0) {
        response.sendRedirect("actiondesign.jsp?flowchartId=" + flowChartId);
    } else {
        response.sendRedirect("addflowchart.jsp");
    }
%>