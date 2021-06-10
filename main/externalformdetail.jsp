<%-- 
    Document   : externalformdetail
    Created on : Jan 26, 2015, 11:26:10 AM
    Author     : SOE HTIKE
--%>

<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.entity.*"
        import = "com.bizmann.product.resources.*"
        import = "com.bizmann.flowchart.controller.*"
        import = "com.bizmann.external.form.controller.*"
        import = "com.bizmann.external.form.entity.*"  %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    UserController uCtrl = new UserController();
    String loginid = (String) session.getAttribute("user");
    int userId = uCtrl.getUserIdByLoginId(loginid);

    String type = request.getParameter("type");
    if (type == null) {
        type = "";
    }

    String subtype = request.getParameter("subtype");
    if (subtype == null) {
        subtype = "";
    }

    String flowChartId = request.getParameter("flowChartId");
    if (flowChartId == null) {
        flowChartId = "0";
    }
    flowChartId = flowChartId.trim();
    if (flowChartId.equals("")) {
        flowChartId = "0";
    }
    int intFlowChartId = Integer.parseInt(flowChartId);
    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    String todoaction = request.getParameter("todoaction");
    if (todoaction == null) {
        todoaction = "";
    }

    ExternalFormController eFormCtrl = new ExternalFormController();
    ArrayList<ExternalForm> efDetailList = eFormCtrl.getExternalFormDetails(intFlowChartId);

    String errMessage = "";
    if (todoaction.equals("update")) {
        for (int i = 0; i < efDetailList.size(); i++) {
            ExternalForm efDetail = efDetailList.get(i);
            String form_name = request.getParameter("txtFormName" + efDetail.getAction_id());
            if (form_name != null) {
                efDetail.setForm_name(form_name);
            }
        }
        
        eFormCtrl.handleExternalFormDetailsRecord(efDetailList);
        
        //retrieve data again 
        efDetailList = eFormCtrl.getExternalFormDetails(intFlowChartId);
        todoaction = ""; //reset todoaction
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <script type="text/javascript" src="../include/js/jquery-1.10.2.js" ></script>
        <title>bmFLO</title>
        <script>
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=type%>";
            var subtype = "<%=subtype%>";

            function fnOnLoad(){
                if(action == "version"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "externalform.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "externalform.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }
            
            function formLimitReached(){
                parent.frames.alertMessage("Flowchart Activation Limit has Reached!");
            }
            
            function validateFrmData(){
                var flag = true;
                //                $('.psadview').each(function() {
                //                    if($(this).val() == ''){
                //                        alert("Unable to update with Empty Form Name!");
                //                        flag = false;
                //                    }
                //                });
                var x = document.getElementsByClassName("psadview");
                var i;
                for (i = 0; i < x.length; i++) {
                    if(x[i].value == ''){
                        flag = false;
                        alert("Unable to update with Empty Form Name!");
                        break;
                    }
                }
                return flag;
            }
            
            function fnbtnUpdateClicked(){
                if(validateFrmData() == true){
                    document.getElementById("todoaction").value = "update";
                    document.frmExternalFormDetail.submit();
                }else{
                    return false;
                }
            }
        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png" style="width:650px">
        <form id="frmExternalFormDetail" name="frmExternalFormDetail" action="externalformdetail.jsp" method="POST">
            <% if (flowChartId.equals("0")) {%>
            <!-- Leave it blank -->
            <%} else {%>
            <div align="center" valign="top">
                <table>
                    <tr>
                        <td class="orgtable" valign="top" align="center">
                            <br>
                            <table>
                                <tr>
                                    <td colspan="2">
                                        <div class="psadtitle">
                                            <br>
                                            External Form Details

                                            <input type="hidden" id="flowChartId" name="flowChartId" value="<%=flowChartId%>" />
                                            <input type="hidden" id="todoaction" name="todoaction" value="" />
                                            <input type="hidden" id="type" name="type" value="<%=type%>" />
                                            <input type="hidden" id="subtype" name="subtype" value="<%=subtype%>" />
                                            <br>
                                            <br>
                                        </div>
                                    </td>
                                </tr>
                                <tr class="psadtitle">
                                    <th width="200" align="centre"><b>Activity Name</b></th>
                                    <th width="300" align="centre"><b>Form Name(.jsp)</b></th>
                                </tr>
                                <%
                                    for (int i = 0; i < efDetailList.size(); i++) {
                                        ExternalForm efDetail = efDetailList.get(i);
                                %>
                                <tr>
                                    <td wdith="200" align="center"><b><%=efDetail.getAction_name()%></b></td>
                                    <td width="300" align="center">&nbsp;
                                        <input type="text" id="txtFormName<%=efDetail.getAction_id()%>" name="txtFormName<%=efDetail.getAction_id()%>" size="30" class="psadview" value="<%=efDetail.getForm_name()%>" />
                                    </td>
                                </tr>
                                <% }%>
                                <tr>
                                    <td colspan="2">
                                        <div class="psadtitle">
                                            <input type="button" id="btnUpdate" name="btnUpdate" value="Update" onclick="fnbtnUpdateClicked()" />
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </div>
            <% }%>
        </form>
        <script>
            <%=errMessage%>
        </script>
    </body>
</html>
