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
        import = "com.bizmann.product.controller.*" %>
<%@ include file="helper/sessioncheck.jsp" %>
<!DOCTYPE html>
<%
    String strFieldTypeId = request.getParameter("ftId");
    if (strFieldTypeId == null) {
        strFieldTypeId = "0";
    }
    if (strFieldTypeId.trim().equals("")) {
        strFieldTypeId = "0";
    }

    int fieldTypeId = Integer.parseInt(strFieldTypeId);

    String fieldIdentifier = request.getParameter("fId");
    if (fieldIdentifier == null) {
        fieldIdentifier = "0";
    }
    if (fieldIdentifier.trim().equals("")) {
        fieldIdentifier = "0";
    }

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
    
    String toClose = "";
    String minmax = "1";
    if (fieldTypeId == 10) {
        minmax = "0";
    }
    if ("POST".equalsIgnoreCase(request.getMethod())) {
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
        FieldController fCtrl = new FieldController();
        int fieldId = fCtrl.insertNewField(formId, fieldName, fieldDefaultValue, fieldIdentifier, fieldTypeId, mandatory,
                basicMaxCharSel, basicMinCharSel, cbtxttype, minwords, maxwords, minnum, maxnum, cbnumtype, decnum,
                basicMinCharSel, basicMaxCharSel, txtfileext, fieldValue);

        if (fieldId != 0) {
            toClose = "window.opener.add(" + fieldId + ");self.close();";
        } else {
            toClose = "alert('New Field Insertion Failed! Please try again.');";
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
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <title></title>
        <style>
            body { font: 12px Helvetica, Arial; overflow-x: hidden;}
        </style>
        <script>
            function doSubmit(){
                var vfieldTypeId = '<%=fieldTypeId%>';
                if(vfieldTypeId == '3' || vfieldTypeId == '4' || vfieldTypeId == '5' ||vfieldTypeId == '11'){
                    var vfv = document.getElementById("fieldValue").value;
                    if(vfv == '' || vfv == ' '){
                        alert("Please provide field Values for selection!");
                    }else{
                        document.detailsFrm.submit();
                    }
                }else{
                    document.detailsFrm.submit();
                }
            }
            
            function doCancel(){
                window.opener.remove();
                self.close();
            }
            
            function fnOpenWindow(URL) {
                var arguments = 'resizable=1,toolbar=0,location=0,directories=0,addressbar=0,scrollbars=1,status=1,menubar=0,top=0,left=0, screenX=200,screenY=100,width=200,height=100';
                newwindow = window.open(URL,'mywindow',arguments);
                newwindow.moveTo(0,0);
            }
            
            
            function importBtnClicked(){
                window.open('importing.jsp','','width=200,height=100');
            }
            
            function assignValue(values){
                //                $("#fieldValue").val(values.substring(0,10));
                //                $("#fieldValue").val(values);
                document.getElementById("fieldValue").innerHTML = values;
                console.log(values.substring(0,10));
            }
            
            $(function() {
                $( "#tabs" ).tabs();
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
        <form id="detailsFrm" name="detailsFrm" method="POST" action="detailfields.jsp">
            <input type="hidden" id="ftId" name="ftId" value="<%=fieldTypeId%>"/>
            <input type="hidden" id="fId" name="fId" value="<%=fieldIdentifier%>"/>
            <input type="hidden" id="formId" name="formId" value="<%=formId%>"/>
<!--            <input type="hidden" id="action" name="action" value="add"/>-->
            <fieldset>
                <legend>Field Properties</legend>
                <table>
                    <tr>
                        <th align="right">Name:</th>
                        <td align="left"><input type="text" id="fieldName" name="fieldName" /></td>
                    </tr>
                    <tr>
                        <th align="right">Value:</th>
                        <td align="left" valign="middle">
                            <textarea id="fieldValue" name="fieldValue" ></textarea>
                            <input type="button" id="importBtn" name="importBtn" value="Import" onclick="importBtnClicked()"/>
                        </td>
                    </tr>
                    <tr>
                        <th align="right">Default Value:</th>
                        <td align="left"><input type="text" id="fieldDefaultValue" name="fieldDefaultValue" /></td>
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
                                <td align="left"><input type="checkbox" id="basicRequired" name="basicRequired" /></td>
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
                                <td align="left"><input type="number" id="basicMinCharSel" name="basicMinCharSel" value="<%=minmax%>" /></td>
                            </tr>
                            <tr>
                                <th align="left">Max Selections:<br/><font size="0.5px">(For check box & date)</font></th>
                                <td align="left"><input type="number" id="basicMaxCharSel" name="basicMaxCharSel" value="<%=minmax%>" /></td>
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
                                    <select id="cbtxttype" name="cbtxttype">
                                        <option value="general" selected>Any Value</option>
                                        <option value="email">Email</option>
                                        <option value="url">Web URL</option>
                                        <option value="letter">Only Letters</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th align="left">Min Words Required: </th>
                                <td align="left"><input type="number" id="txtminwords" name="txtminwords" value="0" /></td>
                            </tr>
                            <tr>
                                <th align="left">Max Words Allowed: </th>
                                <td align="left"><input type="number" id="txtmaxwords" name="txtmaxwords" value="200" /></td>
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
                                <th align="left">Type: </th>
                                <td align="left">
                                    <select id="cbnumtype" name="cbnumtype">
                                        <option value="anynumeric" selected>Any ((+/-) (Numbers/Decimals))</option>
                                        <option value="posnumber">Whole Numbers ((+) Numbers only)</option>
                                        <option value="posnegnumber">Whole Numbers ((+/-) Numbers only)</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th align="left">Min Number: </th>
                                <td align="left"><input type="number" id="txtminnum" name="txtminnum" value="0" /></td>
                            </tr>
                            <tr>
                                <th align="left">Max Number: </th>
                                <td align="left"><input type="number" id="txtmaxnum" name="txtmaxnum" value="999999999" max="999999999"/></td>
                            </tr>
                            <tr>
                                <th align="left">Decimal Places: </th>
                                <td align="left"><input type="number" id="txtdecnum" name="txtdecnum" value="2"/></td>
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
                                <th align="left">Extensions: <br/>(separated by commas)<br/>(e.g., xls,doc,ppt): </th>
                                <td align="left"><input type="text" id="txtfileext" name="txtfileext" /></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </fieldset>
            <input type="button" id="submitBtn" name="submitBtn" value="Submit" onclick="doSubmit()"/>
            <input type="button" id="cancelBtn" name="cancelBtn" value="Cancel" onclick="doCancel()"/>
        </form>
    </body>
    <script><%=toClose%></script>
</html>
