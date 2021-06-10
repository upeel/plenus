<%-- 
    Document   : detailfields
    Created on : Nov 21, 2013, 10:50:58 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*" %>
<%@page import="com.bizmann.poi.resource.PropProcessor" %>
<%@page import="com.bizmann.poi.controller.*" %>
<%@page import="com.bizmann.poi.entity.*"
        import = "com.bizmann.product.controller.*"
        import = "com.bizmann.diy.admin.controller.*" %>
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

    FieldController fCtrl = new FieldController();
    FieldValidationController fvCtrl = new FieldValidationController();
    FieldDetails fDetails = fvCtrl.getFieldValidationsByFieldId(fieldId, userId);
    Field field = fDetails.getField();

    if (field.getField_type_id() == 3 || field.getField_type_id() == 4 || field.getField_type_id() == 5 || field.getField_type_id() == 11 || field.getField_type_id() == 19) {
        //check whether the field is integrated with admin list or web service
        new FieldAdminListController().defineIntegrationPoints(field);
    }

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
    //formId, fieldName, fieldDefaultValue, fieldIdentifier, fieldTypeId, mandatory,
    //basicMaxCharSel, basicMinCharSel, cbtxttype, minwords, maxwords, minnum, maxnum, cbnumtype, decnum,
    //basicMinCharSel, basicMaxCharSel, txtfileext, fieldValue

    if (todoaction.equalsIgnoreCase("update")) {
        String fieldName = request.getParameter("fieldName");
        if (fieldName == null) {
            fieldName = "";
        }
        fieldName = fieldName.trim();

        String fieldValue = request.getParameter("fieldValue");
        if (fieldValue == null) {
            fieldValue = "";
        }
        fieldValue = fieldValue.trim();

        String fieldDefaultValue = request.getParameter("fieldDefaultValue");
        if (fieldDefaultValue == null) {
            fieldDefaultValue = "";
        }
        fieldDefaultValue = fieldDefaultValue.trim();

        String basicRequired = request.getParameter("basicRequired");
        if (basicRequired == null) {
            basicRequired = "";
        }
        basicRequired = basicRequired.trim();

        boolean mandatory = false;
        if (basicRequired.equalsIgnoreCase("on")) {
            mandatory = true;
        }

        String strBasicMinCharSel = request.getParameter("basicMinCharSel");
        if (strBasicMinCharSel == null) {
            strBasicMinCharSel = "0";
        }
        strBasicMinCharSel = strBasicMinCharSel.trim();
        if (strBasicMinCharSel.equalsIgnoreCase("")) {
            strBasicMinCharSel = "0";
        }
        int basicMinCharSel = Integer.parseInt(strBasicMinCharSel);

        String strBasicMaxCharSel = request.getParameter("basicMaxCharSel");
        if (strBasicMaxCharSel == null) {
            strBasicMaxCharSel = "0";
        }
        strBasicMaxCharSel = strBasicMaxCharSel.trim();
        if (strBasicMaxCharSel.equalsIgnoreCase("")) {
            strBasicMaxCharSel = "0";
        }
        int basicMaxCharSel = Integer.parseInt(strBasicMaxCharSel);

        String cbtxttype = request.getParameter("cbtxttype");
        if (cbtxttype == null) {
            cbtxttype = "";
        }
        cbtxttype = cbtxttype.trim();

        String txtminwords = request.getParameter("txtminwords");
        if (txtminwords == null) {
            txtminwords = "0";
        }
        txtminwords = txtminwords.trim();
        if (txtminwords.equalsIgnoreCase("")) {
            txtminwords = "0";
        }
        int minwords = Integer.parseInt(txtminwords);

        String txtmaxwords = request.getParameter("txtmaxwords");
        if (txtmaxwords == null) {
            txtmaxwords = "0";
        }
        txtmaxwords = txtmaxwords.trim();
        if (txtmaxwords.equalsIgnoreCase("")) {
            txtmaxwords = "0";
        }
        int maxwords = Integer.parseInt(txtmaxwords);

        String cbnumtype = request.getParameter("cbnumtype");
        if (cbnumtype == null) {
            cbnumtype = "";
        }
        cbnumtype = cbnumtype.trim();

        String txtminnum = request.getParameter("txtminnum");
        if (txtminnum == null) {
            txtminnum = "0";
        }
        txtminnum = txtminnum.trim();
        if (txtminnum.equalsIgnoreCase("")) {
            txtminnum = "0";
        }
        int minnum = (int) (Double.parseDouble(txtminnum));

        String txtmaxnum = request.getParameter("txtmaxnum");
        if (txtmaxnum == null) {
            txtmaxnum = "0";
        }
        txtmaxnum = txtmaxnum.trim();
        if (txtmaxnum.equalsIgnoreCase("")) {
            txtmaxnum = "0";
        }
        int maxnum = (int) (Double.parseDouble(txtmaxnum));

        String txtdecnum = request.getParameter("txtdecnum");
        if (txtdecnum == null) {
            txtdecnum = "0";
        }
        txtdecnum = txtdecnum.trim();
        if (txtdecnum.equalsIgnoreCase("")) {
            txtdecnum = "0";
        }
        int decnum = Integer.parseInt(txtdecnum);

        String txtfileext = request.getParameter("txtfileext");
        if (txtfileext == null) {
            txtfileext = "";
        }
        txtfileext = txtfileext.trim();

        /*
        System.out.println("fieldName : " + fieldName);
        System.out.println("fieldValue : " + fieldValue);
        System.out.println("fieldDefaultValue : " + fieldDefaultValue);
        System.out.println("basicRequired : " + basicRequired);
        System.out.println("strBasicMinCharSel : " + strBasicMinCharSel);
        System.out.println("strBasicMaxCharSel : " + strBasicMaxCharSel);
        System.out.println("cbtxttype : " + cbtxttype);
        System.out.println("txtminwords : " + txtminwords);
        System.out.println("txtmaxwords : " + txtmaxwords);
        System.out.println("cbnumtype : " + cbnumtype);
        System.out.println("txtminnum : " + txtminnum);
        System.out.println("txtmaxnum : " + txtmaxnum);
        System.out.println("txtdecnum : " + txtdecnum);
        System.out.println("txtfileext : " + txtfileext);
        */
        fCtrl.updateField(formId, fieldId, fieldName, fieldDefaultValue, mandatory, basicMaxCharSel, basicMinCharSel,
                cbtxttype, minwords, maxwords, minnum, maxnum, cbnumtype, decnum,
                basicMinCharSel, basicMaxCharSel, txtfileext, fieldValue);
        //int fieldId = fCtrl.insertNewField(formId, fieldName, fieldDefaultValue, fieldIdentifier, fieldTypeId, mandatory,
        //        basicMaxCharSel, basicMinCharSel, cbtxttype, minwords, maxwords, minnum, maxnum, cbnumtype, decnum,
        //        basicMinCharSel, basicMaxCharSel, txtfileext, fieldValue);

        if (fieldId != 0) {
            toClose = "window.location.href='editfields.jsp?formId=" + formId + "&fieldId=" + fieldId + "';";
        } else {
            toClose = "self.close();";
        }
    }
    /*
     *  
    1 - Text Field
    2 - Text Area
    3 - Combo Box
    4 - Radio Button
    5 - Check Box
    6 - File
    7 - Number
    8 - Label
    9 - Time
    10 - Date
    11 - AutoComplete
    12 - Currency
    13 - Current Date
    14 - Sketch Board
     * 
     */

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
        <title>Edit Fields</title>
        <style>
            body { font: 12px Helvetica, Arial; overflow-x: hidden;}
        </style>
        <script>
            function doSubmit(){
                var vfieldTypeId = '<%=field.getField_type_id()%>';
                if(vfieldTypeId == '3' || vfieldTypeId == '4' || vfieldTypeId == '5' ||vfieldTypeId == '11'){
                    var vfv = document.getElementById("fieldValue").value;
                    if(vfv == '' || vfv == ' '){
                        alert("Please provide field Values for selection!");
                    }else{
                        if(<%=isFormula%>){
                            enableForm(document.getElementById("detailsFrm"));
                        }
                        document.getElementById("submitBtn").disabled = true;
                        document.getElementById("cancelBtn").disabled = true;
                        document.detailsFrm.submit();
                    }
                }else{
                    if(<%=isFormula%>){
                        enableForm(document.getElementById("detailsFrm"));
                    }
                    document.getElementById("submitBtn").disabled = true;
                    document.getElementById("cancelBtn").disabled = true;
                    document.detailsFrm.submit();
                }
            }
            
            function doCancel(){
                self.close();
            }
            
            function disableForm(form) {
                var length = form.elements.length,
                i;
                for (i=0; i < length; i++) {
                    if( form.elements[i].type === 'hidden' || form.elements[i].name === '' || form.elements[i].name === 'fieldName' || form.elements[i].name === 'submitBtn' || form.elements[i].name === 'cancelBtn'){
                        //form.elements[i].disabled = true;
                    }else{
                        form.elements[i].disabled = true;
                    }
                }
            }
            
            function enableForm(form) {
                var length = form.elements.length,
                i;
                for (i=0; i < length; i++) {
                    //if( form.elements[i].type === 'hidden' || form.elements[i].name === '' || form.elements[i].name === 'fieldName' || form.elements[i].name === 'submitBtn' || form.elements[i].name === 'cancelBtn'){
                    //form.elements[i].disabled = true;
                    //}else{
                    form.elements[i].disabled = false;
                    //}
                }
            }
            
            
            function importBtnClicked(){
                window.open('importing.jsp','','width=200,height=100');
            }
            
            function integrateBtnClicked(){
                var url = 'fieldintegration.jsp?formId=<%=formId%>&fieldId=<%=fieldId%>';
                window.open(url,'1385013844412','width=1330,height=640,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');
            }
            
            function AdminListBtnClicked(){
                var url = 'fieldadminmod.jsp?formId=<%=formId%>&fieldId=<%=fieldId%>';
                window.open(url,'1385013844412','width=1330,height=640,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');
            }
            
            function assignValue(values){
                //                $("#fieldValue").val(values.substring(0,10));
                //                $("#fieldValue").val(values);
                document.getElementById("fieldValue").innerHTML = values;
                console.log(values.substring(0,10));
            }
            
            function fnnumtypechanged(values){
                var vc = confirm("Do you wish to use default values for Min, Max & Decimal places?");
                if(vc){
                    if(values == 'anynumeric') {
                        document.getElementById("txtminnum").value = "0";
                        document.getElementById("txtmaxnum").value = "999999999";
                        document.getElementById("txtdecnum").value = "2";
                    }else if(values == 'posnumber'){
                        document.getElementById("txtminnum").value = "0";
                        document.getElementById("txtmaxnum").value = "999999999";
                        document.getElementById("txtdecnum").value = "0";
                    }else if(values == 'posnegnumber'){
                        document.getElementById("txtminnum").value = "-999999999";
                        document.getElementById("txtmaxnum").value = "999999999";
                        document.getElementById("txtdecnum").value = "0";
                    }
                }
            }
            
            $(function() {
                $( "#tabs" ).tabs();
                if(<%=isFormula%>){
                    disableForm(document.getElementById("detailsFrm"));
                    //document.getElementById("fieldName").disabled = false;
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
        <form id="detailsFrm" name="detailsFrm" method="POST" action="editfields.jsp">
            <input type="hidden" id="formId" name="formId" value="<%=formId%>"/>
            <input type="hidden" id="fieldId" name="fieldId" value="<%=fieldId%>"/>
            <input type="hidden" id="todoaction" name="todoaction" value="update"/>
            <fieldset>
                <legend>Field Properties</legend>
                <table>
                    <tr>
                        <th align="right">Name:</th>
                        <td align="left"><input type="text" id="fieldName" name="fieldName" value="<%=field.getName()%>"/></td>
                    </tr>
                    <tr>
                        <th align="right">Value:</th>
                        <td align="left" valign="middle"><textarea id="fieldValue" name="fieldValue" ><%=fValues%></textarea>
                            <% if (field.getField_type_id() == 3 || field.getField_type_id() == 4 || field.getField_type_id() == 5 || field.getField_type_id() == 11 || field.getField_type_id() == 19) {%>
                            <input type="button" id="importBtn" name="importBtn" value="Import" onclick="importBtnClicked()"/>
                            <% if (field.isIs_integrated()) {%>
                            <input type="button" id="integrateBtn" name="integrateBtn" value="Integrate" onclick="integrateBtnClicked()"/>
                            <% } else if (field.isIs_adminList()) {%>
                            <input type="button" id="adminListBtn" name="adminlistBtn" value="Admin List" onclick="AdminListBtnClicked()"/>
                            <% } else {%>
                            <input type="button" id="integrateBtn" name="integrateBtn" value="Integrate" onclick="integrateBtnClicked()"/>
                            <input type="button" id="adminListBtn" name="adminlistBtn" value="Admin List" onclick="AdminListBtnClicked()"/>
                            <% }
                                }%>
                        </td>
                    </tr>
                    <tr>
                        <th align="right">Default Value:</th>
                        <td align="left"><input type="text" id="fieldDefaultValue" name="fieldDefaultValue" value="<%=field.getDefault_value()%>"/></td>
                    </tr>
                </table>
            </fieldset>

            <fieldset>
                <legend>Field Validations</legend>
                <div id='tabs'>
                    <ul>
                        <li><a href='#tabs-1'>General</a></li>
                        <li><a href='#tabs-2'>Text</a></li>
                        <li><a href='#tabs-3'>Number</a></li>
                        <li><a href='#tabs-4'>File</a></li>
                    </ul>
                    <div id='tabs-1'>
                        <table>
                            <tr>
                                <th colspan="2">
                                    General Validations: 
                                </th>
                            </tr>
                            <tr>
                                <th align="left">Mandatory? </th>
                                <%
                                    String mandatoryChecked = "";
                                    if (field.isMandatory()) {
                                        mandatoryChecked = "checked";
                                    } else {
                                        mandatoryChecked = "";
                                    }
                                %>
                                <td align="left"><input type="checkbox" id="basicRequired" name="basicRequired" <%=mandatoryChecked%>/></td>
                            </tr>
                            <!--                            <tr>
                                                            <th align="left">Min Number: </th>
                                                            <td align="left"><input type="number" id="basicMinNumber" name="basicMinNumber" /></td>
                                                        </tr>
                                                        <tr>
                                                            <th align="left">Max Number: </th>
                                                            <td align="left"><input type="number" id="basicMaxNumber" name="basicMaxNumber" /></td>
                                                        </tr>
                            -->                                                        
                            <tr>
                                <th align="left">Min Selections:<br/><font size="0.5px">(For check box & date)</font></th>
                                <td align="left"><input type="number" id="basicMinCharSel" name="basicMinCharSel" value="<%=fValidation.getMin_selection()%>"/></td>
                            </tr>
                            <tr>
                                <th align="left">Max Selections:<br/><font size="0.5px">(For check box & date)</font></th>
                                <td align="left"><input type="number" id="basicMaxCharSel" name="basicMaxCharSel" value="<%=fValidation.getMax_selection()%>"/></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <font size="0.5px">Provide in number of Days (for date range, 0 for unlimited)</font>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id='tabs-2'>
                        <table>
                            <tr>
                                <th colspan="2">
                                    Text Validations: 
                                </th>
                            </tr>
                            <tr>
                                <th align="left">Type: </th>
                                <td align="left">
                                    <%
                                        String generalChecked = "";
                                        String emailChecked = "";
                                        String urlChecked = "";
                                        String letterChecked = "";
                                        String tmpTxtType = fValidation.getText_type();
                                        if (tmpTxtType == null) {
                                            tmpTxtType = "";
                                        }
                                        if (tmpTxtType.equalsIgnoreCase("general")) {
                                            generalChecked = "selected";
                                        } else if (tmpTxtType.equalsIgnoreCase("email")) {
                                            emailChecked = "selected";
                                        } else if (tmpTxtType.equalsIgnoreCase("url")) {
                                            urlChecked = "selected";
                                        } else if (tmpTxtType.equalsIgnoreCase("letter")) {
                                            letterChecked = "selected";
                                        }
                                    %>
                                    <select id="cbtxttype" name="cbtxttype">
                                        <option value="general" <%=generalChecked%>>Any Value</option>
                                        <option value="email" <%=emailChecked%>>Email</option>
                                        <option value="url" <%=urlChecked%>>Web URL</option>
                                        <option value="letter" <%=letterChecked%>>Only Letters</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th align="left">Min Words Required: </th>
                                <td align="left"><input type="number" id="txtminwords" name="txtminwords" value="<%=fValidation.getMin_word()%>" /></td>
                            </tr>
                            <tr>
                                <th align="left">Max Words Allowed: </th>
                                <td align="left"><input type="number" id="txtmaxwords" name="txtmaxwords" value="<%=fValidation.getMax_word()%>" /></td>
                            </tr>
                        </table>
                    </div>
                    <div id='tabs-3'>
                        <table>
                            <tr>
                                <th colspan="2">
                                    Number Validations: 
                                </th>
                            </tr>
                            <tr>
                                <%
                                    String anyChecked = "";
                                    String posChecked = "";
                                    String posnegChecked = "";
                                    String tmpNumType = fValidation.getNumber_type();
                                    if (tmpNumType == null) {
                                        tmpNumType = "";
                                    }
                                    if (tmpNumType.equalsIgnoreCase("anynumeric")) {
                                        anyChecked = "selected";
                                    } else if (tmpNumType.equalsIgnoreCase("posnumber")) {
                                        posChecked = "selected";
                                    } else if (tmpNumType.equalsIgnoreCase("posnegnumber")) {
                                        posnegChecked = "selected";
                                    }
                                %>
                                <th align="left">Type: </th>
                                <td align="left">
                                    <select id="cbnumtype" name="cbnumtype" onchange="fnnumtypechanged(this.value)">
                                        <option value="anynumeric" <%=anyChecked%>>Any ((+/-) (Numbers/Decimals))</option>
                                        <option value="posnumber" <%=posChecked%>>Whole Numbers ((+) Numbers only)</option>
                                        <option value="posnegnumber" <%=posnegChecked%>>Whole Numbers ((+/-) Numbers only)</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th align="left">Min Number: </th>
                                <td align="left"><input type="number" id="txtminnum" name="txtminnum" value="<%=fValidation.getMin_number()%>" /></td>
                            </tr>
                            <tr>
                                <th align="left">Max Number: </th>
                                <td align="left"><input type="number" id="txtmaxnum" name="txtmaxnum" value="<%=fValidation.getMax_number()%>" max="999999999"/></td>
                            </tr>
                            <tr>
                                <th align="left">Decimal Places: </th>
                                <td align="left"><input type="number" id="txtdecnum" name="txtdecnum" value="<%=fValidation.getDecimal_place()%>"/></td>
                            </tr>
                        </table>
                    </div>
                    <div id='tabs-4'>
                        <table>
                            <tr>
                                <th colspan="2">
                                    Accepted File Formats:
                                </th>
                            </tr>
                            <tr>
                                <%
                                    String tmpFileTypes = fValidation.getExtensions();
                                    if (tmpFileTypes == null) {
                                        tmpFileTypes = "";
                                    }
                                %>
                                <th align="left">Extensions: <br/>(separated by commas)<br/>(e.g., xls,doc,ppt): </th>
                                <td align="left"><input type="text" id="txtfileext" name="txtfileext" value="<%=tmpFileTypes%>"/></td>
                            </tr>
                        </table>

                    </div>
                </div>
            </fieldset>
            <input type="button" id="submitBtn" name="submitBtn" value="Update" onclick="doSubmit()"/>
            <input type="button" id="cancelBtn" name="cancelBtn" value="Close" onclick="doCancel()"/>
        </form>
    </body>
    <script><%=toClose%></script>
</html>
