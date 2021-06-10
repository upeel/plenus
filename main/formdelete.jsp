<%-- 
    Document   : formdelete
    Created on : Feb 11, 2014, 3:36:25 PM
    Author     : SOE HTIKE
--%>
<%@ page import="com.bizmann.poi.controller.FormController"
         import = "com.bizmann.product.controller.*" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String ssid = (String) session.getAttribute("user");
    if (ssid == null || ssid.equals("")) {
        response.sendRedirect("../include/redirect.jsp");
        return;
    } else {
        int formId = 0;
        String strFormId = request.getParameter("formId");
        if (strFormId == null) {
            strFormId = "0";
        }
        strFormId = strFormId.trim();
        if (strFormId.equals("")) {
            strFormId = "0";
        }
        formId = Integer.parseInt(strFormId);

        FormController frmCtrl = new FormController();

        boolean isActivated = frmCtrl.isFormActivated(formId);

        if (isActivated) {
            return;
        }

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

        new FormController().deleteForm(formId);
        response.sendRedirect("formadd.jsp?type=Design");
    }
%>
