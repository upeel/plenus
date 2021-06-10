<%--
    Document   : tmenu
    Created on : Feb 17, 2009, 12:17:43 PM
    Author     : Tan Chiu Ping
--%>

<%@page import="com.bizmann.poi.resource.PropProcessor"%>

<%
    String authenticationMethod = PropProcessor.getPropertyValue("auth.method");
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/button.css" />
        <script src="../include/js/jquery-1.10.2.js"></script>
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <style>
            .tmenu{
                border-bottom:1px solid #cbcbcb;
                border-left:0px;
                border-right:0px;
                border-top:0px;
                width:100%;
            }
        </style>

        <script>

            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>";

            function hideDivs() {
                document.getElementById('dvLoading').style.visibility = 'hidden';
                document.getElementById('overlay').style.visibility = 'hidden';
                //                $('#dvLoading').hide();
                //                $('#overlay').hide();
            }

            function showDivs() {
                document.getElementById('dvLoading').style.visibility = 'visible';
                document.getElementById('overlay').style.visibility = 'visible';
                //                $('#dvLoading').show();
                //                $('#overlay').show();
            }

            function fnSync() {
                alert("Please wait while synchronizing LDAP Users! Do not click multiple time!");
                showDivs();
                $.ajax({
                    url: "doUserSyncServlet",
                    cache: false,
                    success: function (result) {
                        hideDivs();
                        alert("LDAP Users Synchronization Completed! The Page will reload.");
                        document.location.reload();
                    },
                    error: function (result) {
                        hideDivs();
                        alert("ERROR!! LDAP Users Synchronization FAILED! Please Kindly Contact the Site Admin.");
                        document.location.reload();
                    }
                });
            }

            function fnAdd() {
                if (type == "Design") {
                    if (document.getElementById("subtype").value == "flowchartlibrary") {
                        //flowChartId = parent.frames.document.getElementById("hidFlowChartId").value;
                        //+"&flowChartId="+flowChartId
                        $('#iflowchartlibrary').attr('src', "flowchartlibraryadd.jsp?type=" + type + "&subtype=" + subtype);
                        //parent.frames["iflowchartlibrary"].location.href="flowchartlibraryadd.jsp?type="+type+"&subtype="+subtype;
                        //parent.document.frames("iflowchartlibrary").location.href="flowchartlibraryadd.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                    } else if (document.getElementById("subtype").value == "flowchartdesigner") {
                        //Do nothing
                    } else if (document.getElementById("subtype").value == "flowchartpermission") {
                        iniProId = parent.frames.document.getElementById("hidIniProId").value;
                        $('#inipro').attr('src', "initiateprocessadd.jsp?type=" + type + "&subtype=" + subtype + "&iniProId=" + iniProId);
                        //parent.frames["inipro"].location.href="initiateprocessadd.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId;
                        //parent.document.frames("inipro").location.href="initiateprocessadd.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId;
                    } else if (document.getElementById("subtype").value == "externalreport") {
                        externalReportId = parent.frames.document.getElementById("hidExternalReportId").value;
                        $('#iexternalreport').attr('src', "externalreportadd.jsp?type=" + type + "&subtype=" + subtype + "&externalReportId=" + externalReportId);
                        //parent.frames["iexternalreport"].location.href="externalreportadd.jsp?type="+type+"&subtype="+subtype+"&externalReportId="+externalReportId;
                        //parent.document.frames("iexternalreport").location.href="externalreportadd.jsp?type="+type+"&subtype="+subtype+"&externalReportId="+externalReportId;
                    } else if (document.getElementById("subtype").value == "adminmod") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        $('#iuser').attr('src', "adminmodadd.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId);
                        //parent.frames["iadmintask"].location.href="admintaskadd.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        //parent.document.frames("iadmintask").location.href="admintaskadd.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                    } else if (document.getElementById("subtype").value == "externaladmintask") {
                        //parentId = parent.frames.document.getElementById("hidParentId").value;
                        $('#iadmintask').attr('src', "externaladmintaskadd.jsp?type=" + type + "&subtype=" + subtype);
                        //parent.frames["iadmintask"].location.href="admintaskadd.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        //parent.document.frames("iadmintask").location.href="admintaskadd.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                    } else if (document.getElementById("subtype").value == "subproc") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        $('#iuser').attr('src', "subprocessadd.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId);
                        //parent.frames["iadmintask"].location.href="admintaskadd.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        //parent.document.frames("iadmintask").location.href="admintaskadd.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                    } else if (document.getElementById("subtype").value == "consolidation") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        childId = parent.frames.document.getElementById("hidChildId").value;
                        if (parentId == "" || childId == "" || parentId == null || childId == "") {
                            parentId = "0";
                            childId = "0";
                        }
                        $('#iuser').attr('src', "consolidationadd.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId + "&childId=" + childId);
                        //parent.frames["iuser"].location.href="consolidationadd.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                } else if (type == "Organization") {
                    if (document.getElementById("subtype").value == "designation") {
                        designationId = parent.frames.document.getElementById("hidDesId").value;
                        $('#idesignation').attr('src', "designationadd.jsp?type=" + type + "&subtype=" + subtype + "&designationId=" + designationId);
                        //parent.frames["idesignation"].location.href="designationadd.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId;
                        //parent.document.frames("idesignation").location.href="designationadd.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId;
                    } else if (document.getElementById("subtype").value == "orgunit") {
                        orgunitId = parent.frames.document.getElementById("hidOrgUnitId").value;
                        //to capture first time coming in with no click on the form yet.
                        if (orgunitId == "" || orgunitId == null) {
                            orgunitId = "0";
                        }
                        $('#iorgunit').attr('src', "orgunitadd.jsp?type=" + type + "&subtype=" + subtype + "&orgunitId=" + orgunitId);
                        //parent.frames['iorgunit'].location.href="orgunitadd.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId;
                        //parent.document.frames("iorgunit").location.href="orgunitadd.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId;
                    } else if (document.getElementById("subtype").value == "user") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        childId = parent.frames.document.getElementById("hidChildId").value;
                        if (parentId == "" || childId == "" || parentId == null || childId == "") {
                            parentId = "0";
                            childId = "0";
                        }
                        $('#iuser').attr('src', "useradd.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId + "&childId=" + childId);
                        //parent.frames["iuser"].location.href="useradd.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //parent.document.frames("iuser").location.href="useradd.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                }
            }

            function fnModify() {
                if (type == "Design") {
                    if (document.getElementById("subtype").value == "flowchartlibrary") {
                        flowChartId = parent.frames.document.getElementById("hidFlowChartId").value;
                        $('#iflowchartlibrary').attr('src', "flowchartlibrarymodify.jsp?type=" + type + "&subtype=" + subtype + "&flowChartId=" + flowChartId);
                        //parent.frames["iflowchartlibrary"].location.href="flowchartlibrarymodify.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                        //parent.document.frames("iflowchartlibrary").location.href="flowchartlibrarymodify.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                    } else if (document.getElementById("subtype").value == "flowchartdesigner") {
                        //Do nothing
                    } else if (document.getElementById("subtype").value == "flowchartpermission") {
                        iniProId = parent.frames.document.getElementById("hidIniProId").value;
                        $('#inipro').attr('src', "initiateprocessmodify.jsp?type=" + type + "&subtype=" + subtype + "&iniProId=" + iniProId);
                        //parent.frames["inipro"].location.href="initiateprocessmodify.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId;
                        //parent.document.frames("inipro").location.href="initiateprocessmodify.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId;
                    } else if (document.getElementById("subtype").value == "externalreport") {
                        externalReportId = parent.frames.document.getElementById("hidExternalReportId").value;
                        if (externalReportId != "") {
                            $('#iexternalreport').attr('src', "externalreportmodify.jsp?type=" + type + "&subtype=" + subtype + "&externalReportId=" + externalReportId);
                            //parent.frames["iexternalreport"].location.href="externalreportmodify.jsp?type="+type+"&subtype="+subtype+"&externalReportId="+externalReportId;
                            //parent.document.frames("iexternalreport").location.href="externalreportmodify.jsp?type="+type+"&subtype="+subtype+"&externalReportId="+externalReportId;
                        }
                    } else if (document.getElementById("subtype").value == "adminmod") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        if (parentId != "") {
                            $('#iuser').attr('src', "adminmodmodify.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId);
                            //parent.frames["iadmintask"].location.href="admintaskmodify.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                            //parent.document.frames("iadmintask").location.href="admintaskmodify.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        }
                    } else if (document.getElementById("subtype").value == "externaladmintask") {
                        adminTaskId = parent.frames.document.getElementById("hidAdminTaskId").value;
                        $('#iadmintask').attr('src', "externaladmintaskmodify.jsp?type=" + type + "&subtype=" + subtype + "&adminTaskId=" + adminTaskId);
                        //parent.frames["iadmintask"].location.href="admintaskadd.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        //parent.document.frames("iadmintask").location.href="admintaskadd.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                    } else if (document.getElementById("subtype").value == "subproc") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        if (parentId != "") {
                            $('#iuser').attr('src', "subprocessmodify.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId);
                            //parent.frames["iadmintask"].location.href="admintaskmodify.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                            //parent.document.frames("iadmintask").location.href="admintaskmodify.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        }
                    } else if (document.getElementById("subtype").value == "consolidation") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        childId = parent.frames.document.getElementById("hidChildId").value;
                        if (parentId == "" || childId == "" || parentId == null || childId == "") {
                            parentId = "0";
                            childId = "0";
                        }
                        $('#iuser').attr('src', "consolidationmodify.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId + "&childId=" + childId);
                        //parent.frames["iuser"].location.href="consolidationmodify.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                } else if (type == "Organization") {
                    if (document.getElementById("subtype").value == "designation") {
                        designationId = parent.frames.document.getElementById("hidDesId").value;
                        if (designationId == "" || designationId == null) {
                            designationId = "0";
                        }
                        $('#idesignation').attr('src', "designationmodify.jsp?type=" + type + "&subtype=" + subtype + "&designationId=" + designationId);
                        //parent.frames["idesignation"].location.href="designationmodify.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId;
                        //parent.document.frames("idesignation").location.href="designationmodify.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId;
                    } else if (document.getElementById("subtype").value == "orgunit") {
                        orgunitId = parent.frames.document.getElementById("hidOrgUnitId").value;
                        if (orgunitId == "" || orgunitId == null) {
                            orgunitId = "0";
                        }
                        $('#iorgunit').attr('src', "orgunitmodify.jsp?type=" + type + "&subtype=" + subtype + "&orgunitId=" + orgunitId);
                        //parent.frames['iorgunit'].location.href="orgunitmodify.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId;
                        //parent.document.frames("iorgunit").location.href="orgunitmodify.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId;
                    } else if (document.getElementById("subtype").value == "user") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        childId = parent.frames.document.getElementById("hidChildId").value;
                        if (parentId == "" || childId == "" || parentId == null || childId == "") {
                            parentId = "0";
                            childId = "0";
                        }
                        $('#iuser').attr('src', "usermodify.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId + "&childId=" + childId);
                        //parent.frames["iuser"].location.href="usermodify.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //parent.document.frames("iuser").location.href="usermodify.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                }
            }

            function fnDelete() {
                if (type == "Design") {
                    if (document.getElementById("subtype").value == "flowchartlibrary") {
                        flowChartId = parent.frames.document.getElementById("hidFlowChartId").value;
                        $('#iflowchartlibrary').attr('src', "flowchartlibrarydelete.jsp?type=" + type + "&subtype=" + subtype + "&flowChartId=" + flowChartId);
                        //parent.frames["iflowchartlibrary"].location.href="flowchartlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                        //parent.document.frames("iflowchartlibrary").location.href="flowchartlibrarydelete.jsp?type="+type+"&subtype="+subtype+"&flowChartId="+flowChartId;
                    } else if (document.getElementById("subtype").value == "flowchartdesigner") {
                        //Do nothing
                    } else if (document.getElementById("subtype").value == "flowchartpermission") {
                        iniProId = parent.frames.document.getElementById("hidIniProId").value;
                        $('#inipro').attr('src', "initiateprocessdelete.jsp?type=" + type + "&subtype=" + subtype + "&iniProId=" + iniProId);
                        //parent.frames["inipro"].location.href="initiateprocessdelete.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId;
                        //parent.document.frames("inipro").location.href="initiateprocessdelete.jsp?type="+type+"&subtype="+subtype+"&iniProId="+iniProId;
                    } else if (document.getElementById("subtype").value == "externalreport") {
                        externalReportId = parent.frames.document.getElementById("hidExternalReportId").value;
                        if (externalReportId != "") {
                            $('#iexternalreport').attr('src', "externalreportdelete.jsp?type=" + type + "&subtype=" + subtype + "&externalReportId=" + externalReportId);
                            //parent.frames["iexternalreport"].location.href="externalreportdelete.jsp?type="+type+"&subtype="+subtype+"&externalReportId="+externalReportId;
                            //parent.document.frames("iexternalreport").location.href="externalreportdelete.jsp?type="+type+"&subtype="+subtype+"&externalReportId="+externalReportId;
                        }
                    } else if (document.getElementById("subtype").value == "adminmod") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        if (parentId != "") {
                            $('#iuser').attr('src', "adminmoddelete.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId);
                            //parent.frames["iadmintask"].location.href="admintaskmodify.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                            //parent.document.frames("iadmintask").location.href="admintaskmodify.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        }
                    } else if (document.getElementById("subtype").value == "externaladmintask") {
                        adminTaskId = parent.frames.document.getElementById("hidAdminTaskId").value;
                        $('#iadmintask').attr('src', "externaladmintaskdelete.jsp?type=" + type + "&subtype=" + subtype + "&adminTaskId=" + adminTaskId);
                        //parent.frames["iadmintask"].location.href="admintaskadd.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        //parent.document.frames("iadmintask").location.href="admintaskadd.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                    } else if (document.getElementById("subtype").value == "subproc") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        if (parentId != "") {
                            $('#iuser').attr('src', "subprocessdelete.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId);
                            //parent.frames["iadmintask"].location.href="admintaskmodify.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                            //parent.document.frames("iadmintask").location.href="admintaskmodify.jsp?type="+type+"&subtype="+subtype+"&adminTaskId="+adminTaskId;
                        }
                    } else if (document.getElementById("subtype").value == "consolidation") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        childId = parent.frames.document.getElementById("hidChildId").value;
                        if (parentId == "" || childId == "" || parentId == null || childId == "") {
                            parentId = "0";
                            childId = "0";
                        }
                        $('#iuser').attr('src', "consolidationdelete.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId + "&childId=" + childId);
                        //parent.frames["iuser"].location.href="consolidationdelete.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                } else if (type == "Organization") {
                    if (document.getElementById("subtype").value == "designation") {
                        designationId = parent.frames.document.getElementById("hidDesId").value;
                        if (designationId == "" || designationId == null) {
                            designationId = "0";
                        }
                        $('#idesignation').attr('src', "designationdelete.jsp?type=" + type + "&subtype=" + subtype + "&designationId=" + designationId);
                        //parent.frames["idesignation"].location.href="designationdelete.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId;
                        //parent.document.frames("idesignation").location.href="designationdelete.jsp?type="+type+"&subtype="+subtype+"&designationId="+designationId;
                    } else if (document.getElementById("subtype").value == "orgunit") {
                        orgunitId = parent.frames.document.getElementById("hidOrgUnitId").value;

                        if (orgunitId == "" || orgunitId == null) {
                            orgunitId = "0";
                        }
                        $('#iorgunit').attr('src', "orgunitdelete.jsp?type=" + type + "&subtype=" + subtype + "&orgunitId=" + orgunitId);
                        //parent.frames['iorgunit'].location.href="orgunitdelete.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId;
                        //parent.document.frames("iorgunit").location.href="orgunitdelete.jsp?type="+type+"&subtype="+subtype+"&orgunitId="+orgunitId;
                    } else if (document.getElementById("subtype").value == "user") {
                        parentId = parent.frames.document.getElementById("hidParentId").value;
                        childId = parent.frames.document.getElementById("hidChildId").value;
                        if (parentId == "" || childId == "" || parentId == null || childId == "") {
                            parentId = "0";
                            childId = "0";
                        }
                        $('#iuser').attr('src', "userdelete.jsp?type=" + type + "&subtype=" + subtype + "&parentId=" + parentId + "&childId=" + childId);
                        //parent.frames["iuser"].location.href="userdelete.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                        //parent.document.frames("iuser").location.href="userdelete.jsp?type="+type+"&subtype="+subtype+"&parentId="+parentId+"&childId="+childId;
                    }
                }
            }

        </script>
    </head>
    <body onload="hideDivs()" onbeforeunload="showDivs();" >
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <div align="right">
            <table class="tmenu" id="tmenu" border="0" width="100%" height="28px" cellpadding="0" background="../images/background.png" style="border-collapse: collapse">
                <tr align="right" height="27px">
                    <%
                        if (authenticationMethod.equalsIgnoreCase("ldap"))
                        {
                    %>
                    <td style="text-align: left;">
                        <img border="0" style="width: 30px;" class="menubutton" src="../images/sync.png" alt="Sync User" onclick="fnSync()">
                    </td>
                    <%
                        }
                    %>
                    <td style="text-align: right;">
                        <img border="0" class="menubutton" src="../images/add.png" alt="Add" onclick="fnAdd()">
                        <img border="0" class="menubutton" src="../images/modify.png" alt="Modify" onclick="fnModify()">
                        <img border="0" class="menubutton" src="../images/delete.png" alt="Delete" onclick="fnDelete()">
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>