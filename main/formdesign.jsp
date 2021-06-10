<%-- 
    Document   : formdesign
    Created on : Nov 27, 2013, 2:28:22 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.io.*,java.util.*" %>
<%@page import="com.bizmann.poi.resource.PropProcessor" %>
<%@page import="com.bizmann.poi.controller.FormController" %>
<%@page import="com.bizmann.poi.entity.Form" %>
<%@page import="com.bizmann.poi.entity.FirstRenderer"
        import = "com.bizmann.product.controller.*" 
        import = "com.bizmann.utility.Application" %>

<%@ include file="helper/sessioncheck.jsp" %>
<!DOCTYPE html>
<%    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Expires", "0");

    String feedbackmsg = "";
    FormController frmCtrl = new FormController();
    String basePath = Application.getAPPLICATION_EXCEL_CONTAINER_FILE_PATH();

    String strFormId = request.getParameter("formId");
    if (strFormId == null)
    {
        strFormId = "0";
    }
    strFormId = strFormId.trim();
    if (strFormId.equals(""))
    {
        strFormId = "0";
    }
    int formId = Integer.parseInt(strFormId);

    int userId = 0;
    int authGrpId = 0;
    if (ssid == null || ssid.equals(""))
    {
    }
    else
    {
        UserController userCtrl = new UserController();
        userId = userCtrl.getUserIdByLoginId(ssid);

        UserAuthGrpController authGrpCtrl = new UserAuthGrpController();
        authGrpId = authGrpCtrl.getAuthGrpIdByUserId(userId);
    }
    if (authGrpId == 1)
    {
    }
    else if (authGrpId == 3)
    {
        boolean doesBelong = frmCtrl.formBelongs2User(userId, formId);
        if (!doesBelong)
        {
            return;
        }
    }

    Form form = frmCtrl.getFormById(formId);

    String formName = form.getName();
    String fileName = form.getPath();

    FirstRenderer frdr = frmCtrl.CustomTable(fileName, formId, userId);
    //FirstRenderer frdr = frmCtrl.CustomTable(fileName, formId);
    ArrayList<String> emptyList = frdr.getEmptyList();
    String htmlTags = frdr.getHtmlTags();

    boolean isActivated = frmCtrl.isFormActivated(formId);
%>
<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="../include/js/jquery-1.10.2.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <script src="../include/jquery-ui-1.10.3/ui/jquery-ui.js"></script>
        <script src="../include/js/jquery.ui.touch-punch.min.js"></script>
        <link rel="stylesheet" href="../include/jquery-ui-1.10.3/themes/base/jquery-ui.css" type="text/css" />
        <link rel="stylesheet" href="../include/css/loading.css" type="text/css" />
        <title>Design Form</title>
        <style type="text/css" media="screen">
            body { font: 12px Helvetica, Arial; }
            /*            background: #d6d6d6;*/
            /*            body {background-image:url("../images/background.png");}*/
            div { margin: 5px; padding: 0;}
            ul { margin: 0; padding: 0;}
            li { list-style: none; padding: 0; margin: 0; float:left;}
            #selectActions span, #selectActions li {float: left; padding: 5px;}
            /*            /border: 2px dashed grey; url("images/droppable.png") background-color:whitesmoke; */
            .droppableContainer { border: 1px outset white; border-color:whitesmoke; width: 90%; float: left; min-height: 40px}
            /*            .droppableContainer li { width: 100px; margin: 2px; padding-bottom: 4px;}
                        .droppableContainer img { width: 100px; max-height: 90px; max-width: 110px; vertical-align: middle;}*/
            .droppableContainer input { vertical-align: middle; }
            .droppableContainer li { width: 100px; margin: 2px; padding-bottom: 2px; margin-bottom: 20px}
            .droppableContainer img { width: 100px; max-height: 90px; max-width: 110px; vertical-align: middle;}
            #draggingContainer { width:48%; }
            #draggingContainer input { visibility: hidden;}
            #dropTarget1, #dropTarget2, #dropTarget3 { border: 3px dashed grey;}
            #dropTarget1 input, #dropTarget2 input, #dropTarget3 input { visibility: hidden; }
            #dragSource {
                /* Position absolutely, 30px down from the top */
                position: absolute;
                top: 5px;
                display: block;
                border: 1px solid black; 
                z-index: 10;
                background: #484848;
                /*                border-color: black; */
                /*                background: #cccccc;*/
                padding:1px;
                /*                    #ffd684;*/
                /* In my case I'm centering it in the window; do what you like */
                /*                margin-left: -100px;*/
                /*                left: 50%;*/
                width: 130px;

            }
            /*Edited by JIAN HUA*/ 
            #dragSource2 {
                /* Position absolutely, 30px down from the top */
                position: absolute;
                top: 5px;
                display: block;
                border: 1px solid black;
                z-index: 10;
                background: #484848;
                /*                border-color: black; */
                /*                background: #cccccc;*/
                padding: 1px;
                /*                    #ffd684;*/
                /* In my case I'm centering it in the window; do what you like */
                /*                margin-left: -100px;*/
                /*                left: 50%;*/
                width: 130px;
                margin-left:90%;
            }
            #box {
                position: absolute;
                left: 150px;
            }
            #mybuttons {
                position: absolute;
                left: 115px;
            }
            #delete {
                width: 40px;
                /*                background: #ff4f33;*/
            }
            #edit {
                width: 40px;
                /*                background: #7aff7a;*/
            }
            /*Edited by JIAN HUA*/
            #copy{
                width:40px;
            }
            #preview {
                width: 40px;
                /*                background: #a999ff;*/
            }
            #actpreview {
                width: 40px;
                /*                background: #a999ff;*/
            }
            .selected {
                border: 2px solid #f80;
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
            var vselected;
            var completed = true;

            var baseUrl = 'detailfields.jsp?formId=<%=formId%>&';
            function select(obj) {
                $(".selectable").removeClass("selected");
                obj.addClass("selected");
                vselected = obj;
            }

            function remove() {
                velem.remove();
                completed = true;
                //                var elem = document.getElementsByClassName("selected");
                //                console.log(elem);
                //                velem.remove();
                //                remember.removeChild(remember.);
                //                remember.removeChild(remember);
                //                remember.parentNode.removeChild(remember);
            }

            function add(vfieldId) {
                //vzone.append(vfieldId);
                velem.attr("fieldId", vfieldId);
                completed = true;
                //                velem.mousedown( function () {
                //                    select(velem);
                //                });
                //                vzone.append(velem);
                //                velem.mousedown( function () {
                //                    select(velem);
                //                });
            }

            $(function () {
                $('#dvLoading').hide();
                $('#overlay').hide();

                $(window).bind('beforeunload', function (e) {
                    $('#dvLoading').show();
                    $('#overlay').show();
                });

                if (<%=isActivated%>) {
                    $('#dragSource').hide();
                    $('#dragSource2').hide();
                    //$('.droppableContainer').hide(); //JIAN HUA
                    //                    $('#activatedPreview').show();
                } else {
                    $('#activatedPreview').hide();
                    //                    $('html').keyup(function(e){
                    //                        if(e.keyCode == 46){
                    //                            $( "#delete" ).click();
                    //                        }
                    //                    });
                }

                $(".selectable").mousedown(function () {
                    select($(this));
                });

                //                $("#preview").button();
                $("#preview").click(function () {
                    document.location.href = 'formpreview.jsp?formId=<%=formId%>';
                });

                $("#actpreview").click(function () {
                    document.location.href = 'formpreview.jsp?formId=<%=formId%>';
                });

                $("#copy").click(function () {
                    if (typeof vselected.attr("fieldId") === 'undefined') {
                        alert("Please select a Field to Copy.");
                    } else {
                        var vfieldId = vselected.attr("fieldId");
                        var url = 'copyfields.jsp?formId=<%=formId%>&fieldId=' + vfieldId;
                        window.open(url, '1385013844412', 'width=500,height=100,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');
                    }
                });

                //                $("#edit").button();
                $("#edit").click(function () {
                    if (typeof vselected.attr("fieldId") === 'undefined') {
                        alert("Please select a Field to Edit.");
                    } else {
                        var vfieldId = vselected.attr("fieldId");
                        var url = 'editfields.jsp?formId=<%=formId%>&fieldId=' + vfieldId;
                        window.open(url, '1385013844412', 'width=500,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');
                    }
                });

                //                $("#delete").button();
                $("#delete").click(function () {
                    if (typeof vselected.attr("fieldId") === 'undefined') {
                        alert("Please select a Field to Delete.");
                    } else {
                        var vconfirm = confirm("Are you sure you want to delete?");
                        if (vconfirm) {
                            var vfieldIdtodel = vselected.attr("fieldId");
                            $.ajax({
                                url: 'fieldprocess.jsp',
                                data: 'formId=<%=formId%>&fieldId=' + vfieldIdtodel,
                                success: function () {
                                    $(".selected").remove();
                                }
                            });
                        }
                    }
                    //                    $(".slottype1:empty").droppable("option", "accept", acceptType1);
                });

                function getScrollTop() {
                    if (typeof window.pageYOffset !== 'undefined') {
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

                function getScrollLeft() {
                    if (typeof window.pageXOffset !== 'undefined') {
                        // Most browsers
                        return window.pageXOffset;
                    }

                    var d = document.documentElement;
                    if (d.clientWidth) {
                        // IE in standards mode
                        return d.scrollLeft;
                    }

                    // IE in quirks mode
                    return document.body.scrollLeft;
                }

                window.onscroll = function () {
                    //                    var box = document.getElementById('dragSource'),
                    //                    scroll = getScrollTop();
                    //                    scrollLeft = getScrollLeft();
                    //
                    //                    if (scroll <= 4) {
                    //                        box.style.top = "5px";
                    //                    }
                    //                    else {
                    //                        box.style.top = (scroll + 2) + "px";
                    //                    }
                    //                    if (scrollLeft <= 4) {
                    //                        box.style.left = "5px";
                    //                    }
                    //                    else {
                    //                        box.style.left = (scrollLeft + 2) + "px";
                    //                    }
                    var box = document.getElementsByClassName('droppableContainer');//jian hua

                    /*Edited by JIAN HUA*/
                    for (var i = 0; i < box.length; i++)
                    {
                        //var element = box[i];
                        scroll = getScrollTop();
                        scrollLeft = getScrollLeft();

                        if (scroll <= 4) {
                            box[i].style.top = "5px";
                        } else {
                            box[i].style.top = (scroll + 2) + "px";
                        }
                        if (scrollLeft <= 4) {
                            box[i].style.left = "5px";
                        } else {
                            box[i].style.left = (scrollLeft + 2) + "px";
                        }
                    }
                };

                $('#dragSource li, #dragSource2 li').draggable({
                    //                $('.droppableContainer li').draggable({  //jian hua
                    helper: function () {
                        var selected = $('.droppableContainer input:checked').parents('li');
                        if (selected.length === 0) {
                            selected = $(this);
                        }
                        var container = $('<div/>').attr('id', 'draggingContainer');
                        container.append(selected.clone());
                        return container;
                    },
                    start: function (e, ui) {
                        //                        remember = $(this).attr('id');
                        //                        $(this).html("<div>hello</div>");
                    },
                    stop: function (e, ui) {
                        //                        $(this).html(remember);
                    }
                });

            <%
                for (int i = 0; i < emptyList.size(); i++)
                {
                    String identifier = emptyList.get(i);
            %>
                $('#dropTarget<%=identifier%>').droppable({
                    tolerance: 'pointer',
                    drop: function (event, ui) {
                        if (completed) {
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
                            clone.mousedown(function () {
                                select(clone);
                            });

                            $(this).append(clone);
                            vzone = $(this);
                            velem = clone;

                            window.open(baseUrl + 'ftId=' + ftId + '&fId=' + fId, '1385013844412', 'width=500,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');
                        } else {
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
                                clone.mousedown(function () {
                                    select(clone);
                                });

                                $(this).append(clone);
                                vzone = $(this);
                                velem = clone;

                                window.open(baseUrl + 'ftId=' + ftId + '&fId=' + fId, '1385013844412', 'width=500,height=500,toolbar=0,menubar=0,location=0,status=1,scrollbars=1,resizable=1,left=0,top=0');

                            } else
                            {
                                alert("Please continue defining the field!");
                            }
                        }
                    }
                });
            <% }%>

                $('#selectAll').click(function () {
                    //                        $('#dragSource input').attr('checked', 'checked');
                    $('.droppableContainer input').attr('checked', 'checked');//jian hua
                    return false;
                });

                $('#selectNone').click(function () {
                    //                        $('#dragSource input').removeAttr('checked');
                    $('.droppableContainer input').removeAttr('checked'); //JIAN HUA
                    return false;
                });

                $('#selectInvert').click(function () {
                    //                        $('#dragSource input').each(function(){
                    $('.droppableContainer input').each(function () { //JIAN HUA
                        var $this = $(this);
                        if ($this.attr('checked')) {
                            $this.removeAttr('checked');
                        } else {
                            $this.attr('checked', 'checked');
                        }
                    });
                    return false;
                });
            });

            function fnalert() {
                alert(<%=emptyList.size()%>);
            }
        </script>
    </head>
    <body >
        <div id="dvLoading"></div>
        <div id="overlay" class="web_dialog_overlay"></div>
        <% if (formId != 0)
            {%>
        <div style="display: block;overflow:auto;display:inline;white-space:nowrap;">
            <div style="float:left;margin-right:-1000em">
                <!--            <div class="button" id="activatedPreview">
                                <input name="actpreview" id="actpreview" type="image" src="images/preview.png" alt="Preview" style="cursor:pointer;"/>
                            </div>-->
                <!--Edited by JIAN HUA-->
                <div id="dragSource" class="droppableContainer">
                    <div style="float: left;display: block;">
                        <ul>
                            <li><img width="350" id="1" name="1" src="fieldsimg/1.png" /></li>
                            <li><img width="350" id="2" name="2" src="fieldsimg/2.png" /></li>
                            <li><img width="350" id="5" name="5" src="fieldsimg/5.png" /></li>
                            <li><img width="350" id="3" name="3" src="fieldsimg/3.png" /></li>
                            <li><img width="350" id="4" name="4" src="fieldsimg/4.png" /></li>
                            <li><img width="350" id="19" name="19" src="fieldsimg/19.png" /></li>
                            <li><img width="350" id="16" name="16" src="fieldsimg/16.png" /></li>
                            <li><img width="350" id="17" name="17" src="fieldsimg/17.png" /></li>
                            <li><img width="350" id="18" name="18" src="fieldsimg/18.png" /></li>
                            <li>
                                <div class="button" style="display: inline;">
                                    <input name="preview" id="preview" type="image" src="images/preview.png" alt="Preview" style="cursor:pointer"/>
                                </div>
                                <div class="button" style="display: inline;">
                                    <input name="edit" id="edit" type="image" src="images/edit.png" alt="Edit" style="cursor:pointer"/>
                                </div>
                                <div>
                                    <div style="display: inline; color:white">Preview</div>
                                    <div style="display: inline; color:white">Edit</div>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <p></p>
                </div>
                <!-- <div id="dragSource" class="droppableContainer">
                     <div style="float: left;">
                         <ul>
                                                 <div class="button">
                                                     <button id="preview" name="preview">Preview</button>
                                                 </div>
                             <li><img width="350" id="1" name="1" src="fieldsimg/1.png" /></li>
                             <li><img width="350" id="2" name="2" src="fieldsimg/2.png" /></li>
                             <li><img width="350" id="3" name="3" src="fieldsimg/3.png" /></li>
                             <li><img width="350" id="4" name="4" src="fieldsimg/4.png" /></li>
                             <li><img width="350" id="5" name="5" src="fieldsimg/5.png" /></li>
                                                 <li><img width="80" id="6" name="6" src="fieldsimg/6.png" /></li>
                             <li><img width="350" id="7" name="7" src="fieldsimg/7.png" /></li>
                             <li><img width="350" id="8" name="8" src="fieldsimg/8.png" /></li>
                             <li><img width="350" id="9" name="9" src="fieldsimg/9.png" /></li>
                             <li><img width="350" id="10" name="10" src="fieldsimg/10.png" /></li>
                             <li><img width="350" id="11" name="11" src="fieldsimg/11.png" /></li>
                             <li><img width="350" id="12" name="12" src="fieldsimg/12.png" /></li>
                             <li><img width="350" id="13" name="13" src="fieldsimg/13.png" /></li>
                             <li><img width="350" id="14" name="14" src="fieldsimg/14.png" /></li>
                         </ul>
                     </div>
                     <div id="mybuttons">                    <div class="button">
                         <div class="button">
                             <input name="preview" id="preview" type="image" src="images/preview.png" alt="Preview" style="cursor:pointer"/>
                         </div>
                         <div class="button">
                             <input name="edit" id="edit" type="image" src="images/edit.png" alt="Edit" style="cursor:pointer"/>
                         </div>
                         <div class="button">
                             <input name="copy" id="copy" type="button" value="Copy" style="cursor:pointer"/>
                         </div>
                         <div class="button">
                                                     <button id="edit" name="edit">Edit</button>
                                                 </div>
                                                 <div class="button">
                             <input name="delete" id="delete" type="image" src="images/delete.png" alt="Delete" style="cursor:pointer"/>
                         </div>
                                                 <button id="delete" name="delete">Delete</button>
                                             </div>
                     </div>
                 </div>-->
                <div id="box" style="background-color:#F0F0F0">
                    <fieldset>
                        <legend><%=formName%></legend>
                        <%=htmlTags%>
                    </fieldset>
                </div>
                <!--Edited by JIAN HUA-->
                <div id="dragSource2" class="droppableContainer" style="position: absolute;right:0; top:5px">
                    <div style="float:left">
                        <ul>
                            <li><img width="350" id="8" name="8" src="fieldsimg/8.png" /></li>
                            <li><img width="350" id="11" name="11" src="fieldsimg/11.png" /></li>
                            <li><img width="350" id="9" name="9" src="fieldsimg/9.png" /></li>
                            <li><img width="350" id="10" name="10" src="fieldsimg/10.png" /></li>
                            <li><img width="350" id="13" name="13" src="fieldsimg/13.png" /></li>
                            <li><img width="350" id="7" name="7" src="fieldsimg/7.png" /></li>
                            <li><img width="350" id="12" name="12" src="fieldsimg/12.png" /></li>
                            <li><img width="350" id="14" name="14" src="fieldsimg/14.png" /></li>
                            <li>
                                <div class="button" style="display:inline" >
                                    <input name="copy" id="copy" type="image" src="images/copy.png" alt="copy" style="cursor:pointer"/>
                                </div>

                                <div class="button" style="display:inline">
                                    <input name="delete" id="delete" type="image" src="images/delete.png" alt="Delete" style="cursor:pointer"/>
                                </div>

                                <div ><div style="display:inline; color:white">Copy</div><div style="display:inline; margin-left:20px; color:white" >Delete</div></div>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <% }
        else
        {%>
        <h1>Invalid Access! Access Denied!</h1>
        <% }%>
    </body>
</html>
