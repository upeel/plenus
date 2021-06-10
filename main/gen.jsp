<%-- 
    Document   : gen
    Created on : Nov 15, 2013, 2:47:53 PM
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
    GenController genCtrl = new GenController();
    ArrayList<GenHeader> gList = genCtrl.getAllGens();
    String eid = "";
    int count = 1;
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Auto Gen No List</title>
        <script type="text/javascript" src="../include/jquery-ui-1.10.3.custom/js/jquery-1.9.1.js"></script>
        <script type="text/javascript" src="../include/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.js"></script>
        <script type="text/javascript" src="../include/js/main.js"></script>
        <script type="text/javascript" src="../include/js/genheader.js"></script>
        <link href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" rel="stylesheet"></link>
        <!--        <link href="../include/jquery-ui-1.10.3.custom/css/redmond/jquery-ui-1.10.3.custom.css" rel="stylesheet"></link>-->
        <!--        <link href="../include/css/formlibrary.css" rel="stylesheet"></link>-->
    </head>
    <body>
        <div id="dvLoading"></div>
        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr><td>
                        <table align="center"  valign="top" class="ui-widget ui-widget-content" style="width:90%;">  
                            <thead>
                                <tr class="ui-widget-header" id="mainHeader" background="../images/menu-background.png" >                
                                    <td colspan="5">
                                        <span style="text-align:left; vertical-align: bottom">Auto Gen# List</span>
                                    </td>
                                </tr>           
                                <tr class="demoHeaders">
                                    <th><b>Auto Gen# Name</b></th>
                                    <th><b>No. of Digits</b></th>
                                    <th><b>Start No.</b></th>
                                    <th><b>Created Date</b></th>
                                </tr>
                            </thead>
                            <tbody>
                                <%if (gList != null) {
                                        for (GenHeader gHeader : gList) {%>      
                                <tr id="<%=count%>" onclick="HighLightTR(this,'#C0C0C0');" onmouseover="fnChangePointer(this)">   
                                    <td align="center" >
                                        <% if (!gHeader.isIsInUse()) {%>
                                        <a href="gendesign.jsp?genId=<%=gHeader.getId()%>&type=Design&subtype=autogen" target="_self" title="view details"><%=gHeader.getGen_name()%></a>
                                        <%} else {%>
                                        <%=gHeader.getGen_name()%>
                                        <% }%>
                                    </td>
                                    <td align="center" ><%=gHeader.getDigit()%></td>
                                    <td align="center" ><%=gHeader.getStart_no()%></td>
                                    <td align="center" ><%=gHeader.getCreated_date()%></td>                            
                                    <td align="center" >
                                        <% if (!gHeader.isIsInUse()) {%>
                                        <button style="text-align:right; float:right; font-size: 70%" id="btnDelete_<%=count%>" class="btnDelete"  onclick="fnseteditval(<%=gHeader.getId()%>,this,<%=count%>);">Delete</button>
                                        <button style="text-align:right; float:right; font-size: 70%" id="btnEdit_<%=count%>" class="btnEdit" onclick="fnseteditval(<%=gHeader.getId()%>,this,<%=count%>);">Edit</button>
                                        <% }%>
                                    </td>
                                </tr> 
                                <% count += 1;
                                        }
                                    }%>                
                            <input type="hidden" name="editid" id="editid" value="<%=eid%>" />  
                            </tbody>
                            <tfoot>
                                <tr><td colspan="5"><button style="text-align:right; float:right; font-size: 70%" id="btnAdd">Add New</button></td></tr>
                            </tfoot>
                        </table>
                        <div id="dialog-form" title="Add New">            
                            <form name="addForm" action="genheaderprocess.jsp" method="post" >
                                <label for="type">Name</label>
                                <input  type="text" name="txtGenName" id="txtGenName" class="text ui-widget-content ui-corner-all" maxlength="100" style="width:90%" />
                                <label for="type">No. of Digit</label>
                                <input  type="number" name="txtGenDigit" id="txtGenDigit" class="text ui-widget-content ui-corner-all" maxlength="100" style="width:90%" />
                                <label for="type">Start No.<br>(First Generated No. will be this)</label>
                                <input  type="number" name="txtGenStart" id="txtGenStart" class="text ui-widget-content ui-corner-all" maxlength="100" style="width:90%" />
                                <input type="hidden" name="mode" id="mode" value="add" />
                            </form>
                        </div>        

                        <div id="dialog-message" title="No Row Selected">
                            <p>
                                <span class="ui-icon ui-icon-circle-check" style="float:left; margin:0 7px 50px 0;"></span>
                                Please select a row.
                            </p>
                        </div>   

                        <div id="dialog-edit-form" title="Edit">            
                            <form name="editForm" method="post">
                                <label for="type">Name</label>
                                <input  type="text" name="txtGenName" id="txtGenName" class="text ui-widget-content ui-corner-all" maxlength="100" style="width:90%" />
                                <label for="type">No. of Digit</label>
                                <input  type="number" name="txtGenDigit" id="txtGenDigit" class="text ui-widget-content ui-corner-all" maxlength="100" style="width:90%" />
                                <label for="type">Start No. <br>(First Generated No. will be this)</label>
                                <input  type="number" name="txtGenStart" id="txtGenStart" class="text ui-widget-content ui-corner-all" maxlength="100" style="width:90%" />

                                <input type="hidden" name="mode" id="mode" value="edit" />
                                <input type="hidden" name="id" id="id"  />
                            </form>
                        </div>

                        <div id="dialog-confirm" title="Delete">
                            <form name="deleteForm">
                                <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>These item will be permanently deleted. Are you sure you want to delete?</p>
                                <input type="hidden" name="mode" id="mode" value="delete" />
                                <input type="hidden" name="id" id="id"  />
                            </form>
                        </div>
                    </td></tr>
            </table>
        </div>
    </body>
</html>
