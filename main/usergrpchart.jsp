<%-- 
    Document   : usergrpchart.jsp
    Created on : Feb 20, 2009, 5:01:33 PM
    Author     : Tan Chiu Ping
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<%@ include file="../include/header.jsp" %>
<%@ include file="../include/menu.jsp" %>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/treeview/assets/skins/sam/treeview.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/treeview/treeview-min.js"></script>

        <style type="text/css">
            .icon-orgunit { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }
            .icon-user { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }
            .icon-mgr { display:block; height: 23px; padding-left: 0px; background: transparent 0 0px no-repeat; }

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
        String userno = "5";
    %>

    <script type="text/javascript">
        var tree;
        var tmpNode;

        function init(){
            tree = new YAHOO.widget.TreeView("treediv");
            root = tree.getRoot();
            tmpNode = new YAHOO.widget.TextNode({ label: "Bizmann", id:"Bizmann" }, root);
            tmpNode.labelStyle="icon-orgunit";
            for(i=0; i<parseInt(<%=userno%>); i++){
                var tmpSubNode = new YAHOO.widget.TextNode({label: "Org Unit " + i, id: "Org Unit " + i}, tmpNode);
                tmpSubNode.labelStyle = "icon-orgunit";

                for(j=0; j<parseInt(<%=userno%>); j++){
                    var tmpSubSubNode = new YAHOO.widget.TextNode({label: "User " + j, id: "User " + j}, tmpSubNode);
                    tmpSubSubNode.labelStyle = "icon-user";
                }
            }
            tree.draw();

            tree.subscribe("expand", function(node) {
                alert("<"+node.data.id + "> was selected");
            });

            tree.subscribe("collapse", function(node) {
                alert("<"+node.data.id + "> was selected");
            });
        }

        YAHOO.util.Event.onDOMReady(init);

    </script>

    <body>
        <div align="center" valign="top">
            <table width="980px" height="420px" background="../images/background.png">
                <tr>
                    <td class="orgtable" valign="top" width="300">
                        <%@ include file="../include/tmenu.jsp" %>
                        <div id="treediv" class="treediv"></div>
                    </td>
                    <td class="orgtable" valign="top"  align="center">
                        <br><table border="0" width="500">
                            <tr>
                                <td colspan="2">
                                    <div class="psadtitle">
                                        <br>--- Add User Group ---<br><br>
                                    </div></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>ID:</b></td>
                                <td width=350 align="left"><input type="text" name="txtLoginID" size="20" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Name:</b></td>
                                <td width=350 align="left"><input type="text" name="txtLoginID" size="30" class="psadtext"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Users:</b></td>
                                <td width=350 align="left">
                                    <textarea rows="4" name="S1" cols="35" class="psadtextarea"></textarea>
                                    <input type="button" value="..." name="btnSubmit0" class="psadbutton" width="100"></td>
                            </tr>
                            <tr>
                                <td width=150 align="right"><b>Manager:</b></td>
                                <td width=350 align="left">
                                    <select size="1" name="cbManager">
                                        <option>Manager 1</option>
                                        <option>Manager 2</option>
                                    </select>				
                                </td>
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
                                <td width=350 align="left"><input type="button" value="Enter" name="btnSubmit" class="psadbutton" width="100"></td>
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

<%@ include file="../include/footer.jsp" %>