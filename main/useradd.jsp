<%-- 
    Document   : useradd
    Created on : Jul 15, 2009, 9:31:38 AM
    Author     : NooNYUki
    
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.admin.controller.AdminUserLimitController" %>

<%
    String parentId = request.getParameter("parentId");
    String childId = request.getParameter("childId");
    String msg = "";

    int uorgunitId = 0;

    boolean isDuplicate = false;
    boolean isDuplicateEmail = false;

    if (parentId == null || parentId.equals("0")) {
        parentId = "0";

    } else if (childId == null || childId.equals("0")) {
        childId = "0";
    }
    //parentid 0 means it s the root -org name.
    if (parentId.equals("0") && childId.equals("0")) {
        uorgunitId = 0;
    } // this means user clicked on an OU
    else if (parentId.equals("0") && childId.startsWith("O")) {
        childId = childId.substring(1);
        uorgunitId = Integer.parseInt(childId);

    } //this means user clicked on username and then clicked add button.
    else if (parentId.startsWith("O") && childId.startsWith("U")) {
        parentId = parentId.substring(1);
        uorgunitId = Integer.parseInt(parentId);

    } //this means user clicked on an OU name and clicked add button.
    else if (parentId.startsWith("O") && childId.startsWith("O")) {
        childId = childId.substring(1);
        uorgunitId = Integer.parseInt(childId);
    }

    String action = request.getParameter("action");

    if (action == null) {
        action = "";
    }

    if (action.equals("add")) {
        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");

        //get the form data
        String lastName = request.getParameter("lastName");
        String middleName = request.getParameter("middleName");
        String firstName = request.getParameter("firstName");
        String contactNo = request.getParameter("contactNo");
        String mobileNo = request.getParameter("mobileNo");
        String faxNo = request.getParameter("faxNo");
        String email = request.getParameter("email");
        String field1 = request.getParameter("txtField1");
        String field2 = request.getParameter("txtField2");
        String field3 = request.getParameter("txtField3");
        String loginId = request.getParameter("loginId");
        String uPwd = request.getParameter("uPwd");
        String uDesId = request.getParameter("uDesId");
        String uAuthGrpId = request.getParameter("uAuthGrpId");

        //update the database
        UserController uCtrl = new UserController();
        UserAuthGrpController userauthgrpCtrl = new UserAuthGrpController();
        UserOUDesignationController useroudesCtrl = new UserOUDesignationController();

        isDuplicate = uCtrl.isDuplicateUser(firstName, middleName, lastName, loginId);
        isDuplicateEmail = uCtrl.isDuplicateEmail(email);
        if (isDuplicate) {
            msg = "This user already exists.";

        } else if (isDuplicateEmail) {
            msg = "This email already exists.";
        } else if(new AdminUserLimitController().hasUserLimitReached(Integer.parseInt(uAuthGrpId))){
            msg = "No. of Users for this Authority Group has Reached the Limit!";
        }else {
            msg = "";

            String modloginid = (String) session.getAttribute("user");
            int moduserId = uCtrl.getUserIdByLoginId(modloginid);

            //User user = new User(lastName, middleName, firstName, contactNo, mobileNo, faxNo, email, loginId, uPwd);
            User user = new User(lastName, middleName, firstName, contactNo, mobileNo, faxNo, email, loginId, uPwd, field1, field2, field3);
            uCtrl.addNewUser(user, moduserId);

            int newlyaddeduserId = uCtrl.getUserIdByLoginId(loginId);
            UserAuthGrp userauthgrp = new UserAuthGrp(newlyaddeduserId, Integer.parseInt(uAuthGrpId));
            userauthgrpCtrl.addNewUserAuthGrp(userauthgrp);

            UserOUDesignation useroudesignation = new UserOUDesignation(newlyaddeduserId, uorgunitId, Integer.parseInt(uDesId), 1);
            useroudesCtrl.addNewUserOUDesignation(useroudesignation);
        }
    }

    if (action.equals("exadd")) {

        //get the current type and subtype
        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");

        String exUserId = request.getParameter("exUserId");
        String exDesId = request.getParameter("exDesId");

        boolean userHasPrimaryJob = false;
        boolean userAssignedtoOrg = false;

        UserOUDesignationController exuseroudesCtrl = new UserOUDesignationController();
        userAssignedtoOrg = exuseroudesCtrl.userExistsInthisOU(Integer.parseInt(exUserId), uorgunitId);
        int isPrimary = 0;

        if (userAssignedtoOrg == true) {
            msg = "This user already exists in this organization unit.";
        } //if the user currently doesn't have any primary role, this new post will become his/her primary role.
        else {
            userHasPrimaryJob = exuseroudesCtrl.userHasPrimaryDesignation(Integer.parseInt(exUserId));
            if (userHasPrimaryJob == true) {
                isPrimary = 0;
            } else {
                isPrimary = 1;
            }
            msg = "";

            UserOUDesignation exuseroudesignation = new UserOUDesignation(Integer.parseInt(exUserId), uorgunitId, Integer.parseInt(exDesId), isPrimary);
            exuseroudesCtrl.addNewUserOUDesignation(exuseroudesignation);
        }
    }
%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/layout.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/menu/assets/skins/sam/menu.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />

        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/imageloader/imageloader-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/container/container_core-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/menu/menu-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-beta-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/button/button-min.js"></script>
        <script type="text/javascript" src="../include/js/url.js"></script>
        <script>

            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"
            var msg = "<%= msg%>";
            var uorgunitId = "<%=uorgunitId%>";

            function fnOnLoad(){
                if(msg != "" && msg != null){
                    if(uorgunitId == "0"){
                        //  leave it blank
                    }
                    else
                    {    parent.frames.alertMessage(msg);    }
                }

                else if(action == "add" || action == "exadd"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "user.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "user.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }


            function formValidated(){

                var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
                var address = document.getElementById("txtEmail").value;

                if(document.getElementById("txtFirstName").value == ""){
                    parent.frames.alertMessage("Please enter first name.");
                    return false;
                }
                else if((document.getElementById("txtFirstName").value).length > 100){
                    parent.frames.alertMessage("Please enter a name with 100 characters or less.");
                    document.getElementById("txtFirstName").value = "";
                    return false;
                }
                else if(document.getElementById("txtMiddleName").value != "" && (document.getElementById("txtMiddleName").value).length > 100){
                    parent.frames.alertMessage("Please enter a name with 100 characters or less.");
                    document.getElementById("txtMiddleName").value = "";
                    return false;
                }
                else if(document.getElementById("txtLastName").value == ""){
                    parent.frames.alertMessage("Please enter last name.");
                    return false;
                }
                else if((document.getElementById("txtLastName").value).length > 100){
                    parent.frames.alertMessage("Please enter a name with 100 characters or less.");
                    document.getElementById("txtLastName").value = "";
                    return false;
                }

                else if(document.getElementById("txtEmail").value == ""){
                    parent.frames.alertMessage("Please enter email address.");
                    return false;
                }
                else if((document.getElementById("txtEmail").value).length > 100){
                    parent.frames.alertMessage("Please enter an email address with 100 characters or less.");
                    document.getElementById("txtEmail").value = "";
                    return false;
                }
                else if((document.getElementById("txtField1").value).length > 100){
                    parent.frames.alertMessage("Please enter custom field 1 with 100 characters or less.");
                    document.getElementById("txtEmail").value = "";
                    return false;
                }
                else if((document.getElementById("txtField2").value).length > 100){
                    parent.frames.alertMessage("Please enter custom field 2 with 100 characters or less.");
                    document.getElementById("txtEmail").value = "";
                    return false;
                }
                else if((document.getElementById("txtField3").value).length > 100){
                    parent.frames.alertMessage("Please enter custom field 3 with 100 characters or less.");
                    document.getElementById("txtEmail").value = "";
                    return false;
                }
                else if(document.getElementById("txtLoginID").value == ""){
                    parent.frames.alertMessage("Please enter login id.");
                    return false;
                }
                else if((document.getElementById("txtLoginID").value).length > 100){
                    parent.frames.alertMessage("Please enter a login ID with 100 characters or less.");
                    document.getElementById("txtLoginID").value = "";
                    return false;
                }
                else if(document.getElementById("txtUPassword").value == ""){
                    parent.frames.alertMessage("Please enter password for the user.");
                    return false;
                }
                else if((document.getElementById("txtUPassword").value).length > 100){
                    parent.frames.alertMessage("Please enter a password with 100 characters or less.");
                    document.getElementById("txtUPassword").value = "";
                    return false;
                }
                else if(document.getElementById("txtConPassword").value == ""){
                    parent.frames.alertMessage("Please enter password again.");
                    return false;
                }
                else if((document.getElementById("txtConPassword").value).length > 100){
                    parent.frames.alertMessage("Please enter a password with 100 characters or less.");
                    document.getElementById("txtConPassword").value = "";
                    return false;
                }
                else if(document.getElementById("txtConPassword").value != document.getElementById("txtUPassword").value){
                    parent.frames.alertMessage("Passwords you entered do not match.");
                    return false;
                }

                else if(reg.test(address) == false) {
                    parent.frames.alertMessage("Please enter a valid email address.");
                    return false;
                }

                else if(document.getElementById("cmbDesignation").value == "" || document.getElementById("cmbDesignation").value == null){
                    parent.frames.alertMessage("Please select a primary designation for this user.");
                    return false;
                }
                else if(document.getElementById("cmbAuthGrp").value == "" || document.getElementById("cmbAuthGrp").value == null){
                    parent.frames.alertMessage("Please select an authority group for this user.");
                    return false;
                }
                else{
                    return true;
                }

            }

            //form submission for existing user.
            function fnExSubmit(){
                var exUserId = document.getElementById("cmbExistingUser").value;
                var exDesId = document.getElementById("cmbJobDes").value;



                if(exUserId=="" || exUserId == null){
                    parent.frames.alertMessage("Please select a user.");
                }
                else if(exDesId=="" || exDesId == null){
                    parent.frames.alertMessage("Please select a designation.");
                }
                else{
                    var parentId = "<%=request.getParameter("parentId")%>"
                    var childId = "<%=request.getParameter("childId")%>"


                    document.location.href="useradd.jsp?type="+type+"&subtype="+subtype+"&action=exadd&exUserId="
                        +exUserId+"&exDesId="+exDesId+
                        "&parentId="+parentId+"&childId="+childId;
                }
            }

            function fnSubmit(){
                if(formValidated() == true){
                    //get the form data
                    var lastName = fnURLEncode(document.getElementById("txtLastName").value);
                    var middleName = fnURLEncode(document.getElementById("txtMiddleName").value);
                    var firstName = fnURLEncode(document.getElementById("txtFirstName").value);
                    var contactNo = fnURLEncode(document.getElementById("txtContactNo").value);
                    var mobileNo = fnURLEncode(document.getElementById("txtMobileNo").value);
                    var faxNo = fnURLEncode(document.getElementById("txtFaxNo").value);
                    var email = fnURLEncode(document.getElementById("txtEmail").value);
                    var txtField1 = fnURLEncode(document.getElementById("txtField1").value);
                    var txtField2 = fnURLEncode(document.getElementById("txtField2").value);
                    var txtField3 = fnURLEncode(document.getElementById("txtField3").value);
                    var loginId = fnURLEncode(document.getElementById("txtLoginID").value);
                    var uPwd = fnURLEncode(document.getElementById("txtUPassword").value);
                    var uDesId = document.getElementById("cmbDesignation").value;
                   
                    var uAuthGrpId = document.getElementById("cmbAuthGrp").value;

                    var parentId = "<%=request.getParameter("parentId")%>"
                    var childId = "<%=request.getParameter("childId")%>"

                    //update the form in the database
                    document.location.href = "useradd.jsp?type="+type+"&subtype="+subtype+"&action=add&lastName="+ lastName +
                        "&middleName="+middleName+"&firstName="+firstName+
                        "&contactNo="+contactNo+"&mobileNo="+mobileNo+
                        "&faxNo="+faxNo+"&email="+email+"&loginId="+loginId+"&uPwd="+uPwd+
                        "&uDesId="+uDesId+"&uAuthGrpId="+uAuthGrpId+
                        "&parentId="+parentId+"&childId="+childId
                        +"&txtField1="+txtField1+"&txtField2="+txtField2+"&txtField3="+txtField3;
                }

            }
        </script>

    </head>
    <body onload="fnOnLoad()" class="yui-skin-sam" background="../images/background.png" style="width:650px">
        <!-- alert message -->
        <%if (childId.equals("") || childId.equals("0") || (parentId.equals("0") && childId.equals("0"))) {%>
        <!-- Leave it blank -->
        <%} else {

            AuthGrpController authgrpCtrl = new AuthGrpController();
            AuthGrp authgrp = new AuthGrp();

            DesignationController designationCtrl = new DesignationController();
            Designation designation = new Designation();

            UserController uCtrl = new UserController();
            User u = new User();

            ArrayList designationlist = designationCtrl.getAllDesignation();
            ArrayList authgrplist = authgrpCtrl.getAllAuthGrp();

            ArrayList userlist = uCtrl.getAllUserName();

        %>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br><table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Add User<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>First Name</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFirstName" name="txtFirstName" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Middle Name</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtMiddleName" name="txtMiddleName" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Last Name</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtLastName" name="txtLastName" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Contact No</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtContactNo" name="txtContactNo" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Mobile No</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtMobileNo" name="txtMobileNo" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Fax No</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFaxNo" name="txtFaxNo" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Email</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtEmail" name="txtEmail" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Custom Field 1</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtField1" name="txtField1" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Custom Field 2</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtField2" name="txtField2" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Custom Field 3</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtField3" name="txtField3" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Login ID</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtLoginID" name="txtLoginID" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Password</b></td>
                                <td width=350 align="left">&nbsp;<input type="password" id="txtUPassword" name="txtUPassword" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Confirm Password</b></td>
                                <td width=350 align="left">&nbsp;<input type="password" id="txtConPassword" name="txtConPassword" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Primary Designation</b></td>
                                <td width=350 align="left">&nbsp;<select size="1" id="cmbDesignation" name="cmbDesignation" style="width:200px" align="top" class="psadselect">
                                        <option></option>

                                        <%
                                            for (int j = 0; j < designationlist.size(); j++) {
                                                designation = (Designation) designationlist.get(j);

                                        %>
                                        <option class="psadselect option"value="<%=designation.getDesignationId()%>" ><%= designation.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Authority Group</b></td>
                                <td width=350 align="left">&nbsp;<select size="1" id="cmbAuthGrp" name="cmbAuthGrp" style="width:200px" align="top" class="psadselect">
                                        <option></option>

                                        <%
                                            for (int k = 0; k < authgrplist.size(); k++) {
                                                authgrp = (AuthGrp) authgrplist.get(k);

                                        %>
                                        <option class="psadselect option" value="<%=authgrp.getId()%>" ><%= authgrp.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select> 
                                </td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><input type="hidden" value="<%=msg%>" name="msg" id="msg" ></input></td>
                                <td width=350 align="left">&nbsp;<input type="button" value="Add" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()"></td>
                            </tr>

                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Add Existing User<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>User </b></td>
                                <td width=350 align="left">&nbsp;<select size="1" id="cmbExistingUser" name="cmbExistingUser" style="width:200px" align="top" class="psadselect">
                                        <option> </option>

                                        <%
                                            for (int l = 0; l < userlist.size(); l++) {
                                                u = (User) userlist.get(l);


                                        %>
                                        <option value="<%=u.getUserId()%>" ><%= u.getFullName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Job Designation </b></td>
                                <td width=350 align="left">&nbsp;<select size="1" id="cmbJobDes" name="cmbJobDes" style="width:200px" align="top" class="psadselect">
                                        <option></option>

                                        <%
                                            for (int j = 0; j < designationlist.size(); j++) {
                                                designation = (Designation) designationlist.get(j);

                                        %>
                                        <option class="psadselect option" value="<%=designation.getDesignationId()%>" ><%= designation.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;<input type="button" value="Add Existing User" name="btnExSubmit" class="psadbutton" width="100" align="top" onclick="fnExSubmit()"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <%}%>
    </body>
</html>


