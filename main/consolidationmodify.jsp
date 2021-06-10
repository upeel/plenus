<%-- 
    Document   : consolidationmodify
    Created on : Mar 7, 2014, 2:02:53 PM
    Author     : SOE HTIKE
--%>
<%-- 
    Document   : consolidationdetail
    Created on : Mar 7, 2014, 10:50:37 AM
    Author     : SOE HTIKE
--%>

<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.product.resources.*" %>
<%@ page import = "com.bizmann.flowchart.controller.ConsolidationController" %>
<%@ page import = "com.bizmann.flowchart.entity.ConsolidationDetail" %>
<%@ page import = "com.bizmann.poi.entity.Field" %>

<%@ include file="helper/sessioncheck.jsp" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    String parentId = request.getParameter("parentId");
    String childId = request.getParameter("childId");
    if (parentId == null) {
        parentId = "0";
    }
    if (childId == null) {
        childId = "0";
    }

    String type = request.getParameter("type");
    if (type == null) {
        type = "";
    }

    String subtype = request.getParameter("subtype");
    if (subtype == null) {
        subtype = "";
    }

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }
    ConsolidationController conCtrl = new ConsolidationController();
    ArrayList<com.bizmann.poi.entity.Field> fieldList = conCtrl.getFieldsByActionId(Integer.parseInt(childId));
    ConsolidationDetail conD = conCtrl.getConsolidationByFlowchartByActionId(Integer.parseInt(parentId), Integer.parseInt(childId));

    if (todoaction.equalsIgnoreCase("modify")) {
        String columns = "";
        //System.out.println("here");
        String[] checkboxArr = request.getParameterValues("chkcells");
        if (checkboxArr != null) {
            for (int a = 0; a < checkboxArr.length; a++) {
                columns = columns + checkboxArr[a] + ",";
            }
            if (columns.contains(",")) {
                columns = columns.substring(0, columns.length() - 1);
            }
        }
        //System.out.println(columns);
        conCtrl.updateConsolidationByFlowchartByActionId(Integer.parseInt(parentId), Integer.parseInt(childId), columns);
        //conCtrl.insertNewConsolidation(Integer.parseInt(parentId), comboActionSelected, columns);
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <title>bmFLO</title>
        <script>
            var type = "<%=type%>";
            var subtype = "<%=subtype%>";
            var action = "<%=todoaction%>";
            
            function fnOnLoad(){
                if(action == "modify"){
                    if(subtype == "null"){
                        parent.document.location.href = "consolidationdesigner.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "consolidationdesigner.jsp?type="+type+"&subtype="+subtype;
                    }
                }
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
            
            function modifyBtnClicked(){
                if(fnCheckForChk()==true){
                    document.getElementById("todoaction").value= "modify";
                    document.consolidationFrm.submit();
                }else{
                    alert("Please check at least one field to be shown.");
                }
            }
        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png" style="width:650px">
        <%
            if (childId.equals("") || childId.equals("0") || parentId.equals("") || parentId.equals("0")) {%>
        <!-- Leave it blank -->
        <%} else {
        %>
        <div align="center" valign="top">
            <form id="consolidationFrm" name="consolidationFrm" action="consolidationmodify.jsp" method="POST">
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
                                            <br>Consolidated Dashboard Details For <%=conD.getAction_name()%><br><br>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2"><hr/>
                                    </td>
                                </tr>
                                <tr>
                                    <td width=150 align="right">&nbsp;</td>
                                    <td width=350 align="left">&nbsp;</td>
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
                                        String tmpCols = conD.getColumns();
                                        String[] colArr = tmpCols.split(",");
                                        ArrayList<String> arrayList = new ArrayList<String>(Arrays.asList(colArr));
                                        String isChecked = "";
                                        if (arrayList.contains(cell)) {
                                            isChecked = "checked";
                                        }
                                %>
                                <tr>
                                    <td align="right" valign="middle"><input type="checkbox" id="chk-<%=a%>" name="chkcells" value="<%=cell%>" <%=isChecked%>/></td>
                                    <td align="left"><%="(" + cell + ") " + name%></td>
                                </tr>
                                <%
                                    }
                                %>
                                <tr>
                                    <td colspan="2" width=500 align="right"><input type="button" id="modifyBtn" name="modifyBtn" value="Modify" onclick="modifyBtnClicked()"/></td>
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
