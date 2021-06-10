<%--
    Document   : designationmodify
    Created on : Jun 30, 2009, 11:39:21 AM
    Author     : NooNYUki
--%>

<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "com.bizmann.product.controller.*"
        import = "com.bizmann.product.entity.*"
        import = "com.bizmann.product.resources.*" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%
    String designationId = request.getParameter("designationId");
    int desId = 0;

    String msg = "";
    boolean isDuplicate = false;

    if (designationId == null || designationId.equals("0")) {
        designationId = "0";
        desId = 0;
        msg = "Please select a designation to delete.";
    } else {
        desId = Integer.parseInt(designationId);
        msg = "";
    }
    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }

    if (action.equals("modify")) {
        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");

        //get the form data

        String designationName = request.getParameter("designationName");

        //get the current user name for modified by field.
        UserController nuCtrl = new UserController();
        String modloginid = (String) session.getAttribute("user");
        int moduserId = nuCtrl.getUserIdByLoginId(modloginid);

        //update the database
        DesignationController designationCtrl = new DesignationController();
        isDuplicate = designationCtrl.isDuplicateDesignation(designationName);
        if (isDuplicate) {
            msg = "This job designation already exists.";
        } else {
            msg = "";
            designationCtrl.updateDesignationById(Integer.parseInt(designationId), designationName, moduserId);

        }
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <script type="text/javascript" src="../include/js/url.js"></script>

        <script>

            var formName;
            var designationId;
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>";
            var msg = "<%= msg%>";
            var desId = "<%=desId%>";

            function fnOnLoad(){
                if(msg != "" && msg != null){
                    if(desId == "0"){
                        //  alert("Please choose a designation to delete.");
                    }
                    else
                    {    parent.frames.alertMessage(msg);  }
                }
                if(action == "modify" && (document.getElementById("msg").value == null || document.getElementById("msg").value == "")){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "designation.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "designation.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }

            function fnSubmit(){
                if(formValidated() == true){
                    designationName = fnURLEncode(document.getElementById("txtDesignationName").value);
                    designationId= "<%=designationId%>";
                    document.location.href = "designationmodify.jsp?type="+type+"&subtype="+subtype+"&action=modify&designationName="+designationName+"&designationId="+designationId;
                }
            }

            function formValidated(){


                if(document.getElementById("txtDesignationName").value == ""){
                    parent.frames.alertMessage("Please enter job designation name.");
                    return false;
                }
                else if((document.getElementById("txtDesignationName").value).length > 100){
                    parent.frames.alertMessage("Please enter designation with 100 characters or less.");
                    document.getElementById("txtDesignationName").value = "";
                    return false;
                }
                else if(document.getElementById("initName").value == document.getElementById("txtDesignationName").value){
                    parent.frames.alertMessage("You didn't make any changes to the name.");
                    return false;
                }
                else{
                    return true;
                }
            }
        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png">
        <% if (designationId.equals("") || designationId.equals("0") || desId == 0) {%>
        <!-- Leave it blank -->
        <%} else {
            DesignationController designationCtrl = new DesignationController();
            Designation designation = designationCtrl.getDesignationById(Integer.parseInt(designationId));
            UserController uCtrl = new UserController();
        %>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br>
                        <table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Modify Job Designation<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationId" name="txtDesignationId" size="30" class="psadview" value="JD<%=ResourceUtil.getVersionFormat(designation.getDesignationId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationName" name="txtDesignationName" size="30" class="psadtext" value="<%=designation.getName()%>"></td>
                            </tr>

                            <tr>
                                <td width=150 align="right"><b>Created Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationCreatedDate" name="txtDesignationCreatedDate" size="30" class="psadview" value="<%=designation.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationCreatedBy" name="txtDesignationCreatedBy" size="30" class="psadview" value="<%=uCtrl.getUserNameById(designation.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationModifiedDate" name="txtDesignationModifiedDate" size="30" class="psadview" value="<%=designation.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtDesignationModifiedBy" name="txtDesignationModifiedBy" size="30" class="psadview" value="<%=uCtrl.getUserNameById(designation.getModifiedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><input type="hidden" value="<%=msg%>" name="msg" id="msg" ></input></td>
                                <td width=350 align="left"><input type="hidden" value="<%=designation.getName()%>" name="initName" id="initName"/>&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">
                                    <!-- Update the form name upon submission -->
                                    &nbsp;<input type="button" value="Modify" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%}%>
    </body>
</html>


