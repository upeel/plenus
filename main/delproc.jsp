<%-- 
    Document   : delproc
    Created on : Aug 11, 2015, 9:10:11 AM
    Author     : SOE HTIKE
--%>
<%@page import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.resources.*"
        import = "com.bizmann.product.entity.*"
        import = "com.bizmann.flowchart.controller.*"
        import = "com.bizmann.flowchart.entity.*"
        import = "java.util.*"
        import = "java.lang.*"
        import="java.text.DateFormat"
        import="java.text.SimpleDateFormat" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%
    if (userId != 1) { // only our default admin account has the rights to do this.
        return;
    }

    DeleteProcessController dpCtrl = new DeleteProcessController();
    ArrayList<WorkActivity> outstandingProcessList = new ArrayList<WorkActivity>();

    String strselProcess = request.getParameter("selProcess");
    if (strselProcess == null) {
        strselProcess = "0";
    }
    strselProcess = strselProcess.trim();
    if (strselProcess.isEmpty()) {
        strselProcess = "0";
    }
    int selProcess = Integer.parseInt(strselProcess);

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }
    if (todoaction.equals("deleteprocess")) {
        String strhidSelProc = request.getParameter("hidSelProc");
        if (strhidSelProc == null) {
            strhidSelProc = "0";
        }
        strhidSelProc = strhidSelProc.trim();
        if (strhidSelProc.isEmpty()) {
            strhidSelProc = "0";
        }
        selProcess = Integer.parseInt(strhidSelProc);

        if (selProcess > 0) {
            outstandingProcessList = dpCtrl.getOutstandingActivityByFlowChart(selProcess);
        }

        String processes = "";
        String[] checkboxArr = request.getParameterValues("chkcells");
        if (checkboxArr != null) {
            for (int a = 0; a < checkboxArr.length; a++) {
                processes = processes + checkboxArr[a] + ",";
            }
            if (processes.contains(",")) {
                processes = processes.substring(0, processes.length() - 1);
            }
        }
        dpCtrl.deleteProcesses(processes, userId);
    }

    ArrayList<EngineFlowChart> processList = dpCtrl.getProcessList();

    if (selProcess > 0) {
        outstandingProcessList = dpCtrl.getOutstandingActivityByFlowChart(selProcess);
    }

    if (outstandingProcessList.size() <= 0) {
        selProcess = 0;
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
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/datatable/assets/skins/sam/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/paginator/assets/skins/sam/paginator.css" />
        <link rel="stylesheet" href="../include/tinytable/css/style.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datasource/datasource-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datatable/datatable-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/paginator/paginator-min.js"></script>
        <script type="text/javascript" src="../include/tinytable/js/script.js"></script>
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <style>
            .yui3-skin-sam .yui3-hide {
                display:none;
            }

            .psadheader{
                font:100% arial,helvetica,clean,sans-serif;
                text-align:left;
                width:910px;
            }

            .datatable table{
                width: 910px;
                position: relative;
            }

            .admintask{
                text-align: center;
                position: relative;
            }
            .admintask table{
                margin-left:auto; margin-right:auto;
                width: 99%;
                position: relative;
            }
            .admintask, .admintask .yui-dt-loading{
                text-align: center; background-color: transparent;
                position: relative;
            }
        </style>
        <script type="text/javascript">
            function fnselProcessChanged(){
                document.frmDeleteProcess.submit();
            }
            
            checked=false;
            function checkAll(){            
                if (checked == false) {
                    checked = true
                }
                else{
                    checked = false
                }
                for(var vi=0;vi<<%=outstandingProcessList.size()%>;vi++){
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
            
            function fnbtnDeleteClicked(){
                if(fnCheckForChk()==true){
                    document.getElementById("todoaction").value = "deleteprocess";
                    document.frmDeleteProcess.submit();
                }else{
                    alert("Please check at least one process to delete.");
                }
            }
            
            function fnOpenPrintPage(row){
                var row = document.getElementById('worktable').rows[row.rowIndex];
                var vprocessId = row.cells[1].innerHTML;
                fnOpenWindow('printpage.jsp?processId='+vprocessId);
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
                var arguments = 'resizable=1,toolbar=0,location=0,directories=0,addressbar=0,scrollbars=1,status=1,menubar=0,top=0,left=0, screenX='+x+',screenY='+y+',width='+availWidth+',height='+availHeight;
                newwindow = window.open(URL,'delprocess',arguments);
                newwindow.moveTo(0,0);
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
    <body class="yui-skin-sam">
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <form id="frmDeleteProcess" name="frmDeleteProcess" action="delproc.jsp" method="POST">
            <div align="center">
                <table border="0" width="980px" height="420px" background="../images/background.png">
                    <tr>
                        <td valign="top" align="left"><br><br>
                            <fieldset>
                                <legend>
                                    <hr/>
                                    <table border="0">
                                        <tr>
                                            <td>
                                                <div class="psadinitheader">
                                                    <b>&nbsp;&nbsp;Outstanding Processes</b>
                                                </div>
                                            </td>
                                            <td width="380px" align="right"><b><font face="Arial" color="#606060">Select Process: </font></b>
                                                <select id="selProcess" name="selProcess" onchange="fnselProcessChanged()">
                                                    <option value="0">=== Please Select a Process ===</option>
                                                    <%
                                                        String flowchartSelected = "";
                                                        for (int i = 0; i < processList.size(); i++) {
                                                            EngineFlowChart engFlc = processList.get(i);
                                                            if (selProcess == engFlc.getId()) {
                                                                flowchartSelected = "selected";
                                                            } else {
                                                                flowchartSelected = "";
                                                            }
                                                    %>
                                                    <option value="<%=engFlc.getId()%>" <%=flowchartSelected%>><%=engFlc.getName()%></option>
                                                    <% }%>
                                                </select>
                                                <input type="hidden" id="hidSelProc" name="hidSelProc" value="<%=selProcess%>" />
                                                <input type="hidden" id="todoaction" name="todoaction" value="" />
                                            </td>
                                        </tr>
                                    </table>
                                    <hr/>
                                </legend>
                                <div id="worktablewrapper" background="../images/background.png" width="100%">
                                    <div id="worktableheader" background="../images/background.png">
                                        <div class="search" background="../images/background.png">
                                            <select id="workcolumns" onchange="worksorter.search('workquery')"></select>
                                            <input type="text" id="workquery" onkeyup="worksorter.search('workquery')" />
                                        </div>
                                        <span class="details" background="../images/background.png">
                                            <div>Records <span id="workstartrecord"></span>-<span id="workendrecord"></span> of <span id="worktotalrecords"></span></div>
                                            <div><a id="resetBtn" href="javascript:worksorter.reset()">reset</a></div>
                                        </span>
                                    </div>
                                    <div align="right">
                                        <input type="button" id="btnDelete" name="btnDelete" value=" [ DELETE ] " onclick="fnbtnDeleteClicked()" />
                                    </div>
                                    <table class="tinytable" id="worktable" name="worktable" cellpadding="0" cellspacing="0" border="0"  style="table-layout:fixed" width="80%" background="../images/background.png">
                                        <thead>
                                            <tr valign="top">
                                                <th class="nosort">
                                        <h3>
                                            <input type="checkbox" id="chkall" name="chkall" value="" onClick="checkAll()"/>
                                        </h3>
                                        </th>
                                        <th><h3>Process ID</h3></th>
                                        <th><h3>Process Name</h3></th>
                                        <th><h3>Process Initiator</h3></th>
                                        <th><h3>Activity Name</h3></th>
                                        <th><h3>Activity Start Date</h3></th>
                                        <th><h3>Document Number</h3></th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <%if (outstandingProcessList.size() <= 0) {%>
                                            <tr>
                                                <td colspan="7">No Records Found!</td>
                                            </tr>
                                            <%} else {
                                                for (int i = 0; i < outstandingProcessList.size(); i++) {
                                                    WorkActivity workActivity = outstandingProcessList.get(i);
                                            %>
                                            <tr style="cursor:pointer" onclick="fnOpenPrintPage(this)">
                                                <td><input type="checkbox" id="chk-<%=i%>" name="chkcells" value="<%=workActivity.getProcessId()%>"/></td>
                                                <td><%="P" + ResourceUtil.getVersionFormat(workActivity.getProcessId())%></td>
                                                <td><%=workActivity.getProcessName()%></td>
                                                <td><%=workActivity.getProcessInitiator()%></td>
                                                <td><%=workActivity.getActivityName()%></td>
                                                <td><%=workActivity.getActivityStartDate()%></td>
                                                <td><%=workActivity.getDocNumber()%></td>
                                            </tr>
                                            <%}
                                                }%>
                                        </tbody>
                                    </table>
                                    <div id="worktablefooter">
                                        <div id="worktablenav">
                                            <div>
                                                <img src="include/js/images/first.gif" width="16" height="16" alt="First Page" onclick="worksorter.move(-1,true)" />
                                                <img src="include/js/images/previous.gif" width="16" height="16" alt="Previous Page" onclick="worksorter.move(-1)" />
                                                <img src="include/js/images/next.gif" width="16" height="16" alt="Next Page" onclick="worksorter.move(1)" />
                                                <img src="include/js/images/last.gif" width="16" height="16" alt="Last Page" onclick="worksorter.move(1,true)" />
                                            </div>
                                            <div>
                                                <select id="workpagedropdown"></select>
                                            </div>
                                            <div>
                                                <a id="viewAllBtn" href="javascript:worksorter.showall()">view all</a>
                                            </div>
                                        </div>
                                        <div id="worktablelocation">
                                            <div>
                                                <select onchange="worksorter.size(this.value)">
                                                    <option value="5" selected="selected">5</option>
                                                    <option value="10">10</option>
                                                    <option value="20">20</option>
                                                    <option value="50">50</option>
                                                    <option value="100">100</option>
                                                </select>
                                                <span>Entries Per Page</span>
                                            </div>
                                            <div class="page">Page <span id="workcurrentpage"></span> of <span id="worktotalpages"></span></div>
                                        </div>
                                    </div>
                                </div>
                                <br/>
                            </fieldset>
                        </td>
                    </tr>
                </table>
            </div>
        </form>
        <script type="text/javascript">
            var worksorter = new TINY.table.sorter('worksorter','worktable',{
                headclass:'head',
                ascclass:'asc',
                descclass:'desc',
                evenclass:'evenrow',
                oddclass:'oddrow',
                evenselclass:'evenselected',
                oddselclass:'oddselected',
                paginate:true,
                size:5,
                colddid:'workcolumns',
                currentid:'workcurrentpage',
                totalid:'worktotalpages',
                startingrecid:'workstartrecord',
                endingrecid:'workendrecord',
                totalrecid:'worktotalrecords',
                hoverid:'selectedrow',
                pageddid:'workpagedropdown',
                navid:'worktablenav',
                //sortcolumn:0,
                //sortdir:1,
                //sum:[8],
                //avg:[6,7,8,9],
                //columns:[{index:7, format:'%', decimals:1},{index:8, format:'$', decimals:0}],
                init:true
            });
        </script>
    </body>
</html>
<%@ include file="../include/footer.jsp" %>