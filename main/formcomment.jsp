<%-- 
    Document   : formcomment
    Created on : Feb 26, 2014, 2:35:03 PM
    Author     : SOE HTIKE
--%>

<% request.setCharacterEncoding("UTF-8");%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bizmann.product.resources.CommentUtil" %>
<%@page import="com.bizmann.product.entity.Comment" %>
<%
    String txtComment = request.getParameter("txtComment");
    if (txtComment == null) {
        txtComment = "";
    }
    String processId = request.getParameter("cprocessid");
    String actionId = request.getParameter("cactionid");
    String userId = request.getParameter("cuserid");

    if (processId == null) {
        processId = "0";
    }
    processId = processId.trim();
    if (processId.equals("")) {
        processId = "0";
    }

    if (actionId == null) {
        actionId = "0";
    }
    actionId = actionId.trim();
    if (actionId.equals("")) {
        actionId = "0";
    }

    if (userId == null) {
        userId = "0";
    }
    userId = userId.trim();
    if (userId.equals("")) {
        userId = "0";
    }
    //System.out.println("1");
    CommentUtil commUtil = new CommentUtil();
    //System.out.println("2");
    Comment comm = commUtil.addComment(Integer.parseInt(processId), Integer.parseInt(actionId), Integer.parseInt(userId), txtComment);
    //System.out.println("3");
    int commentId = comm.getId();
    //System.out.println("4");
%>

<%
    if (commentId != 0) {
%>
[{"txtCommentedBy":"<%=comm.getUsername()%>",
"txtComment":"<%=comm.getMessage()%>",
"txtCommentedOn":"<%=comm.getCommentdate()%>"}]
<%
} else {
%>
[{"txtCommentedBy":"",
"txtComment":"",
"txtCommentedOn":""}]
<%}
%>