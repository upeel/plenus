<%-- 
    Document   : gendesignprocess
    Created on : Nov 18, 2013, 2:42:52 PM
    Author     : SOE HTIKE
--%>

<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.gen.controller.*"
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
    ArrayList<GenDetails> gDetailsList = gCtrl.getAllGenDetailsById(genId);

    GenHeader gHeader = gCtrl.getGenById(genId);
    String yesSelected = "";
    String noSelected = "";
    if (gHeader.isDo_reset()) {
        yesSelected = "checked";
    } else {
        noSelected = "checked";
    }

    String redirectLink = "";
    
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String strRdoReset = request.getParameter("rdoReset");
        if (strRdoReset == null) {
            strRdoReset = "false";
        }
        String strCbFactor = request.getParameter("cbFactor");
        if (strCbFactor == null) {
            strCbFactor = "0";
        }
        String strTxtResetStartNo = request.getParameter("txtResetStartNo");
        if (strTxtResetStartNo == null) {
            strTxtResetStartNo = "0";
        }

        String strnewOrder = request.getParameter("newOrder");
        if (strnewOrder == null) {
            strnewOrder = "";
        }

        String fIdList = "";
        StringBuffer fIdSbf = new StringBuffer();
        for (int a = 0; a < gDetailsList.size(); a++) {
            GenDetails tmpf = gDetailsList.get(a);
            int tmpfId = tmpf.getId();
            fIdSbf.append(tmpfId + ",");
        }
        fIdList = fIdSbf.toString();
        if (fIdList.equals("")) {
        } else {
            fIdList = fIdList.substring(0, fIdList.length() - 1);
        }

        String[] arr_new_position = strnewOrder.split(",");
        String[] arr_gen_details = fIdList.split(",");
        gCtrl.doReOrder(Boolean.parseBoolean(strRdoReset), Integer.parseInt(strCbFactor), Integer.parseInt(strTxtResetStartNo), genId, arr_new_position, arr_gen_details);
        
        redirectLink = "gendesignprocess.jsp?genId=" + genId + "&type=Design&subtype=autogen";
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!--        <link href="../include/jquery-ui-1.10.3.custom/css/redmond/jquery-ui-1.10.3.custom.css" rel="stylesheet">-->
        <link href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet"></link>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <!--        <link href="../include/css/formdesign.css" rel="stylesheet">-->
        <script type="text/javascript" src="../include/js/url.js"></script>        
        <script type="text/javascript"src="../include/jquery-ui-1.10.3.custom/js/jquery-1.9.1.js"></script>
        <script type="text/javascript" src="../include/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"></script>
        <title>JSP Page</title>
        <script>
            var old_position;
            var new_position;
            
            function fnDoSubmit(){
                document.getElementById("newOrder").value = new_position.toString(); 
                document.cfrm.submit();
            }
            
            function fnDoBack(){
                document.location.href="gen.jsp?type=Design&subtype=autogen";
            }
            
            $(document).ready(function (){
                $('.sort').sortable({
                    create: function( event, ui ) {
                        new_position = $(this).sortable('toArray');
                    },
                    start: function(e, ui) {
                        old_position = $(this).sortable('toArray');
                    },
                    update: function(e, ui) {
                        new_position = $(this).sortable('toArray');
                    },
                    stop: function(event, ui) { 
                        new_position = $(this).sortable('toArray'); 
                    }
                });
                
                <% if(redirectLink != null && !redirectLink.isEmpty()){ %>
                    document.location.href = "<%=redirectLink%>";
                <% } %>
            });
        </script>
    </head>
    <body>
        <div id="dvLoading"></div>
        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr><td>
                        <div style="width:50%; display: block; margin-left: auto; margin-right: auto;">
                            <% if (genId != 0) {%>
                            <form id="cfrm" name="cfrm" action="gendesignprocess.jsp" method="POST">
                                <table>
                                    <tr>
                                        <td>
                                            <label for="rdoReset">Do Reset?</label>
                                            <input type="hidden" id="type" name="type" value="Design"/>
                                            <input type="hidden" id="subtype" name="subtype" value="autogen" />
                                        </td>
                                        <td>
                                            <input type="radio" name="rdoReset" id="true" value="true" <%=yesSelected%>/>YES
                                            <input type="radio" name="rdoReset" id="false" value="false" <%=noSelected%> />NO
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label for="cbFactor">Resetting Factor: </label>
                                        </td>
                                        <td>
                                            <select id="cbFactor" name="cbFactor" style="width:320px;">
                                                <option value="0">-Select a Prefix-</option>
                                                <%
                                                    String preSelected = "";
                                                    for (int i = 0; i < gDetailsList.size(); i++) {
                                                        GenDetails gDetails = gDetailsList.get(i);
                                                        String shrtDesc = gDetails.getValue();
                                                        if (shrtDesc.length() > 10) {
                                                            shrtDesc = shrtDesc.substring(0, 10) + "...";
                                                        }
                                                        if (shrtDesc.length() > 0) {
                                                            shrtDesc = "-" + shrtDesc;
                                                        }
                                                        if (gDetails.getType() != 5) {
                                                            if (gDetails.getId() == gHeader.getReset_gen_detail_id()) {
                                                                preSelected = "selected";
                                                            } else {
                                                                preSelected = "";
                                                            }
                                                %>
                                                <option value="<%=gDetails.getId()%>" <%=preSelected%>><%=gDetails.getTypeName()%><%=shrtDesc%></option>
                                                <%
                                                        }
                                                    }
                                                %>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label for="txtResetStartNo">Starting No.(After Reset): </label>
                                        </td>
                                        <td>
                                            <input type="number" id="txtResetStartNo" name="txtResetStartNo" value="<%=gHeader.getReset_start_no()%>" />
                                            <input type="hidden" id="newOrder" name="newOrder"/>
                                            <input type="hidden" id="genId" name="genId" value="<%=genId%>"/>
                                        </td>
                                    </tr>
                                    <br/>
                            </form>
            </table>
            <table border="1" width="100%"  cellpadding="3" style="border-collapse:collapse"  bordercolor="#C0C0C0">
                <tr style="background-color: #606060">
                    <th width=20 align="center"><label class="labelheaderfont"><font color="white">Order</font></label></th>
                    <th width=90 align="center"><label class="labelheaderfont"><font color="white">Type</font></label></th>
                    <th width=200 align="center"><label class="labelheaderfont"><font color="white">Value</font></label></th>
                </tr>
                <tbody class="sort">
                    <%
                        for (int i = 0; i < gDetailsList.size(); i++) {
                            GenDetails gDetails = gDetailsList.get(i);
                            //String style = "background-color: #b9b7ff;";
                            //if (i % 2 == 0) {
                            //    style = "background-color: #7370ff;";
                            //}
%>
                    <tr id="<%=i%>"style="">
                        <td align="right"><label class="labelfont"><%=gDetails.getOrder()%> </label></td>
                        <td align="right"><label class="labelfont"><%=gDetails.getTypeName()%> </label></td>
                        <td align="right"><label class="labelfont"><%=gDetails.getValue()%> </label></td>
                    </tr>
                    <%}%>
                </tbody>
                <tr>
                    <td colspan="3" class="labelfont" style="text-align:center">
                        <input type="button" value="Confirm" id="btnConfirm" name="btnConfirm" class="psadbutton" width="100" onclick="fnDoSubmit()">
                        <input type="button" value="Back" id="btnBack" name="btnBack" class="psadbutton" width="100" onclick="fnDoBack()">
                    </td>
                </tr>
            </table>
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
