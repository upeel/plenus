<%-- 
    Document   : copyfields
    Created on : Mar 19, 2014, 2:29:11 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*" %>
<%@page import="com.bizmann.poi.resource.PropProcessor" %>
<%@page import="com.bizmann.poi.controller.*" %>
<%@page import="com.bizmann.poi.entity.*" %>
<%@page import="com.bizmann.product.controller.*" %>
<%@ include file="helper/sessioncheck.jsp" %>
<!DOCTYPE html>
<%
    String strFormId = request.getParameter("formId");
    if (strFormId == null) {
        strFormId = "0";
    }
    if (strFormId.trim().equals("")) {
        strFormId = "0";
    }
    int formId = Integer.parseInt(strFormId);

    String strFieldId = request.getParameter("fieldId");
    if (strFieldId == null) {
        strFieldId = "0";
    }
    if (strFieldId.trim().equals("")) {
        strFieldId = "0";
    }
    int fieldId = Integer.parseInt(strFieldId);

    String toClose = "";

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }
    UserController userCtrl = new UserController();
    int userId = userCtrl.getUserIdByLoginId(ssid);

    FieldController fCtrl = new FieldController();
    FieldValidationController fvCtrl = new FieldValidationController();
    FieldDetails fDetails = fvCtrl.getFieldValidationsByFieldId(fieldId, userId);
    Field field = fDetails.getField();
    FieldValidation fValidation = fDetails.getFieldValidation();
    ArrayList<FieldValue> fValuesList = fDetails.getFieldValuesList();
    StringBuilder sbd = new StringBuilder();
    for (int a = 0; a < fValuesList.size(); a++) {
        FieldValue fValue = fValuesList.get(a);
        sbd.append(fValue.getValue());
        if (a != (fValuesList.size() - 1)) {
            sbd.append(",");
        }
    }
    String fValues = sbd.toString();

    boolean isFormula = fCtrl.isFormulaField(fieldId);

    if (!isFormula && todoaction.equalsIgnoreCase("copy")) {
        String comboCopyType = request.getParameter("comboCopyType");
        if (comboCopyType == null) {
            comboCopyType = "";
        }
        String txtCopyCount = request.getParameter("txtCopyCount");
        if (txtCopyCount == null || txtCopyCount.equals("")) {
            txtCopyCount = "0";
        }
        txtCopyCount = txtCopyCount.trim();
        if (txtCopyCount.equals("")) {
            txtCopyCount = "0";
        }

        if (!comboCopyType.equals("") && Integer.parseInt(txtCopyCount) > 0) {
            if (fValidation.getExtensions() == null) {
                fValidation.setExtensions("");
            }
            //System.out.println("formId : " + formId);
            //System.out.println("field.getName() : " + field.getName());
            //System.out.println("field.getDefault_value() : " + field.getDefault_value());
            //System.out.println("field.getField_type_id() : " + field.getField_type_id());
            //System.out.println("fValidation.getMax_selection() : " + fValidation.getMax_selection());
            //System.out.println("fValidation.getMin_selection() : " + fValidation.getMin_selection());
            boolean isDuplicates = new CopyFieldController().massInsert(comboCopyType, Integer.parseInt(txtCopyCount), formId, field.getName(), field.getDefault_value(),
                    field.getCell_identifier(), field.getField_type_id(), field.isMandatory(),
                    fValidation.getMax_selection(), fValidation.getMin_selection(), fValidation.getText_type(), fValidation.getMin_word(),
                    fValidation.getMax_word(), fValidation.getMin_number(), fValidation.getMax_number(), fValidation.getNumber_type(),
                    fValidation.getDecimal_place(), fValidation.getMin_selection(), fValidation.getMax_selection(), fValidation.getExtensions(), fValues);
            if (isDuplicates) {
                toClose = "opener.location.reload(true);alert('Existing Fields Detected. Unable to copy into some cells!');self.close();";
            } else {
                toClose = "opener.location.reload(true);self.close();";
            }
        }
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/style.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <title>Copy Fields</title>
        <style>
            body { font: 12px Helvetica, Arial; overflow-x: hidden;}
        </style>
        <script>
            function submitBtnClicked(){
                var count = parseFloat(document.getElementById("txtCopyCount").value);
                if(count <= 0){
                    alert("You have to copy at least to next 1 cell!");
                }else{
                    document.getElementById("submitBtn").disabled = true;
                    document.copyFrm.submit();
                }
            }
            
            $(function() {
                if(<%=isFormula%>){
                    //disableForm(document.getElementById("detailsFrm"));
                    //document.getElementById("fieldName").disabled = false;
                    alert('Formula Fields cannot be copied!');
                    self.close();
                }
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
        <form id="copyFrm" name="copyFrm" method="POST" action="copyfields.jsp">
            <input type="hidden" id="formId" name="formId" value="<%=formId%>"/>
            <input type="hidden" id="fieldId" name="fieldId" value="<%=fieldId%>"/>
            <input type="hidden" id="todoaction" name="todoaction" value="copy"/>
            <label for="comboCopyType">Copy : </label>
            <select id="comboCopyType" name="comboCopyType">
                <option value="Vertical">Vertical</option>
                <option value="Horizontal">Horizontal</option>
            </select>
            <label for="txtCopyCount">For Next No. of Cells</label>
            <input type="number" id="txtCopyCount" name="txtCopyCount" min="1" value="1"/>
            <input type="button" id="submitBtn" name="submitBtn" value="Submit" onclick="submitBtnClicked()"/>
            <h5><font color="red">
                Warning: Copying fields on a Cell with Existing field would cause the field to be over-written.
                <br/>
                If it happens, delete the extra field and refresh the page - to bring back the old field.
                </font></h5>
        </form>
    </body>
    <script>
        <%=toClose%>
    </script>
</html>
