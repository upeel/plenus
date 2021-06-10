<%--
    Document   : usermodify
    Created on : Jul 20, 2009, 9:48:48 AM
    Author     : NooNYUki
--%>

<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.product.resources.*"
         import = "com.bizmann.admin.controller.AdminUserLimitController" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%
    String parentId = request.getParameter("parentId");
    String childId = request.getParameter("childId");
    int uorgunitId = 0;
    int userId = 0;
    String msg = "";
    boolean isDuplicate = false;
    boolean userExistsinOU = false;

    if (parentId == null || parentId.equals("0")) {
        parentId = "0";

    } else if (childId == null || childId.equals("0")) {
        childId = "0";
    }

    //parentid 0 means it s the root -org name. So, it's child is an orgunit.
    if (parentId.equals("0")) {
        if (childId.startsWith("O")) {
            childId = childId.substring(1);

            uorgunitId = Integer.parseInt(childId);

        } else {
            uorgunitId = 0;
            userId = 0;
        }
    } else {
        if (parentId.startsWith("O") && childId.startsWith("U")) {
            parentId = parentId.substring(1);
            uorgunitId = Integer.parseInt(parentId);
            childId = childId.substring(1);
            userId = Integer.parseInt(childId);
        }
    }
    String action = request.getParameter("action");
    if (action == null) {
        action = "";
    }
    
    UserAuthGrpController userauthgrpCtrl = new UserAuthGrpController();
    int olduserauthgrpId = userauthgrpCtrl.getAuthGrpIdByUserId(userId);

    if (action.equals("modify")) {
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
        String isnPrimary = request.getParameter("isnPrimary");
        String fullName = request.getParameter("fullName");
        String initUserName = request.getParameter("initUserName");

        int modOrgUnitId;
        String modorgId = request.getParameter("modorgId");

        if (modorgId == null) {
            modOrgUnitId = 0;
        } else {

            modOrgUnitId = Integer.parseInt(modorgId);
        }

        //update the database
        OrgUnitController ouCtrl = new OrgUnitController();
        UserController uCtrl = new UserController();
        UserOUDesignationController useroudesignationCtrl = new UserOUDesignationController();
        UserAuthGrpController nuserauthgrpCtrl = new UserAuthGrpController();

        //get the current user id for modified by field.
        String modloginid = (String) session.getAttribute("user");
        int moduserId = uCtrl.getUserIdByLoginId(modloginid);



        initUserName = initUserName.trim();

        fullName = fullName.trim();

        if (initUserName.equals(fullName)) {
            isDuplicate = false;
        } else {
            isDuplicate = uCtrl.isDuplicateUserName(firstName, middleName, lastName);
        }

        if (isDuplicate) {
            msg = "This name already exists.";


        } else {
            if (uorgunitId == modOrgUnitId) {
                userExistsinOU = false;
            } else {
                userExistsinOU = useroudesignationCtrl.userExistsInthisOU(userId, modOrgUnitId);
            }

            if (userExistsinOU) {
                msg = "This user already exists in selected organization unit.";
            } else {
                if ((olduserauthgrpId != Integer.parseInt(uAuthGrpId)) && (new AdminUserLimitController().hasUserLimitReached(Integer.parseInt(uAuthGrpId)))) {
                    msg = "No. of Users for this Authority Group has Reached the Limit!";
                } else {
                    msg = "";
                    //update user table.
                    if (uPwd.equals("") || uPwd == null) {
                        //uCtrl.updateUserById(userId, firstName, middleName, lastName, contactNo, mobileNo, faxNo, email, loginId, moduserId);
                        uCtrl.updateUserById(userId, firstName, middleName, lastName, contactNo, mobileNo, faxNo, email, loginId, moduserId, field1, field2, field3);
                    } else {
                        //uCtrl.updateUserById(userId, firstName, middleName, lastName, contactNo, mobileNo, faxNo, email, loginId, uPwd, moduserId);
                        uCtrl.updateUserById(userId, firstName, middleName, lastName, contactNo, mobileNo, faxNo, email, loginId, uPwd, moduserId, field1, field2, field3);
                    }
                    //update for checkbox primary
                    if (isnPrimary.equals("1")) {
                        useroudesignationCtrl.setPrimary(userId, uorgunitId);
                    }
                    //update useroudesignation for designation or orgunit change
                    useroudesignationCtrl.updateUserOUDesignation(userId, Integer.parseInt(uDesId), modOrgUnitId, uorgunitId);

                    nuserauthgrpCtrl.updateUserAuthGrp(userId, Integer.parseInt(uAuthGrpId));

                    if (moduserId == userId) {
                        session.removeAttribute("user");
                        session.setAttribute("user", loginId);
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
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <script type="text/javascript" src="../include/js/url.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <script>

            //var formName;
            //var orgunitId;
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>"
            var msg = "<%= msg%>";
            var uorgunitId = "<%=uorgunitId%>";

            function fnOnLoad(){
                if(msg != "" && msg != null){
                    if(uorgunitId == "0"){
                        //  leave it blank.
                    }
                    else
                    {    parent.frames.alertMessage(msg);    }
                }
                else if(action == "modify"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "user.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "user.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }

            function fnSubmit(){
                if(formValidated() == true){
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
                    var isnPrimary = 0;

                    if(middleName != null)
                    {   fullName = firstName + middleName + lastName;   }
                    else
                    {
                        fullName = firstName+lastName;
                    }


                    if(document.getElementById("chkPrimary").disabled == true){
                        isnPrimary = 0;
                    }
                    else{
                        if(document.getElementById("chkPrimary").checked == true){
                            
                            isnPrimary = 1;
                        }
                        else{
                            isnPrimary = 0;
                        }
                    }
                   
                    initUserName = document.getElementById("initName").value;
                    modorgId = document.getElementById("cmbModOrgUnit").value;
                    var parentId = "<%=request.getParameter("parentId")%>"
                    var childId = "<%=request.getParameter("childId")%>"
                    userId= "<%=userId%>";

                    
                    document.location.href = "usermodify.jsp?type="+type+"&subtype="+subtype+"&action=modify&lastName="+ lastName +
                        "&middleName="+middleName+"&firstName="+firstName+
                        "&contactNo="+contactNo+"&mobileNo="+mobileNo+
                        "&faxNo="+faxNo+"&email="+email+"&loginId="+loginId+"&uPwd="+uPwd+
                        "&uDesId="+uDesId+"&uAuthGrpId="+uAuthGrpId+
                        "&isnPrimary="+isnPrimary+
                        "&fullName="+fullName+"&initUserName="+initUserName+
                        "&modorgId="+modorgId+
                        "&parentId="+parentId+"&childId="+childId
                        +"&txtField1="+txtField1+"&txtField2="+txtField2+"&txtField3="+txtField3;
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
                else if(reg.test(address) == false) {
                    parent.frames.alertMessage("Please enter a valid email Address.");
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
                else if((document.getElementById("txtUPassword").value).length > 100){
                    parent.frames.alertMessage("Please enter a password with 100 characters or less.");
                    document.getElementById("txtUPassword").value = "";
                    return false;
                }
                else if((document.getElementById("txtConPassword").value).length > 100){
                    parent.frames.alertMessage("Please enter a password with 100 characters or less.");
                    document.getElementById("txtConPassword").value = "";
                    return false;
                }
                else if(document.getElementById("txtConPassword").value !="" || document.getElementById("txtUPassword").value != ""){
                    var isEqual = Boolean(true);
                    if(document.getElementById("txtConPassword").value != document.getElementById("txtUPassword").value){
                        parent.frames.alertMessage("Passwords you entered do not match.");
                        isEqual =  false;
                    }
                    return isEqual;
                }
                else if(document.getElementById("cmbDesignation").value == "" || document.getElementById("cmbDesignation").value == null){
                    parent.frames.alertMessage("Please choose a primary designation for this user.");
                    return false;
                }
                else if(document.getElementById("cmbAuthGrp").value == "" || document.getElementById("cmbAuthGrp").value == null){
                    parent.frames.alertMessage("Please choose an authority group for this user.");
                    return false;
                }
                else{
                    return true;
                }
            }



        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png" style="width:650px">
        <%

            if (userId == 0 || uorgunitId == 0) {
        %>
        <!-- Leave it blank -->
        <%} else {
            DesignationController designationCtrl = new DesignationController();
            Designation designation = new Designation();
            AuthGrpController authgrpCtrl = new AuthGrpController();
            AuthGrp authgrp = new AuthGrp();
            int userauthgrpId = userauthgrpCtrl.getAuthGrpIdByUserId(userId);
            UserController nuserCtrl = new UserController();
            User user = nuserCtrl.getUserById(userId);

            UserOUDesignationController useroudesCtrl = new UserOUDesignationController();
            int desId = useroudesCtrl.getUserOUDesignationById(userId, uorgunitId);
            boolean isPrimary = useroudesCtrl.checkPrimary(userId, uorgunitId);

            OrgUnitController orgunitCtrl = new OrgUnitController();
            OrgUnit listorgunit = new OrgUnit();

            ArrayList orgunitlist = orgunitCtrl.getAllOrgUnit();
            ArrayList authgrplist = authgrpCtrl.getAllAuthGrp();
            ArrayList designationlist = designationCtrl.getAllDesignation();
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
                                        <b>Modify User</b><br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserId" name="txtUserId" size="30" class="psadview" value="U<%=ResourceUtil.getVersionFormat(user.getUserId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>First Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFirstName" name="txtFirstName" size="30" class="psadtext" value="<%=user.getFirstName()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Middle Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtMiddleName" name="txtMiddleName" size="30" class="psadtext" value="<%=user.getMiddleName()%>"></td>
                            </tr>                            
                            <tr>
                                <td width=150 align="right"><b>Last Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtLastName" name="txtLastName" size="30" class="psadtext" value="<%=user.getLastName()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Contact No:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtContactNo" name="txtContactNo" size="30" class="psadtext" value="<%=user.getContactNo()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Mobile No:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtMobileNo" name="txtMobileNo" size="30" class="psadtext" value="<%=user.getMobileNo()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Fax No:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtFaxNo" name="txtFaxNo" size="30" class="psadtext" value="<%=user.getFaxNo()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Email:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtEmail" name="txtEmail" size="30" class="psadtext" value="<%=user.getEmail()%>"></td>
                            </tr>
                            <%
                                String field1 = user.getField1();
                                if (field1 == null) {
                                    field1 = "";
                                }
                            %>
                            <tr>
                                <td width=150 align="right"><b>Custom Field 1:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtField1" name="txtField1" size="30" class="psadtext" value="<%=field1%>" ></td>
                            </tr>
                            <%
                                String field2 = user.getField2();
                                if (field2 == null) {
                                    field2 = "";
                                }
                            %>
                            <tr>
                                <td width=150 align="right"><b>Custom Field 2:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtField2" name="txtField2" size="30" class="psadtext" value="<%=field2%>" ></td>
                            </tr>
                            <%
                                String field3 = user.getField3();
                                if (field3 == null) {
                                    field3 = "";
                                }
                            %>
                            <tr>
                                <td width=150 align="right"><b>Custom Field 3:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtField3" name="txtField3" size="30" class="psadtext" value="<%=field3%>" ></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Login ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtLoginID" name="txtLoginID" size="30" class="psadtext" value="<%=user.getLoginId()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Designation:</b></td>
                                <td width=350 align="left">&nbsp;<select size="1" id="cmbDesignation" name="cmbDesignation" style="width:200px" align="top" class="psadselect">
                                        <option></option>

                                        <%
                                            for (int j = 0; j < designationlist.size(); j++) {
                                                designation = (Designation) designationlist.get(j);

                                        %>
                                        <option class="psadselect option"value="<%=designation.getDesignationId()%>"
                                                <%
                                                    if (designation.getDesignationId() == desId) {
                                                        out.print("SELECTED");
                                                    }
                                                %>
                                                ><%= designation.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Organization Unit:</b></td>
                                <td width=350 align="left">&nbsp;<select size="1" id="cmbModOrgUnit" name="cmbModOrgUnit" style="width:200px" align="top" class="psadselect">
                                        <option> </option>

                                        <%
                                            for (int j = 0; j < orgunitlist.size(); j++) {
                                                listorgunit = (OrgUnit) orgunitlist.get(j);

                                        %>
                                        <option class="psadselect option" value="<%=listorgunit.getId()%>"
                                                <%
                                                    if (listorgunit.getId() == uorgunitId) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><%= listorgunit.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Set Primary:</b></td>
                                <td width=350 align="left">&nbsp;<input type="checkbox" value="1" name="chkPrimary" id="chkPrimary" align="top" class="psadtext"
                                                                        <%
                                                                            if (isPrimary == true) {
                                                                                out.print("CHECKED DISABLED");

                                                                            }
                                                                        %>
                                                                        ></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Authority Group:</b></td>
                                <td width=350 align="left">&nbsp;<select size="1" id="cmbAuthGrp" name="cmbAuthGrp" style="width:200px" align="top" class="psadselect">
                                        <option></option>

                                        <%
                                            for (int k = 0; k < authgrplist.size(); k++) {
                                                authgrp = (AuthGrp) authgrplist.get(k);

                                        %>
                                        <option class="psadselect option" value="<%=authgrp.getId()%>"
                                                <%
                                                    if (authgrp.getId() == userauthgrpId) {
                                                        out.print("SELECTED");
                                                    }
                                                %>

                                                ><%= authgrp.getName()%></option>
                                        <%
                                            }
                                        %>
                                    </select>
                                </td>
                            </tr>

                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        <b>Reset User Password</b><br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>New Password:</b></td>
                                <td width=350 align="left">&nbsp;<input type="password" id="txtUPassword" name="txtUPassword" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Confirm Password:</b></td>
                                <td width=350 align="left">&nbsp;<input type="password" id="txtConPassword" name="txtConPassword" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserCreatedDate" name="txtUserCreatedDate" size="30" class="psadview" value="<%=user.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserCreatedBy" name="txtUserCreatedBy" size="30" class="psadview" value="<%=nuserCtrl.getUserNameById(user.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Last Modified Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserModifiedDate" name="txtUserModifiedDate" size="30" class="psadview" value="<%=user.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Last Modified By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtUserModifiedBy" name="txtUserModifiedBy" size="30" class="psadview" value="<%=nuserCtrl.getUserNameById(user.getModifiedBy())%>" readonly></td>
                            </tr>

                            <tr>
                                <td width=150 align="right"><input type="hidden" value="<%=msg%>" name="msg" id="msg" ></input></td>
                                <td width=150 align="left"><input type="hidden" value="<%=user.getFirstName() + user.getMiddleName() + user.getLastName()%>" name="initName" id="initName"></input></td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">
                                    <!-- Update the form name upon submission -->
                                    &nbsp; <input type="button" value="Modify" name="btnSubmit" class="psadbutton" width="100" onclick="fnSubmit()">
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <% }%>
    </body>
</html>
