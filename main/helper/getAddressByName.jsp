<%-- 
    Document   : getAddressByName
    Created on : Mar 18, 2015, 1:53:34 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.bizmann.product.resources.*"
        import="com.bizmann.db.DBConnection"
        import="java.sql.Connection"
        import="java.sql.SQLException"
        import="java.sql.PreparedStatement"
        import="java.sql.ResultSet"
        import="org.apache.commons.lang.StringEscapeUtils"%>
<%!
    String getAddressByname(String name) {
        String address = "";
        DBConnection dbconn = new DBConnection();
        Connection con = dbconn.connect();
        try {
            String sql = "SELECT `A3` FROM mod_2_1426650320 WHERE `A2`=?";
            PreparedStatement prep = con.prepareStatement(sql);
            prep.setString(1, name);
            ResultSet rs = prep.executeQuery();
            while(rs.next()){
                address = rs.getString("A3");
            }
            rs.close();
            prep.close();
        } catch (Exception e) {
            System.out.println("Exception at getAddressByname : " + e);
        } finally {
            if (con != null) {
                try {
                    con.close();
                    dbconn.disconnect();
                } catch (SQLException e) {
                    System.out.println("finally block exception=" + e);
                }
            }
        }
        return address;
    }
%>
<%
    String name = request.getParameter("name");
    if(name == null){
        name = "";
    }
    name = name.trim();
    System.out.println("name");
    String address = getAddressByname(name);
    System.out.println("address : " + address);
%>

<%
    if (address != null) {
%>
[{"txtAddress":"<%=StringEscapeUtils.escapeJavaScript(address)%>"}]
<%
} else {
%>
[{"txtAddress":""}]
<%}
    System.out.println("-------------------ajax end------------------------");
%>
