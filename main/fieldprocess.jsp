<%-- 
    Document   : fieldprocess
    Created on : Nov 28, 2013, 10:33:29 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*" %>
<%@page import="com.bizmann.poi.controller.*" %>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    String strFieldId = request.getParameter("fieldId");
    if (strFieldId == null) {
        strFieldId = "0";
    }
    strFieldId = strFieldId.trim();
    if (strFieldId.equals("")) {
        strFieldId = "0";
    }
    int fieldId = Integer.parseInt(strFieldId);
    
    
    String strFormId = request.getParameter("formId");
    if (strFormId == null) {
        strFormId = "0";
    }
    if (strFormId.trim().equals("")) {
        strFormId = "0";
    }
    int formId = Integer.parseInt(strFormId);

    //System.out.println("formId : " + formId);
    //System.out.println("fieldId : " + fieldId);
    
    FieldController fCtrl = new FieldController();
    fCtrl.fieldDelete(fieldId, formId);
%>