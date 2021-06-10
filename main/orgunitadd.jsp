<%--
    Document   : orgunitadd
    Created on : Jul 3, 2009, 10:20:12 AM
    Author     : NooNYUki
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@page import = "java.util.*"
        import = "java.lang.*"
        import = "com.bizmann.product.controller.UserController"
        import = "com.bizmann.product.controller.OrgUnitController"
        import = "com.bizmann.product.entity.User"
        import = "com.bizmann.product.entity.OrgUnit" %>

<%
    String parentorgunitId = request.getParameter("orgunitId");
    int parentouId = 0;
    //get the current user name for modified by field.
    String msg = "";
    boolean isDuplicate = false;

    if (parentorgunitId == null || parentorgunitId.equals("0")) {
        parentorgunitId = "0";
        parentouId = 0;
    } else {
        parentouId = Integer.parseInt(parentorgunitId);
        msg = "";
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
        String orgunitName = request.getParameter("orgunitName");
        if (orgunitName == null) {
            orgunitName = "";
        }
        orgunitName = orgunitName.trim();

        String orgunitCode = request.getParameter("txtOrgUnitCode");
        if (orgunitCode == null) {
            orgunitCode = "";
        }
        orgunitCode = orgunitCode.trim();
        
        //get the userid.
        UserController uCtrl = new UserController();
        String modloginid = (String) session.getAttribute("user");
        int moduserId = uCtrl.getUserIdByLoginId(modloginid);

        //update the database
        OrgUnitController orgunitCtrl = new OrgUnitController();
        isDuplicate = orgunitCtrl.isDuplicateOrgUnitNameOrCode(orgunitName, orgunitCode); //isDuplicateOrgUnit(orgunitName);
        if (isDuplicate) {
            msg = "This organization unit name/code already exists.";
        } else {
            msg = "";
            OrgUnit orgunit = new OrgUnit(orgunitName, Integer.parseInt(parentorgunitId));
            orgunit.setCode(orgunitCode);
            orgunitCtrl.addNewOrgUnitWithCode(orgunit, moduserId); //addNewOrgUnit(orgunit, moduserId);
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
            var subtype = "<%=request.getParameter("subtype")%>";
            //var msg = "<%= msg%>";
            var parentouId = "<%=parentouId%>";

            function fnOnLoad(){
                if(document.getElementById("msg").value != "" && document.getElementById("msg").value != "null"){
                    parent.frames.alertMessage(document.getElementById("msg").value);
                }

                else if(action == "add"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "orgunit.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "orgunit.jsp?type="+type+"&subtype="+subtype;
                    }
                }
       
            }

            function formValidated(){
                if(document.getElementById("txtOrgUnitName").value == ""){
                    parent.frames.alertMessage("Please enter org unit name.");
                    return false;
                }
                else if((document.getElementById("txtOrgUnitName").value).length > 100){
                    parent.frames.alertMessage("Please enter a name with 100 characters or less.");
                    document.getElementById("txtOrgUnitName").value = "";
                    return false;
                }
                else{

                    return true;
                }
            }

            function fnSubmit(){
                if(formValidated() == true){
                    //get the form data
                    var orgunitName = fnURLEncode(document.getElementById("txtOrgUnitName").value);
                    var orgUnitCode = fnURLEncode(document.getElementById("txtOrgUnitCode").value);
                    var orgunitId = "<%=request.getParameter("orgunitId")%>";
                    //update the form in the database
                    document.location.href = "orgunitadd.jsp?type="+type+"&subtype="+subtype+"&action=add&orgunitName="+ orgunitName+"&orgunitId="+orgunitId+"&txtOrgUnitCode="+orgUnitCode;
                }
            }
        </script>
    </head>
    <body onload="fnOnLoad()" class="yui-skin-sam" background="../images/background.png" >
        <!-- alert message -->
        <div align="center" valign="top">
            <table>
                <tr>
                    <td class="orgtable" valign="top" align="center">
                        <br><table cellpadding="0">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>
                                        Add Organization Unit<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Unit Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitName" name="txtOrgUnitName" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Unit Code:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitCode" name="txtOrgUnitCode" size="30" class="psadtext"></td>
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
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>

