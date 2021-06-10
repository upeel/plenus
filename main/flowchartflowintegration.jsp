<%-- 
    Document   : flowchartflowintegration
    Created on : Mar 31, 2014, 3:12:31 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.poi.entity.Field"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.flowchart.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.flowchart.entity.*"
         import = "com.jenkov.servlet.multipart.MultipartEntry"
         import = "java.io.*"
         import = "com.bizmann.product.resources.*" 
         import="com.bizmann.integration.controller.*"
         import="com.bizmann.integration.entity.*" 
         import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    String strflowId = request.getParameter("flowId");
    if (strflowId == null) {
        strflowId = "0";
    }
    strflowId = strflowId.trim();
    if (strflowId.equals("")) {
        strflowId = "0";
    }
    int flowId = Integer.parseInt(strflowId);

    String strflowchartId = request.getParameter("flowchartId");
    if (strflowchartId == null) {
        strflowchartId = "0";
    }
    strflowchartId = strflowchartId.trim();
    if (strflowchartId.equals("")) {
        strflowchartId = "0";
    }
    int flowchartId = Integer.parseInt(strflowchartId);

    String txturl = "";
    String comboOperation = "";
    String comboPort = "";
    String comboNodes = "";

    IntegrationController intCtrl = new IntegrationController();

    IntegrationPoint intPoint = intCtrl.getIntegrationPointByFlowByFlowChart(flowId, flowchartId);
    IntegrationHeader intHeader = intPoint.getIntegration_header();
    ArrayList<IntegrationDetail> intDetailList = intPoint.getIntegration_detail_list();

    FlowChartFlowController fcfCtrl = new FlowChartFlowController();
    FlowChartFlow fcf = fcfCtrl.getFlowById(flowId, flowchartId);
    ArrayList<Field> allFieldList = fcfCtrl.getAllFieldsByFlowChartId(flowchartId);

    String toClose = "";

    txturl = request.getParameter("txturl");
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

    comboOperation = request.getParameter("comboOperation");
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

    comboPort = request.getParameter("comboPort");
    if (comboPort == null) {
        comboPort = intHeader.getPort_type();
        if (comboPort == null) {
            comboPort = "";
        }
    }
    comboPort = comboPort.trim();

    comboNodes = request.getParameter("comboNodes");
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
            if (valueList.size() > 1) {
                toClose = "alert('Returned Value can only be one!');";
            }
        }
    }

    if (valueList.size() == 1) {
        String todoaction = request.getParameter("todoaction");
        if (todoaction == null) {
            todoaction = "";
        }
        if (todoaction.equalsIgnoreCase("finaladd")) {
            IntegrationController integrationCtrl = new IntegrationController();
            if (intHeader.getId() > 0) {
                int integrationId = integrationCtrl.updateIntegrationPoint(intHeader.getId(), txturl, comboPort, comboOperation, comboNodes, fcf.getCondition_id(), flowchartId, paramValueList);
                if (integrationId > 0) {
                    toClose = "alert('Integration Point Updated Successfully!');self.close();";
                } else {
                    toClose = "alert('WARNING: Integration Point Update FAILED!');";
                }
            } else {
                int integrationId = integrationCtrl.insertNewIntegrationPoint(txturl, comboPort, comboOperation, comboNodes, fcf.getCondition_id(), flowchartId, paramValueList);
                if (integrationId > 0) {
                    toClose = "alert('Integration Point Added Successfully!');self.close();";
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
        <title>bmFLO</title>
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/style.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
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
            
            function paramFieldPopulate(){
                
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
    </head>
    <body>
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <% if (flowId > 0 && flowchartId > 0) {%>
        <h1>Integration Point On - From : <%=fcf.getSource_action_name()%>, To : <%=fcf.getTarget_action_name()%>!</h1>
        <div style="display: block;">
            <div id="divFrm">
                <form id="frmIntegration" name="frmIntegration" method="POST" action="flowchartflowintegration.jsp">
                    <table background="../images/background.png" border="1" cellpadding="2px" style="word-wrap:break-word;text-align:left;font-family: arial;border-collapse:collapse;table-layout: fixed;" width="500px">
                        <tr>
                            <td width="170px">
                                <input type="hidden" id="flowId" name="flowId" value="<%=flowId%>"/>
                                <input type="hidden" id="flowchartId" name="flowchartId" value="<%=flowchartId%>"/>
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
                                            } else if (tmpType == 4) {
                                                comboFieldParamSelected = "selected";
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
                                    <option value="4" <%=comboFieldParamSelected%>>Fields</option>
                                </select>
                                <br/>
                                <label for="comboparam<%=StringEscapeUtils.escapeHtml(param)%>">Field : </label>
                                <select id="comboparam<%=StringEscapeUtils.escapeHtml(param)%>" name="comboparam<%=StringEscapeUtils.escapeHtml(param)%>">
                                    <option value ="0">-- Please select a Field (for "Fields" type) --</option>
                                    <%
                                        for (int a = 0; a < allFieldList.size(); a++) {
                                            Field tmpfield = (Field) allFieldList.get(a);
                                            int id = tmpfield.getId();
                                            String name = tmpfield.getName();
                                            String paramFieldSelectedstr = "";
                                            if(paramFieldSelected == id){
                                                paramFieldSelectedstr = "selected";
                                            }
                                    %>
                                    <option value="<%=id%>" <%=paramFieldSelectedstr%>><%=name%></option>
                                    <% }%>
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
                                <% if (valueList.size() == 1) {%>
                                <input type="button" id="finalSubmitBtn" name="finalSubmitBtn" value="Confirm & Add" onclick="finalSubmitBtnClicked()" />
                                <% }%>
                            </td>
                        </tr>
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
</body>
</html>
