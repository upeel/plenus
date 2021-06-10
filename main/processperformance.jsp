<%-- 
    Document   : processperformance
    Created on : Mar 6, 2014, 10:13:38 AM
    Author     : SOE HTIKE
--%>
<%@page import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.resources.*"
        import = "com.bizmann.product.entity.*"
        import = "java.util.*"
        import = "java.lang.*"
        import="java.text.DecimalFormat" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>

<%
    PerformanceController perfCtrl = new PerformanceController();
    ArrayList<com.bizmann.product.entity.Process> procList = perfCtrl.getProcessList();

    String strComboboxProcessSelected = request.getParameter("comboboxProcess");
    if (strComboboxProcessSelected == null) {
        strComboboxProcessSelected = "0";
    }
    strComboboxProcessSelected = strComboboxProcessSelected.trim();

    if (strComboboxProcessSelected.equals("")) {
        strComboboxProcessSelected = "0";
    }

    int comboboxProcessSelected = Integer.parseInt(strComboboxProcessSelected);

    ArrayList<PerformanceEntity> peList = new ArrayList<PerformanceEntity>();
    ArrayList<PerformanceDetails> pedList = new ArrayList<PerformanceDetails>();
    PerformanceDetails currentPed = new PerformanceDetails();

    if (comboboxProcessSelected != 0) {
        peList = perfCtrl.getAllRecordsByFlowchartId(comboboxProcessSelected);
        pedList = perfCtrl.getPerfDetailsByFlowchartId(comboboxProcessSelected);
        currentPed = perfCtrl.calculatePerformanceDetailsByFlowchartId(comboboxProcessSelected);
    }

    int curpedday = currentPed.getTime_day();
    int curpedhour = currentPed.getTime_hour();
    int curpedminute = currentPed.getTime_minute();
    int curpedsecond = currentPed.getTime_second();
    int curpedseconds = (curpedday * 24 * 60 * 60 * 60) + (curpedhour * 60 * 60) + (curpedminute * 60) + curpedsecond;
    //System.out.println("curpedseconds: " + curpedseconds);

    String ent1Radio = request.getParameter("ent1Radio");
    if (ent1Radio == null) {
        ent1Radio = "";
    }
    String ent1from = request.getParameter("ent1from");
    if (ent1from == null) {
        ent1from = "";
    }
    String ent1to = request.getParameter("ent1to");
    if (ent1to == null) {
        ent1to = "";
    }
    String ent1ComboProcess = request.getParameter("ent1ComboProcess");
    if (ent1ComboProcess == null || ent1ComboProcess.equals("")) {
        ent1ComboProcess = "0";
    }
    int ent1ComboProcessSelected = Integer.parseInt(ent1ComboProcess);

    String ent2Radio = request.getParameter("ent2Radio");
    if (ent2Radio == null) {
        ent2Radio = "";
    }
    String ent2from = request.getParameter("ent2from");
    if (ent2from == null) {
        ent2from = "";
    }
    String ent2to = request.getParameter("ent2to");
    if (ent2to == null) {
        ent2to = "";
    }
    String ent2ComboProcess = request.getParameter("ent2ComboProcess");
    if (ent2ComboProcess == null || ent2ComboProcess.equals("")) {
        ent2ComboProcess = "0";
    }
    int ent2ComboProcessSelected = Integer.parseInt(ent2ComboProcess);
    ComparingEntity comEnt = new ComparingEntity();
    /*
    if (ent1Radio.equalsIgnoreCase("process") && !ent2Radio.equalsIgnoreCase("process")) {
    if (!ent1from.equals("") && !ent1to.equals("") && ent1ComboProcessSelected != 0) {
    //1 is process 2 is manual
    comEnt = perfCtrl.get1Proc2Man(comboboxProcessSelected, ent1ComboProcessSelected, ent1from, ent1to);
    }
    } else if (ent2Radio.equalsIgnoreCase("process") && !ent1Radio.equalsIgnoreCase("process")) {
    if (!ent2from.equals("") && !ent2to.equals("") && ent2ComboProcessSelected != 0) {
    //2 is process 1 is manual
    comEnt = perfCtrl.get2Proc1Man(comboboxProcessSelected, ent2ComboProcessSelected, ent2from, ent2to);
    }
    } else if (ent1Radio.equalsIgnoreCase("process") && ent2Radio.equalsIgnoreCase("process")) {
    
     */
    if (!ent2from.equals("") && !ent2to.equals("") && ent2ComboProcessSelected != 0
            && !ent1from.equals("") && !ent1to.equals("") && ent1ComboProcessSelected != 0) {
        comEnt = perfCtrl.get1Proc2Proc(comboboxProcessSelected, ent1ComboProcessSelected, ent1from, ent1to,
                ent2ComboProcessSelected, ent2from, ent2to);
    }
    // }
    if (comEnt.getEntity1() == null) {
        comEnt.setEntity1(new PerformanceDetails());
    }
    if (comEnt.getEntity2() == null) {
        comEnt.setEntity2(new PerformanceDetails());
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/datatable/assets/skins/sam/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/paginator/assets/skins/sam/paginator.css" />
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datasource/datasource-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datatable/datatable-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/paginator/paginator-min.js"></script>

        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <script src="../include/js/jquery.ui.touch-punch.min.js"></script>
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <script type="text/javascript">
            function comboboxProcessChanged(){
                document.perfFrm.submit();
            }
            
            function refreshPage(){
                document.perfFrm.submit();
            }
            
            function delBtnClicked(vid){
                var vconfirm = confirm("Are you sure you want to delete?");
                if(vconfirm){
                    $.ajax({
                        url: 'performancedelete.jsp',
                        data: 'id=' + vid,
                        success: function(){
                            document.perfFrm.submit();
                        }
                    });
                }
            }
            
            function addBtnClicked(){
                var vflowchartid = document.getElementById("comboboxProcess").value;
                var vurl = 'manualperfadd.jsp?flowchartId='+vflowchartid;
                fnOpenWindow(vurl);
            }
            
            function fnOpenWindow(URL) {
                var availHeight = screen.availHeight;
                var availWidth = screen.availWidth;
                var x = 0, y = 0;
                if (document.all) {
                    x = window.screentop;
                    y = window.screenLeft;
                }
                else if (document.layers) {
                    x = window.screenX;
                    y = window.screenY;
                }
                var arguments = 'width=500,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0';
                //var arguments = 'resizable=1,toolbar=0,location=0,directories=0,addressbar=0,scrollbars=1,status=1,menubar=0,top=0,left=0, screenX='+x+',screenY='+y+',width='+availWidth+',height='+availHeight;
                newwindow = window.open(URL,'mywindow',arguments);
                newwindow.moveTo(0,0);
            }
            
            function compareBtnClicked(){
                //                var vmanual1 = document.getElementById("ent1RadioManual").checked;
                //                var vprocess1 = document.getElementById("ent1RadioProcess").checked;
                //                var vmanual2 = document.getElementById("ent2RadioManual").checked;
                //                var vprocess2 = document.getElementById("ent2RadioProcess").checked;
                var vprocess1 = true;
                var vprocess2 = true;
                var vmanual1 = false;
                var vmanual2 = false;
                if((vmanual1 || vprocess1) && (vmanual2 || vprocess2)){ //it's fine as long as any one of them is checked
                    if(vmanual1 && vmanual2){ // nuff said, no need to validate anymore
                        alert("You are trying to compare two same Manual Process Measurement!");
                    }else{
                        var vproc1 = document.getElementById("ent1ComboProcess").value;
                        var vproc2 = document.getElementById("ent2ComboProcess").value;
                        
                        var vfrom1 = document.getElementById("ent1from").value;
                        var vto1 = document.getElementById("ent1to").value;
                        var vfrom2 = document.getElementById("ent2from").value;
                        var vto2 = document.getElementById("ent2to").value;
                        if(vmanual1){  // 1 is manual - meaning 2 is a process
                            if(vproc2 == '0'){
                                alert("Please select a process to Compare.");
                            }else if(vfrom2 == '' || vto2 == ''){
                                alert("Please select the period of Comparison.");
                            }else{
                                document.perfFrm.submit();
                            }
                        }else if(vmanual2){ // 2 is manual - meaning 1 is a process
                            if(vproc1 == '0'){
                                alert("Please select a process to Compare.");
                            }else if(vfrom1 == '' || vto1 == ''){
                                alert("Please select the period of Comparison.");
                            }else{
                                document.perfFrm.submit();
                            }
                        }else{ // both are process
                            if(vproc1 == '0' || vproc2 == '0'){
                                alert("Please select a process to Compare.");
                            }else if(vfrom1 == '' || vto1 == '' || vfrom2 == '' || vto2 == ''){ //if any one of them is blank
                                alert("Please select the period of Comparison.");
                            }else if(vfrom1 == vfrom2 && vto1 == vto2 && vproc2 == vproc1){
                                alert("You are trying to compare two identical Records!");
                            }else{
                                document.perfFrm.submit();
                            }
                        }
                    }
                }else{
                    alert("Please select the type of Comparison.");
                }
            }
            
            $(function() {
                $( "#ent1from" ).datepicker({
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 2,
                    dateFormat: 'yy-mm-dd',
                    onClose: function( selectedDate ) {
                        $( "#ent1to" ).datepicker( "option", "minDate", selectedDate );
                    }
                });
                $( "#ent1to" ).datepicker({
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 2,
                    dateFormat: 'yy-mm-dd',
                    onClose: function( selectedDate ) {
                        $( "#ent1from" ).datepicker( "option", "maxDate", selectedDate );
                    }
                });
                
                
                $( "#ent2from" ).datepicker({
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 2,
                    dateFormat: 'yy-mm-dd',
                    onClose: function( selectedDate ) {
                        $( "#ent2to" ).datepicker( "option", "minDate", selectedDate );
                    }
                });
                $( "#ent2to" ).datepicker({
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 2,
                    dateFormat: 'yy-mm-dd',
                    onClose: function( selectedDate ) {
                        $( "#ent2from" ).datepicker( "option", "maxDate", selectedDate );
                    }
                });
            });
        </script>
    </head>
    <body>
        <div id="dvLoading"></div>
        <div align="center" valign="top">
            <form id="perfFrm" name="perfFrm" action="processperformance.jsp" method="POST">
                <table background="../images/background.png" border="1" cellpadding="2px" style="text-align:left;font-family: arial;border-collapse:collapse;table-layout:auto" width="980px" height="420px">
                    <tr>
                        <td>
                            <table background="../images/background.png" border="1" cellpadding="2px" style="text-align:left;font-family: arial;border-collapse:collapse;table-layout:auto" width="950px">
                                <tr style="background-color:grey">
                                    <th colspan="2">
                                        <font color="white"><b>Performance Measurement & Benchmark</b></font>
                                        <input type="hidden" id="type" name="type" value="Design"/>
                                        <input type="hidden" id="subtype" name="subtype" value="flowchartperformance"/>
                                    </th>
                                    <th align="right">
                                        <select id="comboboxProcess" name="comboboxProcess" onchange="comboboxProcessChanged()">
                                            <option value="0">
                                                --- Please Select a Process --- 
                                            </option>
                                            <%
                                                for (int a = 0; a < procList.size(); a++) {
                                                    com.bizmann.product.entity.Process proc = procList.get(a);
                                                    int id = proc.getId();
                                                    String name = proc.getName();

                                                    String isSelected = "";
                                                    if (comboboxProcessSelected == id) {
                                                        isSelected = "selected";
                                                    }
                                            %>
                                            <option value="<%=id%>" <%=isSelected%>><%=name%></option>
                                            <% }%>
                                        </select>
                                    </th>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        &nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <th colspan="2" style="background-color:grey">
                                <div style="float: left; width: 400px" >
                                    <font color="white"><u>Process Measurement Comparisons</u></font>
                                </div>
                                </th>
                                <th style="background-color:grey">
                                <div style="float: left; width: 400px" align="right">
                                    <input type="button" id="compareBtn" name="compareBtn" value="Compare" onclick="compareBtnClicked()"/>
                                </div>
                                </th>
                    </tr>
                    <tr>
                        <td colspan="3" align="center">
                            <table background="../images/background.png" border="1" cellpadding="2px" style="text-align:left;font-family: arial;border-collapse:collapse;table-layout:auto">
                                <tr>
                                    <td valign="middle">
                                        <div style="float: left; width: 120px" >
                                            Manual Process
                                        </div>
                                        <% if (peList.size() <= 0 && comboboxProcessSelected != 0) {%>
                                        <div style="float: left; width: 100px" align="right">
                                            <input type="button" id="addBtn" name="addBtn" value=" Add " onclick="addBtnClicked()"/>
                                        </div>
                                        <% }%>
                                    </td>
                                    <td>
                                        Comparing Entity 1
                                    </td>
                                    <td>
                                        Comparing Entity 2
                                    </td>
                                </tr>
                                <tr>
                                    <td rowspan="2" valign="top">
                                        <table background="../images/background.png" border="1" cellpadding="2px" style="text-align:left;font-family: arial;border-collapse:collapse;table-layout:auto">
                                            <tr style="background-color:darkgrey">
                                                <th width="100px">
                                                    <font color="white">No. of Steps</font>
                                                </th>
                                                <th width="150px">
                                                    <font color="white">Process Time</font>
                                                </th>
                                                <th width="50px">
                                                </th>
                                            </tr>
                                            <%
                                                int pedsteps = 0;
                                                int pedday = 0;
                                                int pedhour = 0;
                                                int pedminute = 0;
                                                for (int a = 0; a < peList.size(); a++) {
                                                    PerformanceEntity pe = peList.get(a);
                                                    PerformanceDetails ped = pe.getPerformanceDetails();
                                                    pedsteps = ped.getSteps();
                                                    pedday = ped.getTime_day();
                                                    pedhour = ped.getTime_hour();
                                                    pedminute = ped.getTime_minute();
                                                    int peId = pe.getId();
                                                    String pedtime = pedday + " D(s) " + pedhour + " H(s) " + pedminute + " M(s).";
                                            %>
                                            <tr>
                                                <td>
                                                    <%=pedsteps%>
                                                </td>
                                                <td>
                                                    <%=pedtime%>
                                                </td>
                                                <td>
                                                    <div align="right">
                                                        <input type="button" id="delBtn" name="delBtn" value="Delete" onclick="delBtnClicked('<%=peId%>')"/>
                                                    </div>
                                                </td>
                                            </tr>
                                            <% }%>
                                        </table>
                                    </td>
                                    <td>
                                        <%
                                            /*
                                            String manual1Selected = "";
                                            String manual2Selected = "";
                                            String process1Selected = "";
                                            String process2Selected = "";
                                            if (ent1Radio.equalsIgnoreCase("manual")) {
                                            manual1Selected = "checked";
                                            } else if (ent1Radio.equalsIgnoreCase("process")) {
                                            process1Selected = "checked";
                                            }
                                            
                                            if (ent2Radio.equalsIgnoreCase("manual")) {
                                            manual2Selected = "checked";
                                            } else if (ent2Radio.equalsIgnoreCase("process")) {
                                            process2Selected = "checked";
                                            }
                                             */
                                        %>
                                        <!--                                        <input type="radio" id="ent1RadioManual" name="ent1Radio" value="manual" <manual1Selected%>/>
                                                                                <label for="ent1RadioManual">Manual</label>
                                                                                <br/><br/>-->
                                        <!--                                        <input type="radio" id="ent1RadioProcess" name="ent1Radio" value="process" <process1Selected%>/>
                                                                                <label for="ent1RadioProcess">Process</label>-->
                                        <select id="ent1ComboProcess" name="ent1ComboProcess">
                                            <option value="0">
                                                --- Please Select a Process --- 
                                            </option>
                                            <%
                                                for (int a = 0; a < procList.size(); a++) {
                                                    com.bizmann.product.entity.Process proc = procList.get(a);
                                                    int id = proc.getId();
                                                    String name = proc.getName();

                                                    String isSelected = "";
                                                    if (ent1ComboProcessSelected == id) {
                                                        isSelected = "selected";
                                                    }
                                            %>
                                            <option value="<%=id%>" <%=isSelected%>><%=name%></option>
                                            <% }%>
                                        </select>
                                        <br/>

                                        <label for="from">From</label>
                                        <input type="text" id="ent1from" name="ent1from" width="150px" value="<%=ent1from%>"/>
                                        <label for="to">to</label>
                                        <input type="text" id="ent1to" name="ent1to" width="150px" value="<%=ent1to%>"/>
                                    </td>
                                    <td>
                                        <!--                                        <input type="radio" id="ent2RadioManual" name="ent2Radio" value="manual" <manual2Selected%>/>
                                                                                <label for="ent2RadioManual">Manual</label>
                                                                                <br/><br/>
                                                                                <input type="radio" id="ent2RadioProcess" name="ent2Radio" value="process" <process2Selected%>/>
                                                                                <label for="ent2RadioProcess">Process</label>-->
                                        <select id="ent2ComboProcess" name="ent2ComboProcess">
                                            <option value="0">
                                                --- Please Select a Process --- 
                                            </option>
                                            <%
                                                for (int a = 0; a < procList.size(); a++) {
                                                    com.bizmann.product.entity.Process proc = procList.get(a);
                                                    int id = proc.getId();
                                                    String name = proc.getName();

                                                    String isSelected = "";
                                                    if (ent2ComboProcessSelected == id) {
                                                        isSelected = "selected";
                                                    }
                                            %>
                                            <option value="<%=id%>" <%=isSelected%>><%=name%></option>
                                            <% }%>
                                        </select>
                                        <br/>

                                        <label for="from">From</label>
                                        <input type="text" id="ent2from" name="ent2from" width="150px" value="<%=ent2from%>"/>
                                        <label for="to">to</label>
                                        <input type="text" id="ent2to" name="ent2to" width="150px" value="<%=ent2to%>"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table border="1" cellpadding="2px" style="text-align:left;font-family: arial;border-collapse:collapse;table-layout:auto">
                                            <tr>
                                                <th>No. of Steps</th>
                                                <th>Process Time</th>
                                            </tr>
                                            <tr>
                                                <td><%=comEnt.getEntity1().getSteps()%></td>
                                                <td>
                                                    <%
                                                        String ent1Time = comEnt.getEntity1().getTime_day() + " D(s) "
                                                                + comEnt.getEntity1().getTime_hour() + " H(s) "
                                                                + comEnt.getEntity1().getTime_minute() + " M(s) "
                                                                + comEnt.getEntity1().getTime_second() + " S(s).";
                                                    %>
                                                    <%=ent1Time%>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td>
                                        <table border="1" cellpadding="2px" style="text-align:left;font-family: arial;border-collapse:collapse;table-layout:auto">
                                            <tr>
                                                <th>No. of Steps</th>
                                                <th>Process Time</th>
                                            </tr>
                                            <tr>
                                                <td><%=comEnt.getEntity2().getSteps()%></td>
                                                <td>
                                                    <%
                                                        String ent2Time = comEnt.getEntity2().getTime_day() + " D(s) "
                                                                + comEnt.getEntity2().getTime_hour() + " H(s) "
                                                                + comEnt.getEntity2().getTime_minute() + " M(s) "
                                                                + comEnt.getEntity2().getTime_second() + " S(s).";
                                                    %>
                                                    <%=ent2Time%>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <%
                                    DecimalFormat df = new DecimalFormat("00.00");
                                    if (comEnt.getEntity1().getSteps() != 0 && comEnt.getEntity2().getSteps() != 0) {%>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        <%
                                            String manImprovedSteps = "";
                                            int mantepsDiff = pedsteps - comEnt.getEntity1().getSteps();
                                            if (mantepsDiff > 0) {
                                                manImprovedSteps = "<font color='green'>Number of steps has been reduced by " + mantepsDiff + ".</font>";
                                            } else if (mantepsDiff < 0) {
                                                manImprovedSteps = "<font color='red'>Number of steps has been increased by " + Math.abs(mantepsDiff) + ".</font>";
                                            } else {
                                                manImprovedSteps = "<font color='blue'>Number of steps has remained the same.</font>";
                                            }

                                            long manSecs = (long) (Long.valueOf(pedday) * 24 * 60 * 60 * 60)
                                                    + (pedhour * 60 * 60)
                                                    + (pedminute * 60);

                                            long comSecs1 = (long) (Long.valueOf(comEnt.getEntity1().getTime_day()) * 24 * 60 * 60 * 60)
                                                    + (comEnt.getEntity1().getTime_hour() * 60 * 60)
                                                    + (comEnt.getEntity1().getTime_minute() * 60)
                                                    + comEnt.getEntity1().getTime_second();

                                            String manImprovedPercent = "";
                                            double manDiffpercent = 0;
                                            if (comSecs1 < manSecs) {
                                                manDiffpercent = ((manSecs - comSecs1 * 1.00) / manSecs) * 100.00;
                                                manImprovedPercent = "<font color='green'>Process Time improved by " + df.format(manDiffpercent) + "%</font>";
                                            } else if (comSecs1 > manSecs) {
                                                manDiffpercent = ((comSecs1 - manSecs * 1.00) / manSecs) * 100.00;
                                                manImprovedPercent = "<font color='red'>Process Time worsen by " + df.format(manDiffpercent) + "%</font>";
                                            } else {
                                                manImprovedPercent = "<font color='blue'>Process Time remained the same.</font>";
                                            }

                                            if (peList.size() > 0 && comboboxProcessSelected != 0) {
                                        %>
                                        <b><%=manImprovedSteps%><br/>
                                            <%=manImprovedPercent%></b>
                                            <% }%>
                                    </td>
                                    <td>
                                        <%
                                            String comImprovedSteps = "";
                                            int comStepsDiff = comEnt.getEntity1().getSteps() - comEnt.getEntity2().getSteps();
                                            if (comStepsDiff > 0) {
                                                comImprovedSteps = "<font color='green'>Number of steps has been reduced by " + comStepsDiff + ".</font>";
                                            } else if (comStepsDiff < 0) {
                                                comImprovedSteps = "<font color='red'>Number of steps has been increased by " + Math.abs(comStepsDiff) + ".</font>";
                                            } else {
                                                comImprovedSteps = "<font color='blue'>Number of steps remained the same.</font>";
                                            }

                                            long comSecs2 = (long) (Long.valueOf(comEnt.getEntity2().getTime_day()) * 24 * 60 * 60 * 60)
                                                    + (comEnt.getEntity2().getTime_hour() * 60 * 60)
                                                    + (comEnt.getEntity2().getTime_minute() * 60)
                                                    + comEnt.getEntity2().getTime_second();

                                            String comImprovedPercent = "";
                                            double comDiffpercent = 0;
                                            if (comSecs2 < comSecs1) {
                                                comDiffpercent = ((comSecs1 - comSecs2 * 1.00) / comSecs1) * 100.00;
                                                comImprovedPercent = "<font color='green'>Process Time improved by " + df.format(comDiffpercent) + "%</font>";
                                            } else if (comSecs2 > comSecs1) {
                                                comDiffpercent = ((comSecs2 - comSecs1 * 1.00) / comSecs1) * 100.00;
                                                comImprovedPercent = "<font color='red'>Process Time worsen by " + df.format(comDiffpercent) + "%</font>";
                                            } else {
                                                comImprovedPercent = "<font color='blue'>Process Time remained the same.</font>";
                                            }

                                        %>
                                        <b><%=comImprovedSteps%> <br/>
                                            <%=comImprovedPercent%></b>
                                    </td>
                                </tr>
                                <% }%>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="3">&nbsp;</td>
                    </tr>
                    <tr>
                        <th colspan="3" style="background-color:grey"><font color="white"><u>Current Process Measurement</u></font></th>
                    </tr>
                    <tr style="background-color:darkgrey">
                        <th>
                            <font color="white">No. of Steps</font>
                        </th>
                        <th>
                            <font color="white">Process Time</font>
                        </th>
                        <td>

                        </td>
                    </tr>
                    <tr>
                        <td>
                            <%=currentPed.getSteps()%>
                        </td>
                        <td>
                            <%
                                String curpedtime = curpedday + " D(s) " + curpedhour + " H(s) " + curpedminute + " M(s) " + curpedsecond + " S(s).";
                            %>
                            <%=curpedtime%>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                        </td>
                    </tr>
                    <tr>
                        <th colspan="3" style="background-color:grey"><font color="white"><u>Current Process Measurement By Activity</u></font></th>
                    </tr>
                    <tr style="background-color:darkgrey">
                        <th><font color="white">No.</font></th>
                        <th><font color="white">Activity Name</font></th>
                        <th><font color="white">AVG Time Taken</font></th>
                    </tr>
                    <%
                        for (int a = 0; a < pedList.size(); a++) {
                            PerformanceDetails ped = pedList.get(a);
                            String actionName = ped.getAction_name();
                            int actpedday = ped.getTime_day();
                            int actpedhour = ped.getTime_hour();
                            int actpedminute = ped.getTime_minute();
                            int actpedsecond = ped.getTime_second();

                            String pedtime = actpedday + " D(s) " + actpedhour + " H(s) " + actpedminute + " M(s) " + actpedsecond + " S(s).";
                    %>
                    <tr>
                        <td>
                            <%=a + 1%>
                        </td>
                        <td>
                            <%=actionName%>
                        </td>
                        <td>
                            <%=pedtime%>
                        </td>
                    </tr>
                    <% }%>
                </table>
                </td>
                </tr>
                </table>
            </form>
        </div>
    </body>
</html>

<%@ include file="../include/footer.jsp" %>