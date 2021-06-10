<%-- 
    Document   : monitor
    Created on : Jan 29, 2014, 11:09:44 AM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.entity.*"
        import = "com.bizmann.product.resources.*"
        import="java.text.DateFormat"
        import="java.text.SimpleDateFormat" %>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%
    username = userCtrl.getUserNameByLoginId(loginid);
    user = userCtrl.getUserByLoginId(loginid);
    ArrayList outstandingList = new ArrayList();
    ArrayList completedList = new ArrayList();

    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    Date date = new Date();
    String curdate = dateFormat.format(date);

    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, -100);
    Date olddate = cal.getTime();
    String fromdate = dateFormat.format(olddate);

    String jfrom = request.getParameter("from");
    if (jfrom == null) {
        jfrom = fromdate;
    }
    jfrom = jfrom.trim();

    String jto = request.getParameter("to");
    if (jto == null) {
        jto = curdate;
    }
    jto = jto.trim();
    if (!jfrom.equals("") && !jto.equals("")) {
        MonitorController monitorCtrl = new MonitorController();
        outstandingList = monitorCtrl.getOutstandingMyMonitorList(user.getUserId(), jfrom, jto);
        completedList = monitorCtrl.getCompletedMyMonitorList(user.getUserId(), jfrom, jto);
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
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/datatable/assets/skins/sam/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/paginator/assets/skins/sam/paginator.css" />
        <link rel="stylesheet" href="../include/tinytable/css/style.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <script type="text/javascript" src="../include/tinytable/js/script.js"></script>
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datasource/datasource-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datatable/datatable-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/paginator/paginator-min.js"></script>
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <style>
            .psadheader{
                font:100% arial,helvetica,clean,sans-serif;
                text-align:left;
                width:910px;
            }
        </style>
        <style>
            .mainPanel{
                height:420px;
                width:980px;
                vertical-align:top;
                text-align:center;
                background-image:url('images/background.png');
            }
        </style>
        <script type="text/javascript">
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"
            
            var userId = <%=userId%>;
            function fnopenworkform(row){
                var row = document.getElementById('worktable').rows[row.rowIndex];
                var processid = row.cells[0].innerHTML;
                var processname = row.cells[1].innerHTML;
                var participant = row.cells[2].innerHTML;
                var activityname = row.cells[3].innerHTML;
                var activitystartdate = row.cells[4].innerHTML;
                fnOpenWindow('printpage.jsp?processId='+ processid);
            }
            
            function fnopenendform(row){
                var row = document.getElementById('endtable').rows[row.rowIndex];
                var processid = row.cells[0].innerHTML;
                var processname = row.cells[1].innerHTML;
                var activitystartdate = row.cells[2].innerHTML;
                var activityenddate = row.cells[3].innerHTML;
                fnOpenWindow('printpage.jsp?processId='+ processid);
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
                newwindow = window.open(URL,'mywindow',arguments);
                newwindow.moveTo(0,0);
                //parent.location= "work.jsp";
            }
            
            function filterBtnClicked(){
                var vfrom = document.getElementById("from").value;
                var vto = document.getElementById("to").value;
                if(vfrom != '' && vto != ''){
                    document.location.href='monitor.jsp?type=Dashboard&subtype=monitor&from='+vfrom+'&to='+vto;
                }else{
                    alert('Please provide Process Start Date Range Filter!');
                }
            }
            
            $(document).ready(function(){
                
                //                if($( "#to" ).val() == '' && $( "#from" ).val() == ''){
                //                    var curDate = new Date();
                //                    var toDate = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + '-' + curDate.getDate();
                //                    $( "#to" ).val(toDate);
                //                
                //                    curDate.setDate(curDate.getDate() - 12);
                //                    var fromDate = curDate.getFullYear() + "-" + (curDate.getMonth() + 1) + '-' + curDate.getDate();
                //                    $( "#from" ).val(fromDate);
                //                }
    
                $( "#from" ).datepicker({
                    defaultDate: "-2w",
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 3,
                    dateFormat: 'yy-mm-dd',
                    onClose: function( selectedDate ) {
                        $( "#to" ).datepicker( "option", "minDate", selectedDate );
                    }
                });
                $( "#to" ).datepicker({
                    defaultDate: "0",
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 3,
                    dateFormat: 'yy-mm-dd',
                    onClose: function( selectedDate ) {
                        $( "#from" ).datepicker( "option", "maxDate", selectedDate );
                    }
                });
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
        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td>
                        <p>
                            Process Start Date : 
                            <label>From</label>
                            <input type="text" id="from" name="from" value="<%=jfrom%>" readonly/>
                            <label>to</label>
                            <input type="text" id="to" name="to" value="<%=jto%>" readonly/>
                            <input type="button" id="filterBtn" name="filterBtn" value="Filter" onclick="filterBtnClicked()" />
                        </p>
                    </td>
                </tr>
                <tr>
                    <td width="900px">
                        <fieldset>
                            <legend>
                                <div>
                                    <b>&nbsp;Outstanding Processes&nbsp;&nbsp;</b>
                                </div>
                            </legend>
                            <div id="worktablewrapper" background="../images/background.png" width="90%">
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
                                <table class="tinytable" id="worktable" name="worktable" cellpadding="0" cellspacing="0" border="0"  style="table-layout:fixed" width="80%" background="../images/background.png">
                                    <thead>
                                        <tr valign="top">
                                            <th width="100px"><h3>Process ID</h3></th>
                                    <th width="180px"><h3>Process Name</h3></th>
                                    <th width="180px"><h3>Participant</h3></th>
                                    <th width="180px"><h3>Activity Name</h3></th>
                                    <th width="150px"><h3>Activity Start Date</h3></th>
                                    </tr>
                                    </thead>

                                    <tbody>
                                        <%if (outstandingList.size() <= 0) {%>
                                        <tr>
                                            <td colspan="5">No Records Found!</td>
                                        </tr>
                                        <%} else {
                                            for (int i = 0; i < outstandingList.size(); i++) {
                                                Monitor monitor = (Monitor) outstandingList.get(i);
                                                int processid = monitor.getProcessId();
                                        %>
                                        <tr style="cursor:pointer" onclick="fnopenworkform(this)">
                                            <td>P<%=ResourceUtil.getVersionFormat(monitor.getProcessId())%></td>
                                            <td><%=monitor.getFlowChartName()%></td>
                                            <td><%=monitor.getCurrentUser()%></td>
                                            <td><%=monitor.getActivityName()%></td>
                                            <td><%=monitor.getActivityCreatedDate()%></td>
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
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    <td width="900px">
                        <fieldset>
                            <legend>
                                <div>
                                    <b>&nbsp;Completed Processes&nbsp;&nbsp;</b>
                                </div>
                            </legend>
                            <div id="endtablewrapper" background="../images/background.png" width="90%">
                                <div id="endtableheader" background="../images/background.png">
                                    <div class="search" background="../images/background.png">
                                        <select id="endcolumns" onchange="endsorter.search('endquery')"></select>
                                        <input type="text" id="endquery" onkeyup="endsorter.search('endquery')" />
                                    </div>
                                    <span class="details" background="../images/background.png">
                                        <div>Records <span id="endstartrecord"></span>-<span id="endendrecord"></span> of <span id="endtotalrecords"></span></div>
                                        <div><a id="resetBtn" href="javascript:endsorter.reset()">reset</a></div>
                                    </span>
                                </div>
                                <table class="tinytable" id="endtable" name="endtable" cellpadding="0" cellspacing="0" border="0"  style="table-layout:fixed" width="80%" background="../images/background.png">
                                    <thead>
                                        <tr valign="top">
                                            <th><h3>Process ID</h3></th>
                                    <th><h3>Process Name</h3></th>
                                    <th><h3>Activity Name</h3></th>
                                    <th><h3>Activity Start Date</h3></th>
                                    <th><h3>Activity End Date</h3></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                        <%if (completedList.size() <= 0) {%>
                                        <tr>
                                            <td colspan="5">No Records Found!</td>
                                        </tr>
                                        <%} else {
                                            for (int i = 0; i < completedList.size(); i++) {
                                                Monitor monitor = (Monitor) completedList.get(i);
                                                int processid = monitor.getProcessId();
                                        %>
                                        <tr  style="cursor:pointer" onclick="fnopenendform(this)">
                                            <td>P<%=ResourceUtil.getVersionFormat(monitor.getProcessId())%></td>
                                            <td><%=monitor.getFlowChartName()%></td>
                                            <td><%=monitor.getActivityName()%></td>
                                            <td><%=monitor.getActivityCreatedDate()%></td>
                                            <td><%=monitor.getActivityCompletedDate()%></td>
                                        </tr>

                                        <%}
                                            }%>
                                    </tbody>
                                </table>
                                <div id="endtablefooter">
                                    <div id="endtablenav">
                                        <div>
                                            <img src="include/js/images/first.gif" width="16" height="16" alt="First Page" onclick="endsorter.move(-1,true)" />
                                            <img src="include/js/images/previous.gif" width="16" height="16" alt="Previous Page" onclick="endsorter.move(-1)" />
                                            <img src="include/js/images/next.gif" width="16" height="16" alt="Next Page" onclick="endsorter.move(1)" />
                                            <img src="include/js/images/last.gif" width="16" height="16" alt="Last Page" onclick="endsorter.move(1,true)" />
                                        </div>
                                        <div>
                                            <select id="endpagedropdown"></select>
                                        </div>
                                        <div>
                                            <a id="viewAllBtn" href="javascript:endsorter.showall()">view all</a>
                                        </div>
                                    </div>
                                    <div id="endtablelocation">
                                        <div>
                                            <select onchange="endsorter.size(this.value)">
                                                <option value="5" selected="selected">5</option>
                                                <option value="10">10</option>
                                                <option value="20">20</option>
                                                <option value="50">50</option>
                                                <option value="100">100</option>
                                            </select>
                                            <span>Entries Per Page</span>
                                        </div>
                                        <div class="page">Page <span id="endcurrentpage"></span> of <span id="endtotalpages"></span></div>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </div>
        <script type="text/javascript">
            //        var sorter=new table.sorter("sorter");
            //        sorter.init("sorter",1);
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
                //                sortcolumn:0,
                //                sortdir:1,
                //            sum:[8],
                //            avg:[6,7,8,9],
                //            columns:[{index:7, format:'%', decimals:1},{index:8, format:'$', decimals:0}],
                init:true
            });
            
            var endsorter = new TINY.table.sorter('endsorter','endtable',{
                headclass:'head',
                ascclass:'asc',
                descclass:'desc',
                evenclass:'evenrow',
                oddclass:'oddrow',
                evenselclass:'evenselected',
                oddselclass:'oddselected',
                paginate:true,
                size:5,
                colddid:'endcolumns',
                currentid:'endcurrentpage',
                totalid:'endtotalpages',
                startingrecid:'endstartrecord',
                endingrecid:'endendrecord',
                totalrecid:'endtotalrecords',
                hoverid:'selectedrow',
                pageddid:'endpagedropdown',
                navid:'endtablenav',
                //                sortcolumn:0,
                //                sortdir:1,
                //            sum:[8],
                //            avg:[6,7,8,9],
                //            columns:[{index:7, format:'%', decimals:1},{index:8, format:'$', decimals:0}],
                init:true
            });
        </script>

    </body>
</html>

<%@ include file="../include/footer.jsp" %>