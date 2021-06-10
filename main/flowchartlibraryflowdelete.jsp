<%-- 
    Document   : flowchartlibraryflowdelete
    Created on : Feb 11, 2014, 4:58:09 PM
    Author     : SOE HTIKE
--%>
<%@ page import="com.bizmann.flowchart.controller.FlowChartFlowController" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String ssid = (String) session.getAttribute("user");
    if (ssid == null || ssid.equals("")) {
        response.sendRedirect("../include/redirect.jsp");
        return;
    } else {
        //response.sendRedirect("flowchartlibraryflow.jsp?type=" + type + "&subtype=" + subtype + "&flowChartId=" + flowChartId + "&flowFormId=0&action=add");
        String type = request.getParameter("type");
        if (type == null) {
            type = "";
        }
        String subtype = request.getParameter("subtype");
        if (subtype == null) {
            subtype = "";
        }

        int flowChartId = 0;
        String strflowChartId = request.getParameter("flowChartId");
        if (strflowChartId != null) {
            if (strflowChartId.equals("")) {
                strflowChartId = "0";
            }
            flowChartId = Integer.parseInt(strflowChartId);
        }

        int flowId = 0;
        String strFlowId = request.getParameter("flowId");
        if (strFlowId == null) {
            strFlowId = "0";
        }
        strFlowId = strFlowId.trim();
        if (strFlowId.equals("")) {
            strFlowId = "0";
        }
        flowId = Integer.parseInt(strFlowId);
        new FlowChartFlowController().deleteFlow(flowId);

        response.sendRedirect("flowchartlibraryflow.jsp?type=" + type + "&subtype=" + subtype + "&flowChartId=" + flowChartId + "&flowFormId=0&action=add");
    }
%>