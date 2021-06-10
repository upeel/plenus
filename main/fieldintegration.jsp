<%-- 
    Document   : fieldintegration
    Created on : Jun 3, 2014, 3:23:47 PM
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
        import = "com.bizmann.diy.admin.controller.*" %>
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

    FieldIntegrationController intCtrl = new FieldIntegrationController();
    IntegrationPoint intPoint = intCtrl.getIntegrationPointByFieldByForm(fieldId, formId);
    Field field = intCtrl.getFieldByFieldId(fieldId);
    if (field.getField_type_id() == 3 || field.getField_type_id() == 4 || field.getField_type_id() == 5 || field.getField_type_id() == 11 || field.getField_type_id() == 19) {
        //check whether the field is integrated with admin list or web service
        new FieldAdminListController().defineIntegrationPoints(field);
    }
    IntegrationHeader intHeader = intPoint.getIntegration_header();
    ArrayList<IntegrationDetail> intDetailList = intPoint.getIntegration_detail_list();

    ArrayList<Field> fieldList = new ArrayList<Field>();

    String txturl = request.getParameter("txturl");
    if (txturl == null) {
        txturl = intHeader.getWsdl_url();
        if (txturl == null) {
            txturl = "";
        }
    }
    txturl = txturl.trim();
    if (!txturl.contains("http://") && !txturl.equals("")) {
        txturl = "http://" + txturl;
    }

    String comboOperation = request.getParameter("comboOperation");
    if (comboOperation == null) {
        comboOperation = intHeader.getOperation();
        if (comboOperation == null) {
            comboOperation = "0";
        }
    }
    comboOperation = comboOperation.trim();
    if (comboOperation.equals("")) {
        comboOperation = "0";
    }

    String comboPort = request.getParameter("comboPort");
    if (comboPort == null) {
        comboPort = intHeader.getPort_type();
        if (comboPort == null) {
            comboPort = "";
        }
    }
    comboPort = comboPort.trim();

    String comboNodes = request.getParameter("comboNodes");
    if (comboNodes == null) {
        comboNodes = intHeader.getNode();
        if (comboNodes == null) {
            comboNodes = "0";
        }
    }
    comboNodes = comboNodes.trim();
    if (comboNodes.equals("")) {
        comboNodes = "0";
    }

    WSDLController wsdlCtrl = new WSDLController();
    boolean canExecute = true;
    String responseXML = "";
    ArrayList<String> portList = new ArrayList<String>();
    ArrayList<String> operationList = new ArrayList<String>();
    ArrayList<String> params = new ArrayList<String>();
    ArrayList<String> nodesList = new ArrayList<String>();
    ArrayList<String> valueList = new ArrayList<String>();
    ArrayList<ParamEntity> paramValueList = new ArrayList<ParamEntity>();

    boolean isValidUrl = wsdlCtrl.isValidURL(txturl);

    if (isValidUrl && !txturl.equals("")) {
        portList = wsdlCtrl.getPortList(txturl);
        if (comboPort.equals("") && portList.size() > 0) {
            comboPort = portList.get(0);
        }
        operationList = wsdlCtrl.getSOAP12OperationsList(txturl, comboPort);
    } else if (!txturl.equals("") && !isValidUrl) {
        toClose = "alert('Invalid URL!');";
    }

    if (!comboOperation.equals("0")) {
        params = wsdlCtrl.getParams(txturl, comboOperation, comboPort);
    }

    if (!comboOperation.equals("0") && params.size() == 0) {
        responseXML = wsdlCtrl.executeRequest(txturl, comboOperation, comboPort, paramValueList);
    } else {
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            for (int b = 0; b < params.size(); b++) {
                String param = params.get(b);
                String comboparam = request.getParameter("combo" + param);
                if (comboparam == null) {
                    comboparam = "0";
                }
                if (comboparam.equals("")) {
                    comboparam = "0";
                }

                String paramfield = request.getParameter("comboparam" + param);
                if (paramfield == null) {
                    paramfield = "0";
                }
                if (paramfield.equals("")) {
                    paramfield = "0";
                }
                String txtparam = request.getParameter("txt" + param);
                if (txtparam == null) {
                    txtparam = "";
                }
                txtparam = txtparam.trim();

                ParamEntity paramEnt = new ParamEntity();
                paramEnt.setKey(param);
                paramEnt.setType(Integer.parseInt(comboparam));
                paramEnt.setField_input(Integer.parseInt(paramfield));
                paramEnt.setValue(txtparam);
                if (txtparam.equals("")) {
                    canExecute = false;
                }
                paramValueList.add(paramEnt);
            }
        } else {
            if (intDetailList.size() > 0) {
                for (int x = 0; x < intDetailList.size(); x++) {
                    IntegrationDetail intDetail = intDetailList.get(x);
                    ParamEntity paramEnt = new ParamEntity();
                    paramEnt.setKey(intDetail.getKey());
                    paramEnt.setType(intDetail.getType());
                    paramEnt.setField_input(intDetail.getField_input());
                    paramEnt.setValue(intDetail.getValue());
                    paramValueList.add(paramEnt);
                }
            }
            canExecute = true;
        }
        if (canExecute) {
            responseXML = wsdlCtrl.executeRequest(txturl, comboOperation, comboPort, paramValueList);
        }
    }

    if (responseXML != null && !responseXML.equals("")) {
        nodesList = wsdlCtrl.getAllNodes(responseXML);
        if (!comboNodes.equals("0")) {
            valueList = wsdlCtrl.getSpecificTag(responseXML, comboNodes);
            if (valueList.size() <= 0) {
                toClose = "alert('Returned Value is Empty!');";
            }
        }
    }
    //System.out.println("nodesList : " + nodesList.size());

    if (valueList.size() > 0) {
        String todoaction = request.getParameter("todoaction");
        if (todoaction == null) {
            todoaction = "";
        }
        if (todoaction.equalsIgnoreCase("finaladd")) {
            FieldIntegrationController integrationCtrl = new FieldIntegrationController();
            if (intHeader.getId() > 0) {
                //int integrationId = 0;
                int integrationId = integrationCtrl.updateFieldIntegrationPoint(intHeader.getId(), txturl, comboPort, comboOperation, comboNodes,
                        fieldId, formId, paramValueList);
                if (integrationId > 0) {
                    toClose = "alert('Integration Point Updated Successfully!');opener.location.reload(true);self.close();";
                } else {
                    toClose = "alert('WARNING: Integration Point Update FAILED!');";
                }
            } else {
                //int integrationId = 0;
                int integrationId = integrationCtrl.insertNewFieldIntegrationPoint(txturl, comboPort, comboOperation, comboNodes,
                        fieldId, formId, paramValueList);
                if (integrationId > 0) {
                    toClose = "alert('Integration Point Added Successfully!');opener.location.reload(true);self.close();";
                } else {
                    toClose = "alert('WARNING: Integration Point Adding FAILED!');";
                }
            }
        }
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

        <title>bmFLO</title>
        <style>
            #divFrm {
                position: absolute;
                top: 100px;
                display: block;
                width: 520px;
            }
            #divRes {
                position: absolute;
                top: 100px;
                border: 1px solid black; 
                padding:5px;
                left: 600px;
            }
        </style>
        <script>
            function txturlChanged(){
                document.frmIntegration.submit();
            }
            
            function comboOperationChanged(){
                document.frmIntegration.submit();
            }
            
            function paramBtnClicked(){
                document.frmIntegration.submit();
            }
            
            function comboNodesChanged(){
                document.frmIntegration.submit();
            }
            
            function comboPortChanged(){
                document.frmIntegration.submit();
            }
            
            function finalSubmitBtnClicked(){
                document.getElementById("todoaction").value = "finaladd";
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
        <% if (formId > 0 && (!field.isIs_adminList())) {%>
        <h1>Integration Point On <%=field.getName()%>!</h1>
        <div style="display: block;">
            <div id="divFrm">
                <form id="frmIntegration" name="frmIntegration" method="POST" action="fieldintegration.jsp">
                    <table background="../images/background.png" border="1" cellpadding="2px" style="word-wrap:break-word;text-align:left;font-family: arial;border-collapse:collapse;table-layout: fixed;" width="500px">
                        <!--                        <tr>
                                                    <td width="170px">
                                                        <label for="fieldId">Field</label>
                                                    </td>
                                                    <td width="410px">
                                                        <select id="fieldId" name="fieldId">
                                                            <option value="0">--- Please Select a Field ---</option>
                                                            <
                                                                for (int a = 0; a < fieldList.size(); a++) {
                                                                    Field tmpField = fieldList.get(a);
                                                                    String comboFieldSelected = "";
                                                                    if (fieldId == tmpField.getId()) {
                                                                        comboFieldSelected = "selected";
                                                                    } else {
                                                                        comboFieldSelected = "";
                                                                    }
                                                            %>
                                                            <option value="<=tmpField.getId()%>" <=comboFieldSelected%>><=StringEscapeUtils.escapeHtml(tmpField.getName())%></option>
                                                            <}%>
                                                        </select>
                                                    </td>
                                                </tr>-->
                        <% if (fieldId > 0) {%>
                        <tr>
                            <td width="170px">
                                <input type="hidden" id="formId" name="formId" value="<%=formId%>"/>
                                <input type="hidden" id="fieldId" name="fieldId" value="<%=fieldId%>"/>
                                <input type="hidden" id="todoaction" name="todoaction" />
                                <label for="txturl">WSDL URL : </label>
                            </td>
                            <td width="410px">
                                <input type="text" size="60" id="txturl" name="txturl" value="<%=txturl%>" onchange="txturlChanged()"/>
                            </td>
                        </tr>
                        <% if (portList != null && portList.size() > 0) {%>
                        <tr>
                            <td>
                                <label for="comboPort">Port Type List : </label>
                            </td>
                            <td>
                                <select id="comboPort" name="comboPort" onchange="comboPortChanged()">
                                    <%
                                        for (int a = 0; a < portList.size(); a++) {
                                            String port = portList.get(a);
                                            String comboPortSelected = "";
                                            if (comboPort.equalsIgnoreCase(port)) {
                                                comboPortSelected = "selected";
                                            } else {
                                                comboPortSelected = "";
                                            }
                                    %>
                                    <option value="<%=StringEscapeUtils.escapeHtml(port)%>" <%=comboPortSelected%>><%=StringEscapeUtils.escapeHtml(port)%></option>
                                    <% }%>
                                </select>
                            </td>
                        </tr>
                        <%}%>
                        <% if (operationList != null && operationList.size() > 0) {%>
                        <tr>
                            <td>
                                <label for="comboOperation">Operation List : </label>
                            </td>
                            <td>
                                <select id="comboOperation" name="comboOperation" onchange="comboOperationChanged()">
                                    <option value="0">--- Please Select an Operation ---</option>
                                    <%
                                        for (int a = 0; a < operationList.size(); a++) {
                                            String operation = operationList.get(a);
                                            String comboOpSelected = "";
                                            if (comboOperation.equalsIgnoreCase(operation)) {
                                                comboOpSelected = "selected";
                                            } else {
                                                comboOpSelected = "";
                                            }
                                    %>
                                    <option value="<%=StringEscapeUtils.escapeHtml(operation)%>" <%=comboOpSelected%>><%=StringEscapeUtils.escapeHtml(operation)%></option>
                                    <% }%>
                                </select>
                            </td>
                        </tr>
                        <%}%>
                        <%
                            if (params != null && params.size() > 0) {
                                for (int b = 0; b < params.size(); b++) {
                                    String param = params.get(b);
                                    String comboFixedParamSelected = "";
                                    String comboUserParamSelected = "";
                                    String comboDesignationParamSelected = "";
                                    String comboDepartmentParamSelected = "";
                                    String comboFieldParamSelected = "";
                                    String txtParamValue = "";
                                    int paramFieldSelected = 0;
                                    for (int c = 0; c < paramValueList.size(); c++) {
                                        ParamEntity paramEnt = paramValueList.get(c);
                                        String tmpKey = paramEnt.getKey();
                                        if (tmpKey.equalsIgnoreCase(param)) {
                                            int tmpType = paramEnt.getType();
                                            txtParamValue = paramEnt.getValue();
                                            paramFieldSelected = paramEnt.getField_input();
                                            if (tmpType == 0) {
                                                comboFixedParamSelected = "selected";
                                            } else if (tmpType == 1) {
                                                comboUserParamSelected = "selected";
                                            } else if (tmpType == 2) {
                                                comboDesignationParamSelected = "selected";
                                            } else if (tmpType == 3) {
                                                comboDepartmentParamSelected = "selected";
                                            }
                                            break;
                                        }
                                    }
                        %>
                        <tr>
                            <td><%=StringEscapeUtils.escapeHtml(param)%></td>
                            <td>
                                <label for="combo<%=StringEscapeUtils.escapeHtml(param)%>">Value Type : </label>
                                <select id="combo<%=StringEscapeUtils.escapeHtml(param)%>" name="combo<%=StringEscapeUtils.escapeHtml(param)%>">
                                    <option value="0" <%=comboFixedParamSelected%>>Fixed</option>
                                    <option value="1" <%=comboUserParamSelected%>>User</option>
                                    <option value="2" <%=comboDesignationParamSelected%>>Designation</option>
                                    <option value="3" <%=comboDepartmentParamSelected%>>Department</option>
                                </select>
                                <br/>
                                <label for="txt<%=StringEscapeUtils.escapeHtml(param)%>">Value <font size="1px">(For Fixed Type & Sample Execution)</font> : </label>
                                <input type="text" id="txt<%=StringEscapeUtils.escapeHtml(param)%>" name="txt<%=StringEscapeUtils.escapeHtml(param)%>" value="<%=txtParamValue%>"/>
                            </td>
                        </tr>
                        <% }%>
                        <tr>
                            <td colspan="2">
                                <input type="button" id="paramBtn" name="paramBtn" value="Submit" onclick="paramBtnClicked()" />
                            </td>
                        </tr>
                        <% }%>
                        <% if (nodesList != null && nodesList.size() > 0) {%>
                        <tr>
                            <td>
                                <label for="comboNodes">Nodes List : </label>
                            </td>
                            <td>
                                <select id="comboNodes" name="comboNodes" onchange="comboNodesChanged()">
                                    <option value="0">--- Please Select Node ---</option>
                                    <%
                                        for (int a = 0; a < nodesList.size(); a++) {
                                            String node = nodesList.get(a);
                                            String comboNodeSelected = "";
                                            if (comboNodes.equalsIgnoreCase(node)) {
                                                comboNodeSelected = "selected";
                                            } else {
                                                comboNodeSelected = "";
                                            }
                                    %>
                                    <option value="<%=StringEscapeUtils.escapeHtml(node)%>" <%=comboNodeSelected%>><%=StringEscapeUtils.escapeHtml(node)%></option>
                                    <% }%>
                                </select>
                            </td>
                        </tr>
                        <%}%>
                        <% if (valueList != null && valueList.size() > 0) {%>
                        <tr>
                            <td colspan="2">
                                <div style="overflow:auto; height:200px; width:580px;">
                                    <% for (int d = 0; d < valueList.size(); d++) {%>
                                    <%=(d + 1) + " - " + valueList.get(d)%>
                                    <br/>
                                    <% }%>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <% if (valueList.size() > 0) {%>
                                <input type="button" id="finalSubmitBtn" name="finalSubmitBtn" value="Confirm & Add" onclick="finalSubmitBtnClicked()" />
                                <% }%>
                            </td>
                        </tr>
                        <% }%>
                        <% }%>
                    </table>
                </form>
            </div>
            <div id="divRes" style="overflow:auto; height:480px; width:700px;">
                <h2>Raw Returned Data</h2>
                <% if (responseXML != null && !responseXML.equals("")) {%>
                <!--                StringEscapeUtils.escapeXml-->
                <!--                //wsdlCtrl.format-->
                <textarea rows="18" cols="110" style="border:none;" readonly><%=wsdlCtrl.format(responseXML)%></textarea>
                <% }%>
            </div>
        </div>
        <% }%>
    </body>
    <script>
        <%=toClose%>
    </script>
</html>
