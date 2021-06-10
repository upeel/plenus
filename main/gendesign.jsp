<%-- 
    Document   : gendesign
    Created on : Nov 15, 2013, 2:48:46 PM
    Author     : SOE HTIKE
--%>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.gen.controller.*"
         import = "org.apache.commons.lang.StringEscapeUtils"
         import = "com.bizmann.gen.entity.*"
         import = "com.bizmann.product.resources.*"
         %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<!DOCTYPE html>
<%
    String strgenId = request.getParameter("genId");
    if (strgenId == null || strgenId.equals("")) {
        strgenId = "0";
    }
    int genId = Integer.parseInt(strgenId);

    GenController gCtrl = new GenController();
    ArrayList<PrefixType> gTypeList = gCtrl.getPrefixTypes();
    String typeOption = "";
    StringBuffer sbf = new StringBuffer();
    for (int i = 0; i < gTypeList.size(); i++) {
        PrefixType tmpPrefixes = gTypeList.get(i);
        int tmpPreId = tmpPrefixes.getId();
        String tmpPreName = tmpPrefixes.getName();
        sbf.append("{ Value: '" + tmpPreId + "', DisplayText: '" + StringEscapeUtils.escapeJavaScript(tmpPreName) + "' }, ");
    }
    typeOption = sbf.toString();
    if (typeOption.equals("")) {
    } else {
        typeOption = typeOption.substring(0, typeOption.length() - 2);
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../include/jquery-ui-1.10.3.custom/js/jquery-1.9.1.js"></script>
        <script src="../include/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"></script>
        <script src="../include/js/main.js"></script>
        <!--        <script type="text/javascript" src="include/js/genheader.js"></script>-->
        <script src="../include/jtable/jquery.jtable.min.js" type="text/javascript"></script>
        <link href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet"></link>
<!--        <link href="../include/jquery-ui-1.10.3.custom/css/redmond/jquery-ui-1.10.3.custom.css" rel="stylesheet"></link>-->
        <link href="../include/jtable/themes/metro/lightgray/jtable.min.css" rel="stylesheet" type="text/css" />
        <title>Auto Gen No Details</title>
        <script type="text/javascript">
            $(document).ready(function () {
                var vgenId = <%=genId%>;
                $('#FlowTableContainer').jtable({
                    title: 'Prefix List',
                    actions: {
                        listAction: 'gendesignActions.jsp?action=list&genId='+vgenId,
                        createAction: 'gendesignActions.jsp?action=create&genId='+vgenId,
                        updateAction: 'gendesignActions.jsp?action=update&genId='+vgenId,
                        deleteAction: 'gendesignActions.jsp?action=delete&genId='+vgenId
                    },
                    fields: {
                        DetailId: {
                            key: true,
                            create: false,
                            edit: false,
                            list: false
                        },
                        DetailType: {
                            title: 'Type',
                            width: '40%',
                            edit: true,
                            options: [ <%=typeOption%> ]
                        },
                        DetailValue: {
                            title: 'Value',
                            width: '40%',
                            edit: true
                        }
                    }
                });
                $('#FlowTableContainer').jtable('load');
            });
            
            $("#btnFlowContinue").click(function() {
                var vtxtflowchartname = document.getElementById("cbStartAction");
                var vflowchartname = vtxtflowchartname.value;
                if(vflowchartname == null || $.trim(vflowchartname) == "0"){
                    alert("Please provide choose a start action.");
                }else{
                    $( "#btnFlowContinue" ).button({ disabled: true });
                    $( "#frmSubmit" ).submit();
                }
            });
        </script>
    </head>
    <body><div id="dvLoading"></div>
        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr><td>
                        <div style="width:50%; display: block; margin-left: auto; margin-right: auto;">
                            <% if (genId != 0) {%>
                            <h3>You do not need to create the prefix in order here.</h3>
                            <div id="FlowTableContainer"></div>
                            <input style="float: right;" type="button" value="Finalize & Confirm" onclick="document.location.href='gendesignprocess.jsp?genId=<%=genId%>&type=Design&subtype=autogen';"/>
                            <% } else {%>
                            <p>Invalid Access! Access Denied!</p>
                            <% }%>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>
