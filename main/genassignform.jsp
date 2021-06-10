<%-- 
    Document   : assigngenform
    Created on : Nov 29, 2013, 10:08:17 AM
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
<!DOCTYPE html>
<%
    String strflowChartId = request.getParameter("flowChartId");
    if (strflowChartId == null) {
        strflowChartId = "0";
    }
    strflowChartId = strflowChartId.trim();
    if (strflowChartId.equals("")) {
        strflowChartId = "0";
    }
    int flowChartId = Integer.parseInt(strflowChartId);
    if (flowChartId == 0) {
        return;
    }
    GenAssignController gasCtrl = new GenAssignController();
    ArrayList<GenHeader> genList = gasCtrl.getAllGensUnassigned();
    ArrayList<GenControl> gcList = gasCtrl.getGenControlByFlowChartId(flowChartId);
    ArrayList<GenControl> actreList = gasCtrl.getActionUnassigned(flowChartId);
    int count = 1;
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="../include/jquery-ui-1.10.3.custom/js/jquery-1.9.1.js"></script>
        <script type="text/javascript" src="../include/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"></script>
        <script type="text/javascript" src="../include/js/main.js"></script>
        <script type="text/javascript" src="../include/js/genassign.js"></script>
        <!--        <link href="../include/css/demo.css" rel="stylesheet"></link>-->
        <link href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet"></link>
        <!--        <link href="../include/jquery-ui-1.10.3.custom/css/redmond/jquery-ui-1.10.3.custom.css" rel="stylesheet"></link>-->
        <link href="../include/css/formlibrary.css" rel="stylesheet"></link>
        <title>Assign Auto Gen. No. to Form</title>
        <script type="text/javascript">
            function fnDoBack(){
                document.location.href="gen.jsp";
            }
        </script>
    </head>
    <body background="../images/background.png" style="width:650px">
        <br><br>
        <div align="center" valign="top">
            <table>
                <tr>
                    <td>
                        <table align="center" class="ui-widget ui-widget-content" style="width:90%;">  
                            <thead>
                                <tr class="ui-widget-header" id="mainHeader" style="background-color: #0B0B61" >                
                                    <td colspan="6">
                                        <span style="text-align:left; vertical-align: bottom">Auto Gen. No. List</span>
                                    </td>
                                </tr>           
                                <tr class="demoHeaders">
                                    <th><b>Auto Gen #</b></th>
                                    <th><b>Action (Activity)</b></th>
                                    <th><b>Response Made</b></th>
                                    <th><b>Last Generated No.</b></th>
                                    <th><b>Last Generated On</b></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%if (gcList != null) {
                                        for (GenControl gControl : gcList) {%>      
                                <tr id="<%=count%>" onclick="HighLightTR(this,'#C0C0C0');" onmouseover="fnChangePointer(this)">   
                                    <td ><%=gControl.getGen_name()%></td>
                                    <td ><%=gControl.getAction_name()%></td>
                                    <td ><%=gControl.getResponse_name()%></td>
                                    <td ><%=gControl.getLast_id()%></td>
                                    <td ><%=gControl.getLast_gen()%></td>                            
                                    <td>
                                        <button style="text-align:right; float:right; font-size: 70%" id="btnDelete_<%=count%>" class="btnDelete"  onclick="fnseteditval(<%=gControl.getId()%>,this,<%=count%>);">Delete</button>
                                    </td>
                                </tr> 
                                <% count += 1;
                                        }
                                    }%>                
                            <input type="hidden" name="editid" id="editid" value="0" />  
                            </tbody>
                            <tfoot>
                                <tr><td colspan="6"><button style="text-align:right; float:right; font-size: 70%" id="btnAdd">Add New</button></td></tr>
                            </tfoot>
                        </table>
                        <div id="dialog-form" title="Add New">            
                            <form name="addForm" action="genassignformActions.jsp" method="post" >
                                <label for="type">Auto Gen. No.
                                </label>
                                <input type="hidden" id="type" name="type" value="Design" />
                                <input type="hidden" id="subtype" name="subtype" value="flowchartlibrary" />
                                <select size="1" id="cbGen" name="cbGen" class="text ui-widget-content ui-corner-all">
                                    <option value="0"></option>
                                    <%
                                        for (int i = 0; i < genList.size(); i++) {
                                            GenHeader gHeader = (GenHeader) genList.get(i);
                                    %>
                                    <option value="<%=gHeader.getId()%>"><%=gHeader.getGen_name()%></option>
                                    <%}%>
                                </select>
                                <br/>
                                <label for="type">Generate at</label>
                                <select size="1" id="cbActRes" name="cbActRes" class="text ui-widget-content ui-corner-all">
                                    <option value="0_0_0"></option>
                                    <%
                                        for (int a = 0; a < actreList.size(); a++) {
                                            GenControl tmpGC = actreList.get(a);
                                            String tmpValue = flowChartId + "_" + tmpGC.getAction_id() + "_" + tmpGC.getResponse_id();
                                            String tmpDesc = tmpGC.getAction_name() + " - " + tmpGC.getResponse_name();
                                    %>
                                    <option value="<%=tmpValue%>"><%=tmpDesc%></option>
                                    <% }%>
                                </select>
                                <br/>
                                <input type="hidden" name="mode" id="mode" value="add" />
                            </form>
                        </div>        

                        <div id="dialog-message" title="No Row Selected">
                            <p>
                                <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
                                Please select a row.
                            </p>
                        </div> 

                        <!-- <div id="dialog-edit-form" title="Edit">            
                            <form name="editForm" method="post">
                                <label for="type">Name</label>
                                <input  type="text" name="txtGenName" id="txtGenName" class="text ui-widget-content ui-corner-all" maxlength="100" style="width:90%" />
                                <label for="type">No. of Digit</label>
                                <input  type="number" name="txtGenDigit" id="txtGenDigit" class="text ui-widget-content ui-corner-all" maxlength="100" style="width:90%" />
                                <label for="type">Start No.</label>
                                <input  type="number" name="txtGenStart" id="txtGenStart" class="text ui-widget-content ui-corner-all" maxlength="100" style="width:90%" />
                    
                                <input type="hidden" name="mode" id="mode" value="edit" />
                                <input type="hidden" name="id" id="id"  />
                            </form>
                        </div> -->

                        <div id="dialog-confirm" title="Delete">
                            <form name="deleteForm">
                                <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>These item will be permanently deleted. Are you sure you want to delete?</p>
                                <input type="hidden" name="mode" id="mode" value="delete" />
                                <input type="hidden" name="id" id="id"  />
                            </form>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>
