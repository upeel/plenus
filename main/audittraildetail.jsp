<%-- 
    Document   : audittraildetail
    Created on : Apr 11, 2014, 2:56:08 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="com.bizmann.product.controller.*"
        import="com.bizmann.product.resources.*"
        import="com.bizmann.product.entity.*"
        import="java.lang.*"
        import="java.util.*"
        import="java.text.SimpleDateFormat"
        %>
<%
    String pid = request.getParameter("pid");
    if (pid.equals("") || pid == null) {
        pid = "";
    } else {
        pid = ResourceUtil.trimPaddedId(pid);
    }

    ActivityController activityCtrl = new ActivityController();
    ActionController acCtrl = new ActionController();
    ProcessController processCtrl = new ProcessController();
    ResponseController resCtrl = new ResponseController();
    
    ArrayList aList = activityCtrl.getAllActivityByProcessId(Integer.parseInt(pid));
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
        <title>Flo'</title>

        <style>
            table, input, option, textarea {
                font-family: arial;
                font-size: 12px;
                font-style: normal;
                line-height: normal;
                font-variant: normal;
                color: #000000;
                text-align: left;
            }

            .mainPanel{
                height:420px;
                width:980px;
                vertical-align:top;
                text-align:center;
                background-image:url('images/background.png');
            }

        </style>
    </head>

    <body class="yui-skin-sam">
        <div align="center" class ="mainPanel">
            <table>

                <tr>
                    <td colspan="2">
                        <div class="psadtitle">
                            <br>
                            Process Details<br><br>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Process Name:</td>
                    <%
                        //int formid = processCtrl.getFormIDByprocessID(Integer.parseInt(pid));
                        String processname = processCtrl.getFlowchardNameById(Integer.parseInt(pid));
                    %>
                    <td><%=processname%></td>
                </tr>
                <tr>
                    <td>Next Participant:</td>

                    <%
                        UserController uCtrl = new UserController();
                        //String participant = uCtrl.getUserNameById(activityCtrl.getLatestActivityUserByProcessId(Integer.parseInt(pid)));
                        String participant = activityCtrl.getLatestActivityUser(Integer.parseInt(pid));
                        if (participant == null || participant.equals("") || participant.equals("Not Assigned Yet")) {
                            participant = "N/A";
                        }
                    %>
                    <td><b><%=participant%></b></td>
                </tr>
                <%
                    String proStatus = "";
                    String proElapsedTime = "";
                    boolean processIsComplete = processCtrl.isCompletedProcess(Integer.parseInt(pid));
                    if (processIsComplete) {
                        proStatus = "Complete";
                        proElapsedTime = processCtrl.getProcessElapsedTime(Integer.parseInt(pid));
                    } else {
                        proStatus = "Ongoing";
                    }
                %>
                <tr>
                    <td>Process Status:</td>
                    <td><%=proStatus%></td>
                </tr>
                <% if (proElapsedTime.equals("") == false) {
                        out.print("<tr>"
                                + "<td>Process Cycle Time:</td>"
                                + "<td>" + proElapsedTime + "</td></tr>");
                    }
                %>
                <tr>
                    <td><br><br></td>
                </tr>
                <table border="1" width="80%"  cellpadding="3" style="border-collapse:collapse">
                    <tr align="left">
                        <td><b>Participant</b></td>
                        <td><b>Action</b></td>
                        <td><b>Response</b></td>
                        <td><b>Date/Time</b></td>
                        <td><b>Elapsed Time </b></td>
                    </tr>

                    <%
                        //System.out.println("aList size: " + aList.size());
                        for (int i = 0; i < aList.size(); i++) {
                            Activity activity = (Activity) aList.get(i);
                            String actionname = acCtrl.getActionNameById(activity.getActionId());
                            String responsename = resCtrl.getResponseNameById(activity.getResponseId());
                            String elapsed = activity.getElapsedtime();
                            if (actionname.equals("Submit")) {
                                elapsed = "";
                            }
                            if (actionname.equals("null")) {
                                actionname = "";
                            }
                    %>
                    <tr align="left">
                        <td width="18%"><%=uCtrl.getUserNameById(activity.getFrom())%></td>
                        <td width="17%"><%=actionname%></td>
                        <td width="14%"><%=responsename%></td>
                        <td width="15%"><%=activity.getCompletedDate()%></td>
                        <td width="16%"><%=elapsed%></td>
                    </tr>
                    <%}%>
                </table>
            </table>
        </div>
    </body>
</html>
