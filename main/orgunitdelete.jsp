<%--
    Document   : orgunitdelete
    Created on : Jul 9, 2009, 6:00:25 PM
    Author     : NooNYUki
--%>

<%@page import = "java.util.*"
    import = "java.lang.*"
    import = "com.bizmann.product.controller.OrgUnitController"
    import = "com.bizmann.product.controller.UserOUDesignationController"
    import = "com.bizmann.product.controller.OrgChartController"
    import = "com.bizmann.product.controller.UserController"
    import = "com.bizmann.product.entity.OrgUnit"
    import = "com.bizmann.product.resources.ResourceUtil" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%
        String orgunitId = request.getParameter("orgunitId");
        int ouId = 0;
        String msg="";
        boolean orgHasUsers = true;

        if (orgunitId == null || orgunitId.equals("0")) {
            orgunitId = "0";
            ouId = 0;
            msg = "Please select a designation to delete.";
        } else {
            ouId = Integer.parseInt(orgunitId);
            msg = "";
        }

        String action = request.getParameter("action");
        if(action == null){
            action = "";
        }

        if(action.equals("delete")){
            //get the current type and subtype
            String type = request.getParameter("type");
            String subtype = request.getParameter("subtype");

           //check if the unit or any of its grand child or child has users.
            OrgUnitController orgunitCtrl = new OrgUnitController();
            UserOUDesignationController useroudesignationCtrl = new UserOUDesignationController();
            orgHasUsers = useroudesignationCtrl.userAssignedtoOrgUnit(Integer.parseInt(orgunitId));
            
            ArrayList firstChildList = orgunitCtrl.getChildOrgUnit(Integer.parseInt(orgunitId));
            if (orgHasUsers == false){

                for(int i=0; i<firstChildList.size(); i++){
                    OrgUnit firstlorgunit = (OrgUnit) firstChildList.get(i);
                    orgHasUsers = useroudesignationCtrl.userAssignedtoOrgUnit(firstlorgunit.getId());
                    
                    if (orgHasUsers){
                        break;
                    }
                    ArrayList secondChildList = orgunitCtrl.getChildOrgUnit(firstlorgunit.getId());
                    for(int j=0; j<secondChildList.size(); j++){
                        OrgUnit secondlorgunit = (OrgUnit) secondChildList.get(j);
                        orgHasUsers = useroudesignationCtrl.userAssignedtoOrgUnit(secondlorgunit.getId());
                        if (orgHasUsers){
                            break;
                        }
                        ArrayList thirdChildList = orgunitCtrl.getChildOrgUnit(secondlorgunit.getId());
                        for(int k=0; k<thirdChildList.size(); k++){
                            OrgUnit thirdlorgunit = (OrgUnit) thirdChildList.get(k);
                            orgHasUsers = useroudesignationCtrl.userAssignedtoOrgUnit(thirdlorgunit.getId());
                            if(orgHasUsers){
                                break;
                            }
                            ArrayList fourthChildList = orgunitCtrl.getChildOrgUnit(thirdlorgunit.getId());
                            for(int l=0; l<fourthChildList.size(); l++){
                                OrgUnit fourthlorgunit = (OrgUnit) fourthChildList.get(l);
                                orgHasUsers = useroudesignationCtrl.userAssignedtoOrgUnit(fourthlorgunit.getId());
                                if(orgHasUsers){
                                    break;
                                }
                                ArrayList fifthChildList = orgunitCtrl.getChildOrgUnit(fourthlorgunit.getId());
                                for(int m=0; m<fifthChildList.size(); m++){
                                    OrgUnit fifthlorgunit = (OrgUnit) fifthChildList.get(m);
                                    orgHasUsers = useroudesignationCtrl.userAssignedtoOrgUnit(fifthlorgunit.getId());
                                    if(orgHasUsers){
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
             }


            UserController nuCtrl = new UserController();
            String modloginid = (String) session.getAttribute("user");
            int moduserId = nuCtrl.getUserIdByLoginId(modloginid);


            if (orgHasUsers){
                msg = "This organization unit or its child unit(s) is currently in use.";
                
            }
            else{
                msg = "";
                orgunitCtrl.deleteOrgUnitById(Integer.parseInt(orgunitId),moduserId);
                for(int n=0; n< firstChildList.size(); n++){
                    OrgUnit firstorgtodel = (OrgUnit)firstChildList.get(n);
                    orgunitCtrl.deleteOrgUnitById(firstorgtodel.getId(), moduserId);
                    ArrayList secondChildtoDel = orgunitCtrl.getChildOrgUnit(firstorgtodel.getId());
                    for(int o=0; o<secondChildtoDel.size(); o++){
                        OrgUnit secondorgtodel = (OrgUnit)secondChildtoDel.get(o);
                        orgunitCtrl.deleteOrgUnitById(secondorgtodel.getId(), moduserId);
                        ArrayList thirdChildtoDel = orgunitCtrl.getChildOrgUnit(secondorgtodel.getId());
                        for(int p=0; p<thirdChildtoDel.size(); p++){
                            OrgUnit thirdorgtodel = (OrgUnit)thirdChildtoDel.get(p);
                            orgunitCtrl.deleteOrgUnitById(thirdorgtodel.getId(), moduserId);
                            ArrayList fourthChildtoDel = orgunitCtrl.getChildOrgUnit(thirdorgtodel.getId());
                            for(int q=0; q<fourthChildtoDel.size(); q++){
                                OrgUnit fourthorgtodel = (OrgUnit)fourthChildtoDel.get(q);
                                orgunitCtrl.deleteOrgUnitById(fourthorgtodel.getId(), moduserId);
                                ArrayList fifthChildtoDel = orgunitCtrl.getChildOrgUnit(fourthorgtodel.getId());
                                for(int r=0; r<fifthChildtoDel.size(); r++){
                                    OrgUnit fifthorgtodel = (OrgUnit)fifthChildtoDel.get(r);
                                    orgunitCtrl.deleteOrgUnitById(fifthorgtodel.getId(), moduserId);
                                }
                            }
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
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />

        <script>

            var formName;
            var designationId;
            var action = "<%=request.getParameter("action")%>";
            var type = "<%=request.getParameter("type")%>";
            var subtype = "<%=request.getParameter("subtype")%>";
            var msg = "<%= msg%>";
            var ouId = "<%=ouId%>";

            function fnOnLoad(){
                if(msg != "" && msg != null){
                    if(ouId == "0"){
                      //  Leave it blank;
                    }
                    else
                    {    parent.frames.alertMessage(msg);    }
                }
                else if(action == "delete"){
                    //redirect the user
                    if(subtype == "null"){
                        parent.document.location.href = "orgunit.jsp?type="+type;
                    }
                    else{
                        parent.document.location.href = "orgunit.jsp?type="+type+"&subtype="+subtype;
                    }
                }
            }


            function fnOrgDelete(){
                parent.frames.promptMessage(type, subtype, "delete", "Are you sure you want to delete this organization unit?");
                
            }

        </script>
    </head>
    <body onload="fnOnLoad()" background="../images/background.png">
        <% if (orgunitId.equals("") || orgunitId.equals("0") || ouId == 0) {%>
            <!-- Leave it blank -->
        <%} else {
            OrgUnitController orgunitCtrl = new OrgUnitController();
            OrgUnit orgunit = orgunitCtrl.getOrgUnitById(Integer.parseInt(orgunitId));
            UserController uCtrl = new UserController();
            OrgChartController orgchartCtrl = new OrgChartController();
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
                                        Delete Organization Unit<br><br>
                                </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitId" name="txtOrgUnitId" size="30" class="psadview" value="OU<%=ResourceUtil.getVersionFormat(orgunit.getId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Code:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitCode" name="txtOrgUnitCode" size="30" class="psadview" value="<%=orgunit.getCode()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Name:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitName" name="txtOrgUnitName" size="30" class="psadview" value="<%=orgunit.getName()%>"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Manager:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitManager" name="txtOrgUnitManager" size="30" class="psadview" value="<%=uCtrl.getUserNameById(orgunit.getManager())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Parent Org Unit:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitParentId" name="txtOrgUnitName" size="30" class="psadview" value="<%=orgunitCtrl.getOUNameById(orgunit.getParentId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Organization Chart:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitOrgChartId" name="txtOrgUnitOrgChartId" size="30" class="psadview" value="<%=orgchartCtrl.getOCNameById(orgunit.getOrgChartId())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitCreatedDate" name="txtOrgUnitCreatedDate" size="30" class="psadview" value="<%=orgunit.getCreatedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Created By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitCreatedBy" name="txtOrgUnitCreatedBy" size="30" class="psadview" value="<%=uCtrl.getUserNameById(orgunit.getCreatedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified Date:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitModifiedDate" name="txtOrgUnitModifiedDate" size="30" class="psadview" value="<%=orgunit.getModifiedDate()%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Modified By:</b></td>
                                <td width=350 align="left">&nbsp;<input type="text" id="txtOrgUnitModifiedBy" name="txtOrgUnitModifiedBy" size="30" class="psadview" value="<%=uCtrl.getUserNameById(orgunit.getModifiedBy())%>" readonly></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><input type="hidden" value="<%=msg%>" name="msg" id="msg" ></input></td>
                                <td width=350 align="left"><input type="hidden" value="<%=orgunit.getName()%>" name="initName" id="initName"></input></td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">&nbsp;</td>
                            </tr>
                            <tr>
                                <td width=150 align="right">&nbsp;</td>
                                <td width=350 align="left">
                                    <!-- Update the form name upon submission -->
                                     &nbsp;<input type="button" value="Delete" name="btnoDelete" class="psadbutton" width="100" onclick="fnOrgDelete()"></input>
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
