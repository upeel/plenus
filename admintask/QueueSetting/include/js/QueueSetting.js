/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/* global countTime */

$(document).ready(function (){
  
    bindGenerateQRCodes();
    bindSubmitAction();
//    myFunction();
});

//function myFunction() {
//  var myVar = setTimeout(alertFunc, countTime);
//}
//
//function alertFunc() {
//  alert("Hello!");
//}

function bindSubmitAction(){
    $("#SubmitBtn").on("click", function(){
        if(requiredSubmitValidation()){
            showLoading();
            injectIntentionForGenerateQRCode('Update');
            $("#QueueSettingfrm").submit();
        }
    });
}

function bindGenerateQRCodes(){
    
    $("#generateQRCode").on("click", function(){
        if(requiredSubmitValidation()){
            showLoading();
            var txtLocation = document.getElementById("txtLocation").value;
            var selStatus = document.getElementById("selStatus").value;
            var txtBufferBeforeSkip = document.getElementById("txtBufferBeforeSkip").value;
            var txtMaxPaxAllowed = document.getElementById("txtMaxPaxAllowed").value;
            var outletId = document.getElementById("txtOutletId").value;

            injectIntentionForGenerateQRCode('startGenerateQRCode');
            
            var txtIntention = $('#txtIntention').val();
            var generateQRCodes = $.ajax({
                url: 'QRCodeGenerator',
                data: {outletId: outletId, txtLocation: txtLocation, selStatus: selStatus, txtBufferBeforeSkip: txtBufferBeforeSkip, txtMaxPaxAllowed: txtMaxPaxAllowed, txtIntention: txtIntention,},
                type: "POST"
            });
            generateQRCodes.done(function (QRCodeCreated)
            {
                if(QRCodeCreated !== null){
                    try {
                         var qRCodeCreateds = QRCodeCreated;
                         if(qRCodeCreateds !== null || !qRCodeCreateds.equals("")){
                             $("#txtQueueQRCode").val(qRCodeCreateds);//Test
                             var getSrc = "../../GetAttachmentFile?attachmentFilePath=";
                             getSrc = getSrc + qRCodeCreateds;
                             $("#QRCodeImage")[0].src = getSrc;
                         }
                         alert("Created QR Code Successfully");
                    } catch (err) {
                        alert("Generate QR Code Fail!");
                    }
                }else{
                    alert("Generate QR Code Fail!");
                }
                
            });

            generateQRCodes.fail(function ()
            {
                alert("Fail to Generate QR Code!");
            });
            generateQRCodes.always(function ()
            {
                hideLoading();
            });
        }
    });
}

function injectIntentionForGenerateQRCode(intention)
{
    $("#txtIntention").remove();

    var $intentionInput = $("<input>")
            .attr("id", "txtIntention")
            .attr("name", "txtIntention")
            .attr("type", "text")
            .attr("hidden", true)
            .val(intention);

    $intentionInput.appendTo("#QueueSettingfrm");
}

function requiredSubmitValidation(){
    var result = true;
    var noMandatory = 0;
    var firstValidation = 0;
    
    var txtLocation = $("#txtLocation");
    var selStatus = $("#selStatus");
    var txtBufferBeforeSkip = $("#txtBufferBeforeSkip");
    var txtMaxPaxAllowed = $("#txtMaxPaxAllowed");
    
    var validationList = [];
    validationList.push(txtLocation, selStatus, txtBufferBeforeSkip, txtMaxPaxAllowed);
    console.log(validationList); //Check validation list
    
    for(var v = 0; v < validationList.length; v++){
        
        var thisValue = validationList[v].val();
        var txtContent = validationList[v].selector.replace("#", "").trim();
        var thisElementType = document.getElementById(txtContent).type;
        var lblContent = txtContent.replace("txt", "lbl").replace("sel", "lbl");
        var commentText = txtContent.replace("txt", "").replace("sel", "").trim();
        commentText = commentText.match(/[A-Z][a-z]+/g) + "";
        commentText = commentText.replace(",", " ");
           
        if (fnCheckFormFieldValid(txtContent, thisValue, commentText, firstValidation) === false)
        {   
            $("#"+lblContent).addClass("errorfieldfont");
            noMandatory++;
            
            if(firstValidation === 0){
                if(thisElementType === "select-one"){
                    scrollTo(txtContent+"s");
                }else{scrollTo(txtContent);}
                
                firstValidation++;
            }
            
        }else{
            $("#"+lblContent).removeClass("errorfieldfont");
        }
    }
    
    if(noMandatory !== 0){
        result = false;
    }
    
    return result;
}

function fnCheckFormFieldValid(selectedId, selectedValue, message, firstValidation)
{
    var isValid = true;
    if (selectedValue === '' || selectedValue === null || selectedValue === "0.0000" || selectedValue === undefined || selectedValue === "0" || selectedValue === "0.00")
    {
        if(firstValidation === 0){
            alert(message + " is required to fill!");
        }
        
        isValid = false;
    }
    
    return isValid;
}

function scrollTo(id)
{
    $('html, body').animate({
        scrollTop: $("#"+id).offset().top
    }, 500);
}

function fnNumbersOnly(myfield, e, dec)
{  
    var key;
    var keychar;

    if (window.event)
        key = window.event.keyCode;
    else if (e)
        key = e.which;
    else
        return true;

    keychar = String.fromCharCode(key);
    // control keys 
    if ((key === null) || (key === 0) || (key === 8) || (key === 9) || (key === 13) || (key === 27) )
    {
        return true;
    }
    // numbers
    else if ((("0123456789").indexOf(keychar) > -1))
    {
        return true;   
    }
    // decimal point jump
    else if (dec && (keychar === "."))
    {
        myfield.form.elements[dec].focus();
        return false;
    }
    else
    {
        return false;
    }
}