<%-- 
    Document   : consolidatedwork
    Created on : Mar 7, 2014, 10:09:14 AM
    Author     : SOE HTIKE
--%>

<%@ page import = "com.bizmann.product.entity.OrgUnit"
         import = "com.bizmann.product.entity.UserOUDesignation"
         import = "com.bizmann.product.controller.OrgUnitController"
         import = "com.bizmann.product.controller.OrgChartController"
         import = "com.bizmann.product.controller.UserOUDesignationController"
         import = "com.bizmann.product.controller.UserController"
         import = "com.bizmann.product.resources.*"
         import = "com.bizmann.flowchart.entity.ConsolidatedWork"
         import = "com.bizmann.flowchart.controller.ConsolidationController"
         import = "java.util.ArrayList"
         import = "java.lang.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>

<%
    String refreshMain = "";
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

    String comboProcess = request.getParameter("comboProcess");
    if (comboProcess == null || comboProcess.equals("")) {
        comboProcess = "0";
    }
    int comboProcessSelected = Integer.parseInt(comboProcess);


    String comboAction = request.getParameter("comboAction");
    if (comboAction == null || comboAction.equals("")) {
        comboAction = "0";
    }
    int comboActionSelected = Integer.parseInt(comboAction);

    ConsolidationController conCtrl = new ConsolidationController();

    if (todoaction.equalsIgnoreCase("responsemade")) {
        String cbResponse = request.getParameter("cbResponse");
        if (cbResponse == null || cbResponse.equals("")) {
            cbResponse = "0";
        }
        int response_id = Integer.parseInt(cbResponse);

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
        conCtrl.doBulkRouting(comboProcessSelected, comboActionSelected, userId, response_id, processes);
    }

    ArrayList<ConsolidatedWork> outstandingList = new ArrayList<ConsolidatedWork>();
    //System.out.println("1" + System.currentTimeMillis() / 1000L);
    ArrayList<com.bizmann.product.entity.Process> processList = conCtrl.getOutstandingProcessList(userId);
    //System.out.println("2" + System.currentTimeMillis() / 1000L);
    ArrayList<Action> actList = new ArrayList<Action>();
    //System.out.println("3" + System.currentTimeMillis() / 1000L);

    if (comboProcessSelected != 0) {
        //System.out.println("4" + System.currentTimeMillis() / 1000L);
        actList = conCtrl.getOutstandingActionList(userId, comboProcessSelected);
        //System.out.println("5" + System.currentTimeMillis() / 1000L);
    }

    ArrayList fhResponseList = new ArrayList();
    if (comboActionSelected != 0) {
        EngineResponseController fhEngineResponseCtrl = new EngineResponseController();
        //System.out.println("6" + System.currentTimeMillis() / 1000L);
        fhResponseList = fhEngineResponseCtrl.getResponses(comboActionSelected);
        //System.out.println("7" + System.currentTimeMillis() / 1000L);
        outstandingList = conCtrl.getOustandingWorkList(userId, comboProcessSelected, comboActionSelected);
        //System.out.println("8" + System.currentTimeMillis() / 1000L);
    }
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
        <script>
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
            }
            
            function fnopenworkform(cell){
                //var row = document.getElementById('worktable').rows[row.rowIndex];
                var processid = cell.innerHTML;
                processid = processid.trim();
                fnOpenWindow('printpage.jsp?processId='+ processid);
            }
            
            function comboProcessChanged(){
                document.getElementById("comboAction").selectedIndex = -1;
                document.consolidatedWorkFrm.submit();
            }
            
            function comboActionChanged(){
                document.consolidatedWorkFrm.submit();
            }
            
            
            checked=false;
            function checkAll(){            
                if (checked == false) {
                    checked = true
                }
                else{
                    checked = false
                }
                for(var vi=0;vi<<%=outstandingList.size()%>;vi++){
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
                
            function responseMade(){
                if(fnCheckForChk()==true){
                    document.getElementById("todoaction").value = "responsemade";
                    document.consolidatedWorkFrm.submit();
                }else{
                    alert("Please check at least one process to act on.");
                }
            }
            
            $(document).ready(function(){
                //                $('#excelUpload').show();
                $('#dvLoading').hide();
                $('#overlay').hide();
                //                $('#excelDesign').hide();
                //$('.sigPad').signaturePad({drawOnly : true, validateFields: false});
                $(window).bind('beforeunload', function(e) {
                    $('#dvLoading').show();
                    $('#overlay').show();
                });
            });
            
            //$("#mainSubBtn").on("click", function(event) {
            //event.preventDefault ? event.preventDefault() : event.returnValue = false;
            //$("#mainSubBtn").attr("disabled", "disabled");
            //responseMade();
            //});
        </script>
    </head>
    <body>
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <div align="center">
            <form id="consolidatedWorkFrm" name="consolidatedWorkFrm" action="consolidatedwork.jsp" method="POST">
                <table border="0" width="980px" height="420px" background="../images/background.png">
                    <tr>
                        <td width="900px" valign="top">
                            <br/>
                            <input type="hidden" id="type" name="type" value="<%=type%>" />
                            <input type="hidden" id="subtype" name="subtype" value="<%=subtype%>" />
                            <input type="hidden" id="todoaction" name="todoaction" value="" />
                            <div align="right" width="500px">
                                <!--                                        <b>Please select a Process: </b>-->
                                <select id="comboProcess" name="comboProcess" style="width: 200px" onchange="comboProcessChanged()">
                                    <option value="0">-- Please select a Process --</option>
                                    <%
                                        for (int a = 0; a < processList.size(); a++) {
                                            com.bizmann.product.entity.Process proc = processList.get(a);
                                            int procId = proc.getId();
                                            String procName = proc.getName();
                                            String isProcSelected = "";
                                            if (comboProcessSelected == procId) {
                                                isProcSelected = "selected";
                                            }
                                    %>
                                    <option value="<%=procId%>" <%=isProcSelected%>><%=procName%></option>
                                    <% }%>
                                </select>
                            </div>
                            <br/>
                            <div align="right" width="500px">
                                <!--                                        <b>Please select a Process: </b>-->
                                <select id="comboAction" name="comboAction" style="width: 200px" onchange="comboActionChanged()">
                                    <option value="0">-- Please select an Action --</option>
                                    <%
                                        for (int a = 0; a < actList.size(); a++) {
                                            Action act = actList.get(a);
                                            int actId = act.getId();
                                            String actName = act.getName();
                                            String isActSelected = "";
                                            if (comboActionSelected == actId) {
                                                isActSelected = "selected";
                                            }
                                    %>
                                    <option value="<%=actId%>" <%=isActSelected%>><%=actName%></option>
                                    <% }%>
                                </select>
                            </div>
                            <br/>

                            <%if (comboActionSelected != 0) {%>
                            <table bgcolor="E4EFF3">
                                <tr>
                                    <td>
                                        <select size="1" id="cbResponse" name="cbResponse" style="font:12px arial,helvetica,clean,sans-serif">
                                            <%
                                                for (int i = 0; i < fhResponseList.size(); i++) {
                                                    Response res = (Response) fhResponseList.get(i);
                                                    int responseId = res.getId();
                                                    String responseName = res.getName();
                                            %>
                                            <option value="<%=responseId%>"><%=responseName%></option>

                                            <%}%>
                                        </select>
                                    </td>
                                    <td>
                                        <input type="image" name="mainSubBtn" id="mainSubBtn" src="images/submit.gif" style="cursor:pointer" onclick="responseMade()"/>
                                    </td>
                                </tr>
                            </table>

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
                                    <table class="tinytable" id="worktable" name="worktable" cellpadding="0" cellspacing="0" border="0"  style="table-layout:auto" width="80%" background="../images/background.png">
                                        <%if (outstandingList.size() <= 0) {%>
                                        <thead>
                                            <tr valign="top">
                                                <th class="nosort"><h3><input type="checkbox" id="chkall" name="chkall" value="" onClick="checkAll()"/></h3></th>
                                                <th width="100px"><h3>Process ID</h3></th>
                                                <th width="150px"><h3>Activity Start Date</h3></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td colspan="3">No Records Found!</td>
                                            </tr>
                                        </tbody>
                                        <%} else {
                                            for (int i = 0; i < outstandingList.size(); i++) {
                                                ConsolidatedWork conWork = outstandingList.get(i);
                                                ArrayList<ActionData> tmpDataList = conWork.getValueList();
                                                if (i == 0) {
                                        %>
                                        <thead>
                                            <tr valign="top">
                                                <th class="nosort"><h3><input type="checkbox" id="chkall" name="chkall" value="" onClick="checkAll()"/></h3></th>
                                                <th width="100px"><h3>Process ID</h3></th>
                                                <th width="150px"><h3>Activity Start Date</h3></th>
                                                <%
                                                    for (int a = 0; a < tmpDataList.size(); a++) {
                                                        ActionData tmpData = tmpDataList.get(a);
                                                        String headerCell = tmpData.getCellId();
                                                        String headerDesc = tmpData.getValue();
                                                %>
                                                <th><h3><%=headerDesc%> (<%=headerCell%>)</h3></th>
                                                <%
                                                    }
                                                %>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% } else {
                                            %>
                                            <tr>
                                                <td><input type="checkbox" id="chk-<%=i - 1%>" name="chkcells" value="<%=conWork.getProcess_id()%>"/></td>
                                                <td style="cursor:pointer" onclick="fnopenworkform(this)">
                                                    <%="P" + ResourceUtil.getVersionFormat(conWork.getProcess_id())%>
                                                </td>
                                                <td><%=conWork.getActivity_start_date()%></td>
                                                <%
                                                    for (int a = 0; a < tmpDataList.size(); a++) {
                                                        ActionData tmpData = tmpDataList.get(a);
                                                        String tmpCellId = tmpData.getCellId();
                                                        String tmpCellValue = tmpData.getValue();
                                                        if (tmpCellValue == null || tmpCellValue.equals("")) {
                                                            tmpCellValue = "&nbsp;";
                                                        }
                                                %>
                                                <td><%=tmpCellValue%></td>
                                                <%
                                                    }
                                                %>
                                            </tr>
                                            <%}
                                                }%>
                                        </tbody>
                                        <% }%>
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
                            <% }%>
                        </td>
                    </tr>
                </table>
            </form>
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
            <%=refreshMain%>
        </script>
    </body>
</html>
<%@ include file="../include/footer.jsp" %>
