<%--
   Document   : setabsence
   Created on : Jul 7, 2009, 4:38:39 PM
   Author     : Hnaye
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>
<%@page import="com.bizmann.product.controller.*"
        import="com.bizmann.product.resources.*"
        import="com.bizmann.component.cryptography.DesEncrypter"
        import="com.bizmann.product.entity.*"
        import="com.bizmann.product.resources.MailUtil"
        import="java.util.*"
        import="java.lang.*"
        import="java.io.*"
        import="java.lang.Math"
        import="java.sql.Blob"
        import="java.util.Map"
        import="java.util.Iterator"
        %>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Flo'</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/calendar/assets/skins/sam/calendar.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/calendar.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <script type="text/javascript" src="../include/js/yui/calendar/calendar-min.js"></script>
        <script type="text/javascript" src="../include/js/url.js"></script>
        <style type="text/css">
            .icon-form { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }

            .treediv{
                position: relative;
                text-align: left;
            }

            .orgtable {
                border-left:1px solid #cbcbcb;
                border-right:1px solid #cbcbcb;
                border-top:1px solid #cbcbcb;
                border-bottom:1px solid #cbcbcb;
                border:1px solid #cbcbcb;
            }
        </style>
    </head>

    <%
        boolean isAbsent = false;
        Absence absence = new Absence();
        AbsenceController abCtrl = new AbsenceController();
        OrgUnitController orgUnitCtrl = new OrgUnitController();

        username = userCtrl.getUserNameByLoginId(loginid);
        user = userCtrl.getUserByLoginId(loginid);
        isAbsent = abCtrl.checkAbsenceByUserId(user.getUserId());
        if (isAbsent) {
            absence = abCtrl.getAbsenceByDesignate(user.getUserId());
        } else {
            absence.setId(0);
            absence.setDesignate(0);
            absence.setDesignated(0);
            absence.setStartdate("");
            absence.setEnddate("");
            absence.setMessage("");
            absence.setOrgunitid(0);
            absence.setStatus(0);
        }


        String msg = "";
        String action = request.getParameter("action");
        String compEditability = "";

        String orgUnitId = request.getParameter("orgUnitId");
        if (orgUnitId == null) {
            orgUnitId = "0";
        }
        if (absence.getStatus() == 1) {
            orgUnitId = "" + absence.getOrgunitid();
            compEditability = "disabled";
        }

        String assignToId = request.getParameter("assignToId");
        if (assignToId == null) {
            assignToId = "0";
        }
        if (absence.getStatus() == 1) {
            assignToId = "" + absence.getDesignated();
        }

        String isAbsenceCheck = request.getParameter("isAbsenceCheck");
        if (isAbsenceCheck == null) {
            isAbsenceCheck = "false";
        }

        String sDate = request.getParameter("sDate");
        if (sDate == null) {
            sDate = "";
        }

        String eDate = request.getParameter("eDate");
        if (eDate == null) {
            eDate = "";
        }

        String strMsg = request.getParameter("strMsg");
        if (strMsg == null) {
            strMsg = "";
        }

        String type = request.getParameter("type");
        String subtype = request.getParameter("subtype");
        boolean update = false;



        boolean designatedIsAbsent = false;

        OrgUnitController orgCtrl = new OrgUnitController();
        if (action != null) {
            if (action == "" || action.equals("")) {
                action = "";
            } else if (action.equals("save")) {
                String message = request.getParameter("message");
                String startDate = request.getParameter("startDate");
                String endDate = request.getParameter("endDate");
                String designated = request.getParameter("designated");
                String orgunit = request.getParameter("orgunit");
                String status = request.getParameter("status");
                String[] tempStr = designated.split("\\_n");
                String email = tempStr[0];
                int designatedId = Integer.parseInt(tempStr[1]);
                //check whether the designated person is absent during that period.
                designatedIsAbsent = abCtrl.isAbsentinthisTime(designatedId, startDate, endDate);

                if (designatedIsAbsent == false) {
                    if (abCtrl.saveAbsence(user.getUserId(), designatedId, startDate, endDate, message, Integer.parseInt(status), Integer.parseInt(orgunit))) {
                        msg = "Set Absence Successfully";
                        session.setAttribute("msg", msg);
                        String designatedEmail = userCtrl.getEmailByUserId(designatedId);
                        //String designatedEmail = "soehtaike92@gmail.com";
                        String designateUserName = userCtrl.getUserNameById(user.getUserId());
                        MailUtil mailUtil = new MailUtil();
                        String emailMsg = "You are assigned from " + startDate + " to " + endDate + " by " + designateUserName + ". \n " + message;
                        mailUtil.sendMail(designatedEmail, "Set Absence", emailMsg);

                    }
                } else {
                    msg = "The designated is absent during this period.";
                    session.setAttribute("msg", msg);
                    status = "";
                    session.setAttribute("status", status);
                }
            } else if (action.equals("update")) {
                sDate = request.getParameter("sDate");
                eDate = request.getParameter("eDate");
                strMsg = request.getParameter("strMsg");
                String status = request.getParameter("status");
                String designated = request.getParameter("designated");
                String[] tempStr = designated.split("\\_n");
                String email = tempStr[0];
                int designatedId = Integer.parseInt(tempStr[1]);
                if (abCtrl.updateAbsence(user.getUserId(), Integer.parseInt(status), designatedId)) {
                    msg = "Unset Absence Successfully!";
                    update = true;
                }
            }
        }

    %>
    <script type="text/javascript">
        javascript:window.history.forward(1);

        var action = "<%=request.getParameter("action")%>";
        var displaymsg = "<%=msg%>"
        var type = "<%=request.getParameter("type")%>";
        var subtype = "<%=request.getParameter("subtype")%>";
        var deptId = "<%=request.getParameter("deptId")%>"

        function fnLoad(){
            if(document.getElementById("msg").value != "" && document.getElementById("msg").value != "null"){


                alert(document.getElementById("msg").value);
                document.getElementById("msg").value = "";

            }
            if(action == "update" || action == "save"){
                parent.document.location.href = "setabsence.jsp?type="+type+"&subtype="+subtype;
            }
        }

        function fnUpdate(){

            isAbsenceCheck = document.getElementById("absence").checked;
            startDate = document.getElementById("txtStartDate").value;
            endDate = document.getElementById("txtEndDate").value;
            message = fnURLEncode(document.getElementById("txtMessage").value);
            designated = document.getElementById("Designated").value;
            orgunit = document.getElementById("organization").value;

            if(isAbsenceCheck == true){
                if(fnCheckMandatoryFields()== true){
                    var status = 1;
                    document.getElementById("btnOK").disabled = true;
                    parent.document.location.href = "setabsence.jsp?type="+type+"&subtype="+subtype+"&action=save&isAbsenceCheck="+isAbsenceCheck+"&startDate="+startDate+"&endDate="+endDate+"&designated="+designated+"&message="+message+"&orgunit="+orgunit+"&status="+status;
                }
            }
            else{
                if(fnCheckMandatoryFieldsForUnset()){
                    status = 0;
                    parent.document.location.href = "setabsence.jsp?type="+type+"&subtype="+subtype+"&action=update&isAbsenceCheck="+isAbsenceCheck+"&status="+status+"&designated="+designated+"&sDate="+startDate+"&eDate="+endDate+"&strMsg="+message;
                }
            }
        }

        function DateCompare(startDate, endDate) {

            
            //var strStartDate = startDate.value;
            //var strEndDate = endDate.value;
            var startDateSplit = startDate.split('/');
            var endDateSplit = endDate.split('/');
            
            if(startDateSplit[2]<endDateSplit[2]){
                return true;
            }
            else if(startDateSplit[2]==endDateSplit[2]){
                if(startDateSplit[1]<endDateSplit[1]){
                    return true;
                }
                else if(startDateSplit[1]>endDateSplit[1]){
                    return false;
                }
                else{
                    if(startDateSplit[0]<endDateSplit[0] || startDateSplit[0]==endDateSplit[0]){
                        return true;
                    }
                    else{
                        return false;
                    }
                }
            }
            else{
                return false;
            }
        }

        function fncheckMsg(){
            var msg = document.getElementById("txtMessage").value;
            alert(msg);
            if(msg=="" || msg==null){
                return false;
            }
            else{
                return true;
            }
        }


        function fnCheckMandatoryFields(){
            if(document.getElementById("status").value == "0" && document.getElementById("absence").checked == false){
                parent.frames.alertMessage("To set absence, please check on Set Absence. ");
                return false;
            }
            else if(document.getElementById("organization").value == ""){
                parent.frames.alertMessage("Please select Organization. ");
                return false;
            }
            else if(document.getElementById("Designated").value == ""){
                parent.frames.alertMessage("Please select Assign To. ");
                return false;
            }
            else if(document.getElementById("txtStartDate").value==""){
                parent.frames.alertMessage("Please select Start Date");
                return false;
            }
            else if(document.getElementById("txtEndDate").value==""){
                parent.frames.alertMessage("Please select End Date");
                return false;
            }
            else if(!DateCompare(document.getElementById("txtStartDate").value,document.getElementById("txtEndDate").value)){
                parent.frames.alertMessage("Start Date Cannot be later than End Date");
                return false;
            }
            else if(!ValidateDate(document.getElementById("txtStartDate"))){
                parent.frames.alertMessage("Please select Start Date again");
                return false;
            }
            else if(!ValidateDate(document.getElementById("txtEndDate"))){
                parent.frames.alertMessage("Please select End Date again");
                return false;
            }
            else if(document.getElementById("txtMessage").value=="" || document.getElementById("txtMessage").value==null){

                parent.frames.alertMessage("Please enter Message");
                return false;
            }
            return true;
        }

        function fnCheckMandatoryFieldsForUnset(){
            if(document.getElementById("status").value == "0" && document.getElementById("absence").checked == false){
                parent.frames.alertMessage("To set absence, please check on Set Absence. ");
                return false;
            }
            else if(document.getElementById("organization").value == ""){
                parent.frames.alertMessage("Please select Organization. ");
                return false;
            }
            else if(document.getElementById("Designated").value == ""){
                parent.frames.alertMessage("Please select Assign To. ");
                return false;
            }
            else if(document.getElementById("txtStartDate").value==""){
                parent.frames.alertMessage("Please select Start Date");
                return false;
            }
            else if(document.getElementById("txtEndDate").value==""){
                parent.frames.alertMessage("Please select End Date");
                return false;
            }
            else if(!DateCompare(document.getElementById("txtStartDate").value,document.getElementById("txtEndDate").value)){
                parent.frames.alertMessage("Start Date Cannot be later than End Date");
                return false;
            }
            else if(document.getElementById("txtMessage").value=="" || document.getElementById("txtMessage").value==null){

                parent.frames.alertMessage("Please enter Message");
                return false;
            }
            return true;
        }

        function fnUpdateValues(combo){
            orgUnitId= combo.value;
            isAbsenceCheck = document.getElementById("absence").checked;


            startDate = document.getElementById("txtStartDate").value;
            endDate = document.getElementById("txtEndDate").value;
            message = document.getElementById("txtMessage").value;

            document.location.href = "setabsence.jsp?type="+type+"&subtype="+subtype+"&isAbsenceCheck="+isAbsenceCheck+"&action=updateou&orgUnitId="+orgUnitId+"&sDate="+startDate+"&eDate="+endDate+"&strMsg="+message;
        }

        function ValidateDate(date)
        {
            var varDate=date;
            var enterDate = varDate.value;
            var today = document.getElementById("date").value;
            var todaySplit = today.split('/');
            var enterDateSplit = enterDate.split('/');
            if(enterDateSplit[2]<todaySplit[2]){
                return false;
            }
            else if(enterDateSplit[2]==todaySplit[2]){
                if(enterDateSplit[1]<todaySplit[1]){
                    return false;
                }
                else if(enterDateSplit[1]>todaySplit[1]){
                    return true;
                }
                else{
                    if(enterDateSplit[0]<todaySplit[0]){
                        return false;
                    }
                    else{
                        return true;
                    }
                }
            }
            else{
                return true;
            }
           
        }
    </script>
    <body onload="fnLoad()" class="yui-skin-sam">
        <%
            if (update == true) {
                absence = abCtrl.getLastUpdateAbsenceByDesignate(user.getUserId());
            }
        %>
        <div align="center">
            <table border="0" width="980px" height="420px" align="center" background="../images/background.png">
                <tr>
                    <td colspan="2">
                        <div class="psadtitle">
                            <br>
                            Set Absence<br><br>
                        </div>
                    </td>
                </tr>

                <tr>
                    <td width=373 align="right"><b>Name:</b></td>
                    <td width=597 align="left"><input type="text" name="txtUserName" class="psadview" value="<%=username%>" size="20" readonly="readonly" /></td>
                </tr>
                <tr>
                    <td width=373 align="right"><b>Set Absence: </b></td>
                    <td width=597 align="left">
                        <%if (absence.getStatus() == 1) {%>
                        <input type="checkbox" id="absence" value="absence" checked>
                        <% } else if (isAbsenceCheck.equals("true")) {%>
                        <input type="checkbox" id="absence" value="absence" checked>
                        <%} else if (absence.getStatus() == 0) {%>
                        <input type="checkbox" id="absence" value="absence">
                        <%} else {%>
                        <input type="checkbox" id="absence" value="absence">
                        <%}%>
                    </td>
                </tr>
                <tr>
                    <td width=373 align="right"><b>Organization:</b></td>
                    <td width=597 align="left">
                        <select name="organization" id="organization" onchange="fnUpdateValues(this)" <%=compEditability%> >
                            <option value=""></option>
                            <%
                                ArrayList orgList = new ArrayList();
                                orgList = orgCtrl.getOrgUnitName();
                                Iterator org = orgList.iterator();
                                while (org.hasNext()) {
                                    OrgUnit orgUnit = (OrgUnit) (org.next());
                            %>
                            <%
                                if (Integer.parseInt(orgUnitId) == (orgUnit.getId())) {%>
                            <option value="<%=orgUnit.getId()%>" selected><%=orgUnit.getName()%></option>
                            <%} else {%>
                            <option value="<%=orgUnit.getId()%>"><%=orgUnit.getName()%></option>
                            <%}%>
                            <% }%>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td width=373 align="right"><b>Assign To:</b></td>
                    <td width=597 align="left"><select class="psadtext" name="Designated" id="Designated" <%=compEditability%> >
                            <option value=""></option>
                            <%
                            //System.out.println(user.getUserId());
                            //System.out.println(orgUnitId);
                                ArrayList userList = orgUnitCtrl.getOrgUsersbyDeptId(user.getUserId(), Integer.parseInt(orgUnitId));
                                Iterator res = userList.iterator();

                                while (res.hasNext()) {
                                    User orgUser = (User) (res.next());
                                    if (orgUser.getUserId() == Integer.parseInt(assignToId)) {
                            %>
                            <option value="<%=orgUser.getEmail()%>_n<%=orgUser.getUserId()%>" selected><%=orgUser.getFullName()%></option>
                            <%} else {%>
                            <option value="<%=orgUser.getEmail()%>_n<%=orgUser.getUserId()%>"><%=orgUser.getFullName()%></option>
                            <%}%>
                            <%}%>

                        </select></td>
                </tr>

                <tr>
                    <td width=373 align="right"><b>Start Date:</b></td>
                    <td width=597 align="left">
                        <%if (absence.getStatus() == 1) {%>
                        <input class="psadview" type="text" id="txtStartDate" name="txtStartDate" size="10" readonly="readonly" value="<%=absence.getStartdate()%>" >
                        <input type="hidden" id="sDate" name="sDate" value="<%=absence.getStartdate()%>">
                        <!--<img class="menubutton" src="images/calendar.png" onClick="newWindow('txtStartDate','')" >-->
                        <%} else if (update == true) {%>
                        <input class="psadtext" type="text" id="txtEndDate" name="txtEndDate" size="10" readonly="readonly" value="<%=absence.getStartdate()%>" >
                        <img class="menubutton" src="../images/calendar.png" onClick="newWindow('txtEndDate','')" >
                        <%} else {%>
                        <input class="psadtext" type="text" id="txtStartDate" name="txtStartDate" size="10" readonly="readonly" value="<%=sDate%>">
                        <img class="menubutton" src="../images/calendar.png" onClick="newWindow('txtStartDate','')">
                        <%}%>

                </tr>
                <tr>
                    <td width=373 align="right"><b>End Date:</b></td>
                    <td width=597 align="left">
                        <%if (absence.getStatus() == 1) {%>
                        <input class="psadview" type="text" id="txtEndDate" name="txtEndDate" size="10" readonly="readonly" value="<%=absence.getEnddate()%>" >
                        <input type="hidden" id="eDate" name="eDate" value="<%=absence.getEnddate()%>">
                        <!--<img class="menubutton" src="images/calendar.png" onClick="newWindow('txtEndDate','')">-->
                        <%} else if (update == true) {%>
                        <input class="psadtext" type="text" id="txtEndDate" name="txtEndDate" size="10" readonly="readonly" value="<%=absence.getEnddate()%>" >
                        <img class="menubutton" src="../images/calendar.png" onClick="newWindow('txtEndDate','')">
                        <%} else {%>
                        <input class="psadtext" type="text" id="txtEndDate" name="txtEndDate" size="10" readonly="readonly" value="<%=eDate%>">
                        <img class="menubutton" src="../images/calendar.png" onClick="newWindow('txtEndDate','')">
                        <%}%>

                </tr>
                <tr>
                    <td width=373 align="right"><b>Message:</b></td>
                    <td width=597 align="left">
                        <%if (absence.getStatus() == 1) {%>
                        <textarea class="psadview" name="txtMessage" id="txtMessage" rows="4" cols="40" align="left" readonly><%=absence.getMessage()%></textarea>
                        <input type="hidden" name="strMsg" value="<%=absence.getMessage()%>">
                        <%} else if (update == true) {%>
                        <textarea name="txtMessage" id="txtMessage" rows="4" cols="40" align="left"><%=absence.getMessage()%></textarea>

                        <%} else {%>
                        <textarea name="txtMessage" id="txtMessage" rows="4" cols="40" align="left" ><%=strMsg%></textarea>
                        <%}%>
                    </td>
                </tr>
                <tr>
                    <td><input type ="hidden" name="date" id="date" value="<%=DateUtil.getCurrentDateJS()%>"></td>
                    <td width=597 align="left">&nbsp;</td>
                </tr>

                <tr>
                    <td width=373 align="right">&nbsp;</td>
                    <td width=597 align="left">&nbsp;</td>
                </tr>

                <tr>
                    <td width=373 align="right"></td>
                    <td width=597 align="left">
                        <input type="button" width="100" class="psadbutton" value="Submit" id="btnOK" name="btnOK" onclick="fnUpdate()"/>&nbsp
                    </td>
                </tr>


                <tr>
                    <td width=373 align="right">&nbsp;</td>
                    <td width=597 align="left">&nbsp;</td>
                </tr>

                <tr>
                    <td width=373 align="right">&nbsp;</td>
                    <td width=597 align="left">&nbsp;</td>
                </tr>

            </table>
            <input type="hidden" value="<%=msg%>" name="msg" id="msg" >
            <input type="hidden" value="<%=update%>" name="update" id="update" >
            <input type="hidden" value="<%=absence.getStatus()%>" name="status" id="status" >
        </div>
        <script>
            function y2k(number)    { return (number < 1000) ? number + 1900 : number; }
            function padout(number) { return (number < 10) ? '0' + number : number; }
            var today = new Date();
            var day = today.getDate(), month = today.getMonth(), year = y2k(today.getYear());
            var todayFormat = padout(day) + "/" + padout(month-0+1) + "/" + year;
            var whichOne = "";
            var count=0;

            function newWindow(number,end) {
                whichOne = number;
                endDate=end;
                mywindow=open('../include/cal.htm','myname','resizable=no,width=220,height=180');
                mywindow.location.href = '../include/cal.htm';
                if (mywindow.opener == null) mywindow.opener = self;
            }

            function restart() {
                var period;
                document.getElementById(whichOne).value = '' + padout(day) + '/' + padout(month - 0 + 1) + '/' + year;
                mywindow.close();

                if (endDate!=""){
                    year = parseInt(year) +1;
                    document.getElementById(endDate).value = '' + padout(day) + '/' + padout(month - 0 + 1) + '/' + year;
                }
            }
        </script>


    </body>
</html>
<%@ include file="../include/footer.jsp" %>
