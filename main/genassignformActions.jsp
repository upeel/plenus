<%-- 
    Document   : genassignformActions
    Created on : Nov 29, 2013, 10:10:43 AM
    Author     : SOE HTIKE
--%>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "java.io.*"
         import = "com.bizmann.gen.controller.*"
         import = "com.bizmann.gen.entity.*"
         import = "com.jenkov.servlet.multipart.MultipartEntry" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String mode = request.getParameter("mode");
    if (mode == null) {
        mode = "";
    }
    String cbGen = request.getParameter("cbGen");
    if (cbGen == null || cbGen.equals("")) {
        cbGen = "0";
    }
    String cbActRes = request.getParameter("cbActRes");
    if (cbActRes == null || cbActRes.equals("")) {
        cbActRes = "";
    }
    String streditid = request.getParameter("id");
    if (streditid == null || streditid.equals("")) {
        streditid = "0";
    }
    int editId = Integer.parseInt(streditid);

    GenAssignController gasCtrl = new GenAssignController();

    int genId = Integer.parseInt(cbGen);
    int flowChartId = 0;
    int actionId = 0;
    int responseId = 0;
    if (!cbActRes.equals("")) {
        String[] cbActResArr = cbActRes.split("_");
        if (cbActResArr.length == 3) {
            if (cbActResArr[0].length() > 0 && cbActResArr[1].length() > 0 && cbActResArr[2].length() > 0) {
                flowChartId = Integer.parseInt(cbActResArr[0]);
                actionId = Integer.parseInt(cbActResArr[1]);
                responseId = Integer.parseInt(cbActResArr[2]);
            }
        }
    }

    if (mode.equalsIgnoreCase("add")) {
        if (flowChartId > 0 && actionId > 0 && responseId > 0) {
            gasCtrl.insertGenControl(flowChartId, actionId, responseId, genId);
        }
    } else if (mode.equalsIgnoreCase("edit")) {
        //gCtrl.updatePartialGenHeader(txtGenName, genDigit, genStart, genId);
    } else if (mode.equalsIgnoreCase("delete")) {
        System.out.println("editId : " + editId);
        gasCtrl.deleteGenControlForJson(editId);
    }

    response.sendRedirect("genassignform.jsp?flowChartId=" + flowChartId);
%>
