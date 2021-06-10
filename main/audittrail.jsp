<%-- 
    Document   : audittrail
    Created on : Apr 10, 2014, 4:03:24 PM
    Author     : SOE HTIKE
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%@page import = "com.bizmann.product.controller.InitiateProcessController"
        import = "com.bizmann.product.resources.*"
        import = "com.bizmann.product.entity.User"
        import = "com.bizmann.product.entity.Form"
        import = "com.bizmann.product.entity.AuditTrail" %>
<%
    username = userCtrl.getUserNameByLoginId(loginid);
    user = userCtrl.getUserByLoginId(loginid);

    MonitorController monitorCtrl = new MonitorController();
    ArrayList outstandingList = monitorCtrl.getOutstandingMonitorList(user.getUserId());
    ArrayList completedList = monitorCtrl.getCompletedMonitorList(user.getUserId());
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Flo'</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/datatable/assets/skins/sam/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/paginator/assets/skins/sam/paginator.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datasource/datasource-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datatable/datatable-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/paginator/paginator-min.js"></script>
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
                background-image:url('../images/background.png');
            }
        </style>
    </head>

    <script type="text/javascript">
        var action = "<%=request.getParameter("action")%>";
        var type = "<%=request.getParameter("type")%>";
        var subtype = "<%=request.getParameter("subtype")%>";

        function changeViewBy(){
            var viewby = document.getElementById("viewby").value;
            document.location.href = "processmonitor.jsp?type="+type+"&subtype="+subtype+"&viewby="+viewby;
        }

        function fnByProcess(){
            var processname = document.getElementById("byprocess").value;
            if(processname != ""){
                document.location.href = "processmonitor.jsp?type="+type+"&subtype="+subtype+"&viewby=process&processname="+processname;
            }
        }
    </script>
    <SCRIPT LANGUAGE="JavaScript">
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
            //parent.location= "monitor.jsp";
        }
    </SCRIPT>
    <body class=" yui-skin-sam" >
        <div align="center" background="../images/background.png" >
            <table border="0" width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td align="left"><br><br>
                        <div class="psadheader" >
                            <b>&nbsp;&nbsp;Outstanding Processes</b>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <div id="ongoing" class="datatable" background="../images/background.png">
                            <table id="ongoingtable" class="ongoingtable" width="90%" background="../images/background.png" >
                                <thead>
                                    <tr>
                                        <th>Process ID</th>
                                        <th>Process Name</th>
                                        <th>Participant</th>
                                        <th>Activity Name</th>
                                        <th>Activity Start Date</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <%for (int i = 0; i < outstandingList.size(); i++) {
                                            Monitor monitor = (Monitor) outstandingList.get(i);
                                            int processid = monitor.getProcessId();
                                    %>
                                    <tr>
                                        <td>P<%=ResourceUtil.getVersionFormat(monitor.getProcessId())%></td>
                                        <td><%=monitor.getFlowChartName()%></td>
                                        <td><%=monitor.getCurrentUser()%></td>
                                        <td><%=monitor.getActivityName()%></td>
                                        <td><%=monitor.getActivityCreatedDate()%></td>
                                    </tr>
                                    <%}%>
                                </tbody>
                            </table>
                        </div>
                        <table>
                            <tr>
                                <td><div id="ongoingpag" class="ongoingpag"></div></td>
                            </tr>
                        </table>
                        <script type="text/javascript">
                            YAHOO.util.Event.addListener(window, "load", function() {
                                YAHOO.example.EnhanceFromMarkup = function() {
                                    var myColumnDefs = [
                                        {key:"pid",label:"Process ID",sortable:true,width:80},
                                        {key:"pname",label: "Process Name", sortable:true,width:140},
                                        {key:"participant",label: "Participant", sortable:true,width:130},
                                        {key:"aname",label: "Activity Name", sortable:true,width:80},
                                        {key:"astartdate",label: "Activity Start Date", sortable:true,width:120}
                                    ];

                                    var ongoingSource = new YAHOO.util.DataSource(YAHOO.util.Dom.get("ongoingtable"));
                                    ongoingSource.responseType = YAHOO.util.DataSource.TYPE_HTMLTABLE;
                                    ongoingSource.responseSchema = {
                                        fields: [
                                            {key:"pid"},
                                            {key:"pname"},
                                            {key:"participant"},
                                            {key:"aname"},
                                            {key:"astartdate", parser:"datetime"}
                                        ]
                                    };

                                    var oConfigs = {
                                        paginator: new YAHOO.widget.Paginator({
                                            rowsPerPage: 7,
                                            containers: 'ongoingpag',
                                            alwaysVisible : false,
                                            firstPageLinkLabel : " << ",
                                            lastPageLinkLabel : " >> ",
                                            previousPageLinkLabel : " < prev ",
                                            nextPageLinkLabel : " next > "
                                        }),
                                        initialRequest: "results=100"
                                    };

                                    var ongoingTable = new YAHOO.widget.DataTable("ongoing", myColumnDefs, ongoingSource, oConfigs);

                                    ongoingTable.subscribe("rowMouseoverEvent", ongoingTable.onEventHighlightRow);
                                    ongoingTable.subscribe("rowMouseoutEvent", ongoingTable.onEventUnhighlightRow);
                                    ongoingTable.subscribe("rowClickEvent", ongoingTable.onEventSelectRow);
                                    ongoingTable.subscribe("rowDblclickEvent", function (oArgs) {
                                        var rec = this.getRecord(oArgs.target);
                                        fnOpenWindow('audittraildetail.jsp?pid='+ rec.getData('pid'));
                                    }, ongoingTable, true);
                                    return {
                                        oDS: ongoingSource,
                                        oDT: ongoingTable
                                    };
                                }();
                            });
                        </script>
                    </td>
                </tr>
                <tr>
                    <td align="left"><br><br>
                        <div class="psadheader" >
                            <b>&nbsp;&nbsp;Completed Processes</b>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td valign="top">
                        <!-- Completed -->
                        <div id="completed" class="datatable" >
                            <table id="completedtable" class="completedtable" >
                                <thead>
                                    <tr>
                                        <th>Process ID</th>
                                        <th>Process Name</th>
                                        <th>Activity Start Date</th>
                                        <th>Activity End Date</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <%for (int i = 0; i < completedList.size(); i++) {
                                            Monitor monitor = (Monitor) completedList.get(i);
                                            int processid = monitor.getProcessId();
                                    %>
                                    <tr>
                                        <td>P<%=ResourceUtil.getVersionFormat(monitor.getProcessId())%></td>
                                        <td><%=monitor.getFlowChartName()%></td>
                                        <td><%=monitor.getActivityCreatedDate()%></td>
                                        <td><%=monitor.getActivityCompletedDate()%></td>
                                    </tr>
                                    <%}%>
                                </tbody>
                            </table>
                        </div>
                        <table>
                            <tr>
                                <td><div id="completedpag" class="completedpag"></div></td>
                            </tr>
                        </table>
                        <script type="text/javascript">
                            YAHOO.util.Event.addListener(window, "load", function() {
                                YAHOO.example.EnhanceFromMarkup = function() {
                                    var myColumnDefs = [
                                        {key:"pid",label:"Process ID",sortable:true,width:100},
                                        {key:"pname",label: "Process Name", sortable:true,width:150},
                                        {key:"astartdate",label: "Process Start Date", sortable:true,width:135},
                                        {key:"aenddate",label: "Process End Date", sortable:true,width:135}
                                    ];

                                    var completedSource = new YAHOO.util.DataSource(YAHOO.util.Dom.get("completedtable"));
                                    completedSource.responseType = YAHOO.util.DataSource.TYPE_HTMLTABLE;
                                    completedSource.responseSchema = {
                                        fields: [
                                            {key:"pid"},
                                            {key:"pname"},
                                            {key:"astartdate", parser:"datetime"},
                                            {key:"aenddate", parser:"datetime"}
                                        ]
                                    };

                                    var oConfigs = {
                                        paginator: new YAHOO.widget.Paginator({
                                            rowsPerPage: 7,
                                            containers: 'completedpag',
                                            alwaysVisible : false,
                                            firstPageLinkLabel : " << ",
                                            lastPageLinkLabel : " >> ",
                                            previousPageLinkLabel : " < prev ",
                                            nextPageLinkLabel : " next > "
                                        }),
                                        initialRequest: "results=100"
                                    };

                                    var completedTable = new YAHOO.widget.DataTable("completed", myColumnDefs, completedSource, oConfigs);

                                    completedTable.subscribe("rowMouseoverEvent", completedTable.onEventHighlightRow);
                                    completedTable.subscribe("rowMouseoutEvent", completedTable.onEventUnhighlightRow);
                                    completedTable.subscribe("rowClickEvent", completedTable.onEventSelectRow);
                                    completedTable.subscribe("rowDblclickEvent", function (oArgs) {
                                        var rec = this.getRecord(oArgs.target);
                                        fnOpenWindow('audittraildetail.jsp?pid='+ rec.getData('pid'));
                                    }, completedTable, true);
                                    return {
                                        oDS: completedSource,
                                        oDT: completedTable
                                    };
                                }();
                            });
                        </script>
                        <br><br><br><br>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>
<%@ include file="../include/footer.jsp" %>