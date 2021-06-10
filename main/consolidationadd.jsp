<%-- 
    Document   : consolidationadd
    Created on : Mar 7, 2014, 11:03:25 AM
    Author     : SOE HTIKE
--%>

<%@ page import = "java.util.*" %>
<%@ page import = "java.lang.*" %>
<%@ page import = "com.bizmann.product.controller.*" %>
<%@ page import = "com.bizmann.product.entity.*" %>
<%@ page import = "com.bizmann.admin.controller.AdminUserLimitController" %>
<%@ page import = "com.bizmann.flowchart.controller.ConsolidationController" %>
<%@ page import = "com.bizmann.flowchart.entity.ConsolidationDetail" %>
<%@ page import = "com.bizmann.flowchart.entity.FlowChartAction" %>
<%@ page import = "com.bizmann.poi.entity.Field" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    String parentId = request.getParameter("parentId");
    String childId = request.getParameter("childId");
    String msg = "";

    if (parentId == null || parentId.equals("")) {
        parentId = "0";

    }
    if (childId == null || childId.equals("")) {
        childId = "0";
    }

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }

    String type = request.getParameter("type");
    if (type == null) {
        type = "";
    }

    String subtype = request.getParameter("subtype");
    if (subtype == null) {
        subtype = "";
    }

    String comboAction = request.getParameter("comboAction");
    if (comboAction == null || comboAction.equals("")) {
        comboAction = "0";
    }
    int comboActionSelected = Integer.parseInt(comboAction);

    ConsolidationController conCtrl = new ConsolidationController();
    ArrayList<FlowChartAction> actList = conCtrl.getActionListByFlowchartId(Integer.parseInt(parentId));
    ArrayList<com.bizmann.poi.entity.Field> fieldList = new ArrayList<com.bizmann.poi.entity.Field>();
    if (comboActionSelected != 0) {
        fieldList = conCtrl.getFieldsByActionId(comboActionSelected);
    }
    if (todoaction.equals("add")) {
        String columns = "";
        String[] checkboxArr = request.getParameterValues("chkcells");
        if (checkboxArr != null) {
            for (int a = 0; a < checkboxArr.length; a++) {
                columns = columns + checkboxArr[a] + ",";
            }
            if (columns.contains(",")) {
                columns = columns.substring(0, columns.length() - 1);
            }
        }
        conCtrl.insertNewConsolidation(Integer.parseInt(parentId), comboActionSelected, columns);
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/layout.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/menu/assets/skins/sam/menu.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />

        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/imageloader/imageloader-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/container/container_core-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/menu/menu-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-beta-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/button/button-min.js"></script>
        <script type="text/javascript" src="../include/js/url.js"></script>
        <script>

            var action = "<%=todoaction%>";
            var type = "<%=type%>";
            var subtype = "<%=subtype%>"
            var msg = "<%= msg%>";
            
            function fnOnLoad(){
                if(msg != "" && msg != null){
                    if(uorgunitId == "0"){
                        //  leave it blank
                    }
                    else
                    {    parent.frames.alertMessage(msg);    }
                }

                else if(action == "add"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "consolidationdesigner.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "consolidationdesigner.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }
            
            function comboActionChanged(){
                document.consolidationFrm.submit();
            }
            
            checked=false;
            function checkAll(){            
                if (checked == false) {
                    checked = true
                }
                else{
                    checked = false
                }
                for(var vi=0;vi<<%=fieldList.size()%>;vi++){
                    document.getElementById("chk-"+vi).checked=checked;
                }                
            }
            
            function fnCheckForChk(){
                var chkboxes= document.getElementsByName("chkcells");
                var vcount=0;
                for (var i =0; i < chkboxes.length; i++)
                {
                    if(chkboxes[i].checked==true){
                        vcount++;
                    }
                }
                if(vcount==0){
                    return false;
                }else{
                    return true;
                }
            }
            
            function submitBtnClicked(){
                var vcbAction = document.getElementById("comboAction");
                if(vcbAction == "0"){
                    alert("Please select an action.");
                }else{
                    if(fnCheckForChk()==true){
                        document.getElementById("todoaction").value= "add";
                        document.consolidationFrm.submit();
                    }else{
                        alert("Please check at least one field to be shown.");
                    }
                }
            }
        </script>
    </head>
    <body>
    <body onload="fnOnLoad()" class="yui-skin-sam" background="../images/background.png" style="width:650px">
        <!-- alert message -->
        <%if (!childId.equals("0") || parentId.equals("") || parentId.equals("0")) {%>
        <!--  You can't have this defined in Child, you need to have at least one parent flowchart ID   -->
        <!-- Leave it blank -->
        <%} else {%>
        <div align="center" valign="top">
            <form id="consolidationFrm" name="consolidationFrm" action="consolidationadd.jsp" method="POST">
                <table>
                    <tr>
                        <td class="orgtable" valign="top" align="center">
                            <br>
                            <table cellpadding="0">
                                <tr>
                                    <td colspan="2">
                                        <input type="hidden" id="parentId" name="parentId" value="<%=parentId%>"/>
                                        <input type="hidden" id="childId" name="childId" value="<%=childId%>"/>
                                        <input type="hidden" id="todoaction" name="todoaction" value=""/>
                                        <input type="hidden" id="type" name="type" value="<%=type%>"/>
                                        <input type="hidden" id="subtype" name="subtype" value="<%=subtype%>"/>
                                        <div class="psadtitle">
                                            <br>Add New Consolidated Dashboard<br><br>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width=150 align="right"><b>Action: </b></td>
                                    <td width=350 align="left">&nbsp;
                                        <select size="1" id="comboAction" name="comboAction" style="width:200px" align="top" onchange="comboActionChanged()" class="psadselect">
                                            <option value="0">-- Select Action --</option>
                                            <%
                                                for (int k = 0; k < actList.size(); k++) {
                                                    FlowChartAction act = actList.get(k);
                                                    String isSelected = "";
                                                    if (comboActionSelected == act.getId()) {
                                                        isSelected = "selected";
                                                    }
                                            %>
                                            <option class="psadselect option" value="<%=act.getId()%>" <%=isSelected%>><%=act.getName()%></option>
                                            <%
                                                }
                                            %>
                                        </select> 
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2"><hr/>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="middle">
                                        <input type="checkbox" id="chkall" name="chkall" value="" onClick="checkAll()"/>
                                    </td>
                                    <td><b><u>Columns to be shown</u></b>
                                    </td>
                                </tr>
                                <%
                                    for (int a = 0; a < fieldList.size(); a++) {
                                        com.bizmann.poi.entity.Field field = fieldList.get(a);
                                        String cell = field.getCell_identifier();
                                        String name = field.getName();
                                %>
                                <tr>
                                    <td align="right" valign="middle"><input type="checkbox" id="chk-<%=a%>" name="chkcells" value="<%=cell%>"/></td>
                                    <td align="left"><%="(" + cell + ") " + name%></td>
                                </tr>
                                <%
                                    }
                                %>
                                <tr>
                                    <td colspan="2" width=500 align="right"><input type="button" id="submitBtn" name="submitBtn" value="Add" onclick="submitBtnClicked()"/></td>
                                </tr>

                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <%}%>
    </body>
</html>
