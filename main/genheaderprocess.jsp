<%-- 
    Document   : genheaderprocess
    Created on : Nov 18, 2013, 11:34:19 AM
    Author     : SOE HTIKE
--%>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "java.io.*"
         import = "com.bizmann.gen.controller.*"
         import = "com.bizmann.gen.entity.*"
         import = "com.bizmann.product.resources.*"
         import = "com.jenkov.servlet.multipart.MultipartEntry" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String strgenId = request.getParameter("id");
    if (strgenId == null) {
        strgenId = "0";
    }
    String mode = request.getParameter("mode");
    if (mode == null) {
        mode = "";
    }

    String txtGenName = request.getParameter("txtGenName");
    if (txtGenName == null) {
        txtGenName = "";
    }
    String txtGenDigit = request.getParameter("txtGenDigit");
    if (txtGenDigit == null) {
        txtGenDigit = "0";
    }
    String txtGenStart = request.getParameter("txtGenStart");
    if (txtGenStart == null) {
        txtGenStart = "0";
    }

    GenController gCtrl = new GenController();

    int genDigit = Integer.parseInt(txtGenDigit);
    int genStart = Integer.parseInt(txtGenStart);
    int genId = Integer.parseInt(strgenId);

    if (mode.equalsIgnoreCase("add")) {
        boolean doReset = false;
        int resetFactor = 0;
        int resetStartNo = 0;

        GenHeader gHeader = new GenHeader();
        gHeader.setDigit(genDigit);
        gHeader.setDo_reset(doReset);
        gHeader.setGen_name(txtGenName);
        gHeader.setReset_gen_detail_id(resetFactor);
        gHeader.setReset_start_no(resetStartNo);
        gHeader.setStart_no(genStart);

        gCtrl.insertGenHeader(gHeader);
    } else if (mode.equalsIgnoreCase("edit")) {
        gCtrl.updatePartialGenHeader(txtGenName, genDigit, genStart, genId);
    } else if (mode.equalsIgnoreCase("delete")) {
        gCtrl.deleteGenHeader(genId);
    }
    
    response.sendRedirect("gen.jsp?type=Design&subtype=autogen");
%>
