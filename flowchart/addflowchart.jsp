<%-- 
    Document   : addflowchart
    Created on : Dec 10, 2013, 4:20:47 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../include/js/jquery.ui.touch-punch.min.js"></script>
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <title>Add New Flowchart</title>
        <script type="text/javascript">
            $(document).ready(function () {
                $("#btnContinue").click(function() {
                    var vtxtflowchartname = document.getElementById("txtflowchartname");
                    var vflowchartname = vtxtflowchartname.value;
                    if(vflowchartname == null || $.trim(vflowchartname) == ""){
                        alert("Please provide a flow chart name.");
                    }else{
                        //                        vtxtflowchartname.disabled = true;
                        $( "#btnContinue" ).button({ disabled: true });
                        document.frmflowchart.submit();
                        //                        var posting = $.post("createaction.jsp", { flowchartname: vflowchartname} );
                        //                        posting.done(function(data) {
                        //                            $( "#result" ).empty().append( data );
                        //                        });
                    }
                });
            });
        </script>
    </head>
    <body>
        <h1>Add New Flowchart</h1>
        <form id="frmflowchart" name="frmflowchart" method="POST" action="insertflowchart.jsp">
            <input type="text" id="txtflowchartname" name="txtflowchartname"/>
            <button id="btnContinue" name="btnContinue">Continue</button>
        </form>
    </body>
</html>
