<%-- 
    Document   : userprofile
    Created on : Jul 13, 2009, 9:26:07 AM
    Author     : Hnaye
--%>
<%@page import = "com.bizmann.product.controller.UserController"
        import = "com.bizmann.product.resources.*"
        import = "com.bizmann.component.cryptography.DesEncrypter"
        import = "com.bizmann.product.entity.User" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%
    OrgUnitController orgUnitCtrl = new OrgUnitController();

    String msg = "";
    String action = request.getParameter("action");
       
    boolean updatePwd = false;
        
    String oldPwd = request.getParameter("oldPwd");
    String newPwd = request.getParameter("newPwd");
    String confirmPwd = request.getParameter("confirmPwd");     
       
    username = userCtrl.getUserNameByLoginId(loginid);
    user = userCtrl.getUserByLoginId(loginid);
        
    if(action!= null){
        if(action == "" || action.equals("")){
            action = "";
        }
        else if(action.equals("save")){
            PasswordSecure pws = new PasswordSecure();
            DesEncrypter des = new DesEncrypter(oldPwd);

            String enteredValue= des.encrypt(oldPwd);
            String recordValue= pws.readDBByLoginID(loginid);
            boolean isCorrectPassword= pws.comparePassword(recordValue, enteredValue);

           if(isCorrectPassword == false){
                msg = "The old password is not correct.";
            }
            else if(isCorrectPassword == true){
                if(newPwd.equals(confirmPwd)){
                        
                    updatePwd = userCtrl.updatePassword(loginid, newPwd);
                        
                    if(updatePwd){
                        msg = "Your password is updated successfully.";
                    }
                    else{

                    }
                }
            }
        }
    }
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />  
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/datasource/datasource-min.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/calendar/assets/skins/sam/calendar.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/calendar.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <script type="text/javascript" src="../include/js/yui/calendar/calendar-min.js"></script>
    </head>
    <style>
        .rightColumn{
            width:15%;
            height:10px;
            font-weight:normal;
            text-align:right;
        }
        .leftColumn{
            width:300px;
            height:10px;
            text-align:left;
        }
        .mainPanel{
            height:420px;
            width:980px;
            vertical-align:top;
            text-Align:right;
            background-image:url('../images/background.png');
        }
    </style>
    <script type="text/javascript">
        javascript:window.history.forward(1);

        var action = "<%=request.getParameter("action")%>";
        var type = "<%=request.getParameter("type")%>";
        var subtype = "<%=request.getParameter("subtype")%>";

        function fnCancel(){
            parent.document.location.href = "../main/work.jsp";
        }

        function fnOnLoad(){
            if(action=="save"){
                if(subtype=="null"){
                    parent.document.location.href = "userprofile.jsp?type="+type;
                }
                else{
                    if(document.getElementById("msg").value != "" && document.getElementById("msg").value != "null"){
                        
                        parent.frames.alertMessage(document.getElementById("msg").value);
                    }   
                }
            }
        }


        function fnSave(){
            if(fnCheckMandatoryFields()==true){
                oldPwd = document.getElementById("txtOldPassword").value;
                newPwd = document.getElementById("txtNewPassword").value;
                confirmPwd = document.getElementById("txtConfirmPassword").value;
                document.getElementById("btnSubmit").disabled = true;
                document.location.href = "userprofile.jsp?type="+type+"&subtype="+subtype+"&action=save&oldPwd="+oldPwd+"&newPwd="+newPwd+"&confirmPwd="+confirmPwd;
            }

        }

        function fnCheckMandatoryFields(){
            if(document.getElementById("txtOldPassword").value==""){
                parent.frames.alertMessage("Please enter Old Password.");
                return false;
            }
            else if(document.getElementById("txtNewPassword").value==""){
                parent.frames.alertMessage("Please enter New Password.");
                return false;
            }
            else if(document.getElementById("txtConfirmPassword").value==""){
                parent.frames.alertMessage("Please enter Confirm Password.");
                return false;
            }
            else if((document.getElementById("txtNewPassword").value)!=(document.getElementById("txtConfirmPassword").value)){
                parent.frames.alertMessage("Please re-enter New Password or Confirm Password as they do not match. ");
                return false;
            }
            else
            {   return true;}
        }

    </script>
    <body onload="fnOnLoad()" class="yui-skin-sam">
        <div align="center"  >
            <table border="0" width="980px" height="420px" background="../images/background.png" align="center">
                <tr>
                    <td colspan="2" class="psadtitle">                        
                        <br>
                        User Profile<br><br>
                    </td>
                </tr>
                <tr>
                    <td width=430 align="right"><b>Name:</b></td>
                    <td width=560 align="left"><input type="text" id="txtUserName" name="txtUserName" size="30" class="psadview" value="<%=username%>" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right"><b>Organization:</b></td>
                    <td align="left"><textarea class="psadview" rows="4" id="txtOrganization" cols="33" name="txtOrganization" readonly><%=orgUnitCtrl.getOrganizationName(user.getUserId())%></textarea>
                    <!--<input type="text" name="txtOrganization" class="psadview" value="<%=orgUnitCtrl.getOrganizationName(user.getUserId())%>" size="30" readonly="readonly" /></td>-->
                </tr>
                <tr>
                    <td align="right"><b>Contact No:</b></td>
                    <td align="left"><input type="text" id="txtContactNo" name="txtContactNo" size="30" class="psadview" value="<%=user.getContactNo()%>" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right"><b>Mobile No:</b></td>
                    <td align="left"><input type="text" id="txtMobileNo" name="txtMobileNo" size="30" class="psadview" value="<%=user.getMobileNo()%>" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right"><b>Fax No:</b></td>
                    <td align="left"><input type="text" id="txtFaxNo" name="txtFaxNo" size="30" class="psadview" value="<%=user.getFaxNo()%>" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right"><b>Email:</b></td>
                    <td align="left"><input type="text" id="txtEmail" name="txtEmail" size="30" class="psadview" value="<%=user.getEmail()%>" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right"><b>Login Id:</b></td>
                    <td align="left"><input type="text" id="txtLoginId" name="txtLoginId" size="30" class="psadview" value="<%=user.getLoginId()%>" readonly="readonly"></td>
                </tr>
                <tr>
                    <td align="right"><b>Old Password:</b></td>
                    <td align="left">

                        <input type="password" id="txtOldPassword" name="txtOldPassword" size="30" class="psadtext" value="">

                    </td>
                </tr>
                <tr>
                    <td align="right"><b>New Password:</b></td>
                    <td align="left"><input type="password" id="txtNewPassword" name="txtNewPassword" size="30" class="psadtext"></td>
                </tr>
                <tr>
                    <td align="right"><b>Confirm Password:</b></td>
                    <td align="left"><input type="password" id="txtConfirmPassword" name="txtConfirmPassword" size="30" class="psadtext"></td>
                </tr>
                <tr>
                    <td align="right">&nbsp;</td>
                    <td align="left">&nbsp;</td>
                </tr>
                <tr>
                    <td align="right">&nbsp;</td>
                    <td align="left">&nbsp;</td>
                </tr>
                <tr>
                    <td align="right">&nbsp;</td>
                    <td align="left"><input type="button" value="Submit" id="btnSubmit" name="btnSubmit" class="psadbutton" width="100" onclick="fnSave()">&nbsp;<!--<input type="button" value="Cancel" name="btnCancel" class="psadbutton" width="100" onclick="fnCancel()">--></td>

                </tr>
                <tr>
                    <td align="right">&nbsp;</td>
                    <td align="left">&nbsp;</td>
                </tr>
                <tr>
                    <td align="right">&nbsp;</td>
                    <td align="left">&nbsp;</td>
                </tr>
            </table>
            <input type="hidden" value="<%=msg%>" name="msg" id="msg" >
        </div>
    </body>
</html>

<%@ include file="../include/footer.jsp" %>