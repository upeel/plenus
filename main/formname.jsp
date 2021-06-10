<%-- 
    Document   : formname
    Created on : Apr 14, 2014, 5:27:49 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "java.net.*"
        import="com.bizmann.poi.controller.*"
        import = "com.bizmann.product.controller.*" %>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    String strFormId = request.getParameter("formId");
    if (strFormId == null) {
        strFormId = "0";
    }
    if (strFormId.trim().equals("")) {
        strFormId = "0";
    }
    int formId = Integer.parseInt(strFormId);

    FormController frmCtrl = new FormController();
    //boolean isActivated = frmCtrl.isFormActivated(formId);
    //if (isActivated) {
    //    return;
    //}

    int userId = 0;
    int authGrpId = 0;
    if (ssid == null || ssid.equals("")) {
    } else {
        UserController userCtrl = new UserController();
        userId = userCtrl.getUserIdByLoginId(ssid);

        UserAuthGrpController authGrpCtrl = new UserAuthGrpController();
        authGrpId = authGrpCtrl.getAuthGrpIdByUserId(userId);
    }
    if (authGrpId == 1) {
    } else if (authGrpId == 3) {
        boolean doesBelong = frmCtrl.formBelongs2User(userId, formId);
        if (!doesBelong) {
            return;
        }
    }

    boolean isSuccess = false;

    String formName = request.getParameter("formName");
    if (formName == null) {
        formName = "";
    }
    formName = formName.trim();

    if (!frmCtrl.checkDupForm(formName)) {
        isSuccess = frmCtrl.updateFormName(formId, formName);
    }
%>
[{"txtResult":"<%=isSuccess%>"}]