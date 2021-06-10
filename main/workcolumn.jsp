<%-- 
    Document   : workcolumn
    Created on : Jun 29, 2015, 9:10:36 AM
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

    String type = request.getParameter("type");
    if (type == null) {
        type = "";
    }
    String subtype = request.getParameter("subtype");
    if (subtype == null) {
        subtype = "";
    }

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

    FormController frmCtrl = new FormController();
    com.bizmann.poi.entity.Form form = frmCtrl.getFormById(formId);

    String formName = form.getName();
    String fileName = form.getPath();

    UserController userCtrl = new UserController();
    int userId = userCtrl.getUserIdByLoginId(ssid);

    WorkColumnController wcCtrl = new WorkColumnController();
    ArrayList<com.bizmann.poi.entity.Field> fieldList = wcCtrl.getFieldsByFormId(formId);

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }

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
        wcCtrl.handleWorkColumnSubmission(flowChartId, formId, columns);
        //conCtrl.insertNewConsolidation(Integer.parseInt(parentId), comboActionSelected, columns);
    }
    
    WorkColumnDetails wcd = wcCtrl.getWorkColumnDetails(flowChartId);
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <script src="../include/js/url.js"></script>
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" href="../include/tinytable/css/style.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/datatable/assets/skins/sam/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/paginator/assets/skins/sam/paginator.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datasource/datasource-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datatable/datatable-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/paginator/paginator-min.js"></script>
        <script type="text/javascript" src="../include/tinytable/js/script.js"></script>
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <script type="text/javascript">
            
            var type = "<%=type%>";
            var subtype = "<%=subtype%>"
            var type = "<%=type%>";
            var subtype = "<%=subtype%>";
            
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
                //if(fnCheckForChk()==true){
                document.getElementById("todoaction").value= "modify";
                document.workColFrm.submit();
                //}else{
                //alert("Please check at least one field to be shown.");
                //}
            }
        </script>
    </head>
    <body  background="../images/background.png" style="width:650px">
        <div align="center" valign="top">
            <form id="workColFrm" name="workColFrm" action="workcolumn.jsp" method="POST">
                <table>
                    <tr>
                        <td class="orgtable" valign="top" align="center">
                            <br>
                            <table cellpadding="0">
                                <tr>
                                    <td colspan="2">
                                        <input type="hidden" id="flowChartId" name="flowChartId" value="<%=flowChartId%>"/>
                                        <input type="hidden" id="formId" name="formId" value="<%=formId%>"/>
                                        <input type="hidden" id="todoaction" name="todoaction" value=""/>
                                        <input type="hidden" id="type" name="type" value="<%=type%>"/>
                                        <input type="hidden" id="subtype" name="subtype" value="<%=subtype%>"/>
                                        <div class="psadtitle">
                                            <br>Dashboard Additional Columns for <%=formName%><br><br>
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

                                        String isChecked = "";
                                        String tmpCols = wcd.getColumns();
                                        if (tmpCols != null && !tmpCols.isEmpty()) {
                                            String[] colArr = tmpCols.split(",");
                                            ArrayList<String> arrayList = new ArrayList<String>(Arrays.asList(colArr));
                                            if (arrayList.contains(cell)) {
                                                isChecked = "checked";
                                            }
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
    </body>
</html>
