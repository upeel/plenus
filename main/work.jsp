<%--
    Document   : work.jsp
    Created on : Feb 20, 2009, 5:01:33 PM
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
        import="java.text.SimpleDateFormat"
        import="java.security.Principal"
        import="org.apache.catalina.realm.GenericPrincipal" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%
//    final Principal userPrincipal = request.getUserPrincipal();
//    GenericPrincipal genericPrincipal = (GenericPrincipal) userPrincipal;
//    final String[] roles = genericPrincipal.getRoles();
//    for(String role : roles){
//        System.out.println("role : " + role);
//    }
    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    Date date = new Date();
    String curdate = dateFormat.format(date);

    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, -60);
    Date olddate = cal.getTime();
    String fromdate = dateFormat.format(olddate);

    String type = request.getParameter("type");
    if (type == null) {
        type = "Dashboard";
    }

    String subtype = request.getParameter("subtype");
    if (subtype == null) {
        subtype = "work";
    }

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

    if (jfrom.equals("")) {
        jfrom = fromdate;
    }

    if (jto.equals("")) {
        jto = curdate;
    }

    if (!jfrom.equals("") && !jto.equals("")) {
    }

    String goToLast = "";
    if (session.getAttribute("url") != null) {
        String lastKnownURL = (String) session.getAttribute("url");
        //System.out.println("lastKnownURL : " + lastKnownURL);
        session.setAttribute("url", null);
        if (!lastKnownURL.equals("")) {
            //&& new UrlValidator().isValid(lastKnownURL)) {
            //System.out.println("is Valid!");
            goToLast = "fnOpenWindow('" + lastKnownURL + "');";
        }
    }

    username = userCtrl.getActiveUserNameByLoginId(loginid);
    user = userCtrl.getUserByLoginId(loginid);
    String orgunid = "0";
    int iorgunid = 0;
    UserOUDesignationController userOUDesignationCtrl = new UserOUDesignationController();
    ArrayList userOUDesignationList = userOUDesignationCtrl.getUserOUDesignationByUserId(userId);
    OrgUnitController orgUnitCtrl = new OrgUnitController();

    for (int j = 0; j < userOUDesignationList.size(); j++) {
        UserOUDesignation userOUDesignation = (UserOUDesignation) userOUDesignationList.get(j);
        int isPrimary = userOUDesignation.getIsPrimary();
        if (isPrimary == 1) {
            iorgunid = userOUDesignation.getOrgUnitid();
        }
    }

    InitiateProcessController initCtrl = new InitiateProcessController();
    //ArrayList initList = initCtrl.getFlowChartbyUserId(user.getUserId());
    ArrayList initList = initCtrl.getFlowChartbyUserIdAndOU(user.getUserId(), iorgunid);

    WorkActivityController workActivityCtrl = new WorkActivityController();
    ArrayList<EngineFlowChart> processList = workActivityCtrl.getProcessList(user.getUserId());

    AdminTaskController adminTaskCtrl = new AdminTaskController();
    ArrayList adminTaskList = adminTaskCtrl.getAllAdminTaskByUserId(user.getUserId());

    String list = request.getParameter("list");
    if (list == null) {
        list = "work";
    }
    list = list.trim();
    if (list.equals("")) {
        list = "work";
    }

    if (list.equalsIgnoreCase("absence") && list.equalsIgnoreCase("forward")) {
        list = "work";
    }

    String process = "";
    int processSelected = 0;
    process = request.getParameter("process");
    if (process == null) {
        process = "";
    }
    process = process.trim();

    if ((!process.contains(",")) && (!process.equalsIgnoreCase("0")) && (!process.equalsIgnoreCase(""))) {
        process = request.getParameter("process");
        process = process.trim();
        processSelected = Integer.parseInt(process);
    } else if (process.equalsIgnoreCase("0")) {
        process = ""; //reset it
        for (int a = 0; a < processList.size(); a++) {
            EngineFlowChart tmpprc = processList.get(a);
            int tmpid = tmpprc.getId();
            //process = process.replace("'", "");
            process = process + tmpid + ",";
        }
        if (process.length() > 0) {
            process = process.substring(0, process.length() - 1);
        }

    } else if (process.equalsIgnoreCase("")) {
        if (processList.size() > 0) {
            EngineFlowChart tmpprc = processList.get(0);
            int tmpid = tmpprc.getId();
            //process = process.replace("'", "");
            process = Integer.toString(tmpid);
            processSelected = tmpid;
        }
    }
    WorkColumnController wcCtrl = new WorkColumnController();
    WorkColumnDetails wcd = wcCtrl.getWorkColumnDetails(processSelected);

    boolean hasAdditionalColumns = false;
    ArrayList<ActionData> additionalColumnList = new ArrayList<ActionData>();
    if (wcd.getColumns() != null && !wcd.getColumns().isEmpty()) {
        additionalColumnList = wcCtrl.getFieldDescriptions(processSelected, wcd.getColumns().split(","));
        hasAdditionalColumns = true;
    }
    //System.out.println("process =" + process);

    //ArrayList forwardreturnList = new ArrayList();
    //forwardreturnList = workActivityCtrl.getForwardReturnActivity(user.getUserId());
    //forward process
    //AdminTaskController adminTaskCtrl = new AdminTaskController();
    //ArrayList adminTaskList = adminTaskCtrl.getAllAdminTaskByUserId(user.getUserId());
    //String orgunid="0";
    //int iorgunid=0;
    if (request.getParameter("orgunit") != null) {
        orgunid = request.getParameter("orgunit");
        iorgunid = Integer.valueOf(orgunid);
        session.setAttribute("org", iorgunid);
        initList = initCtrl.getFlowChartbyUserIdAndOU(user.getUserId(), iorgunid);
    } else if (session.getAttribute("org") != null) {
        iorgunid = (Integer) session.getAttribute("org");
        initList = initCtrl.getFlowChartbyUserIdAndOU(user.getUserId(), iorgunid);
    }

    int currentuserId = userCtrl.getUserIdByLoginId(loginid);
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO - Dashboard</title>
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/datatable/assets/skins/sam/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/paginator/assets/skins/sam/paginator.css" />
        <!--        <script src="../include/js/jquery-1.10.2.js"></script>-->
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
        <script>
            function fnChangeTab(url) {
                document.location.href = url;
            }

            function fnChangeProcess(process) {
                var vfrom = document.getElementById("from").value;
                var vto = document.getElementById("to").value;
                var e = document.getElementById("cbprocess");
                var vprocess = e.options[e.selectedIndex].value;
                var orgunit = document.getElementById("cbInitOrgUnit").value;
                document.getElementById("list").value = '<%=list%>';
                var vlist = '<%=list%>';
                document.location.href = "work.jsp?from=" + vfrom + "&to=" + vto + "&process=" + vprocess + "&orgunit=" + orgunit + "&list=" + vlist;
                //document.location.href="work.jsp?process="+process+"&orgunit="+orgunit+"&list=<%=list%>";
            }

            function fnopenworkform(row) {
                var cuserid = "<%=currentuserId%>"
                var orgUnitId = document.getElementById("cbInitOrgUnit").value;
                var row = document.getElementById('worktable').rows[row.rowIndex];
                var processname = row.cells[0].innerHTML;
                fnOpenWindow('initiateflowchart.jsp?action=initiateflowchart&flowChartName=' + processname + '&userId=' + cuserid + '&orgUnitId=' + orgUnitId);
            }

            function openAdminTask(vhid) {
                var cuserid = "<%=currentuserId%>"
                var orgUnitId = document.getElementById("cbInitOrgUnit").value;
                fnOpenWindow('admintask.jsp?headerId=' + vhid + '&userId=' + cuserid + '&orgUnitId=' + orgUnitId);
            }

            function fnopenendform(row) {
                var cuserid = "<%=currentuserId%>"
                var row = document.getElementById('endtable').rows[row.rowIndex];
                var processid = row.cells[0].innerHTML;
                var processname = row.cells[1].innerHTML;
                fnOpenWindow('workonactivity.jsp?action=workonactivity&flowChartName=' + processname + '&userId=' + cuserid + '&processId=' + processid);
            }

            function fnOpenWindow(URL) {
                var availHeight = screen.availHeight;
                var availWidth = screen.availWidth;
                var x = 0, y = 0;
                if (document.all) {
                    x = window.screentop;
                    y = window.screenLeft;
                } else if (document.layers) {
                    x = window.screenX;
                    y = window.screenY;
                }
                var arguments = 'resizable=1,toolbar=0,location=0,directories=0,addressbar=0,scrollbars=1,status=1,menubar=0,top=0,left=0, screenX=' + x + ',screenY=' + y + ',width=' + availWidth + ',height=' + availHeight;
                newwindow = window.open(URL, 'bmFLOWindow', arguments);
                newwindow.moveTo(0, 0);
            }

            function fnChangeOrgunit(orgunit) {
                document.location.href = "work.jsp?orgunit=" + orgunit;
            }

            function filterBtnClicked() {
                var vfrom = document.getElementById("from").value;
                var vto = document.getElementById("to").value;
                var e = document.getElementById("cbprocess");
                var vprocess = e.options[e.selectedIndex].value;
                var orgunit = document.getElementById("cbInitOrgUnit").value;
                document.getElementById("list").value = '<%=list%>';
                var vlist = '<%=list%>';
                document.location.href = "work.jsp?from=" + vfrom + "&to=" + vto + "&process=" + vprocess + "&orgunit=" + orgunit + "&list=" + vlist;
            }

            function changeListBtnClicked(vlist) {
                document.getElementById("list").value = vlist;
                var vfrom = document.getElementById("from").value;
                var vto = document.getElementById("to").value;
                var e = document.getElementById("cbprocess");
                var vprocess = e.options[e.selectedIndex].value;
                var orgunit = document.getElementById("cbInitOrgUnit").value;
                document.location.href = "work.jsp?from=" + vfrom + "&to=" + vto + "&process=" + vprocess + "&orgunit=" + orgunit + "&list=" + vlist;
            }

            function resetBtnClicked() {
                document.getElementById("from").value = "";
                document.getElementById("to").value = "";
                var vfrom = "";
                var vto = "";
                var e = document.getElementById("cbprocess");
                var vprocess = e.options[e.selectedIndex].value;
                var orgunit = document.getElementById("cbInitOrgUnit").value;
                document.getElementById("list").value = '<%=list%>';
                var vlist = '<%=list%>';
                document.location.href = "work.jsp?from=" + vfrom + "&to=" + vto + "&process=" + vprocess + "&orgunit=" + orgunit + "&list=" + vlist;
            }

            function allBtnClicked() {
                document.getElementById("from").value = "1900-01-01";
                var vfrom = "1900-01-01";
                var vto = "";
                var e = document.getElementById("cbprocess");
                var vprocess = e.options[e.selectedIndex].value;
                var orgunit = document.getElementById("cbInitOrgUnit").value;
                document.getElementById("list").value = '<%=list%>';
                var vlist = '<%=list%>';
                document.location.href = "work.jsp?from=" + vfrom + "&to=" + vto + "&process=" + vprocess + "&orgunit=" + orgunit + "&list=" + vlist;
            }

            $(document).ready(function () {
                $("#from").datepicker({
                    defaultDate: "-2w",
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 3,
                    dateFormat: 'yy-mm-dd',
                    onClose: function (selectedDate) {
                        $("#to").datepicker("option", "minDate", selectedDate);
                    }
                });

                $("#to").datepicker({
                    defaultDate: "0",
                    changeMonth: true,
                    changeYear: true,
                    numberOfMonths: 3,
                    dateFormat: 'yy-mm-dd',
                    onClose: function (selectedDate) {
                        $("#from").datepicker("option", "maxDate", selectedDate);
                    }
                });

                $('#dvLoading').hide();
                $('#overlay').hide();
                $(window).bind('beforeunload', function (e) {
                    $('#dvLoading').show();
                    $('#overlay').show();
                });

//                fnOpenWindow('../admintask/enquiry/EnquiryManagementListServlet');
//                fnOpenWindow("../admintask/pdfeditor/PDFEditorServlet");
            });
        </script>
    </head>
    <body class="yui-skin-sam">
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
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
                                                <b>&nbsp;&nbsp;Start Process</b>
                                            </div>
                                        </td>
                                        <td width="380px" align="right"><b><font face="Arial" color="#606060">Organization Unit:</font></b>
                                            <select size="1" id="cbInitOrgUnit" name="cbInitOrgUnit" onchange="fnChangeOrgunit(this.value)">
                                                <%
                                                    for (int i = 0; i < userOUDesignationList.size(); i++) {
                                                        UserOUDesignation userOUDesignation = (UserOUDesignation) userOUDesignationList.get(i);
                                                        int orgUnitId = userOUDesignation.getOrgUnitid();
                                                        String orgUnitName = orgUnitCtrl.getOrgUnitNameById(orgUnitId);
                                                        int isPrimary = userOUDesignation.getIsPrimary();
                                                        int org = 0;
                                                        if (session.getAttribute("org") == null) {
                                                        } else {
                                                            org = (Integer) session.getAttribute("org");
                                                        }
                                                        if (isPrimary == 1 && iorgunid == 0) {
                                                %>
                                                <option selected value="<%=orgUnitId%>"><%=orgUnitName%></option>
                                                <%} else if (isPrimary == 1 && iorgunid == orgUnitId) {%>
                                                <option selected value="<%=orgUnitId%>"><%=orgUnitName%></option>
                                                <%} else if (org == orgUnitId) {%>
                                                <option selected value="<%=orgUnitId%>"><%=orgUnitName%></option>
                                                <%} else {%>
                                                <option value="<%=orgUnitId%>"><%=orgUnitName%></option>
                                                <%}%>
                                                <%}%>
                                            </select>
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
                                <table class="tinytable" id="worktable" name="worktable" cellpadding="0" cellspacing="0" border="0"  style="table-layout:fixed" width="80%" background="../images/background.png">
                                    <thead>
                                        <tr valign="top">
                                            <th><h3>Process Name</h3></th>
                                            <th><h3>Created Date</h3></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%if (initList.size() <= 0) {%>
                                        <tr>
                                            <td colspan="2">No Records Found!</td>
                                        </tr>
                                        <%} else {
                                            for (int i = 0; i < initList.size(); i++) {
                                                EngineFlowChart temp = (EngineFlowChart) initList.get(i);
                                        %>
                                        <tr style="cursor:pointer" onclick="fnopenworkform(this)">
                                            <td><%=temp.getName()%></td>
                                            <td><%=temp.getCreatedDate()%></td>
                                        </tr>
                                        <%}
                                            }%>
                                    </tbody>
                                </table>
                                <div id="worktablefooter">
                                    <div id="worktablenav">
                                        <div>
                                            <img src="include/js/images/first.gif" width="16" height="16" alt="First Page" onclick="worksorter.move(-1, true)" />
                                            <img src="include/js/images/previous.gif" width="16" height="16" alt="Previous Page" onclick="worksorter.move(-1)" />
                                            <img src="include/js/images/next.gif" width="16" height="16" alt="Next Page" onclick="worksorter.move(1)" />
                                            <img src="include/js/images/last.gif" width="16" height="16" alt="Last Page" onclick="worksorter.move(1, true)" />
                                        </div>
                                        <div>
                                            <select id="workpagedropdown"></select>
                                        </div>
                                        <div>
                                            <a id="viewAllStartProcessBtn" href="javascript:worksorter.showall()">view all</a>
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
                <tr>
                    <td valign="top" align="left"><br><br>
                        <fieldset>
                            <legend>
                                <hr/>
                                <table border="0">
                                    <tr>
                                        <td>
                                            <div style="width: 960px" class="psadinitheader">
                                                <b>&nbsp;&nbsp;Management Modules</b>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <hr/>
                            </legend>
                            <div id="admintablewrapper" background="../images/background.png" width="100%">
                                <div id="admintableheader" background="../images/background.png">
                                    <div class="search" background="../images/background.png">
                                        <select id="admincolumns" onchange="adminsorter.search('adminquery')"></select>
                                        <input type="text" id="adminquery" onkeyup="adminsorter.search('adminquery')" />
                                    </div>
                                    <span class="details" background="../images/background.png">
                                        <div>Records <span id="adminstartrecord"></span>-<span id="adminendrecord"></span> of <span id="admintotalrecords"></span></div>
                                        <div><a id="resetBtn" href="javascript:adminsorter.reset()">reset</a></div>
                                    </span>
                                </div>
                                <table class="tinytable" id="admintable" name="admintable" cellpadding="0" cellspacing="0" border="0"  style="table-layout:fixed" width="80%" background="../images/background.png">
                                    <thead>
                                        <tr valign="top">
                                            <th><h3>Administrative Task Name</h3></th>
                                            <th><h3>Created Date</h3></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%if (adminTaskList.size() <= 0) {%>
                                        <tr>
                                            <td colspan="2">No Records Found!</td>
                                        </tr>
                                        <%} else {
                                            for (int a = 0; a < adminTaskList.size(); a++) {
                                                AdminTask adTask = (AdminTask) adminTaskList.get(a);
                                        %>
                                        <tr onclick="openAdminTask(<%=adTask.getId()%>)">
                                            <td><%=adTask.getName()%></td>
                                            <td><%=adTask.getCreatedDate()%></td>
                                        </tr>
                                        <% }
                                            }%>
                                    </tbody>
                                </table>
                                <div id="admintablefooter">
                                    <div id="admintablenav">
                                        <div>
                                            <img src="include/js/images/first.gif" width="16" height="16" alt="First Page" onclick="adminsorter.move(-1, true)" />
                                            <img src="include/js/images/previous.gif" width="16" height="16" alt="Previous Page" onclick="adminsorter.move(-1)" />
                                            <img src="include/js/images/next.gif" width="16" height="16" alt="Next Page" onclick="adminsorter.move(1)" />
                                            <img src="include/js/images/last.gif" width="16" height="16" alt="Last Page" onclick="adminsorter.move(1, true)" />
                                        </div>
                                        <div>
                                            <select id="adminpagedropdown"></select>
                                        </div>
                                        <div>
                                            <a id="viewAllAdminTaskBtn" href="javascript:adminsorter.showall()">view all</a>
                                        </div>
                                    </div>
                                    <div id="admintablelocation">
                                        <div>
                                            <select onchange="adminsorter.size(this.value)">
                                                <option value="5" selected="selected">5</option>
                                                <option value="10">10</option>
                                                <option value="20">20</option>
                                                <option value="50">50</option>
                                                <option value="100">100</option>
                                            </select>
                                            <span>Entries Per Page</span>
                                        </div>
                                        <div class="page">Page <span id="admincurrentpage"></span> of <span id="admintotalpages"></span></div>
                                    </div>
                                </div>
                            </div>
                            <br/>
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    <td valign="top" align="left"><br><br>
                        <fieldset>
                            <legend>
                                <div>
                                    <hr/>
                                    <table border="0" >
                                        <tr>
                                            <td width="160px">
                                                <div>
                                                    <b><font face="Arial" color="#606060">&nbsp;&nbsp;Work on Activities</font></b>
                                                </div>
                                            </td>
                                            <!--                                < //int rowNumber = workActivityCtrl.getTotalNumberRowForWorkActivity(userId, process, "au.activitystartdate DESC"); %>-->
                                            <td width="500px" style="text-align: left;">&nbsp;</td>
                                            <td width="300px" style="text-align: right;"><font color="#606060" style="font-weight: bold;" ><b>Select Process:</font></b>
                                                <select size="1" name="cbprocess" id="cbprocess" onchange="fnChangeProcess(this.value)" >
                                                    <option value="0">-ALL-</option>
                                                    <%
                                                        for (int i = 0; i < processList.size(); i++) {
                                                            EngineFlowChart tmpprc = processList.get(i);
                                                            int tmpid = tmpprc.getId();
                                                            String tmpname = tmpprc.getName();
                                                            if (processSelected == tmpid) {
                                                    %>
                                                    <option selected value="<%=tmpid%>"><%=tmpname%></option>
                                                    <%} else {%>
                                                    <option value="<%=tmpid%>"><%=tmpname%></option>
                                                    <%}
                                                        }%>
                                                </select>
                                            </td>
                                        </tr>
                                    </table>

                                    <hr/>
                                    <table border="0" width="700px" height="25px" cellspacing="0" cellpadding="0" background="../images/menu-background.png">
                                        <tr>
                                            <td width="150px">
                                                <%if (list.equals("work")) {%>
                                                <div class="selectedmenu" onclick='changeListBtnClicked("work")'>My Work List</div>
                                                <!--                                                <div class="selectedmenu" onclick='fnChangeTab("work.jsp?type=Dashboard&subtype=work&list=work&process=<=process%>")'>My Work List</div>-->
                                                <%} else {%>
                                                <div class="menu" onclick='changeListBtnClicked("work")'>My Work List</div>
                                                <!--                                                <div class="menu" onclick='fnChangeTab("work.jsp?type=Dashboard&subtype=work&list=work&process=<=process%>")'>My Work List</div>-->
                                                <%}%>
                                            </td>
                                            <td width="150px">
                                                <%if (list.equals("absence")) {%>
                                                <div class="selectedmenu" onclick='changeListBtnClicked("absence")'>Absence List</div>
                                                <!--                                                <div class="selectedmenu" onclick='fnChangeTab("work.jsp?type=Dashboard&subtype=work&list=absence&process=<=process%>")'>Absence List</div>-->
                                                <%} else {%>
                                                <div class="menu" onclick='changeListBtnClicked("absence")'>Absence List</div>
                                                <!--                                                <div class="menu" onclick='fnChangeTab("work.jsp?type=Dashboard&subtype=work&list=absence&process=<=process%>")'>Absence List</div>-->
                                                <%}%>
                                            </td>
                                            <td width="150px">
                                                <%if (list.equals("forward")) {%>
                                                <div class="selectedmenu" onclick='changeListBtnClicked("forward")'>Forwarded List</div>
                                                <!--                                                <div class="selectedmenu" onclick='fnChangeTab("work.jsp?type=Dashboard&subtype=work&list=forward&process=<=process%>")'>Forwarded List</div>-->
                                                <%} else {%>
                                                <div class="menu" onclick='changeListBtnClicked("forward")'>Forwarded List</div>
                                                <!--                                                <div class="menu" onclick='fnChangeTab("work.jsp?type=Dashboard&subtype=work&list=forward&process=<=process%>")'>Forwarded List</div>-->
                                                <%}%>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </legend>
                            <hr/>
                            <br/>
                            <div id="endtablewrapper" background="../images/background.png" width="100%">
                                <div class="search" style="width: 70%; display: block; white-space: no-wrap" background="../images/background.png">
                                    <input type="hidden" id="type" name="type" value="<%=type%>" />
                                    <input type="hidden" id="subtype" name="subtype" value="<%=subtype%>" />
                                    <input type="hidden" id="list" name="list" value="<%=list%>" />
                                    <input type="hidden" id="process" name="process" value="<%=process%>" />
                                    <input type="hidden" id="orgunit" name="orgunit" value="<%=iorgunid%>" />
                                    Activity Start Date : 
                                    <label>From</label>
                                    <input type="text" size="10" id="from" name="from" value="<%=jfrom%>" readonly/>
                                    <label>to</label>
                                    <input type="text" size="10" id="to" name="to" value="<%=jto%>" readonly/>
                                    <input type="button" id="filterBtn" style="width:50px" class="psadbutton" name="filterBtn" value="Filter" onclick="filterBtnClicked()" />
                                    <input type="button" id="allBtn" style="width:50px" class="psadbutton" name="allBtn" value="All" onclick="allBtnClicked()" />
                                    <input type="button" id="rsBtn" style="width:50px" class="psadbutton" name="rsBtn" value="Reset" onclick="resetBtnClicked()" />
                                </div>
                                <br/>
                                <br/>
                                <div id="endtableheader" background="../images/background.png">
                                    <br/>
                                    <div class="search" background="../images/background.png">
                                        <select id="endcolumns" onchange="endsorter.search('endquery')"></select>
                                        <input type="text" id="endquery" onkeyup="endsorter.search('endquery')" />
                                    </div>
                                    <span class="details" background="../images/background.png">
                                        <div>Records <span id="endstartrecord"></span>-<span id="endendrecord"></span> of <span id="endtotalrecords"></span></div>
                                        <div><a id="resetBtn" href="javascript:endsorter.reset()">reset</a></div>
                                    </span>
                                </div>
                                <br/>
                                <br/>
                                <table class="tinytable" id="endtable" name="endtable" cellpadding="0" cellspacing="0" border="0"  style="table-layout:fixed" width="80%" background="../images/background.png">
                                    <thead>
                                        <tr valign="top">
                                            <th><h3>Process ID</h3></th>
                                            <th><h3>Process Name</h3></th>
                                            <th><h3>Process Initiator</h3></th>
                                            <th><h3>Activity Name</h3></th>
                                            <th><h3>Activity Start Date</h3></th>
                                            <th><h3>Document Number</h3></th>
                                                <%
                                                    if (hasAdditionalColumns) {
                                                        for (int a = 0; a < additionalColumnList.size(); a++) {
                                                            ActionData actData = additionalColumnList.get(a);
                                                %>
                                            <th><h3><%=actData.getValue()%></h3></th>
                                                    <% }
                                                        }%>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            if (list.equalsIgnoreCase("work")) {
                                                ArrayList workList = workActivityCtrl.getWorkActivity(user.getUserId(), process, jfrom, jto);
                                                if (workList.size() <= 0) {
                                        %>
                                        <tr>
                                            <td colspan="6">No Records Found!</td>
                                        </tr>
                                        <%                                    } else {
                                            for (int i = 0; i < workList.size(); i++) {
                                                WorkActivity workActivity = (WorkActivity) workList.get(i);
                                        %>
                                        <tr style="cursor:pointer" onclick="fnopenendform(this)">
                                            <td><%="P" + ResourceUtil.getVersionFormat(workActivity.getProcessId())%></td>
                                            <td><%=workActivity.getProcessName()%></td>
                                            <td><%=workActivity.getProcessInitiator()%></td>
                                            <td><%=workActivity.getActivityName()%></td>
                                            <td><%=workActivity.getActivityStartDate()%></td>
                                            <td><%=workActivity.getDocNumber()%></td>
                                            <%
                                                if (hasAdditionalColumns) {
                                                    ArrayList<ActionData> additionalColumnValueList = workActivity.getActDataList();
                                                    for (int a = 0; a < additionalColumnList.size(); a++) {
                                                        ActionData cellIdentifier = additionalColumnList.get(a);
                                                        if (additionalColumnValueList != null && !additionalColumnValueList.isEmpty()) {
                                                            for (int b = 0; b < additionalColumnValueList.size(); b++) {
                                                                ActionData actualValue = additionalColumnValueList.get(b);
                                                                if (actualValue.getCellId().equalsIgnoreCase(cellIdentifier.getCellId())) {
                                            %>
                                            <td><%=actualValue.getValue()%></td>
                                            <%
                                                        break;
                                                    }
                                                }
                                            } else {
                                            %>
                                            <td>&nbsp;</td>
                                            <%                                                        }
                                                    }
                                                }%>
                                        </tr>
                                        <%}
                                                }
                                            }%>

                                        <%
                                            if (list.equalsIgnoreCase("absence")) {
                                                ArrayList absenceList = workActivityCtrl.getAbsenceActivity(user.getUserId(), process, jfrom, jto);
                                                if (absenceList.size() <= 0) {
                                        %>
                                        <tr>
                                            <td colspan="6">No Records Found!</td>
                                        </tr>
                                        <%                                    } else {
                                            for (int m = 0; m < absenceList.size(); m++) {
                                                WorkActivity workActivity = (WorkActivity) absenceList.get(m);
                                        %>
                                        <tr  style="cursor:pointer" onclick="fnopenendform(this)">
                                            <td><%="P" + ResourceUtil.getVersionFormat(workActivity.getProcessId())%></td>
                                            <td><%=workActivity.getProcessName()%></td>
                                            <td><%=workActivity.getProcessInitiator()%></td>
                                            <td><%=workActivity.getActivityName()%></td>
                                            <td><%=workActivity.getActivityStartDate()%></td>
                                            <td><%=workActivity.getDocNumber()%></td>
                                            <%
                                                if (hasAdditionalColumns) {
                                                    ArrayList<ActionData> additionalColumnValueList = workActivity.getActDataList();
                                                    for (int a = 0; a < additionalColumnList.size(); a++) {
                                                        ActionData cellIdentifier = additionalColumnList.get(a);
                                                        if (additionalColumnValueList != null && !additionalColumnValueList.isEmpty()) {
                                                            for (int b = 0; b < additionalColumnValueList.size(); b++) {
                                                                ActionData actualValue = additionalColumnValueList.get(b);
                                                                if (actualValue.getCellId().equalsIgnoreCase(cellIdentifier.getCellId())) {
                                            %>
                                            <td><%=actualValue.getValue()%></td>
                                            <%
                                                        break;
                                                    }
                                                }
                                            } else {
                                            %>
                                            <td>&nbsp;</td>
                                            <%                                                        }
                                                    }
                                                }%>
                                        </tr>
                                        <%}
                                                }
                                            }%>
                                        <%
                                            if (list.equalsIgnoreCase("forward")) {
                                                ArrayList forwardList = workActivityCtrl.getForwardActivity(user.getUserId(), process, jfrom, jto);
                                                if (forwardList.size() <= 0) {
                                        %>
                                        <tr>
                                            <td colspan="6">No Records Found!</td>
                                        </tr>
                                        <%                                    } else {
                                            for (int f = 0; f < forwardList.size(); f++) {
                                                WorkActivity workActivity = (WorkActivity) forwardList.get(f);
                                        %>
                                        <tr  style="cursor:pointer" onclick="fnopenendform(this)">
                                            <td><%="P" + ResourceUtil.getVersionFormat(workActivity.getProcessId())%></td>
                                            <td><%=workActivity.getProcessName()%></td>
                                            <td><%=workActivity.getProcessInitiator()%></td>
                                            <td><%=workActivity.getActivityName()%></td>
                                            <td><%=workActivity.getActivityStartDate()%></td>
                                            <td><%=workActivity.getDocNumber()%></td>
                                            <%
                                                if (hasAdditionalColumns) {
                                                    ArrayList<ActionData> additionalColumnValueList = workActivity.getActDataList();
                                                    for (int a = 0; a < additionalColumnList.size(); a++) {
                                                        ActionData cellIdentifier = additionalColumnList.get(a);
                                                        if (additionalColumnValueList != null && !additionalColumnValueList.isEmpty()) {
                                                            for (int b = 0; b < additionalColumnValueList.size(); b++) {
                                                                ActionData actualValue = additionalColumnValueList.get(b);
                                                                if (actualValue.getCellId().equalsIgnoreCase(cellIdentifier.getCellId())) {
                                            %>
                                            <td><%=actualValue.getValue()%></td>
                                            <%
                                                        break;
                                                    }
                                                }
                                            } else {
                                            %>
                                            <td>&nbsp;</td>
                                            <%                                                        }
                                                    }
                                                }%>
                                        </tr>

                                        <%
                                                    }
                                                }
                                            }
                                        %>
                                    </tbody>
                                </table>
                                <div id="endtablefooter">
                                    <div id="endtablenav">
                                        <div>
                                            <img src="include/js/images/first.gif" width="16" height="16" alt="First Page" onclick="endsorter.move(-1, true)" />
                                            <img src="include/js/images/previous.gif" width="16" height="16" alt="Previous Page" onclick="endsorter.move(-1)" />
                                            <img src="include/js/images/next.gif" width="16" height="16" alt="Next Page" onclick="endsorter.move(1)" />
                                            <img src="include/js/images/last.gif" width="16" height="16" alt="Last Page" onclick="endsorter.move(1, true)" />
                                        </div>
                                        <div>
                                            <select id="endpagedropdown"></select>
                                        </div>
                                        <div>
                                            <a id="viewAllWorkOnActivtiesBtn" href="javascript:endsorter.showall()">view all</a>
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
                            <br/>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </div>
        <script type="text/javascript">
            var worksorter = new TINY.table.sorter('worksorter', 'worktable', {
                headclass: 'head',
                ascclass: 'asc',
                descclass: 'desc',
                evenclass: 'evenrow',
                oddclass: 'oddrow',
                evenselclass: 'evenselected',
                oddselclass: 'oddselected',
                paginate: true,
                size: 5,
                colddid: 'workcolumns',
                currentid: 'workcurrentpage',
                totalid: 'worktotalpages',
                startingrecid: 'workstartrecord',
                endingrecid: 'workendrecord',
                totalrecid: 'worktotalrecords',
                hoverid: 'selectedrow',
                pageddid: 'workpagedropdown',
                navid: 'worktablenav',
                //                sortcolumn:0,
                //                sortdir:1,
                //            sum:[8],
                //            avg:[6,7,8,9],
                //            columns:[{index:7, format:'%', decimals:1},{index:8, format:'$', decimals:0}],
                init: true
            });

            var adminsorter = new TINY.table.sorter('adminsorter', 'admintable', {
                headclass: 'head',
                ascclass: 'asc',
                descclass: 'desc',
                evenclass: 'evenrow',
                oddclass: 'evenrow',
                evenselclass: 'evenselected',
                oddselclass: 'oddselected',
                paginate: true,
                size: 5,
                colddid: 'admincolumns',
                currentid: 'admincurrentpage',
                totalid: 'admintotalpages',
                startingrecid: 'adminstartrecord',
                endingrecid: 'adminendrecord',
                totalrecid: 'admintotalrecords',
                hoverid: 'selectedrow',
                pageddid: 'adminpagedropdown',
                navid: 'admintablenav',
                //                sortcolumn:0,
                //                sortdir:1,
                //            sum:[8],
                //            avg:[6,7,8,9],
                //            columns:[{index:7, format:'%', decimals:1},{index:8, format:'$', decimals:0}],
                init: true
            });

            var endsorter = new TINY.table.sorter('endsorter', 'endtable', {
                headclass: 'head',
                ascclass: 'asc',
                descclass: 'desc',
                evenclass: 'evenrow',
                oddclass: 'oddrow',
                evenselclass: 'evenselected',
                oddselclass: 'oddselected',
                paginate: true,
                size: 5,
                colddid: 'endcolumns',
                currentid: 'endcurrentpage',
                totalid: 'endtotalpages',
                startingrecid: 'endstartrecord',
                endingrecid: 'endendrecord',
                totalrecid: 'endtotalrecords',
                hoverid: 'selectedrow',
                pageddid: 'endpagedropdown',
                navid: 'endtablenav',
                //                sortcolumn:0,
                //                sortdir:1,
                //            sum:[8],
                //            avg:[6,7,8,9],
                //            columns:[{index:7, format:'%', decimals:1},{index:8, format:'$', decimals:0}],
                init: true
            });

            <%=goToLast%>
        </script>
    </body>
</html>

<%@ include file="../include/footer.jsp" %>