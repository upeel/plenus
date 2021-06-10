<%-- 
    Document   : index
    Created on : Nov 19, 2013, 5:07:54 PM
    Author     : SOE HTIKE
--%>
<%@page import="com.bizmann.poi.controller.*"
        import="java.io.File"
        import="java.io.FileInputStream"
        import="java.util.ArrayList" %>
<%
    PoiReadExcelFile preHelper = new PoiReadExcelFile();
    ArrayList<String> emptyList = preHelper.CustomTable();
    //String first = preHelper.doRendering();
    //String second = preHelper.extractData();

    //System.out.println(first);
    //System.out.println(second);

    //out.println(first);
    //out.println(preHelper.CustomTable());

    //out.println("<h1>Data Extracted</h1>");
    //out.println(second);

    //out.println("<br/>");
    //out.println(new ExcelToHtml(new FileInputStream(new File("E:\\tmp folder\\BD sample forms\\80005612-C.xls"))).getHTML());
    //System.out.println("emptyList" + emptyList.size());
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <script src="../include/js/jquery-1.10.2.js"></script>
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <title>bmFLO</title>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
        <style type="text/css" media="screen">
            body { font: 12px Helvetica, Arial; overflow-x: hidden;}
            div { margin: 5px; padding: 0;}
            ul { margin: 0; padding: 0;}
            li { list-style: none; padding: 0; margin: 0; float:left;}
            #selectActions span, #selectActions li {float: left; padding: 5px;}
            .droppableContainer { width: 100%; float: left; min-height: 50px}
            .droppableContainer li { width: 90px; margin: 2px; padding-bottom: 4px;}
            .droppableContainer img { width: 90px; max-height: 90px; max-width: 90px; width: 90px; vertical-align: middle;}
            .droppableContainer input { vertical-align: middle; }
            #draggingContainer { width:48%; }
            #draggingContainer input { visibility: hidden;}
            #dropTarget1, #dropTarget2, #dropTarget3 { border: 3px dashed grey;}
            #dropTarget1 input, #dropTarget2 input, #dropTarget3 input { visibility: hidden; }
            #dragSource {
                /* Position absolutely, 30px down from the top */
                position: absolute;
                top: 30px;
                display: block;
                background: #adbaff;
                /* In my case I'm centering it in the window; do what you like */
                /*                margin-left: -100px;*/
                /*                left: 50%;*/
                width: 100px;

            }
            #box {
                position: absolute;
                left: 180px;
            }
            .selected {
                border: 3px solid #f80;
            }
            body{white-space-collapsing:preserve;}
            /*    table{
                    border-collapse:collapse;
                    border:1px solid #FF0000;
                }
            
                table td{
                    border:1px solid #FF0000;
                }*/
        </style>
        <script>
            var vzone;
            var velem;
            var completed = true;
            
            var baseUrl = 'detailfields.jsp?';
            function select (obj) {
                $(".selectable").removeClass("selected");
                obj.addClass("selected");
            }
            
            function remove(){
                velem.remove();
                completed = true;
                //                var elem = document.getElementsByClassName("selected");
                //                console.log(elem);
                //                velem.remove();
                //                remember.removeChild(remember.);
                //                remember.removeChild(remember);
                //                remember.parentNode.removeChild(remember);
            }
            
            function add(){
                completed = true;
                //                velem.mousedown( function () {
                //                    select(velem);
                //                });
                //                vzone.append(velem);
                //                velem.mousedown( function () {
                //                    select(velem);
                //                });
            }

            $(function(){
                $("#delete").button();
                $("#delete").click( function () {
                    $(".selected").remove();
                    //                    $(".slottype1:empty").droppable("option", "accept", acceptType1);
                });
  
                function getScrollTop() {
                    if (typeof window.pageYOffset !== 'undefined' ) {
                        // Most browsers
                        return window.pageYOffset;
                    }

                    var d = document.documentElement;
                    if (d.clientHeight) {
                        // IE in standards mode
                        return d.scrollTop;
                    }

                    // IE in quirks mode
                    return document.body.scrollTop;
                }

                window.onscroll = function() {
                    var box = document.getElementById('dragSource'),
                    scroll = getScrollTop();

                    if (scroll <= 28) {
                        box.style.top = "30px";
                    }
                    else {
                        box.style.top = (scroll + 2) + "px";
                    }
                };
  
                $('#dragSource li').draggable({
                    helper: function(){
                        var selected = $('#dragSource input:checked').parents('li');
                        if (selected.length === 0) {
                            selected = $(this);
                        }
                        var container = $('<div/>').attr('id', 'draggingContainer');
                        container.append(selected.clone());
                        return container; 
                    },
                    start: function(e, ui) {
                        //                        remember = $(this).attr('id');
                        //                        $(this).html("<div>hello</div>");
                    },
                    stop: function(e, ui) {
                        //                        $(this).html(remember);
                    }
                });
  
            <%
                for (int i = 0; i < emptyList.size(); i++) {
                    String identifier = emptyList.get(i);
            %>
                    $('#dropTarget<%=identifier%>').droppable({
                        tolerance: 'pointer',
                        drop: function(event, ui){
                            if(completed){
                                var ftId = $(ui.draggable).children().attr('id');
                                var fId = $(this).attr('id');
                                fId = fId.replace('dropTarget', '');
                                completed = false;
                                //                            vzone = $(this);
                                //                            velem = ui.helper.children();
                            
                            
                                var clone = ui.helper.children();
                            
                                clone.addClass("selectable");
                                select(clone);
                                //                            clone.onclick=function(){select(clone)};
                                clone.mousedown( function () {
                                    select(clone);
                                });
                            
                                $(this).append(clone);
                                //                            vzone = $(this);
                                velem = clone;
                            
                                window.open(baseUrl+'ftId='+ftId+'&fId='+fId,'1385013844412','width=500,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');
                            }else{
                                var r = confirm("You have unfinished field! <br/>Do you want to discard it and start a new one?");
                                if (r == true)
                                {
                                    velem.remove();
                                    var ftId = $(ui.draggable).children().attr('id');
                                    var fId = $(this).attr('id');
                                    fId = fId.replace('dropTarget', '');
                                    completed = false;
                                    //                            vzone = $(this);
                                    //                            velem = ui.helper.children();
                            
                            
                                    var clone = ui.helper.children();
                            
                                    clone.addClass("selectable");
                                    select(clone);
                                    //                            clone.onclick=function(){select(clone)};
                                    clone.mousedown( function () {
                                        select(clone);
                                    });
                            
                                    $(this).append(clone);
                                    //                            vzone = $(this);
                                    velem = clone;
                            
                                    window.open(baseUrl+'ftId='+ftId+'&fId='+fId,'1385013844412','width=500,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');
                            
                                }
                                else
                                {
                                    alert("Please continue defining the field!");
                                }
                            }
                        }
                    });
            <% }%>
  
                    $('#selectAll').click(function(){
                        $('#dragSource input').attr('checked', 'checked');
                        return false;
                    });
  
                    $('#selectNone').click(function(){
                        $('#dragSource input').removeAttr('checked');
                        return false;
                    });
  
                    $('#selectInvert').click(function(){
                        $('#dragSource input').each(function(){
                            var $this = $(this);
                            if ($this.attr('checked')) {
                                $this.removeAttr('checked');
                            }
                            else {
                                $this.attr('checked', 'checked');
                            }
                        });
                        return false;
                    });
                });
        </script>
    </head>
    <body>
        <div style="display: block;">
            <div id="dragSource" class="droppableContainer">
                <ul>
                    <li><img width="80" id="1" name="1" src="fieldsimg/1.png" /></li>
                    <li><img width="80" id="2" name="2" src="fieldsimg/2.png" /></li>
                    <li><img width="80" id="3" name="3" src="fieldsimg/3.png" /></li>
                    <li><img width="80" id="4" name="4" src="fieldsimg/4.png" /></li>
                    <li><img width="80" id="5" name="5" src="fieldsimg/5.png" /></li>
                    <li><img width="80" id="6" name="6" src="fieldsimg/6.png" /></li>
                    <li><img width="80" id="7" name="7" src="fieldsimg/7.png" /></li>
                    <li><img width="80" id="8" name="8" src="fieldsimg/8.png" /></li>
                    <li><img width="80" id="9" name="9" src="fieldsimg/9.png" /></li>
                    <li><img width="80" id="10" name="10" src="fieldsimg/10.png" /></li>
                    <li><img width="80" id="11" name="11" src="fieldsimg/11.png" /></li>
                    <li><img width="80" id="12" name="12" src="fieldsimg/12.png" /></li>
                    <li><img width="80" id="13" name="13" src="fieldsimg/13.png" /></li>
                    <li><img width="80" id="14" name="14" src="fieldsimg/14.png" /></li>
                    <div class="button">
                        <button id="delete">Delete</button>
                    </div>
                </ul>
            </div>
            <div id="box">
                <%preHelper.CustomTable(out);%>
            </div>
        </div>
    </body>
</html>