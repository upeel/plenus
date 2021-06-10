/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/* global maxPax, bufferTime */

var notthis = "false";

function initializeTableDataEvent(dataTableElementId)
{
    var $datatable = $('#' + dataTableElementId).DataTable({
        
        "aLengthMenu": [[10, 25, 50, 75, -1], [10, 25, 50, 75, "All"]],
        "iDisplayLength": 10,
        "order": [[0, "asc"]],
  
        "responsive": true,
        "colReorder": true,
        "initComplete": function (settings, json) {
            //show the datatable after initializing
            //In cases where the data to load into the datatable is huge, 
            //it will cause the browser to incur an expensive rendering time
            //only after the data is completely loaded, then show the datatable.
            $('#' + dataTableElementId).show();
        }
    });

    // Setup - add a text input to each footer cell
    $('#' + dataTableElementId + ' tfoot th').each(function () {
        var title = $('#' + dataTableElementId + 'thead th').eq($(this).index()).text();
        $(this).html('<input type="text" placeholder="Search ' + title + ' "/>');
    });

    // Apply the search
    $datatable.columns().every(function () {
        var that = this;
        $('input', this.footer()).on('keyup change', function () {
            that
                    .search(this.value)
                    .draw();
        });
    });

    //Move the footer to the top, just below the title of each column
    $('#' + dataTableElementId + ' tfoot tr').appendTo('#' + dataTableElementId + ' thead');

    //rearrange the search all input text to the right and the extension buttons to the left of the table
    $("#dt_searchAndButtonContainer_" + dataTableElementId + " .dataTables_filter").css("float", "left");
    $("#dt_searchAndButtonContainer_" + dataTableElementId + " .dataTables_filter").css("padding-right", "5px");
    $("#dt_searchAndButtonContainer_" + dataTableElementId + " .dt-buttons").css("float", "left");
    $("#dt_searchAndButtonContainer_" + dataTableElementId).css("float", "right");

    //make sure that the datatable is scaled correctly
    $('#' + dataTableElementId).css("width", "100%");
}
function bindInputTextCharacterCountdownEvent()
{
    $("input[type=text], textarea").each(function ()
    {
        var $inputText = $(this);
        $inputText.on("input", function ()
        {
            var maxLength = this.maxLength;

            if (maxLength < 0)
            {
                //if there is no max length defined in the attribute, do not count down.
                return;
            }

            var spanElementId = "span_" + this.id;
            //check if the span element exist
            var $span_character_countdown = $("#" + spanElementId);

            //if not create it
            if ($span_character_countdown.length <= 0)
            {
                $(this).after("<small><i><span class='characterCountDown' id='" + spanElementId + "'></span></i></small>");
            }

        });
    });
}

window.onunload = function(){
  window.opener.location.reload();
};

$(document).ready(function ()
{
    $("#alertmessage").hide();  
    $("#closeAlertButton").on('click', function(){
        $("#alertmessage").hide();
    });
    initializeTableDataEvent("dtQueue");
    bindStartFiler();
    fnActionButtonOnClick();
    
    bindTimeOutQueue();
    
//    bindTimeToSkipQueueNumber("queueDtId", "btnProcessQueue", "queueNumbers");
    
    var outletStatusVal = document.getElementById("outletStatus").value;
    if(outletStatusVal === "OFF"){
        alert("Outlet Status is OFF!\n\Turn ON the Outlet Status at Queue Setting.");
        window.opener.location.reload();
        close();
        
    }
    
});

function bindTimeOutQueue(){
    var getQueueRow = $(".queueDtId").length;
    
    for(var n=0; n<getQueueRow; n++){
        var qId = $(".queueDtId")[n].value;
        var qNo = $(".queueNumbers")[n].value;
        var btnProc = $(".btnProcessQueue")[n].value;
        var bufferTimes = $(".bufferTimes")[n].value;
        var indexRow = n;
        bindTimeToSkipQueueNumber(qId, btnProc, qNo, bufferTimes, indexRow);
    }
}

function bindTimeToSkipQueueNumber(queueDtId, processType, queueNumbers, bufferTimes, indexRow) {
  var thisQueueIdVal = queueDtId;
  var thisProcessTypeVal = processType;
  var queueNumbersVal = queueNumbers;
  
  if(Number(thisQueueIdVal) !== 0 && !isNaN(Number(thisQueueIdVal)) && thisProcessTypeVal === "HERE"){
//      setTimeout(functionz, bufferTime * 1000);
      onTimer();
  }
  
  function onTimer(){
      var minutes = Math.floor(bufferTimes / 60);
      var seconds = Math.floor(bufferTimes % 60);
      
      if(minutes < 10){
          minutes = "0" + minutes;
      }
      
      if(seconds < 10){
          seconds = "0" + seconds;
      }
      
      document.getElementById("mycounter_"+queueNumbersVal).innerHTML = "Queue will be skipped in "+ minutes+":"+seconds;
        bufferTimes--;
        if (bufferTimes >= 0) {
            setTimeout(onTimer, 1000);
        }
        else{
          fnSkipTheQueue(thisQueueIdVal, thisProcessTypeVal, queueNumbersVal, bufferTimes, indexRow);
        }
      }
}

function fnSkipTheQueue(thisQueueIdVal, thisProcessTypeVal, queueNumbersVal, bufferTimes, indexRow) {
  
    var elem = $(".btnProcessQueue")[indexRow];
    if(elem.value === "HERE"){
        if(elem.value==="HERE") elem.value="SKIPPED";
        else elem.value="SKIPPED";
    }

    injectIntentionQueueAction(elem.value);
//    scrollTo();
//    $("#thisAlert").text("Queue No." +queueNumbersVal+ " has been skipped!\n\Please filter status to check the Skipped Queue.");
//    $("#alertmessage").fadeTo(5000, 500).slideUp(500, function(){
//        $("#alertmessage").slideUp(500);
//    }); 
    $("#actionQueue").submit();

}

function bindStartFiler(){
    $("#selStatus").on("change", function(){
        
        var getStatus = document.getElementById("selStatus");
        if(getStatus.value !== null || getStatus.value !== ""){
            $("#frm").submit();
        }
        
    });
}
function removeButton(){
    var isValid = true;

    if($('#status').value !== "Queue")
    {
        document.getElementById("cancelbtn").disabled = true;
        isValid = false;
    }
    return isValid;
}
function change(el, rowIndex, queueDtId)
{
    var checkRow = 0;
    var queLength = $(".btnProcessQueue").length;
    for(var u=0; u<queLength; u++){
        var btnProcess = $(".btnProcessQueue")[u];
        
        if(btnProcess === el){
            checkRow = u - 1;
            
            if($(".btnProcessQueue")[checkRow] === undefined || $(".btnProcessQueue")[checkRow].value !== "SMS"){   
                var elem = el;
                if(elem.value === "SMS"){
                    if(elem.value==="SMS") elem.value="HERE";
                    else elem.value="HERE";
                }else{
                    if(elem.value==="HERE") elem.value="ARRIVED";
                    else elem.value="ARRIVED";
                }

                $("#queueDtId").val(queueDtId);
                injectIntentionQueueAction(elem.value);
                $("#actionQueue").submit();
            }else{
                scrollTo();
                $("#thisAlert").text("This is not Current Queue No.!");
                $("#alertmessage").fadeTo(5000, 500).slideUp(500, function(){
                    $("#alertmessage").slideUp(500);
                }); 
            }
        }
        
    }
}

function scrollTo()
{
    $('html, body').animate({scrollTop: 0}, 500);
}

function looping(){
var select = '';
for(i=1;i<=maxPax;i++){
    select += '<option val=' + i + '>' + i + '</option>';
}
$('#pax').html(select);
}
function asw(){
var select = '';
for(i=0;i<maxPax;i++){
    select += '<option val=' + i + '>' + i + '</option>';
}
$('#baby').html(select);
}
function injectIntentionQueueAction(intention)
{
    //clear existing intention
    $("#txtIntention").remove();

    //define the intention
    var $intentionInput = $("<input>")
            .attr("id", "txtIntention")
            .attr("name", "txtIntention")
            .attr("type", "text")
            .attr("hidden", true)
            .val(intention);

    //attach the intention to the form element, so that server side knows which operation to perform
    $intentionInput.appendTo("#actionQueue");
}


function fnOpenPopUpWindowsQueueList(thisme, queueDetailId){
    if(queueDetailId !== null || queueDetailId !== ""){
        fnOpenPopUpWindow('OpenQueueDetail','QueueDetail?queueId='+queueDetailId+'');
    }
}

function fnActionButtonOnClick(){
    $("#btnProcessQueue").on("click", function(){
//       fawefaw
    });
}

function validate(evt)
{
    var theEvent = evt || window.event;
    
    if (theEvent.type === 'paste'){
        key = event.clipboardData.getData('text/plain');
    } else{
        var key = theEvent.keyCode || theEvent.which;
        key = String.fromCharCode(key);
    }
    var regex = /[0-9]/;
    if(!regex.test(key)){
        theEvent.returnValue = false;
        if(theEvent.preventDefault) theEvent.prefentDefault();
    }
}
function closeWindow(){
    if(confirm("Are you sure want to close this window?")){
        close();
    }
}
function cancelWindow(){
    if(confirm("Are you sure want to cancel this queue?")){
        cancelbtnOnClick();
    }
}
function updateButtonClick()
{
    if(validationCheck()){
        showLoading();
        injectIntentionInputElementIntoForm("ADD");
        $("#frm").submit();
    }
}

function updatebtnOnClick(){
    if(validationCheck()){
    showLoading();
    injectIntentionInputElementIntoForm("UPDATE");
    $("#frm").submit();
    }
}

function cancelbtnOnClick(){
    showLoading();
    injectIntentionInputElementIntoForm("DELETE");
    $("#frm").submit();
}

function validationCheck(){
    var isValid = true;
    var babyE = document.getElementById("baby");
    var babyV = babyE.value;
    var paxE = document.getElementById("pax");
    var paxV = paxE.value;
    
    var contactE = document.getElementById("contact");
    var contactV = contactE.value;
    var sendSMSE = document.getElementById("sms");
    var sendSMSV = sendSMSE.value;
    
    if((parseInt(paxV) + parseInt(babyV))>maxPax){
        alert("Max Pax is "+maxPax+"!\n\Total Pax cannot be more than Max Pax.");
        isValid = false;
    }else if(sendSMSV === "Yes"){
        if(contactV === "" || contactV === 0 || contactV === "0" || contactV < 0){
            alert("Contact Number is required to fill if Send SMS: 'YES'!");
            isValid = false;
        }
    }
    
    if(paxV > maxPax){
        alert("Total Pax is "+maxPax+"!");
        isValid = false;
    }
    
    return isValid;
}