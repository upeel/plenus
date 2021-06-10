<%-- 
    Document   : flowchartpreview
    Created on : Feb 5, 2014, 4:00:29 PM
    Author     : SOE HTIKE
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import = "java.util.*"
         import = "java.lang.*"
         import = "com.bizmann.product.controller.*"
         import = "com.bizmann.flowchart.controller.*"
         import = "com.bizmann.product.entity.*"
         import = "com.bizmann.flowchart.entity.*"
         import = "com.bizmann.product.resources.*" %>
<%@ include file="helper/sessioncheck.jsp" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setHeader("Cache-Control", "no-store");
    response.setHeader("Expires", "0");

    response.addHeader("REFRESH", request.getSession().getMaxInactiveInterval() + ";URL=../include/redirect.jsp");

    int flowChartId = 0;
    String strflowChartId = request.getParameter("flowChartId");
    if (strflowChartId != null) {
        if (strflowChartId.equals("")) {
            strflowChartId = "0";
        }
        flowChartId = Integer.parseInt(strflowChartId);
    }

    FlowChartFlowController fcfCtrl = new FlowChartFlowController();
    FlowChartActionController fcaCtrl = new FlowChartActionController();

    ArrayList<FlowChartFlow> flowList = fcfCtrl.getAllFlowByFlowChartId(flowChartId);
    ArrayList actionList = fcaCtrl.getActionsByFlowChartId(flowChartId);

    FlowChartAction startAction = new FlowChartAction();
    FlowChartAction endAction = new FlowChartAction();

    StringBuilder sbdend = new StringBuilder();

    HashMap<Integer, ArrayList> sourceMap = new HashMap<Integer, ArrayList>();
    HashMap<Integer, ArrayList> targetMap = new HashMap<Integer, ArrayList>();

    for (int a = 0; a < actionList.size(); a++) {
        FlowChartAction fca = (FlowChartAction) actionList.get(a);
        int srcId = fca.getId();
        ArrayList sourcePoints = new ArrayList();
        ArrayList targetPoints = new ArrayList();

        //int trgId = fcf.getTarget_action_id();
        for (int b = 0; b < flowList.size(); b++) {
            FlowChartFlow tmpfcf = flowList.get(b);
            int tmpsrcId = tmpfcf.getSource_action_id();
            int tmptrgId = tmpfcf.getTarget_action_id();
            if (tmpsrcId == srcId) {
                if (sourcePoints.size() == 0 && !targetPoints.contains("RightMiddle")) {
                    sourcePoints.add("RightMiddle");
                } else {
                    if (!targetPoints.contains("TopCenter") && !sourcePoints.contains("TopCenter")) {
                        sourcePoints.add("TopCenter");
                    } else if (!targetPoints.contains("LeftMiddle") && !sourcePoints.contains("LeftMiddle")) {
                        sourcePoints.add("LeftMiddle");
                    } else if (!targetPoints.contains("BottomCenter") && !sourcePoints.contains("BottomCenter")) {
                        sourcePoints.add("BottomCenter");
                    }
                }
            }
            if (tmptrgId == srcId) {
                if (targetPoints.size() == 0 && !sourcePoints.contains("LeftMiddle")) {
                    targetPoints.add("LeftMiddle");
                } else {
                    if (!targetPoints.contains("TopCenter") && !sourcePoints.contains("TopCenter")) {
                        targetPoints.add("TopCenter");
                    } else if (!targetPoints.contains("BottomCenter") && !sourcePoints.contains("BottomCenter")) {
                        targetPoints.add("BottomCenter");
                    } else if (!targetPoints.contains("RightMiddle") && !sourcePoints.contains("RightMiddle")) {
                        targetPoints.add("RightMiddle");
                    }
                }
            }
        }

        sourceMap.put(srcId, sourcePoints);
        targetMap.put(srcId, targetPoints);

        String source = "";
        String target = "";
        for (int x = 0; x < sourcePoints.size(); x++) {
            if (x == 0) {
                source = source + "'" + (String) sourcePoints.get(x) + "'";
            } else {
                source = source + ", '" + (String) sourcePoints.get(x) + "'";
            }
        }
        for (int x = 0; x < targetPoints.size(); x++) {
            if (x == 0) {
                target = target + "'" + (String) targetPoints.get(x) + "'";
            } else {
                target = target + ", '" + (String) targetPoints.get(x) + "'";
            }
        }
        sbdend.append("_addEndpoints('window" + srcId + "', [" + source + "], [" + target + "]);\n\r");

        // jsPlumb.connect({uuids:["window1RightMiddle", "window2LeftMiddle"], detachable:false});
        //_addEndpoints("window1", ["TopCenter", "BottomCenter", "RightMiddle"], ["LeftMiddle"]);
    }

    //possible connections : rightmiddle vs. left middle & topcenter vs. topcenter & bottomcenter vs. bottomcenter
    //#window1 { top:13em;left:1em;}

    StringBuilder sbdpos = new StringBuilder();
    StringBuilder sbdwin = new StringBuilder();

    int top = 7;
    int left = 3;
    for (int a = 0; a < actionList.size(); a++) {
        FlowChartAction fca = (FlowChartAction) actionList.get(a);
        int actionId = fca.getId();
        String actionName = fca.getName();
        String actionType = fca.getType();
        boolean isStartAction = fca.isIs_start_action();
        if (isStartAction) {
            startAction = fca;
        }

        String shape = "Rectangle";

        if (actionType.equalsIgnoreCase("End")) {
            endAction = fca;
            top = 7;
            left = left + 20;
            shape = "CircleEnd";
        }
        if (actionType.equalsIgnoreCase("Decision")) {
            top = 9;
            left = left + 20;
            shape = "Diamond";
        }
        if (actionType.equalsIgnoreCase("BusinessProcess")) {
            if (isStartAction) {
                top = 7;
                left = left + 15;
                shape = "CircleStart";
            } else {
                top = 8;
                left = left + 20;
                shape = "Rectangle";
            }
        }

        if (a == 0) {
            left = 3;
        } else {
            top = top + ((a / 5) * 20);
            if (a % 5 == 0) {
                left = ((a / 5) * 3) + 3;
            }
        }

        sbdpos.append("#window");
        sbdpos.append(actionId);
        sbdpos.append(" { top:");
        sbdpos.append(top);
        sbdpos.append("em;left:");
        sbdpos.append(left);
        sbdpos.append("em;}\n\r");

        sbdwin.append("<div class='shape' id='window");
        sbdwin.append(actionId);
        sbdwin.append("' data-shape='");
        sbdwin.append(shape);
        sbdwin.append("'>");
        sbdwin.append(actionName);
        sbdwin.append("</div>\n\r");
    }


    StringBuilder sbdcon = new StringBuilder();
    for (int a = 0; a < flowList.size(); a++) {
        FlowChartFlow fcf = flowList.get(a);
        int srcId = fcf.getSource_action_id();
        int trgId = fcf.getTarget_action_id();

        ArrayList sourceList = sourceMap.get(srcId);
        ArrayList targetList = targetMap.get(trgId);
        //System.out.println(srcId + " to " + trgId);

        if (sourceList != null && targetList != null) {
            if (sourceList.size() > 0 && targetList.size() > 0) {
                String srcpoi = (String) sourceList.get(0);
                String trgpoi = (String) targetList.get(0);

                sbdcon.append("jsPlumb.connect({uuids:['window" + srcId + srcpoi + "', 'window" + trgId + trgpoi + "'], detachable:false});\n\r");

                sourceList.remove(srcpoi);
                targetList.remove(trgpoi);
            }
        }
    }

    String poscss = sbdpos.toString();
    String winele = sbdwin.toString();
    String endpoi = sbdend.toString();
    String conpoi = sbdcon.toString();
%>

<html>
    <head>
        <link rel="icon" href="../favicon.ico"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>bmFLO</title>
        <script type="text/javascript" src="../include/js/jquery.min.js"></script>
        <script type="text/javascript" src="../include/js/jquery-ui.min.js"></script>
        <script type="text/javascript" src="../include/js/jquery.ui.touch-punch.min.js"></script>  
        <script type="text/javascript" src="../include/js/jsBezier-0.6.js"></script>        
        <script type="text/javascript" src="../include/js/util.js"></script>
        <script type="text/javascript" src="../include/js/dom-adapter.js"></script>
        <script type="text/javascript" src="../include/js/jsPlumb.js"></script>
        <script type="text/javascript" src="../include/js/endpoint.js"></script>
        <script type="text/javascript" src="../include/js/connection.js"></script>
        <script type="text/javascript" src="../include/js/anchors.js"></script>
        <script type="text/javascript" src="../include/js/defaults.js"></script>
        <script type="text/javascript" src="../include/js/connector-editors.js"></script>
        <script type="text/javascript" src="../include/js/connectors-bezier.js"></script>
        <script type="text/javascript" src="../include/js/connectors-statemachine.js"></script>
        <script type="text/javascript" src="../include/js/connectors-flowchart.js"></script>
        <script type="text/javascript" src="../include/js/renderers-svg.js"></script>
        <script type="text/javascript" src="../include/js/renderers-canvas.js"></script>
        <script type="text/javascript" src="../include/js/renderers-vml.js"></script>
        <script type="text/javascript" src="../include/js/jquery.jsPlumb.js"></script>
        <link rel="stylesheet" type="text/css" href="../include/css/form.css" />
        <link rel="stylesheet" type="text/css" href="../include/js/yui/fonts/fonts-min.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/center.css" />
        <link rel="stylesheet" type="text/css" href="../include/css/demo.css" />
        <style>
            <%=poscss%>
        </style>
        <script>
            (function() {
                window.jsPlumbDemo = {
                    init : function() {
                        jsPlumb.importDefaults({
                            // default drag options
                            DragOptions : {
                                cursor: 'pointer', 
                                zIndex:2000
                            },
                            EndpointStyles : [{
                                    fillStyle:'#225588'
                                }, {
                                    fillStyle:'#558822'
                                }],
                            Endpoints : [ [ "Dot", {
                                        radius:7
                                    } ], [ "Dot", {
                                        radius:11
                                    } ]],
                            ConnectionOverlays : [
                                [ "Arrow", {
                                        location:1
                                    } ],
                                [ "Label", { 
                                        //location:0.1,
                                        //id:"label",
                                        //cssClass:"aLabel"
                                    }]
                            ]
                        });		
                        var connectorPaintStyle = {
                            lineWidth:4,
                            strokeStyle:"#deea18",
                            joinstyle:"round",
                            outlineColor:"#eaedef",
                            outlineWidth:2
                        },
                        connectorHoverStyle = {
                            lineWidth:4,
                            strokeStyle:"#5C96BC",
                            outlineWidth:2,
                            outlineColor:"white"
                        },
                        endpointHoverStyle = {
                            fillStyle:"#5C96BC"
                        },
                        sourceEndpoint = {
                            endpoint:"Dot",
                            paintStyle:{ 
                                strokeStyle:"#1e8151",
                                fillStyle:"transparent",
                                radius:7,
                                lineWidth:2 
                            },				
                            isSource:true,
                            connector:[ "Flowchart", {
                                    stub:[30, 30], 
                                    gap:0, 
                                    cornerRadius:10, 
                                    alwaysRespectStubs:true
                                } ],								                
                            connectorStyle:connectorPaintStyle,
                            hoverPaintStyle:endpointHoverStyle,
                            connectorHoverStyle:connectorHoverStyle,
                            dragOptions:{},
                            overlays:[
                                [ "Label", { 
                                        location:[0.5, 1.5], 
                                        //label:"Drag",
                                        cssClass:"endpointSourceLabel" 
                                    } ]
                            ]
                        },
                        targetEndpoint = {
                            endpoint:"Dot",					
                            paintStyle:{
                                fillStyle:"#1e8151",
                                radius:11
                            },
                            hoverPaintStyle:endpointHoverStyle,
                            maxConnections:-1,
                            dropOptions:{
                                hoverClass:"hover", 
                                activeClass:"active"
                            },
                            isTarget:true,			
                            overlays:[
                                [ "Label", {
                                        location:[0.5, -0.5], 
                                        //                    label:"Drop", 
                                        cssClass:"endpointTargetLabel"
                                    } ]
                            ]
                        },			
                        init = function(connection) {
                            // connection.getOverlay("label").setLabel(connection.sourceId.substring(6) + "-" + connection.targetId.substring(6));
                            connection.bind("editCompleted", function(o) {
                                if (typeof console != "undefined")
                                    console.log("connection edited. path is now ", o.path);
                            });
                        };			

                        var _addEndpoints = function(toId, sourceAnchors, targetAnchors) {
                            for (var i = 0; i < sourceAnchors.length; i++) {
                                var sourceUUID = toId + sourceAnchors[i];
                                jsPlumb.addEndpoint(toId, sourceEndpoint, {
                                    anchor:sourceAnchors[i], 
                                    uuid:sourceUUID,
                                    enabled:false
                                });						
                            }
                            for (var j = 0; j < targetAnchors.length; j++) {
                                var targetUUID = toId + targetAnchors[j];
                                jsPlumb.addEndpoint(toId, targetEndpoint, {
                                    anchor:targetAnchors[j], 
                                    uuid:targetUUID,
                                    enabled:false
                                });						
                            }
                        };
            <%=endpoi%>
                            //                        _addEndpoints("window1", ["TopCenter", "BottomCenter", "RightMiddle"], ["LeftMiddle"]);			
                            //                        _addEndpoints("window2", ["TopCenter", "RightMiddle"], ["LeftMiddle", "BottomCenter"]);
                            //                        _addEndpoints("window3", ["RightMiddle", "BottomCenter"], ["LeftMiddle"]);
                            //                        _addEndpoints("window4", ["BottomCenter", "RightMiddle"], ["LeftMiddle", "TopCenter"]);
                            //                        _addEndpoints("window5", ["RightMiddle", "BottomCenter"], ["TopCenter"]);
                            //                        _addEndpoints("window6", [], ["LeftMiddle", "TopCenter", "BottomCenter"]);
                            jsPlumb.bind("connection", function(connInfo, originalEvent) { 
                                init(connInfo.connection);
                            });							
                            jsPlumb.draggable(jsPlumb.getSelector(".window"), {
                                grid: [20, 20]
                            });
                            //jsPlumb.draggable(document.querySelectorAll(".window"), { grid: [20, 20] });
                            //jsPlumb.connect({uuids:["window1RightMiddle", "window2LeftMiddle"], detachable:false});
                            //jsPlumb.connect({uuids:["window1BottomCenter", "window2BottomCenter"], detachable:false});
                            //jsPlumb.connect({uuids:["window1TopCenter", "window6TopCenter"], detachable:false});
                            //jsPlumb.connect({uuids:["window2RightMiddle", "window3LeftMiddle"], detachable:false});
                            //jsPlumb.connect({uuids:["window2TopCenter", "window4TopCenter"], detachable:false});
            <%=conpoi%>
                            //jsPlumb.bind("click", function(conn, originalEvent) {
                                //if (confirm("Delete connection from " + conn.sourceId + " to " + conn.targetId + "?"))
                                //jsPlumb.detach(conn); 
                            //});	
			
                            //jsPlumb.bind("connectionDrag", function(connection) {
                                //console.log("connection " + connection.id + " is being dragged. suspendedElement is ", connection.suspendedElement, " of type ", connection.suspendedElementType);
                            //});		
			
                            //jsPlumb.bind("connectionDragStop", function(connection) {
                                //console.log("connection " + connection.id + " was dragged");
                            //});
                        }
                    };
                })();

                $(function() {
                    jsPlumbDemo.init();
                    var shapes = $(".shape");
                    jsPlumb.draggable(shapes);
                });
        </script>

    </head>
    <body>
<!--        background="../images/background.png"-->
        <div id="main">
            <div id="render"></div>
            <%=winele%>
            <!--            <div class="shape" id="window1" data-shape="Circle"><div>Raise GRN</div></div>
                        <div class="shape" id="window2" data-shape="Diamond">Routing Decision</div>
                        <div class="shape" id="window3" data-shape="Rectangle"><div>Review GRN</div></div>
                        <div class="shape" id="window4" data-shape="Diamond">Adjustment Decision</div>
                        <div class="shape" id="window5" data-shape="Rectangle">Review Amendments</div>
                        <div class="shape" id="window6" data-shape="Circle">End</div>-->
        </div>
    </body>
</html>
