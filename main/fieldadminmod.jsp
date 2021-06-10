<%-- 
    Document   : fieldadminmod
    Created on : Jul 14, 2014, 11:10:47 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*" %>
<%@page import="com.bizmann.poi.resource.*" %>
<%@page import="com.bizmann.product.controller.*" %>
<%@page import="com.bizmann.product.entity.*" %>
<%@page import="com.bizmann.product.resources.CommentUtil" %>
<%@page import="com.bizmann.poi.controller.*" %>
<%@page import="org.apache.poi.ss.usermodel.*" %>
<%@page import="org.apache.poi.ss.util.*" %>
<%@page import="com.bizmann.poi.entity.*" %>
<%@page import="com.bizmann.servlet.upload.*" %>
<%@page import="org.apache.commons.lang.StringEscapeUtils" 
        import="com.bizmann.integration.controller.*"
        import="com.bizmann.integration.entity.*"
        import = "com.bizmann.diy.admin.controller.*"
        import = "com.bizmann.diy.admin.entity.*" %>
<%@ include file="helper/sessioncheck.jsp" %>
<!DOCTYPE html>
<%
    String strFormId = request.getParameter("formId");
    if (strFormId == null) {
        strFormId = "0";
    }
    if (strFormId.equals("")) {
        strFormId = "0";
    }
    int formId = Integer.parseInt(strFormId);

    String strFieldId = request.getParameter("fieldId");
    if (strFieldId == null) {
        strFieldId = "0";
    }
    if (strFieldId.equals("")) {
        strFieldId = "0";
    }
    int fieldId = Integer.parseInt(strFieldId);

    String toClose = "";

    FieldAdminListController falCtrl = new FieldAdminListController();
    FieldAdminList fieldAdminList = falCtrl.getAdminListIntegrationPoint(fieldId, formId);
    Field field = falCtrl.getFieldByFieldId(fieldId);
    if (field.getField_type_id() == 3 || field.getField_type_id() == 4 || field.getField_type_id() == 5 || field.getField_type_id() == 11 || field.getField_type_id() == 19) {
        //check whether the field is integrated with admin list or web service
        falCtrl.defineIntegrationPoints(field);
    }

    ArrayList<AdminHeader> adminHeaderList = falCtrl.getAllAdminInfo();

    String comboHeaderId = request.getParameter("comboHeaderId");
    if (comboHeaderId == null) {
        comboHeaderId = Integer.toString(fieldAdminList.getHeader_id());
        if (comboHeaderId == null) {
            comboHeaderId = "0";
        }
    }
    comboHeaderId = comboHeaderId.trim();
    if (comboHeaderId.equals("")) {
        comboHeaderId = "0";
    }
    int headerId = Integer.parseInt(comboHeaderId);

    String comboDetailId = request.getParameter("comboDetailId");
    if (comboDetailId == null) {
        comboDetailId = Integer.toString(fieldAdminList.getDetail_id());
        if (comboDetailId == null) {
            comboDetailId = "0";
        }
    }
    comboDetailId = comboDetailId.trim();
    if (comboDetailId.equals("")) {
        comboDetailId = "0";
    }
    int detailId = Integer.parseInt(comboDetailId);

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }

    ArrayList<AdminDetail> columnList = new ArrayList<AdminDetail>();
    if (headerId > 0) {
        columnList = falCtrl.getColumnList(headerId);
    }

    if (todoaction.equalsIgnoreCase("finaladd")) {
        if (fieldAdminList.getId() > 0) {
            boolean success = falCtrl.updateAdminListIntegrationPoint(fieldId, formId, headerId, detailId);
            if (success) {
                toClose = "alert('Integration Point Updated Successfully!');opener.location.reload(true);self.close();";
            } else {
                toClose = "alert('WARNING: Integration Point Update FAILED!');";
            }
        } else {
            int integrationId = falCtrl.insertAdminListIntegrationPoint(fieldId, formId, headerId, detailId);
            if (integrationId > 0) {
                toClose = "alert('Integration Point Added Successfully!');opener.location.reload(true);self.close();";
            } else {
                toClose = "alert('WARNING: Integration Point Adding FAILED!');";
            }
        }
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/js/url.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <script src="../include/time/jquery.timeentry.js"></script>
        <script type="text/javascript" src="../include/js/jquery.validationEngine-en.js" charset="utf-8"></script>
        <script type="text/javascript" src="../include/js/jquery.validationEngine.js"></script>
        <script type="text/javascript" src="../include/js/jquery.signaturepad.min.js"></script>
        <script type="text/javascript" src="include/js/autosaveform.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/css/jquery.signaturepad.css"/>
        <link rel="stylesheet" type="text/css" href="../include/css/validationEngine.jquery.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/time/jquery.timeentry.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />

        <script src="../include/js/vendor/jquery.ui.widget.js"></script>
        <script src="../include/js/jquery.iframe-transport.js"></script>
        <script src="../include/js/jquery.fileupload.js"></script>
        <script src="../include/js/jquery.fileupload-ui.js"></script>
        <script src="../include/bootstrap/js/bootstrap.min.js"></script>
        <!--                <link href="../include/bootstrap/css/bootstrap.css" type="text/css" rel="stylesheet" />-->
        <link href="../include/css/myuploadcss.css" type="text/css" rel="stylesheet" />
        <link href="../include/css/mycommentcss.css" type="text/css" rel="stylesheet" />
        <link rel="stylesheet" href="../include/css/jquery.fileupload-ui.css">
        <link href="../include/css/dropzone.css" type="text/css" rel="stylesheet" />
        <script src="../include/js/myuploadfunction.js"></script>
        <script type="text/javascript">
            function finalSubmitBtnClicked(){
                var vhead = document.getElementById("comboHeaderId").value;
                var vdetail = document.getElementById("comboDetailId").value;
                if(vhead == '' || vhead == '0' || vdetail == '' || vdetail == '0'){
                    alert("Please select both the List and the Column!");
                }else{
                    document.getElementById("todoaction").value = "finaladd";
                    document.frmIntegration.submit();
                }
            }
            
            function comboHeaderIdChanged(){
                //document.getElementById("todoaction").value = "finaladd";
                document.frmIntegration.submit();
            }
            
            $(document).ready(function(){
                $('#dvLoading').hide();
                $('#overlay').hide();
                $(window).bind('beforeunload', function(e) {
                    $('#dvLoading').show();
                    $('#overlay').show();
                });
            });
        </script>
    </head>
    <body>
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <% if (formId > 0 && (!field.isIs_integrated())) {%>
        <h1>Field Value with Admin list On <%=field.getName()%>!</h1>
        <form id="frmIntegration" name="frmIntegration" method="POST" action="fieldadminmod.jsp">
            <table background="../images/background.png" border="1" cellpadding="2px" style="word-wrap:break-word;text-align:left;font-family: arial;border-collapse:collapse;table-layout: fixed;" width="500px">
                <tr>
                    <td>
                        <input type="hidden" id="formId" name="formId" value="<%=formId%>"/>
                        <input type="hidden" id="fieldId" name="fieldId" value="<%=fieldId%>"/>
                        <input type="hidden" id="todoaction" name="todoaction" />
                        <label for="comboHeaderId">Admin Module List : </label>
                    </td>
                    <td>
                        <select id="comboHeaderId" name="comboHeaderId" onchange="comboHeaderIdChanged()">
                            <option value="0">--- Please select a List ---</option>
                            <%
                                for (int a = 0; a < adminHeaderList.size(); a++) {
                                    AdminHeader adminHeader = adminHeaderList.get(a);
                                    int id = adminHeader.getId();
                                    String name = adminHeader.getName();

                                    String comboHeadSelected = "";
                                    if (headerId == id) {
                                        comboHeadSelected = "selected";
                                    } else {
                                        comboHeadSelected = "";
                                    }
                            %>
                            <option value="<%=id%>" <%=comboHeadSelected%>><%=StringEscapeUtils.escapeHtml(name)%></option>
                            <% }%>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label for="comboDetailId">Column List : </label>
                    </td>
                    <td>
                        <select id="comboDetailId" name="comboDetailId">
                            <option value="0">--- Please Select a Column ---</option>
                            <%
                                for (int a = 0; a < columnList.size(); a++) {
                                    AdminDetail adDetail = columnList.get(a);
                                    int id = adDetail.getId();
                                    String name = adDetail.getName();

                                    String comboDetailSelected = "";
                                    if (detailId == id) {
                                        comboDetailSelected = "selected";
                                    } else {
                                        comboDetailSelected = "";
                                    }
                            %>
                            <option value="<%=id%>" <%=comboDetailSelected%>><%=StringEscapeUtils.escapeHtml(name)%></option>
                            <% }%>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><input type="button" id="SubmitBtn" name="SubmitBtn" value="Submit" onclick="finalSubmitBtnClicked()" /></td>
                </tr>
            </table>
        </form>
        <% }%>
    </body>
    <script>
        <%=toClose%>
    </script>
</html>
