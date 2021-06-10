<%--
    Document   : footer
    Created on : Feb 17, 2009, 12:17:43 PM
    Author     : Tan Chiu Ping
--%>
<%@page import = "com.bizmann.product.entity.User"
        import = "com.bizmann.product.entity.*"
        import = "com.bizmann.product.controller.*"
        import = "java.util.ArrayList"
        import = "java.lang.*" %>
<%
    String m_licensetype = request.getParameter("type");
    if (m_licensetype == null) {
        m_licensetype = "Dashboard";
    }

    String m_subtype = request.getParameter("subtype");
    if (m_subtype == null) {
        if (m_licensetype.equals("Organization")) {
            m_subtype = "orgunit";
        } else if (m_licensetype.equals("Design")) {
            m_subtype = "formdesigner";
        } else if (m_licensetype.equals("Process")) {
            m_subtype = "processreport";
        } else if (m_licensetype.equals("Dashboard")) {
            m_subtype = "work";
        }
    }
    User user = new User();
%>

<script type="text/javascript">
    function fnSubmit(url){
        document.location.href=url;
    }
</script>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <style>
            .menu{
                font-size:100%;
                color: whitesmoke;
                font-weight:bold;
                padding:5px;
                cursor:pointer;
            }
            .selectedmenu{
                font-size:100%;
                color:#ffffff;
                font-weight:bold;
                padding:5px;
                cursor:pointer;
                /*                background: url('../images/inputbg.png');*/
                background-color: darkgrey;
                border: solid 1px #33677F;
                text-shadow: 0px -1px 0px #374683;
            }
        </style>
    </head>
    <body>
        <div align="center">
            <%if (m_licensetype.equals("Organization")) {%>
            <table border="0" width="980px" height="25px" cellspacing="0" cellpadding="0" background="../images/menu-background.png">
                <tr>
                    <td width="150px">
                        <%if (m_subtype.equals("orgunit")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("orgunit.jsp?type=Organization&subtype=orgunit")'>Organization Unit</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("orgunit.jsp?type=Organization&subtype=orgunit")'>Organization Unit</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("user")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("user.jsp?type=Organization&subtype=user")'>User</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("user.jsp?type=Organization&subtype=user")'>User</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("designation")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("designation.jsp?type=Organization&subtype=designation")'>Job Designation</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("designation.jsp?type=Organization&subtype=designation")'>Job Designation</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("authgrpchart")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("authgrpchart.jsp?type=Organization&subtype=authgrpchart")'>Authority Group Chart</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("authgrpchart.jsp?type=Organization&subtype=authgrpchart")'>Authority Group Chart</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <div class="menu"></div>
                    </td>
                </tr>
            </table>
            <%}%>
            <%if (m_licensetype.equals("Design")) {%>
            <table border="0" width="980px" height="25px" style="table-layout:fixed" cellspacing="0" cellpadding="0" background="../images/menu-background.png">
                <tr>
                    <td width="100px">
                        <%if (m_subtype.equals("formdesigner")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("formadd.jsp?type=Design&subtype=formdesigner")'>Form Designer</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("formadd.jsp?type=Design&subtype=formdesigner")'>Form Designer</div>
                        <%}%>
                    </td>
                    <td width="100px">
                        <%if (m_subtype.equals("autogen")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("gen.jsp?type=Design&subtype=autogen")'>Gen #</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("gen.jsp?type=Design&subtype=autogen")'>Gen #</div>
                        <%}%>
                    </td>
                    <td width="110px">
                        <%if (m_subtype.equals("flowchartlibrary")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("flowchartlibrary.jsp?type=Design&subtype=flowchartlibrary")'>FlowChart Library</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("flowchartlibrary.jsp?type=Design&subtype=flowchartlibrary")'>FlowChart Library</div>
                        <%}%>
                    </td>
                    <td width="100px">
                        <%if (m_subtype.equals("flowchartpermission")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("flowchartpermission.jsp?type=Design&subtype=flowchartpermission")'>Permission</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("flowchartpermission.jsp?type=Design&subtype=flowchartpermission")'>Permission</div>
                        <%}%>
                    </td>
                    <td width="110px">
                        <%if (m_subtype.equals("consolidation")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("consolidationdesigner.jsp?type=Design&subtype=consolidation")'>Consolidated Work</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("consolidationdesigner.jsp?type=Design&subtype=consolidation")'>Consolidated Work</div>
                        <%}%>
                    </td>
                    <td width="100px">
                        <%if (m_subtype.equals("adminmod")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("adminmoddesigner.jsp?type=Design&subtype=adminmod")'>Admin Task</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("adminmoddesigner.jsp?type=Design&subtype=adminmod")'>Admin Task</div>
                        <%}%>
                    </td>
                    <!--                    <td width="150px">
                                            <if (m_subtype.equals("admintask")) {%>
                                            <div class="selectedmenu" onclick='fnSubmit("admintask.jsp?type=Design&subtype=admintask")'>Admin Task</div>
                                            <} else {%>
                                            <div class="menu" onclick='fnSubmit("admintask.jsp?type=Design&subtype=admintask")'>Admin Task</div>
                                            <}%>
                                        </td>               -->
                    <!--                    <td width="150px">
                                            <if (m_subtype.equals("externalreport")) {%>
                                            <div class="selectedmenu" onclick='fnSubmit("externalreport.jsp?type=Design&subtype=externalreport")'>External Report</div>
                                            <} else {%>
                                            <div class="menu" onclick='fnSubmit("externalreport.jsp?type=Design&subtype=externalreport")'>External Report</div>
                                            <}%>
                                        </td>-->
<!--                    <td width="150px">
                    </td>-->
                </tr>
                <tr>
                    <td width="100px">
                        <%if (m_subtype.equals("externalform")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("externalform.jsp?type=Design&subtype=externalform")'>External Form</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("externalform.jsp?type=Design&subtype=externalform")'>External Form</div>
                        <%}%>
                    </td>
                    <td width="100px">
                        <%if (m_subtype.equals("templates")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("templates.jsp?type=Design&subtype=templates")'>Templates</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("templates.jsp?type=Design&subtype=templates")'>Templates</div>
                        <%}%>
                    </td>
                    <td width="100px">
                        <%if (m_subtype.equals("externalreport")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("externalreport.jsp?type=Design&subtype=externalreport")'>External Report</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("externalreport.jsp?type=Design&subtype=externalreport")'>External Report</div>
                        <%}%>
                    </td>
                    <td width="100px">
                        <%if (m_subtype.equals("externaladmintask")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("externaladmintask.jsp?type=Design&subtype=externaladmintask")'>External AdminTask</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("externaladmintask.jsp?type=Design&subtype=externaladmintask")'>External AdminTask</div>
                        <%}%>
                    </td>
                    <td width="100px">
                        <%if (m_subtype.equals("subproc")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("subprocessdesigner.jsp?type=Design&subtype=subproc")'>Sub-Process</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("subprocessdesigner.jsp?type=Design&subtype=subproc")'>Sub-Process</div>
                        <%}%>
                    </td>
                    <td width="100px">
                        <%if (m_subtype.equals("flowchartperformance")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("processperformance.jsp?type=Design&subtype=flowchartperformance")'>Performance</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("processperformance.jsp?type=Design&subtype=flowchartperformance")'>Performance</div>
                        <%}%>
                    </td>
                </tr>
            </table>
            <%}%>

            <!--            <if (m_licensetype.equals("Process")) {%>
                        <table border="0" width="980px" height="25px" cellspacing="0" cellpadding="0" background="../images/menu-background.png">
                            <tr>
                                <td width="150px">
                                    <if (m_subtype.equals("processreport")) {%>
                                    <div class="selectedmenu" onclick='fnSubmit("processreport.jsp?type=Process&subtype=processreport")'>Process Report</div>
                                    <} else {%>
                                    <div class="menu" onclick='fnSubmit("processreport.jsp?type=Process&subtype=processreport")'>Process Report</div>
                                    <}%>
                                </td>
                                <td width="150px">
                                    <if (m_subtype.equals("processsearch")) {%>
                                    <div class="selectedmenu" onclick='fnSubmit("processsearch.jsp?type=Process&subtype=processsearch")'>Process Search</div>
                                    <} else {%>
                                    <div class="menu" onclick='fnSubmit("processsearch.jsp?type=Process&subtype=processsearch")'>Process Search</div>
                                    <}%>
                                </td>
                                <td width="150px">
                                    <if (m_subtype.equals("processmonitor")) {%>
                                    <div class="selectedmenu" onclick='fnSubmit("processmonitor.jsp?type=Process&subtype=processmonitor&viewby=all")'>Process Audit</div>
                                    <} else {%>
                                    <div class="menu" onclick='fnSubmit("processmonitor.jsp?type=Process&subtype=processmonitor&viewby=all")'>Process Audit</div>
                                    <}%>
                                </td>
                                <td width="150px">
                                    <div class="menu"></div>
                                </td>
                                <td width="150px">
                                    <div class="menu"></div>
                                </td>
                            </tr>
                        </table>
                        <}%>-->

            <%if (m_licensetype.equals("System")) {%>
            <table border="0" width="980px" height="25px" cellspacing="0" cellpadding="0" background="../images/menu-background.png">
                <tr>
                    <td width="150px">
                        <%if (m_subtype.equals("systemaudit")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("systemaudit.jsp?type=System&subtype=systemaudit")'>System Audit</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("systemaudit.jsp?type=System&subtype=systemaudit")'>System Audit</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("configconsole")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("configconsole.jsp?type=System&subtype=configconsole")'>Config. Console</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("configconsole.jsp?type=System&subtype=configconsole")'>Config. Console</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("licenseviewer")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("licenseviewer.jsp?type=System&subtype=licenseviewer")'>License Viewer</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("licenseviewer.jsp?type=System&subtype=licenseviewer")'>License Viewer</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("authgrp")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("authgrp.jsp?type=System&subtype=authgrp")'>Authority Group</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("authgrp.jsp?type=System&subtype=authgrp")'>Authority Group</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <div class="menu"></div>
                    </td>
                </tr>
            </table>
            <%}%>

            <%if (m_licensetype.equals("Dashboard")) {%>
            <table border="0" width="980px" height="25px" cellspacing="0" cellpadding="0" background="../images/menu-background.png">
                <tr>
                    <td width="150px">
                        <%if (m_subtype.equals("work")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("work.jsp?type=Dashboard&subtype=work")'>My Work</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("work.jsp?type=Dashboard&subtype=work")'>My Work</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("consolidatedwork")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("consolidatedwork.jsp?type=Dashboard&subtype=consolidatedwork")'>Consolidated Work</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("consolidatedwork.jsp?type=Dashboard&subtype=consolidatedwork")'>Consolidated Work</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("monitor")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("monitor.jsp?type=Dashboard&subtype=monitor&viewby=all")'>My Monitor</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("monitor.jsp?type=Dashboard&subtype=monitor&viewby=all")'>My Monitor</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("userprofile")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("userprofile.jsp?type=Dashboard&subtype=userprofile")'>User Profile</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("userprofile.jsp?type=Dashboard&subtype=userprofile")'>User Profile</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("setabsence")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("setabsence.jsp?type=Dashboard&subtype=setabsence")'>Set Absence</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("setabsence.jsp?type=Dashboard&subtype=setabsence")'>Set Absence</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("workforward")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("workforward.jsp?type=Dashboard&subtype=workforward")'>Work Forwarding</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("workforward.jsp?type=Dashboard&subtype=workforward")'>Work Forwarding</div>
                        <%}%>
                    </td>
                    <td width="150px">
                        <%if (m_subtype.equals("audittrail")) {%>
                        <div class="selectedmenu" onclick='fnSubmit("audittrail.jsp?type=Dashboard&subtype=audittrail")'>Audit Trail</div>
                        <%} else {%>
                        <div class="menu" onclick='fnSubmit("audittrail.jsp?type=Dashboard&subtype=audittrail")'>Audit Trail</div>
                        <%}%>
                    </td>
                    <!--                    
                    
                                        <td width="150px">
                                            <if (m_subtype.equals("workforward")) {%>
                                            <div class="selectedmenu" onclick='fnSubmit("workforward.jsp?type=Dashboard&subtype=workforward")'>Work Forwarding</div>
                                            <} else {%>
                                            <div class="menu" onclick='fnSubmit("workforward.jsp?type=Dashboard&subtype=workforward")'>Work Forwarding</div>
                                            <}%>
                                        </td>-->
                    <td width="150px">
                        <div class="menu"></div>
                    </td>
                </tr>
            </table>
            <%}%>
        </div>

        <input type="hidden" id="type" name="type" value="<%=m_licensetype%>"></input>
        <input type="hidden" id="subtype" name="subtype" value="<%=m_subtype%>"></input>
    </body>
</html>
