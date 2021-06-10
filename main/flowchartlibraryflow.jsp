<%-- 
    Document   : flowchartlibraryflow
    Created on : Dec 18, 2013, 5:32:39 PM
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
         import = "com.bizmann.product.resources.*" %>

<%

    //Get the current type and subtype
    String type = request.getParameter("type");
    if (type == null) {
        type = "";
    }
    String subtype = request.getParameter("subtype");
    if (subtype == null) {
        subtype = "";
    }
    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    int flowChartId = 0;
    String strflowChartId = request.getParameter("flowChartId");
    if (strflowChartId != null) {
        if (strflowChartId.equals("")) {
            strflowChartId = "0";
        }
        flowChartId = Integer.parseInt(strflowChartId);
    }

    FlowChartFlowController fcflowCtrl = new FlowChartFlowController();
    ArrayList<com.bizmann.flowchart.entity.Action> srcActionList = fcflowCtrl.getAllSourceActionsByFlowChartId(flowChartId);
    ArrayList<com.bizmann.flowchart.entity.Action> trgActionList = fcflowCtrl.getAllTargetActionsByFlowChartId(flowChartId);

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }

    String strcbiniaction = request.getParameter("cbiniaction");
    if (strcbiniaction == null) {
        strcbiniaction = "0";
    }
    strcbiniaction = strcbiniaction.trim();
    if (strcbiniaction.equals("")) {
        strcbiniaction = "0";
    }
    int cbiniactionSelected = Integer.parseInt(strcbiniaction);

    String strcbsrcaction = request.getParameter("cbsrcaction");
    if (strcbsrcaction == null) {
        strcbsrcaction = "0";
    }
    strcbsrcaction = strcbsrcaction.trim();
    if (strcbsrcaction.equals("")) {
        strcbsrcaction = "0";
    }
    int cbsrcactionSelected = Integer.parseInt(strcbsrcaction);


    String strcbtrgaction = request.getParameter("cbtrgaction");
    if (strcbtrgaction == null) {
        strcbtrgaction = "0";
    }
    strcbtrgaction = strcbtrgaction.trim();
    if (strcbtrgaction.equals("")) {
        strcbtrgaction = "0";
    }
    int cbtrgactionSelected = Integer.parseInt(strcbtrgaction);

    ArrayList numericFieldList = new ArrayList();
    ArrayList choiceFieldList = new ArrayList();

    boolean isCondition = false;
    boolean isResponse = false;

    if (cbiniactionSelected == 0) {
        cbiniactionSelected = fcflowCtrl.getInitiatingAction(flowChartId);
    }

    String scripting = "";
    if (todoaction.equalsIgnoreCase("srcChange")) {
        String tmpType = "";
        for (int i = 0; i < srcActionList.size(); i++) {
            com.bizmann.flowchart.entity.Action tmpSrcAction = srcActionList.get(i);
            if (tmpSrcAction.getId() == cbsrcactionSelected) {
                tmpType = tmpSrcAction.getType();
                break;
            }
        }
        if (tmpType.equalsIgnoreCase("Decision")) {
            numericFieldList = fcflowCtrl.getNumbericFieldsByFlowChartId(flowChartId);
            choiceFieldList = fcflowCtrl.getChoiceFieldsByFlowChartId(flowChartId);
            scripting = "$('#dvCondition').show();";
            isCondition = true;
        } else {
            scripting = "$('#dvResponse').show();";
            isResponse = true;
        }
    } else if (todoaction.equalsIgnoreCase("iniChange")) {
        fcflowCtrl.updateInitiatingAction(flowChartId, cbiniactionSelected);
        cbsrcactionSelected = 0;
        cbtrgactionSelected = 0;
    } else if (todoaction.equalsIgnoreCase("addNew")) {
        //System.out.println(todoaction);
        com.bizmann.flowchart.entity.Action srcActionToInsert = new com.bizmann.flowchart.entity.Action();
        com.bizmann.flowchart.entity.Action trgActionToInsert = new com.bizmann.flowchart.entity.Action();

        for (int i = 0; i < srcActionList.size(); i++) {
            com.bizmann.flowchart.entity.Action tmpSrcAction = srcActionList.get(i);
            if (tmpSrcAction.getId() == cbsrcactionSelected) {
                srcActionToInsert = tmpSrcAction;
                break;
            }
        }
        for (int i = 0; i < trgActionList.size(); i++) {
            com.bizmann.flowchart.entity.Action tmpTrgAction = trgActionList.get(i);
            if (tmpTrgAction.getId() == cbtrgactionSelected) {
                trgActionToInsert = tmpTrgAction;
                break;
            }
        }

        String strCondFieldId = request.getParameter("cbcondfield");
        if (strCondFieldId == null) {
            strCondFieldId = "0";
        }
        strCondFieldId = strCondFieldId.trim();
        if (strCondFieldId.equals("")) {
            strCondFieldId = "0";
        }
        int condfieldid = Integer.parseInt(strCondFieldId);

        String condfieldvalue = request.getParameter("txtcondvalue");
        if (condfieldvalue == null) {
            condfieldvalue = "";
        }
        String condfieldtype = request.getParameter("cbcondtype");
        if (condfieldtype == null) {
            condfieldtype = "";
        }

        String txtResponse = request.getParameter("txtResponse");
        if (txtResponse == null) {
            txtResponse = "";
        }

        fcflowCtrl.insertNewFlow(flowChartId, srcActionToInsert.getId(), trgActionToInsert.getId(), srcActionToInsert.getType(), srcActionToInsert.getName(),
                trgActionToInsert.getName(), txtResponse, condfieldid, condfieldvalue, condfieldtype);
        cbsrcactionSelected = 0;
        cbtrgactionSelected = 0;
    }

    ArrayList<FlowChartFlow> flowList = fcflowCtrl.getAllFlowByFlowChartId(flowChartId);
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/layout.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/menu/assets/skins/sam/menu.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />

        <script type="text/javascript" src="../include/js/jquery-1.10.2.css"></script>
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/imageloader/imageloader-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/container/container_core-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/menu/menu-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-beta-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/button/button-min.js"></script>
        <script type="text/javascript" src="../include/js/url.js"></script>
        <script type="text/javascript" src="../include/js/jquery-1.10.2.js"></script>
        <style>
            .selected{
                background:#ACD6F5;
                border:1px solid grey;
            }
        </style>
        <script>
            
            var action = "<%=action%>";
            var type = "<%=type%>";
            var subtype = "<%=subtype%>"
            var isCondition = <%=isCondition%>;
            var isResponse = <%=isResponse%>;
            var flowChartId = <%=flowChartId%>;

            function intgerationBtnClicked(vflowId, vflowchartId){
                var url = 'flowchartflowintegration.jsp?flowId='+vflowId+'&flowchartId='+vflowchartId;
                window.open(url,'1385013844412','width=1330,height=640,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');
            }
            
            function fnOnLoad(){
                if(action == "add"){
                    //redirect the user
                    if(subtype == "null"){
                        //parent.document.location.href = "flowchartlibrary.jsp?type="+type;
                    }
                    else{
                        //parent.document.location.href = "flowchartlibrary.jsp?type="+type+"&subtype="+subtype;
                    }
                }
                $('#dvCondition').hide();
                $('#dvResponse').hide();
                if(isCondition == true){
                    $('#dvCondition').show();
                }else if(isResponse == true){
                    $('#dvResponse').show();
                }
                
                $("#btnPreview").click( function (e) {
                    e.preventDefault();
                    fnPreview();
                });
            }
            
            function fnSubmit(){
                var condition_type = document.getElementById("cbcondtype").value;
                var response_text = document.getElementById("txtResponse").value;
                if(response_text != ''){
                    document.frmFlowChartFlow.method = "POST";
                    document.frmFlowChartFlow.action = "flowchartlibraryflow.jsp?type="+type+"&subtype="+subtype+"&todoaction=addNew";
                    document.frmFlowChartFlow.submit();
                }else{
                    if(condition_type == '7' || condition_type == '11' ){
                        document.frmFlowChartFlow.method = "POST";
                        document.frmFlowChartFlow.action = "flowchartlibraryflow.jsp?type="+type+"&subtype="+subtype+"&todoaction=addNew";
                        document.frmFlowChartFlow.submit();
                    }else{
                        var condition_value = document.getElementById("txtcondvalue").value;
                        if(condition_value == ''){
                            alert('Please provide a value for the condition to be matched against!');
                        }else{
                            document.frmFlowChartFlow.method = "POST";
                            document.frmFlowChartFlow.action = "flowchartlibraryflow.jsp?type="+type+"&subtype="+subtype+"&todoaction=addNew";
                            document.frmFlowChartFlow.submit();
                        }
                    }
                }
                //                $('#dvResponse').show();
            }
            
            function fnPreview(){
                window.open('flowchartpreview.jsp?flowChartId=<%=flowChartId%>');
            }
            
            function fnbackBtn(){
                document.location.href="flowchartlibraryproperties.jsp?type=" + type + "&subtype=" + subtype + "&flowChartId=" + flowChartId;
            }
            
            function fnsourcechange(){
                document.frmFlowChartFlow.method = "POST";
                document.frmFlowChartFlow.action = "flowchartlibraryflow.jsp?type="+type+"&subtype="+subtype+"&todoaction=srcChange";
                document.frmFlowChartFlow.submit();
                //                $('#dvResponse').show();
            }
            
            function fnIniChange(){
                document.frmFlowChartFlow.method = "POST";
                document.frmFlowChartFlow.action = "flowchartlibraryflow.jsp?type="+type+"&subtype="+subtype+"&todoaction=iniChange";
                document.frmFlowChartFlow.submit();
                //                $('#dvResponse').show();
            }
            
            function fnpopulatefields(value){
                document.getElementById("cbcondfield").options.length=0;
                if(value == '6'){
            <%
                for (int a = 0; a < choiceFieldList.size(); a++) {
                    Field tmpfield = (Field) choiceFieldList.get(a);
                    int id = tmpfield.getId();
                    String name = tmpfield.getName();
            %>
                        document.getElementById("cbcondfield").options[<%=a%>]=new Option("<%=name%>", "<%=id%>");
            <% }%>
                    } else if(value == '1' || value == '2' || value == '3' || value == '4' || value == '5'){
            <%
                for (int a = 0; a < numericFieldList.size(); a++) {
                    Field tmpfield = (Field) numericFieldList.get(a);
                    int id = tmpfield.getId();
                    String name = tmpfield.getName();
            %>
                        document.getElementById("cbcondfield").options[<%=a%>]=new Option("<%=name%>", "<%=id%>");
            <% }%>
                    } else if(value == '11' || value == '7' ){
                        //$('#cbcondfield').css("visibility", "hidden");
                        //$('#txtcondvalue').css("visibility", "hidden");
                    } else if(value == '8' || value == '9'){
                        //$('#cbcondfield').css("visibility", "hidden");
                    } else if(value == '10'){
                        alert('Please define the integration point separately after adding this flow.');
                    }
                }
            
                //            $(document).ready(function() {
                //            });
        </script>
    </head>
    <body onload="fnOnLoad()" class="yui-skin-sam" background="images/background.png" style="width:650px">
        <div align="center" valign="top">
            <form name="frmFlowChartFlow" id="frmFlowChartFlow" action="flowchartlibraryflow.jsp">
                <table>
                    <% if (flowChartId != 0) {%>
                    <tr>
                        <td class="orgtable" colspan="2" valign="top" align="center">
                            <br>
                            <table>
                                <tr>
                                    <th colspan="2">
                                <div class="psadtitle">
                                    <br>Define Flow Details<br><br>
                                </div>
                                </th>
                    </tr>
                </table>
                </td>
            </tr><tr>
            <td width=150 align="right"><b>Initiating Action: </b></td>
            <td width=350 align="left">
                &nbsp;
                <select id="cbiniaction" name="cbiniaction" class="psadtext" onchange="fnIniChange()">
                    <option value="0">-- Please Select --</option>
                    <%
                        for (int i = 0; i < srcActionList.size(); i++) {
                            com.bizmann.flowchart.entity.Action srcAction = srcActionList.get(i);
                            String isSelected = "";
                            if (cbiniactionSelected == srcAction.getId()) {
                                isSelected = "selected";
                            } else {
                                isSelected = "";
                            }
                    %>
                    <option value="<%=srcAction.getId()%>" <%=isSelected%>><%=srcAction.getName()%></option>
                    <% }%>
                </select>
            </td>
        </tr>
        <tr>
            <td colspan="2"><hr/></td>
        </tr>
        <tr>
            <td width=150 align="right"><b>Source: </b></td>
            <td width=350 align="left">
                &nbsp;
                <select id="cbsrcaction" name="cbsrcaction" class="psadtext" onchange="fnsourcechange()">
                    <option value="0">-- Please Select --</option>
                    <%
                        for (int i = 0; i < srcActionList.size(); i++) {
                            com.bizmann.flowchart.entity.Action srcAction = srcActionList.get(i);
                            String isSelected = "";
                            if (cbsrcactionSelected == srcAction.getId()) {
                                isSelected = "selected";
                            } else {
                                isSelected = "";
                            }
                    %>
                    <option value="<%=srcAction.getId()%>" <%=isSelected%>><%=srcAction.getName()%></option>
                    <% }%>
                </select>
                <input type="hidden" id="action" name="action" value="<%=action%>"/>
                <input type="hidden" id="type" name="type" value="<%=type%>"/>
                <input type="hidden" id="subtype" name="subtype" value="<%=subtype%>"/>
                <input type="hidden" id="flowChartId" name="flowChartId" value="<%=flowChartId%>"/>
            </td>
        </tr>
        <tr>
            <td width=150 align="right"><b>Target: </b></td>
            <td width=350 align="left">
                &nbsp;
                <select id="cbtrgaction" name="cbtrgaction" class="psadtext">
                    <option value="0">-- Please Select --</option>
                    <%
                        for (int i = 0; i < trgActionList.size(); i++) {
                            com.bizmann.flowchart.entity.Action trgAction = trgActionList.get(i);
                            String isSelected = "";
                            if (cbtrgactionSelected == trgAction.getId()) {
                                isSelected = "selected";
                            } else {
                                isSelected = "";
                            }
                    %>
                    <option value="<%=trgAction.getId()%>" <%=isSelected%>><%=trgAction.getName()%></option>
                    <% }%>
                </select>
            </td>
        </tr>
        <tr id="dvResponse" name="dvResponse">
            <td width=150 align="right"><b>Response: </b></td>
            <td width=350 align="left">&nbsp;<input type="text" id="txtResponse" name="txtResponse" /></td>
        </tr>
        <tr id="dvCondition" name="dvCondition">
            <td width=150 align="right"><b>Condition: </b></td>
            <td width=350 align="left">
                Type &nbsp;
                <select id="cbcondtype" name="cbcondtype" class="psadtext" onchange="fnpopulatefields(this.value)">
                    <option value="0">-- Please Select --</option>
                    <option value="1">Numeric (Greater than)</option>
                    <option value="2">Numeric (Greater than OR Equal to)</option>
                    <option value="3">Numeric (Less than)</option>
                    <option value="4">Numeric (Less than OR Equal to)</option>
                    <option value="5">Numeric (Equal to)</option>
                    <option value="6">Choice</option>
                    <option value="7">is HOD</option>
                    <option value="11">NOT HOD</option>
                    <option value="8">is Designation</option>
                    <option value="12">NOT Designation</option>
                    <option value="9">is Department</option>
                    <option value="13">NOT Department</option>
                    <option value="10">Integration (Web Service - WSDL) == Value</option>
                    <option value="14">Integration (Web Service - WSDL) != Value</option>
                </select>
                <br/>
                Field &nbsp;
                <select id="cbcondfield" name="cbcondfield" class="psadtext">
                    <option value="0">-- Please Select --</option>
                </select>
                <br/>
                Condition (Only ONE value) &nbsp;
                <input type="text" id="txtcondvalue" name="txtcondvalue" />
            </td>
        </tr>
        <tr>
        </tr>
        <tr>
            <td width=150 align="right">&nbsp;</td>
            <td width=350 align="left">&nbsp;
                <input type="button" value="Add" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
            </td>
        </tr>
        <tr>
            <td width=150 align="right">&nbsp;</td>
            <td width=350 align="left">&nbsp;</td>
        </tr>
        <input type="hidden" id="hidAction" name="hidAction">
        <input type="hidden" id="hidType" name="hidType">
        <input type="hidden" id="hidSubtype" name="hidSubtype">
        </table>
        </td>
        </tr>
        <% }%>
        </table>
    </form>
    <table background="../images/background.png" border="1" cellpadding="2px" style="text-align:left;font:80% arial,helvetica,clean,sans-serif;border-collapse:collapse;table-layout:auto" width="500px">
        <tr style="background:#333333; text-align:left; color:#ffffff; border:1px solid #fff; border-right:none">
            <td><b>No.</b></td>
            <td><b>Source Action</b></td>
            <td><b>Target Action</b></td>
            <td><b>Response</b></td>
            <td>&nbsp;</td>
        </tr>
        <%
            for (int a = 0; a < flowList.size(); a++) {
                FlowChartFlow tmpFlow = flowList.get(a);
        %>
        <tr>
            <td><%=a + 1%></td>
            <td><%=tmpFlow.getSource_action_name()%></td>
            <td><%=tmpFlow.getTarget_action_name()%></td>
            <td><%=tmpFlow.getResponse_name()%></td>
            <td>
                <a href="flowchartlibraryflowdelete.jsp?flowId=<%=tmpFlow.getId()%>&type=<%=type%>&subtype=<%=subtype%>&flowChartId=<%=flowChartId%>&flowFormId=0&action=add">[Delete]</a>

                <% if (tmpFlow.isIs_integration()) {%>
                <a href="#" id="intgerationBtn" name="intgerationBtn" onclick="intgerationBtnClicked('<%=tmpFlow.getId()%>', '<%=flowChartId%>')" >[Define Int.]</a>
                <% }%>
            </td>
        </tr>
        <% }%>
        <tr>
            <td colspan="5" align="center">&nbsp;
                <input name="btnPreview" id="btnPreview" type="image" src="images/flowchartpreview.png" alt="Preview" style="cursor:pointer"/>
                <!--                <input type="button" value="Preview" name="btnPreview" class="psadbutton" width="100" onclick="fnPreview()">-->
            </td>
        </tr>
    </table>
    <input class="psadbutton" type="button" id="backBtn" name="backBtn" value="Back to Activities" onclick="fnbackBtn()"/>
</div>
<script>
    <%=scripting%>
</script>
</body>
</html>
