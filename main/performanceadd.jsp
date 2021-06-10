<%-- 
    Document   : performanceadd
    Created on : Mar 6, 2014, 3:25:49 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.entity.*"
        import = "java.util.*" %>
<!DOCTYPE html>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    String strFlowchartId = request.getParameter("flowchartId");
    if (strFlowchartId == null) {
        strFlowchartId = "0";
    }
    strFlowchartId = strFlowchartId.trim();
    if (strFlowchartId.equals("")) {
        strFlowchartId = "0";
    }
    int flowchartId = Integer.parseInt(strFlowchartId);
    PerformanceController perfCtrl = new PerformanceController();
    ArrayList<com.bizmann.product.entity.Process> procList = perfCtrl.getProcessList(flowchartId);
    //insertNewPerformanceRecord(int flowchart_id, int legacy_flowchart_id, String type, int steps, int day, int hour, int minute);

    String toclose = "";

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }
    if (todoaction.equalsIgnoreCase("add")) {
        String strcombotype = request.getParameter("combotype");
        if (strcombotype == null) {
            strcombotype = "0";
        }
        String strcomboflowchartid = request.getParameter("comboflowchartid");
        if (strcomboflowchartid == null) {
            strcomboflowchartid = "0";
        }
        String txtSteps = request.getParameter("txtSteps");
        if (txtSteps == null) {
            txtSteps = "0";
        }
        String txtDay = request.getParameter("txtDay");
        if (txtDay == null) {
            txtDay = "0";
        }
        String txtHour = request.getParameter("txtHour");
        if (txtHour == null) {
            txtHour = "0";
        }
        String txtMinute = request.getParameter("txtMinute");
        if (txtMinute == null) {
            txtMinute = "0";
        }

        perfCtrl.insertNewPerformanceRecord(flowchartId, Integer.parseInt(strcomboflowchartid), strcombotype, Integer.parseInt(txtSteps),
                Integer.parseInt(txtDay), Integer.parseInt(txtHour), Integer.parseInt(txtMinute));
        toclose = "window.opener.refreshPage();self.close();";
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
        <title>bmFLO</title>
        <style>
            body { font: 12px Helvetica, Arial; overflow-x: hidden;}
        </style>
        <script type="text/javascript">
            function combotypeChanged(type){
                if(type == 'legacy'){
                    $( "#trlegacy" ).show();
                    $( ".trmanual" ).hide();
                }else if(type == 'manual'){
                    $( ".trmanual" ).show();
                    $( "#trlegacy" ).hide();
                }else{
                    $( "#trlegacy" ).hide();
                    $( ".trmanual" ).hide();
                }
            }
            
            function submitBtnClicked(){
                var vcbtype = document.getElementById("combotype").value
                var vcbflowchartid = document.getElementById("comboflowchartid").value;
                var vsteps = document.getElementById("txtSteps").value;
                var vday = document.getElementById("txtDay").value;
                var vhour = document.getElementById("txtHour").value;
                var vminute = document.getElementById("txtMinute").value;
                if(vcbtype != '0' ){
                    if(vcbtype == 'legacy'){
                        if(vcbflowchartid != '0'){
                            document.detailsFrm.submit();
                        }else{
                            alert("Please selecte a Flow Chart!");
                        }
                    }else{
                        if(parseFloat(vsteps) > 0){
                            if(parseFloat(vday) > 0  || parseFloat(vhour) > 0  || parseFloat(vminute) > 0){
                                document.detailsFrm.submit();
                            }else{
                                alert('Please provide a valid Process Time Taken!');
                            }
                        }else{
                            alert("Please provide a valid number of Steps!");
                        }
                    }
                }else{
                    alert('Please select Type!');
                }
            }
            
            $(function() {
                $( "#trlegacy" ).hide();
                $( ".trmanual" ).hide();
//                setTimeout(function () {
//                    opener.location.reload(true); //will redirect to your blog page (an ex: blog.html)
//                }, 3000);
            });
        </script>
    </head>
    <body>
        <form id="detailsFrm" name="detailsFrm" method="POST" action="performanceadd.jsp">
            <fieldset>
                <legend>Add Old Process Measurement</legend>
                <table style="table-layout: fixed">
                    <tr>
                        <th align="right" width="200px">Type</th>
                        <td align="left" width="500px">
                            <input type="hidden" id="todoaction" name="todoaction" value="add"/>
                            <input type="hidden" id="flowchartId" name="flowchartId" value="<%=flowchartId%>"/>
                            <select id="combotype" name="combotype" onchange="combotypeChanged(this.value)">
                                <option value="0" selected>
                                    --- Select Measurement Type --- 
                                </option>
                                <option value="legacy">
                                    Automated Process
                                </option>
                                <option value="manual">
                                    Manual Process
                                </option>
                            </select>
                        </td>
                    </tr>
                    <tr id="trlegacy" name="trlegacy">
                        <th align="right">Select Old Process:</th>
                        <td align="left">
                            <select id="comboflowchartid" name="comboflowchartid">
                                <option value="0" selected>
                                    --- Select an Old Process ---
                                </option>
                                <%
                                    for (int a = 0; a < procList.size(); a++) {
                                        com.bizmann.product.entity.Process proc = procList.get(a);
                                        int id = proc.getId();
                                        String name = proc.getName();
                                %>
                                <option value="<%=id%>"><%=name%></option>
                                <% }%>
                            </select>
                        </td>
                    </tr>
                    <tr class="trmanual">
                        <th align="right">No. of Steps:</th>
                        <td align="left"><input type="number" id="txtSteps" name="txtSteps" value="0"/></td>
                    </tr>
                    <tr class="trmanual">
                        <td></td>
                        <td><b>Process Time Taken</b></td>
                    </tr>
                    <tr class="trmanual">
                        <th align="right">Day:</th>
                        <td align="left"><input type="number" id="txtDay" name="txtDay" value="0"/></td>
                    </tr>
                    <tr class="trmanual">
                        <th align="right">Hour:</th>
                        <td align="left"><input type="number" id="txtHour" name="txtHour" value="0"/></td>
                    </tr>
                    <tr class="trmanual">
                        <th align="right">Minute:</th>
                        <td align="left"><input type="number" id="txtMinute" name="txtMinute" value="0"/></td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right">
                            <input type="button" id="submitBtn" name="submitBtn" value="Submit" onclick="submitBtnClicked()"/>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </body>
    <script>
        <%=toclose%>
    </script>
</html>
