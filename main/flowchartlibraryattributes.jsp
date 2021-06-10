<%-- 
    Document   : flowchartlibraryattributes
    Created on : Jan 27, 2014, 2:52:07 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.poi.controller.FormController" 
         import = "com.bizmann.poi.entity.Form" 
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.flowchart.controller.*"
         import = "com.bizmann.flowchart.entity.*"
         import = "com.bizmann.poi.entity.FirstRenderer" 
         import = "java.io.*" %>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Expires", "0");

    response.addHeader("REFRESH", request.getSession().getMaxInactiveInterval() + ";URL=../include/redirect.jsp");

    String strflowChartId = request.getParameter("flowChartId");
    if (strflowChartId == null) {
        strflowChartId = "0";
    }
    strflowChartId = strflowChartId.trim();
    if (strflowChartId.equals("")) {
        strflowChartId = "0";
    }
    int flowChartId = Integer.parseInt(strflowChartId);

    String strformId = request.getParameter("formId");
    if (strformId == null) {
        strformId = "0";
    }
    strformId = strformId.trim();
    if (strformId.equals("")) {
        strformId = "0";
    }
    int formId = Integer.parseInt(strformId);

    String stractionId = request.getParameter("actionId");
    if (stractionId == null) {
        stractionId = "0";
    }
    stractionId = stractionId.trim();
    if (stractionId.equals("")) {
        stractionId = "0";
    }
    int actionId = Integer.parseInt(stractionId);

    String type = request.getParameter("type");
    if (type == null || type.equals("")) {
        type = "Visibility";
    }

    String vController = "";
    String eController = "";

    FormController frmCtrl = new FormController();
    com.bizmann.poi.entity.Form form = frmCtrl.getFormById(formId);

    String formName = form.getName();
    String fileName = form.getPath();

    UserController userCtrl = new UserController();
    int userId = userCtrl.getUserIdByLoginId(ssid);

    FirstRenderer frdr = new FirstRenderer();
    if (type.equalsIgnoreCase("Visibility")) {
        frdr = frmCtrl.AttributeTableV(fileName, formId, actionId, userId);
        vController = "selected";
    } else if (type.equalsIgnoreCase("Editability")) {
        frdr = frmCtrl.AttributeTableE(fileName, formId, actionId, userId);
        eController = "selected";
    }
    ArrayList<String> emptyList = frdr.getEmptyList();
    String htmlTags = frdr.getHtmlTags();

    String updated = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String fieldIds = request.getParameter("txtFields");
        if (fieldIds == null) {
            fieldIds = "";
        }
        if (fieldIds.length() > 0) {
            fieldIds = fieldIds.substring(0, fieldIds.length() - 1);
        }

        String rFieldIds = request.getParameter("txtRFields");
        if (rFieldIds == null) {
            rFieldIds = "";
        }
        if (rFieldIds.length() > 0) {
            rFieldIds = rFieldIds.substring(0, rFieldIds.length() - 1);
        }

        frmCtrl.updateAttributes(type, fieldIds, rFieldIds, actionId);

        updated = "alert('Updated!');document.location.href='flowchartlibraryattributes.jsp?type=" + type + "&flowChartId=" + flowChartId + "&formId=" + formId + "&actionId=" + actionId + "'";
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/layout.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/menu/assets/skins/sam/menu.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />
        <script type="text/javascript" src="../include/js/url.js"></script>
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <script src="../include/js/jquery.ui.touch-punch.min.js"></script>
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <title>bmFLO</title>
        <script>
            var flowChartId = "<%=flowChartId%>";
            var formId = "<%=formId%>";
            var actionId = "<%=actionId%>";
            
            function select (obj) {
                //$(".selectable").removeClass("selected");
                if(obj.hasClass("selected")){
                    obj.removeClass("selected");
                    obj.addClass("unselected");
                }else{
                    obj.removeClass("unselected");
                    obj.addClass("selected");
                }
            }
            
            function fnContinue(){
                document.location.href="flowchartlibraryflow.jsp?type=" + type + "&subtype=" + subtype + "&flowChartId=" + flowChartId;
            }
            
            function fnTypeChange(value){
                document.location.href="flowchartlibraryattributes.jsp?type="+value+"&flowChartId="+flowChartId+"&formId="+formId+"&actionId="+actionId;
            }
            
            $(function(){
                $('#dvLoading').hide();
                $('#overlay').hide();
                //                $('#excelDesign').hide();
                //                $('.sigPad').signaturePad({drawOnly : true, validateFields: false});
                $(window).bind('beforeunload', function(e) {
                    $('#dvLoading').show();
                    $('#overlay').show();
                });
                
                $("#selectBtn").click(function (){
                    $('.selectable').each(function(i, obj) {
                        $(this).removeClass("unselected");
                        $(this).addClass("selected");
                    });
                    $("#updateBtn").click();
                });
                
                $("#unselectBtn").click(function (){
                    $('.selectable').each(function(i, obj) {
                        $(this).removeClass("selected");
                        $(this).addClass("unselected");
                    });
                    $("#updateBtn").click();
                });
                
                $(".selectable").mousedown( function () {
                    select($(this));
                });
                
                $(".updateBtnCls").click(function (){
                    var vfids = '';
                    $('.selected').each(function(i, obj) {
                        var vfid = $(this).attr("fieldId");
                        vfids = vfids + vfid + ',';
                    });
                    
                    var frids = '';
                    $('.unselected').each(function(i, obj) {
                        var vrid = $(this).attr("fieldId");
                        frids = frids + vrid + ',';
                    });
                    
                    var vtype = $('#cbAttrType').val();
                    document.getElementById("flowChartId").value=flowChartId;
                    document.getElementById("formId").value=formId;
                    document.getElementById("actionId").value=actionId;
                    document.getElementById("type").value=vtype;
                    document.getElementById("txtFields").value=vfids;
                    document.getElementById("txtRFields").value=frids;
                    document.frmAttr.submit();
                });
            });
        </script>
        <style>
            .selected {
                border: 3px solid #f80;
            }
        </style>
    </head>
    <!--    background="../images/background.png" style="width:650px"-->
    <body>
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <select id="cbAttrType" name="cbAttrType" onchange="fnTypeChange(this.value)">
            <option value="Visibility" <%=vController%>>Visibility</option>
            <option value="Editability" <%=eController%>>Editability</option>
        </select>*selected fields means true (visible/ediable)
        <input type="button" id="selectBtn" name="selectBtn" value="Select All" style="display:inline-block; float: right; overflow: auto; white-space: nowrap;"></input>
        <input type="button" id="unselectBtn" name="unselectBtn" value="Unselect All" style="display:inline-block; float: right; overflow: auto; white-space: nowrap;"></input>
        <input type="button" class="updateBtnCls" id="updateBtn" name="updateBtn" value="Update" style="display:inline-block; float: right; overflow: auto; white-space: nowrap;"></input>
        <%=htmlTags%>
        <input type="button" class="updateBtnCls" id="updateBtn" name="updateBtn" value="Update" style="display:inline-block; float: right; overflow: auto; white-space: nowrap;"></input>
        <form id="frmAttr" name="frmAttr" action="flowchartlibraryattributes.jsp" method="POST">
            <input type="hidden" id="type" name="type"/>
            <input type="hidden" id="txtFields" name="txtFields"/>
            <input type="hidden" id="txtRFields" name="txtRFields"/>
            <input type="hidden" id="flowChartId" name="flowChartId" value="<%=flowChartId%>"/>
            <input type="hidden" id="formId" name="formId" value="<%=formId%>"/>
            <input type="hidden" id="actionId" name="actionId" value="<%=actionId%>"/>
        </form>
    </body>
    <script>
        <%=updated%>
    </script>
</html>
