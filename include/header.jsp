<%--
    Document   : header
    Created on : Feb 17, 2009, 12:17:43 PM
    Author     : Tan Chiu Ping
--%>

<%@page import = "java.util.*"
        import = "java.lang.*"
        import= "com.bizmann.product.resources.*"
        import = "com.bizmann.product.controller.*"
        import="javax.servlet.http.*" 
        import="com.bizmann.utility.Version" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
    response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
    response.setDateHeader("Expires", 0); // Proxies.

    String h_licensetype = request.getParameter("type");
    if (h_licensetype == null)
    {
        h_licensetype = "Dashboard";
    }

    UserController userCtrl = new UserController();
    String loginid = (String) session.getAttribute("user");
    String username = "";
    if (loginid == null || loginid.equals(""))
    {
        response.sendRedirect("../include/redirect.jsp");
        return;
    }
    else
    {
        username = userCtrl.getUserNameByLoginId(loginid);
    }

    int userId = userCtrl.getUserIdByLoginId(loginid);
    UserAuthGrpController authGrpCtrl = new UserAuthGrpController();
    int authGrpId = authGrpCtrl.getAuthGrpIdByUserId(userId);
%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/menu/assets/skins/sam/menu.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/imageloader/imageloader-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/container/container_core-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/menu/menu-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-beta-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/button/button-min.js"></script>
        <style>
            .welcome{
                position:relative;
                top:6px;
                /*                left:10px;*/
                font-size: 110%;
                color: grey;
                font-weight:bold;
            }
            .logout{
                position:relative;
                top:0px;
                left:10px;
                font-size: 85%;
                color: grey;
            }
            .logo{
                position:relative;
                top:30px;
                left:15px;
            }
            .menuGroup{
                position:relative;
                top:5px;
                left:0px;
                font-size:90%;
            }
            .menuLabel{
                position:relative;
                top:10px;
                /*                left:30px;*/
                font-size:90%;
            }
            #logoutLink {
                display: block;
                width: 55px;
                height: 15px;
                background: #666666;
                padding: 2px;
                text-align: center;
                border-radius: 2px;
                color: whitesmoke;
                font-weight: bold;
            }
        </style>
    </head>
    <body class="yui-skin-sam">
        <div align="center" height="95px">
            <table class="new" border="0" width="980px" height="95px" style="background-repeat: no-repeat;"
                   background="../images/header-bg.png">
                <tbody>
                    <tr>
                        <td valign="top" align="right" width="550">
                            <div>
                                <label class="menuLabel">
                                    <b><font face="Arial" color="grey">Management Type:</font></b>
                                </label>
                            </div>
                        </td>
                        <td valign="top" width="150" align="left">
                            <div id="menuGroup" class="menuGroup"></div>
                            <script type="text/javascript">
                                YAHOO.example.init = function () {
                                    function onMenuItemClick(p_sType, p_aArgs, p_oItem) {
                                        var type = p_oItem.cfg.getProperty("text");
                                        menuItem.set("label", type);
                                        if (type == "Organization") {
                                            document.location.href = "../main/orgunit.jsp?type=" + type;
                                        } else if (type == "Design") {
                                            document.location.href = "../main/formadd.jsp?type=" + type;
                                        } else if (type == "Process") {
                                            document.location.href = "../main/processreport.jsp?type=" + type;
                                        } else if (type == "System") {
                                            document.location.href = "../main/systemaudit.jsp?type=" + type;
                                        } else if (type == "Dashboard") {
                                            document.location.href = "../main/work.jsp?type=" + type;
                                        }
                                    }
                                    var menuGroup =
                                            //check permission to access
                                <% if (authGrpId == 1)
                                    {%>
                                    //General Administrator
                                    [{text: "Dashboard", value: "Dashboard", onclick: {fn: onMenuItemClick}},
                                    {text: "Design", value: "Design", onclick: {fn: onMenuItemClick}},
                                    {text: "Organization", value: "Organization", onclick: {fn: onMenuItemClick}}];
                                    //                                        { text: "Process", value: "Process", onclick: { fn: onMenuItemClick } }];
                                <%}
                                else if (authGrpId == 2)
                                {%>
                                    //Manager
                                    [{text: "Dashboard", value: "Dashboard", onclick: {fn: onMenuItemClick}},
                                    {text: "Process", value: "Process", onclick: {fn: onMenuItemClick}}];
                                <%}
                                else if (authGrpId == 3)
                                {%>
                                    //Business Administrator
                                    [{text: "Dashboard", value: "Dashboard", onclick: {fn: onMenuItemClick}},
                                    {text: "Design", value: "Design", onclick: {fn: onMenuItemClick}}];
                                <%}
                                else if (authGrpId == 4)
                                {%>
                                    //User
                                    [{text: "Dashboard", value: "Dashboard", onclick: {fn: onMenuItemClick}}];
                                <%}%>

                                    var menuItem = new YAHOO.widget.Button({type: "menu", label: "<b><%=h_licensetype%></b>", name: "menuGroup", menu: menuGroup, container: "menuGroup"});
                                }();
                            </script>
                        </td>
                        <td valign="top" align="right" width="300">
                            <table class="new" border="0">
                                <tr width="300">
                                    <td height="5px">
                                        <div id="div_welcome" class="welcome">
                                            Welcome! <%=username%>
                                        </div>
                                    </td>
                                </tr>
                                <tr width="200">
                                    <td height="5px">
                                        <div id="div_timestamp" class="logout">
                                            <%=DateUtil.getCurrentDate("dd/MM/yyyy HH:mm:ss")%>
                                        </div>

                                    </td>
                                </tr>
                                <tr width="200">
                                    <td height="5px">
                                        <div id="div_version" class="logout">
                                            <%=Version.VERSION%>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div id="div_logout" class="logout">
                                            <a href="../logout.jsp" target="_parent" id="logoutLink">Logout</a>
                                        </div>
                                    </td>
                                </tr>

                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                <marquee behavior="scroll" direction="left" scrollamount="2">
                    <div>
                        <!--possible to customize this message for user to edit.-->
                        <font color="darkblue">"If you spend too much time thinking about a thing, you'll never get it done." - Bruce Lee</font>
                    </div>
                </marquee>
                </td>
                </tr>
            </table>
        </div>
    </body>
</html>