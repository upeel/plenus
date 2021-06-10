<%-- 
    Document   : workforward
    Created on : Aug 30, 2010, 4:30:23 PM
    Author     : Ei
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%@page import="com.bizmann.product.entity.User"
        import="com.bizmann.product.controller.*"
        import="java.util.*"
        %>
<%
    username = userCtrl.getUserNameByLoginId(loginid);
    user = userCtrl.getUserByLoginId(loginid);
    String orgunid = "0";
    int iorgunid = 0;
    int currentuserId = userCtrl.getUserIdByLoginId(loginid);

    boolean chkAdmin = false;
    boolean chkAbs = false;
    String fwusername = "";
    String fwouname = "";
    int curuserid = currentuserId;
    String msg = "";
    String action = "";
    String fwuserid = "";
    String fwouid = "";
    String fwprocessid = "";
    String fromuser = "";
    String fromuserou = "";
    String fromuserid = "";
    String fromuserouid = "";
    String sfromuserid = "";
    String sfromuserouid = "";
    if (request.getParameter("action") != null) {
        action = request.getParameter("action");
    }

    UserOUDesignationController userOUDesignationCtrl = new UserOUDesignationController();
    AbsenceController absCtrl = new AbsenceController();
    ForwardController fwCtrl = new ForwardController();
    OrgUnitController orgUnitCtrl = new OrgUnitController();
    Activity act = new Activity();
    ArrayList userOUDesignationList = new ArrayList();
    chkAdmin = userOUDesignationCtrl.checkAdmin(user.getUserId());

    if (action.equals("adminchangeuser")) {
        fromuser = request.getParameter("fromuser");
        fromuserou = request.getParameter("fromuserou");
        fromuserid = request.getParameter("fromuserid");
        fromuserouid = request.getParameter("fromuserouid");
        sfromuserid = fromuserid.substring(0, 1);
        if (sfromuserid.equalsIgnoreCase("u")) {
            fromuserid = fromuserid.replaceFirst("U", "0");
        }
        sfromuserouid = fromuserouid.substring(0, 1);
        if (sfromuserouid.equalsIgnoreCase("O")) {
            fromuserouid = fromuserouid.replaceFirst("O", "0");
        }

        userOUDesignationList = userOUDesignationCtrl.getUserOUDesignationByUserId(Integer.valueOf(fromuserid));
        chkAdmin = true;
        username = fromuser;
        curuserid = Integer.parseInt(fromuserid);
    } else if (action.equals("forwardprocess") && chkAdmin == true) {

        fromuser = request.getParameter("fromuser");
        fwusername = request.getParameter("fwusername");
        fwouname = request.getParameter("fwouname");
        fromuserid = request.getParameter("fromuserid");

        sfromuserid = fromuserid.substring(0, 1);
        if (sfromuserid.equalsIgnoreCase("u")) {
            fromuserid = fromuserid.replaceFirst("U", "0");
        }
        //userOUDesignationList = userOUDesignationCtrl.getUserOUDesignationByUserId(Integer.valueOf(fromuserid));
        chkAdmin = userOUDesignationCtrl.checkAdmin(user.getUserId());
        username = fromuser;
        curuserid = Integer.parseInt(fromuserid);
    } else {
        //userOUDesignationList = userOUDesignationCtrl.getUserOUDesignationByUserId(userId);
    }

    ArrayList workList = new ArrayList();
    ArrayList absenceList = new ArrayList();
    //ArrayList forwardList = new ArrayList();
    //ArrayList forwardreturnList = new ArrayList();
    WorkActivityController workActivityCtrl = new WorkActivityController();
    /*
    String process = "";
    ArrayList<EngineFlowChart> processList = workActivityCtrl.getProcessList(user.getUserId());
    //StringBuffer sbf = new StringBuffer();
    for (int j = 0; j < processList.size(); j++) {
    EngineFlowChart tmpprc = processList.get(j);
    int tmpid = tmpprc.getId();
    //process = process.replace("'", "");
    process = process + tmpid + ",";
    //sbf.append("'" + tempprocess + "',");
    }
    if (process.length() > 0) {
    process = process.substring(0, process.length() - 1);
    }
     */

    /* if(!action.equals("changeou")&&!action.equals("adminchangeuser")&&!action.equals("forwardprocess")){
    System.out.println("*****"+action+"******");
    workList = workActivityCtrl.getWorkActivity(user.getUserId());//need to amend for user ou change
    absenceList = workActivityCtrl.getAbsenceActivity(user.getUserId());//need to amend for user ou change
    forwardList=workActivityCtrl.getForwardActivity(user.getUserId());//need to amend for user ou change
    forwardreturnList=workActivityCtrl.getForwardReturnActivity(user.getUserId());
    System.out.println("list size="+workList.size()+" "+absenceList.size()+" "+forwardList.size());
    }else if(action.equals("changeou")){
    workList = workActivityCtrl.getWorkActivity(user.getUserId());//need to amend for user ou change
    absenceList = workActivityCtrl.getAbsenceActivity(user.getUserId());//need to amend for user ou change
    forwardList=workActivityCtrl.getForwardActivity(user.getUserId());//need to amend for user ou change
    forwardreturnList=workActivityCtrl.getForwardReturnActivity(user.getUserId());
    }else if(action.equals("adminchangeuser")||action.equals("forwardprocess")){
    if(chkAdmin==true){
    workList = workActivityCtrl.getWorkActivity(Integer.valueOf(fromuserid));//need to amend for user ou change
    absenceList = workActivityCtrl.getAbsenceActivity(Integer.valueOf(fromuserid));//need to amend for user ou change
    forwardList=workActivityCtrl.getForwardActivity(Integer.valueOf(fromuserid));//need to amend for user ou change
    forwardreturnList=workActivityCtrl.getForwardReturnActivity(Integer.valueOf(fromuserid));
    }else{
    workList = workActivityCtrl.getWorkActivity(user.getUserId());//need to amend for user ou change
    absenceList = workActivityCtrl.getAbsenceActivity(user.getUserId());//need to amend for user ou change
    forwardList=workActivityCtrl.getForwardActivity(user.getUserId());//need to amend for user ou change
    forwardreturnList=workActivityCtrl.getForwardReturnActivity(user.getUserId());
    }
    
    }*/

    if (action.equals("forwardprocess")) {

        fwuserid = request.getParameter("fwuid");
        fwouid = request.getParameter("fwou");
        fwprocessid = request.getParameter("fwprocessid");
        String sfwuserid = fwuserid.substring(0, 1);
        String sfwouid = fwouid.substring(0, 1);
        String sfwprocessid = fwprocessid.substring(0, 1);
        if (sfwuserid.equalsIgnoreCase("u")) {
            fwuserid = fwuserid.replaceFirst("U", "");
        }
        if (sfwouid.equalsIgnoreCase("O")) {
            fwouid = fwouid.replaceFirst("O", "0");
        }
        if (sfwprocessid.equalsIgnoreCase("p")) {
            fwprocessid = fwprocessid.replaceFirst("P", "0");
        }

        chkAbs = absCtrl.checkAbsence(Integer.valueOf(fwuserid));
        if (chkAbs == true) {
            msg = "You are not allowed to forward a process to a user who is currently absence.";
        } else {
            if (chkAdmin == true) {

                fromuserid = request.getParameter("fromuserid");
                sfromuserid = fromuserid.substring(0, 1);
                if (sfromuserid.equalsIgnoreCase("u")) {
                    fromuserid = fromuserid.replaceFirst("U", "0");
                }
                if (fromuserid.equals(fwuserid)) {
                    msg = "You are not allowed to forward a process to the same user.";
                } else {
                    act = fwCtrl.getActivityRecord(Integer.valueOf(fromuserid), Integer.valueOf(fwprocessid));
                    fwCtrl.updateForward(Integer.valueOf(fromuserid), fwuserid, Integer.valueOf(fwprocessid));
                    fwCtrl.setForward(act, fwuserid, Integer.valueOf(fwprocessid));
                }

            } else {

                if (currentuserId == Integer.valueOf(fwuserid)) {
                    msg = "You are not allowed to forward a process to the same user.";
                } else {
                    act = fwCtrl.getActivityRecord(currentuserId, Integer.valueOf(fwprocessid));
                    fwCtrl.updateForward(currentuserId, fwuserid, Integer.valueOf(fwprocessid));
                    fwCtrl.setForward(act, fwuserid, Integer.valueOf(fwprocessid));
                }

            }
        }
        fwusername = request.getParameter("fwusername");
        fwouname = request.getParameter("fwouname");
    }

    if (!action.equals("changeou") && !action.equals("adminchangeuser") && !action.equals("forwardprocess")) {
        workList = workActivityCtrl.getWorkActivity(user.getUserId());//need to amend for user ou change
        absenceList = workActivityCtrl.getAbsenceActivity(user.getUserId());//need to amend for user ou change
        //forwardList = workActivityCtrl.getForwardActivity(user.getUserId());//need to amend for user ou change
        //forwardreturnList = workActivityCtrl.getForwardReturnActivity(user.getUserId());
    } else if (action.equals("changeou")) {
        workList = workActivityCtrl.getWorkActivity(user.getUserId());//need to amend for user ou change
        absenceList = workActivityCtrl.getAbsenceActivity(user.getUserId());//need to amend for user ou change
        //forwardList = workActivityCtrl.getForwardActivity(user.getUserId());//need to amend for user ou change
        //forwardreturnList = workActivityCtrl.getForwardReturnActivity(user.getUserId());
    } else if (action.equals("adminchangeuser") || action.equals("forwardprocess")) {
        if (chkAdmin == true) {
            workList = workActivityCtrl.getWorkActivity(Integer.valueOf(fromuserid));//need to amend for user ou change
            absenceList = workActivityCtrl.getAbsenceActivity(Integer.valueOf(fromuserid));//need to amend for user ou change
            //forwardList = workActivityCtrl.getForwardActivity(Integer.valueOf(fromuserid));//need to amend for user ou change
            //forwardreturnList = workActivityCtrl.getForwardReturnActivity(Integer.valueOf(fromuserid));
        } else {
            workList = workActivityCtrl.getWorkActivity(user.getUserId());//need to amend for user ou change
            absenceList = workActivityCtrl.getAbsenceActivity(user.getUserId());//need to amend for user ou change
            //forwardList = workActivityCtrl.getForwardActivity(user.getUserId());//need to amend for user ou change
            //forwardreturnList = workActivityCtrl.getForwardReturnActivity(user.getUserId());
        }
    }

    for (int j = 0; j < userOUDesignationList.size(); j++) {
        UserOUDesignation userOUDesignation = (UserOUDesignation) userOUDesignationList.get(j);
        int isPrimary = userOUDesignation.getIsPrimary();
        if (isPrimary == 1) {
            iorgunid = userOUDesignation.getOrgUnitid();
        }
    }
    if (request.getParameter("orgunit") != null) {
        orgunid = request.getParameter("orgunit");
        iorgunid = Integer.valueOf(orgunid);
        session.setAttribute("org", iorgunid);
        //need to retrieve work on activity list according to orgunit
    } else if (session.getAttribute("org") != null) {
        iorgunid = (Integer) session.getAttribute("org");
    }
    //System.out.println("workList : " + workList.size());
    //System.out.println("absenceList : " + absenceList.size());
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Flo'</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/datatable/assets/skins/sam/datatable.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/paginator/assets/skins/sam/paginator.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datasource/datasource-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datatable/datatable-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/paginator/paginator-min.js"></script> 

        <script src="../include/js/jquery-1.10.2.js"></script>
        <link rel="stylesheet" href="../include/tinytable/css/style.css" />
        <script type="text/javascript" src="../include/tinytable/js/script.js"></script>
        <style type="text/css">
            .icon-form { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }

            .highlighted { background-color: black; color: blue; }

            table tr.active {background: #1e1e1e;}

            .treediv{
                position: relative;
                text-align: left;
            }

            .orgtable {
                border-left:1px solid #cbcbcb;
                border-right:1px solid #cbcbcb;
                border-top:1px solid #cbcbcb;
                border-bottom:1px solid #cbcbcb;
                border:1px solid #cbcbcb;
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
        </style>
    </head>
    <script type="text/javascript">
        
        var subtype = "<%=request.getParameter("subtype")%>";
        var vchkadmin="<%=chkAdmin%>";

        function fnChangeOrgunit(orgunit){
            document.location.href="workforward.jsp?action=changeou&orgunit="+orgunit+"&subtype="+subtype;
        }     
        
        function fnOnSelect(row){
            var row = document.getElementById('worktable').rows[row.rowIndex];
            $(".highlighted").removeClass("highlighted");
            $(row).addClass("highlighted");
            var pid = row.cells[0].innerHTML;
            document.getElementById("hidpid").value=pid;
        }

        function fnForward(){            
            if(fnValidate()==true){
                if ($(".highlighted")[0]){
                    var vpid=document.getElementById("hidpid").value;
                    var vouid=document.getElementById("hidparentid").value;
                    var vuid=document.getElementById("hidchildid").value;
                    var vfuid=document.getElementById("hidfromuserid").value;
                    var vfouid=document.getElementById("hidfromuserouid").value;
                    var vfuser=document.getElementById("txtusername").value;
                    var vfusername=document.getElementById("txtfwusername").value;
                    var vfouname=document.getElementById("txtfwou").value;
                    //var cmb=document.getElementById("cbInitOrgUnit");
                    var vfou=0;
                    document.location.href="workforward.jsp?action=forwardprocess&fwprocessid="+vpid+"&fwou="+vouid+"&fwuid="+vuid+"&fromuserid="+vfuid+"&fromuserouid="+vfouid+"&fromuser="+vfuser+"&orgunit="+vfou+"&subtype="+subtype+"&fwusername="+vfusername+"&fwouname="+vfouname;
                }else{
                    alert("Please select a process to forward.");
                }
            }
        }

        function fnSelectUser(vadmin){
            var url="";
            if(vadmin==true){
                url="userlist.jsp?ckadmin="+vadmin;
            }else{
                url="userlist.jsp?ckadmin="+vadmin;
            }
            window.open(url,"select","status=1,toolbar=0,width=500,height=500,scrollbars=yes");
        }

        function fnSetUser(userid,parentid,username,ouname){
            document.getElementById("txtfwusername").value=username;
            document.getElementById("txtfwou").value=ouname;
            document.getElementById("hidchildid").value=userid;
            document.getElementById("hidparentid").value=parentid;
        }

        function fnSetUserForAdmin(userid,parentid,username,ouname){
            document.getElementById("hidfromuserid").value=userid;
            document.getElementById("hidfromuserouid").value=parentid;
            document.location.href="workforward.jsp?action=adminchangeuser&fromuser="+username+"&fromuserou="+ouname+"&fromuserid="+userid+"&fromuserouid="+parentid+"&subtype="+subtype;
        }
        
        function fnValidate(){
            
            if(document.getElementById("hidchildid").value==""){
                alert("Please select a user to forward.");
                return false;
            }
            else if(document.getElementById("hidpid").value==""){
                alert("Please select a process to forward.");
                return false;
            }
            /*else if(document.getElementById("hidparentid").value==""){
                alert("Please select an organization unit");
                return false;
            }*/
            return true;

        }

        function fnOnload(){
            var msg=document.getElementById("msg").value;
            if(msg!=""){
                alert(msg);
            }
        }

        function fnChangeOrgunitAdmin(ou){
            var vfuserid=document.getElementById("hidfromuserid").value;
            var vfouid=document.getElementById("hidfromuserouid").value;
            var vfuser=document.getElementById("txtusername").value;
            //var cmb=document.getElementById("cbInitOrgUnit");
            var vfou=0;
            document.location.href="workforward.jsp?action=adminchangeuser&fromuser="+vfuser+"&fromuserou="+vfou+"&fromuserid="+vfuserid+"&fromuserouid="+vfouid+"&orgunit="+ou+"&subtype="+subtype;
        }
    </script>
    <body class="yui-skin-sam" onload="fnOnload()">
        <div align="center">
            <table width="980px" background="../images/background.png">
                <tr>
                    <td colspan="4">
                        <div class="psadtitle">
                            <br>
                            Work Forwarding<br><br>
                        </div>
                    </td>
                </tr>
            </table>
            <table width="980px" background="../images/background.png">
                <tr>
                    <td>                       
                        <table width="99%" border="1">
                            <tr>
                                <td colspan="2" width="49%"><b>From</b></td>
                                <td colspan="2" width="49.5%"><b>To</b></td>
                            </tr>
                            <tr>
                                <td align="right" width="15%"><b>User :</b></td>
                                <%
                                    if (chkAdmin == true) {%>
                                <td align="left"><input type="text" class="psadview" id="txtusername" name="txtusername" value="<%=username%>" size="20" readonly="readonly"/>&nbsp;<img src="../images/user-icon.png" onclick="fnSelectUser(true)"></td>
                                    <%
                                    } else {%>
                                <td align="left"><input type="text" class="psadview" id="txtusername" name="txtusername" value="<%=username%>" size="20" readonly="readonly"/></td>
                                    <%
                                        }
                                    %>
                                <td align="right"><b>User :</b></td>
                                <td align="left"><input type="text" class="psadview" name="txtfwusername" id="txtfwusername" value="<%=fwusername%>" size="20" readonly="readonly"/>&nbsp;&nbsp;<img src="../images/user-icon.png" onclick="fnSelectUser(false)"></td>
                            </tr>
                            <tr>
                                <td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                <td align="right"><b>Organization Unit :</b></td>
                                <td align="left"><input type="text" class="psadview" name="txtfwou" id="txtfwou" value="<%=fwouname%>" size="20" readonly="readonly"/></td>
                            </tr>
                        </table>

                    </td>
                </tr>

            </table>                 
            <table  width="980px" background="../images/background.png">
                <tr>
                    <td valign="bottom" align="left" colspan="2">
                        <div class="psadheader" >
                            <b>&nbsp;&nbsp;</b>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td valign="bottom" align="left" colspan="2">
                        <div class="psadheader" >
                            <b>&nbsp;&nbsp;</b>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td valign="top" colspan="2">
                        <fieldset>
                            <legend>
                                &nbsp;&nbsp;Select Process
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
                                            <th><h3>Process ID</h3></th>
                                            <th><h3>Process Name</h3></th>
                                            <th><h3>Process Initiator</h3></th>
                                            <th><h3>Activity Name</h3></th>
                                            <th><h3>Activity Start Date</h3></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                            for (int i = 0; i < workList.size(); i++) {
                                                WorkActivity workActivity = (WorkActivity) workList.get(i);
                                        %>

                                        <tr style="cursor:pointer" onclick="fnOnSelect(this)">
                                            <td><%="P" + ResourceUtil.getVersionFormat(workActivity.getProcessId())%></td>
                                            <td><%=workActivity.getProcessName()%></td>
                                            <td><%=workActivity.getProcessInitiator()%></td>
                                            <td><%=workActivity.getActivityName()%></td>
                                            <td><%=workActivity.getActivityStartDate()%></td>
                                        </tr>
                                        <%}%>
                                        <%
                                            for (int m = 0; m < absenceList.size(); m++) {
                                                WorkActivity workActivity = (WorkActivity) absenceList.get(m);
                                        %>

                                        <tr style="cursor:pointer" onclick="fnOnSelect(this)">
                                            <td><%="P" + ResourceUtil.getVersionFormat(workActivity.getProcessId())%></td>
                                            <td><%=workActivity.getProcessName()%></td>
                                            <td><%=workActivity.getProcessInitiator()%></td>
                                            <td><%=workActivity.getActivityName()%></td>
                                            <td><%=workActivity.getActivityStartDate()%></td>
                                        </tr>
                                        <%}%>
                                        <!--                                        <
                                                                                    for (int f = 0; f < forwardList.size(); f++) {
                                                                                        WorkActivity workActivity = (WorkActivity) forwardList.get(f);
                                                                                %>-->
                                        <!--                                        <tr style="cursor:pointer" onclick="fnOnSelect(this)">
                                                                                    <td><="P" + ResourceUtil.getVersionFormat(workActivity.getProcessId())%></td>
                                                                                    <td><=workActivity.getProcessName()%></td>
                                                                                    <td><=workActivity.getProcessInitiator()%></td>
                                                                                    <td><=workActivity.getActivityName()%></td>
                                                                                    <td><=workActivity.getActivityStartDate()%></td>
                                                                                </tr>-->
                                        <!--                                        <
                                                                                    }
                                                                                %>-->
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
            <table width="980px" background="../images/background.png">
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td align="left" colspan="2"><div style="margin-left:5px"><input type="button" width="100" class="psadbutton" value="Forward" name="btnOK" onclick="fnForward()"/></div></td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="2">&nbsp;</td>
                </tr>
            </table>

        </div>
        <input type="hidden" name="hidparentid" id="hidparentid" value="<%=fwouid%>"></input>
        <input type="hidden" name="hidchildid" id="hidchildid" value="<%=fwuserid%>"></input>
        <input type="hidden" name="hidpid" id="hidpid" value=""></input>
        <input type="hidden" name="msg" id="msg" value="<%=msg%>"></input>
        <input type="hidden" name="hidfromuserid" id="hidfromuserid" value="<%=curuserid%>"></input>
        <input type="hidden" name="hidfromuserouid" id="hidfromuserouid" value="<%=fromuserouid%>"></input>
        <input type="hidden" name="hidcurrentuserid" id="hidcurrentuserid" value="<%=currentuserId%>"></input>

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

