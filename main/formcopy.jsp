<%-- 
    Document   : formcopy
    Created on : Apr 8, 2014, 3:54:48 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,com.bizmann.poi.resource.PropProcessor" 
         import="com.bizmann.poi.controller.*"
         import="com.bizmann.poi.entity.Form"
         import = "com.bizmann.product.controller.*" %>

<%@ include file="helper/sessioncheck.jsp" %>
<!DOCTYPE html>
<%
    String strformId = request.getParameter("formId");
    if (strformId == null) {
        strformId = "0";
    }
    strformId = strformId.trim();
    if (strformId.equals("")) {
        strformId = "0";
    }
    int formId = Integer.parseInt(strformId);

    FormController frmCtrl = new FormController();
    
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
    
    String feedbackmsg = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String formName = request.getParameter("txtfrmname");
        if (formName == null) {
            formName = "";
        }


        if (!frmCtrl.checkDupForm(formName)) {
            Form oldForm = frmCtrl.getFormById(formId);
            int generatedFormId = frmCtrl.insertNewForm(formName, oldForm.getPath(), oldForm.getFile(), userId, userId);
            if (generatedFormId > 0) {
                if (new CopyFormController().copyFieldsByFormId(formId, generatedFormId, userId)) {
                    feedbackmsg = "document.location.href='formdesign.jsp?formId=" + generatedFormId + "';opener.location.reload(true);";
                } else {
                    feedbackmsg = "alert('Failed to Copy Field Details!');";
                }
            } else {
                feedbackmsg = "alert('Failed to Copy Form Details!');";
            }
        } else {
            feedbackmsg = "alert('Unable to create Duplicate Form Name!');";
        }
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Copy Form</title>
        <script src="../include/js/jquery-1.10.2.js"></script>
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <script>
            
            $(document).ready(function(){
                $('#dvLoading').hide();
                $(window).bind('beforeunload', function(e) {
                    $('#dvLoading').show();
                });
            });
            
            function fnSubmit(){
                var vFrmName = document.getElementById("txtfrmname").value;
                if(vFrmName == ""){
                    alert("Please provide a form Name!");
                }else{
                    document.getElementById("submitBtn").disabled = true;
                    document.copyFrm.submit();
                }
            }
        </script>
    </head>
    <body>
        <div id="dvLoading"></div>
        <div align="center" valign="top">
            <form id="copyFrm" name="copyFrm" action="formcopy.jsp" method="POST">
                <input type="text" id="txtfrmname" name="txtfrmname" />
                <input type="hidden" id="formId" name="formId" value="<%=formId%>"/>
                <input type="button" id="submitBtn" name="submitBtn" onclick="fnSubmit()" value="Submit"/>
            </form>
    </body>
    <script>
        <%=feedbackmsg%>
    </script>
</html>
