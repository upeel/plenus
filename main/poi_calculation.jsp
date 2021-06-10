<%-- 
    Document   : calculation
    Created on : Nov 21, 2013, 3:21:04 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <script src="include/js/jquery-1.10.2.js"></script>
        <script src="include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <link rel="stylesheet" href="include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="include/css/style.css" type="text/css" />
        <script>
            function fnDoCalculate(){
                var va1 = document.getElementById("A1").value;
                var va2 = document.getElementById("A2").value;
                var va3 = document.getElementById("A3").value;
                var va4 = document.getElementById("A4").value;
                var va5 = document.getElementById("A5").value;
                
                $.ajax({
                    url: 'doCalculate.jsp',
                    data: 'A1='+va1+"&A2="+va2+"&A3="+va3+"&A4="+va4+"&A5="+va5,
                    success: function(data){
                        var cData=eval(data);
                        $('#A6').val(cData[0].txtResult);
                    }
                });
            }
        </script>
    </head>
    <body>
        <table>
            <tr>
                <td>
                    <input id="A1" name="A1" type="number" onchange="fnDoCalculate()"/> 
                </td>
            </tr>
            <tr>
                <td>
                    <input id="A2" name="A2" type="number" onchange="fnDoCalculate()"/> 
                </td>
            </tr>
            <tr>
                <td>
                    <input id="A3" name="A3" type="number" onchange="fnDoCalculate()"/> 
                </td>
            </tr>
            <tr>
                <td>
                    <input id="A4" name="A4" type="number" onchange="fnDoCalculate()"/> 
                </td>
            </tr>
            <tr>
                <td>
                    <input id="A5" name="A5" type="number" onchange="fnDoCalculate()"/> 
                </td>
            </tr>
            <tr>
                <td><hr/></td>
            </tr>
            <tr>
                <td>
                    <input id="A6" name="A6" type="number" readonly/> 
                </td>
            </tr>
        </table>
    </body>
</html>
