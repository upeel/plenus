<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/button/assets/skins/sam/button.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/container/assets/skins/sam/container.css" />
        <script type="text/javascript" src="../include/js/yui/yahoo-dom-event/yahoo-dom-event.js"></script>
        <script type="text/javascript" src="../include/js/yui/element/element-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/button/button-min.js"></script>
        <script type="text/javascript" src="../include/js/yui/container/container-min.js"></script>
        <style>
            #alertcontainer {
                height:0px;
                width:0px;
            }

            #messagebody{
                height:0px;
                width:0px;
            }
        </style>
    </head>

    <body id="messagebody" class=" yui-skin-sam">

        <script>
            YAHOO.namespace("example.container");

            function alertMessage(message) {
                var handleYes = function() {
                    this.hide();
                };

                YAHOO.example.container.alertdialog = new YAHOO.widget.SimpleDialog("alertdialog",
                {   width: "300px",
                    fixedcenter: true,
                    visible: false,
                    draggable: false,
                    close: false,
                    text: message,
                    modal: true,
                    icon: YAHOO.widget.SimpleDialog.ICON_WARN,
                    constraintoviewport: true,
                    buttons: [ { text:"OK", handler:handleYes }]
                } );
                YAHOO.example.container.alertdialog.setHeader("bmFLO Alert: ");
                YAHOO.example.container.alertdialog.render("alertcontainer");
                YAHOO.example.container.alertdialog.show();
            }
        </script>
        
        <div id="alertcontainer"></div>

    </body>
</html>