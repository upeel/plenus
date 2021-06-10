<%-- 
    Document   : login
    Created on : Mar 23, 2009, 9:20:42 AM
    Author     : Tan Chiu Ping
--%>
<meta name="apple-mobile-web-app-capable" content="yes">

<meta name="mobile-web-app-capable" content="yes">
<%@page import="com.bizmann.poi.resource.PropProcessor"%>
<%@page import="org.apache.shiro.web.util.WebUtils"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import= "com.bizmann.product.resources.*"
         import= "com.bizmann.component.cryptography.DesEncrypter"
         import = "com.bizmann.product.controller.*"
         import = "org.apache.commons.validator.routines.UrlValidator" 
         import="org.apache.shiro.SecurityUtils"
         import="org.apache.shiro.authc.AuthenticationException"
         import="org.apache.shiro.authc.IncorrectCredentialsException"
         import="org.apache.shiro.authc.LockedAccountException"
         import="org.apache.shiro.authc.UnknownAccountException"
         import="org.apache.shiro.authc.UsernamePasswordToken"
         import="org.apache.shiro.subject.Subject"
         import="org.apache.shiro.authc.AuthenticationInfo"
         import="org.apache.shiro.authc.UsernamePasswordToken"
         import="org.apache.shiro.config.IniSecurityManagerFactory"
         import="org.apache.shiro.mgt.SecurityManager"
         import="org.apache.shiro.util.Factory"
         import="java.security.Principal" %>
<%
    // import="org.apache.shiro.saml2.Saml2Token"
    // import="org.apache.commons.codec.binary.Base64"
    String message = "";
    String forward_page = "";

    String user = request.getParameter("txtLoginID");
    String password = request.getParameter("txtPassword");
    String rememberMe = request.getParameter("chkRememberMe");
    String authenticationMethod = PropProcessor.getPropertyValue("auth.method");

    String SAMLRequest = request.getParameter("SAMLRequest");
    if (SAMLRequest == null) {
        SAMLRequest = "";
    }
    System.out.println("SAMLRequest : " + SAMLRequest);

    UserController userCtrl = new UserController();
    if (user == null) {
        session.setAttribute("user", null);
        message = "";
    } else if (user.trim().equals("")) {
        message = "Login ID required.";
    } else if (password == null || password.trim().equals("")) {
        message = "Password required.";
    } else if (!userCtrl.isExistingLoginId(user)) {
        message = "Login ID doesn't exist in bmFLO yet!";
    } else {
        try {
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                if (authenticationMethod.equalsIgnoreCase("jdbc")) {
                    PasswordSecure pws = new PasswordSecure();
                    DesEncrypter des = new DesEncrypter(password);
                    String enteredValue = des.encrypt(password);
                    String recordValue = pws.readDBByLoginID(user);
                    boolean isCorrectPassword = pws.comparePassword(recordValue, enteredValue);

                    if (isCorrectPassword) {
                        forward_page = "main/work.jsp";

                        session.setAttribute("user", user);
                        System.out.println("user : " + user);

                        if (rememberMe == null) {
                            rememberMe = "";
                        }
                        UsernamePasswordToken token = new UsernamePasswordToken(user, password);
                        if (!rememberMe.isEmpty()) {
                            token.setRememberMe(true);
                        }
                        Subject currentUser = SecurityUtils.getSubject();
                        currentUser.login(token);
                        session.setAttribute("user", user);
//                        response.sendRedirect(forward_page);
                    } else {
                        message = "Incorrect password.";
                    }
                } else if (authenticationMethod.equalsIgnoreCase("ldap")) {
                    String domain = PropProcessor.getPropertyValue("ad.domain");
                    if (rememberMe == null) {
                        rememberMe = "";
                    }
                    String username = user + "@" + domain;
                    UsernamePasswordToken token = new UsernamePasswordToken(username, password);
                    if (!rememberMe.isEmpty()) {
                        token.setRememberMe(true);
                    }
                    Subject currentUser = SecurityUtils.getSubject();
                    currentUser.login(token);
                    session.setAttribute("user", user);
                } else {
                    throw new Exception("Invalid Authentication Method Configuration!");
                }
            }
        } catch (AuthenticationException e) {
            System.out.println("We did not authenticate :(");
            e.printStackTrace();
            message = "Login Failed.";
        } catch (Exception e) {
            //System.out.println("Exception at login.jsp : " + e);
            System.out.println("Exception at login : " + e);
            e.printStackTrace();
            message = "Login Failed.";
        }
    }

    System.out.println(session.getAttribute("user"));

    if (authenticationMethod.equalsIgnoreCase("saml")) {
        Principal userCredentials = request.getUserPrincipal();
        if (userCredentials != null) {
            String principalName = userCredentials.getName();
            System.out.println("principalName : " + principalName);

            String[] principalNameArr = principalName.split("@");
            String domain = PropProcessor.getPropertyValue("ad.domain");
            if (principalNameArr.length == 2) {
                String userDomain = principalNameArr[1];
                if (userDomain.equalsIgnoreCase(domain)) {
                    user = principalNameArr[0];
                }
                System.out.println("userDomain : " + userDomain);
                System.out.println("user : " + user);
            }
        }

        if (!userCtrl.isExistingLoginId(user)) {
            message = "Login ID doesn't exist in bmFLO yet!";
        } else {
            session.setAttribute("user", user);
        }
    } else {
        System.out.println(session.getAttribute("user"));
        if (session.getAttribute("user") == null || ((String) session.getAttribute("user")).isEmpty()) {
            // get the currently executing user:
            System.out.println("no user logged in ");
            Subject currentUser = SecurityUtils.getSubject();
            if ((currentUser != null && (currentUser.isAuthenticated() || currentUser.isRemembered())) || (request.getRemoteUser() != null && !request.getRemoteUser().isEmpty())) {
                String session_user = "";
                if ((currentUser != null && (currentUser.isAuthenticated() || currentUser.isRemembered()))) {
                    session_user = ((String) currentUser.getPrincipal()).split("@")[0];
                } else {
                    session_user = ((String) request.getRemoteUser()).split("@")[0];
                }
                session.setAttribute("user", session_user);
            }
        }
    }
    System.out.println(session.getAttribute("user"));

    if (session.getAttribute("user") != null) {
        forward_page = "main/work.jsp";

        String requestURL = (String) session.getAttribute("requestURL");
        if (requestURL != null) {
            String requestQuery = (String) session.getAttribute("requestQuery");

            if (requestQuery != null) {
                requestURL = requestURL + "?" + requestQuery;
            }

            forward_page = requestURL;

            session.setAttribute("requestQuery", null);
            session.setAttribute("requestURL", null);
        }

        if (authenticationMethod.equalsIgnoreCase("saml")) {
            response.sendRedirect(forward_page);
        } else {
            WebUtils.redirectToSavedRequest(request, response, forward_page);
        }
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Language" content="en-us">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        //        <link rel="icon" href="favicon.ico"/>
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="mobile-web-app-capable" content="yes">
        <script src="include/js/jquery-1.10.2.js"></script>
        <script src="include/jquery.mobile-1.4.5/jquery.mobile-1.4.5.min.js"></script>

        <link rel="stylesheet" type="text/css" href="include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="include/css/form.css" />
        <link rel="stylesheet" href="include/css/loading.css" type="text/css" />

        <link rel="stylesheet" href="include/jquery.mobile-1.4.5/jquery.mobile-1.4.5.min.css">

        <title>bmFLO - Login</title>
        <style>
            /*            .background-style {
                            width:100%; 
                            height:100%; 
                            background: url(images/bmflo-background.jpg) no-repeat center center fixed;
                            -webkit-background-size: cover;
                            -moz-background-size: cover;
                            -o-background-size: cover;
                            background-size: cover;
                        }*/

            .login-table {
                background: rgba(0,0,0,0.6);
                padding-left: 35px;
                padding-right: 35px;
                padding-bottom: 35px;
                padding-top: 7px;

                border: 1px solid #000;
                border-radius: 15px;
                -moz-border-radius: 15px;
            }

            html {display:table; width:100%; height:100%;}
            body {display:table-cell; vertical-align:middle; bgcolor:white !important;}

        </style>
        <script>
            $(document).on('pageinit', function () {
                $('#dvLoading').hide();
                $('#overlay').hide();
                $(window).bind('beforeunload', function (e) {
                    $('#dvLoading').show();
                    $('#overlay').show();
                });
            });

            //$(document).ready(function () {
            //var WinNetwork = new ActiveXObject("WScript.Network");
            //document.getElementById("txtWindowUser").value = WinNetwork.UserName;
            //alert(document.getElementById("txtWindowUser").value);
            // disable chkRememberMe
            //});
        </script>
    </head>
    <body bgcolor="white">
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <div data-role="page" data-theme="a" id="index" class="background-style ui-page ui-page-theme-a ui-page-active" style="width: 100%; height: 100%; min-height: 479px;">
            <form id="loginfrm" name="loginfrm" method="POST" style="width: 100%; height: 100%" data-ajax="false">
                <div align="center">
                    <table border="0" width="100%" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="700" height="500">
                                <div align="center" valign="middle" style="position:relative;top:30px;">
                                    <table border="0" width="350">
                                        <tr>
                                            <td colspan="2" style="text-align: center;">
                                                <img src="images/logo.png" alt="logo" width="350px"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td width="350" align="center" colspan="2">
                                                <font id="txtErrorMessage" name="txtErrorMessage" color="#cccccc"><%=message%>
                                                    <%
                                                        String errorDescription = (String) request.getAttribute("shiroLoginFailure");
                                                        if (errorDescription != null) {
                                                    %>
                                                    <!-- Login attempt was unsuccessful: <=errorDescription%> -->
                                                    <%
                                                        }
                                                    %>
                                                </font>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" colspan="2">
                                                <div class="ui-btn ui-corner-all ui-icon-user ui-btn-icon-left">
                                                    <input type="text" id="txtLoginID" name="txtLoginID" data-clear-btn="true" data-icon="user" placeholder="Username 用户名" />
                                                    <input type="hidden" id="txtWindowUser" name="txtWindowUser" value="" />
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" colspan="2">
                                                <div class="ui-btn ui-corner-all ui-icon-lock ui-btn-icon-left">
                                                    <input type="password" id="txtPassword" name="txtPassword" data-clear-btn="true" data-icon="lock" placeholder="Password 密码" />
                                                </div>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td colspan="2" align="center">
                                                <input type="checkbox" id="chkRememberMe" name="chkRememberMe" value="true">
                                                <label for="chkRememberMe">Stay Signed Inx</label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" align="center">
                                                <button type="submit" id="btnSubmit" name="btnSubmit" class="ui-shadow ui-btn ui-corner-all" style="width: 100%; height: 100%; float: left; margin-top:10px">Sign In 登录</button>
                                                <!--</div>-->
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center;">
                                <!--<br/>-->
                                <!--<br/>-->
                                <!--<div align="center" valign="bottom" style="position:relative;bottom:60px;right:60px">-->
                                <img src="images/bizmann-logo.jpg" alt="Bizmann" style="width: 5%; "/>
                                <br/>
                                <font color="black" face="Calibri (Body)" size="1px" style="letter-spacing: 2px; text-shadow: none;">
                                    Powered by<br/>Bizmann System(S) Pte Ltd<br/><a href="http://bizmann.com" target="_blank">http://bizmann.com</a>
                                </font>
                                <!--</div>-->
                            </td>
                        </tr>
                    </table>
                </div>
            </form>   
        </div>
    </body>
</html>