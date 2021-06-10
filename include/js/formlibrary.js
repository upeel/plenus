var processUrl = "formlibraryprocess.jsp";
$(function() {
    function checkRegexp( o, regexp, n ) {
        if ( !( regexp.test( o.val() ) ) ) {
            o.addClass( "ui-state-error" );
            updateTips( n );
            return false;
        } else {
            return true;
        }
    }

    $( "#dialog-form" ).dialog({
        autoOpen: false,
        height: 400,
        width: 300,
        modal: true,
        resizable: false,
        buttons: {
            "Add": function() {
                //allFields.removeClass( "ui-state-error" ); 
                if(checkMandatory() == false){
                    alert("Please fill in Mandatory Fields.");
                }                
                else{
                    
                    document.addForm.action=processUrl;
                    document.addForm.submit();
                //$( this ).dialog( "close" );
                   
                }
            },
            Cancel: function() {
                $( this ).dialog( "close" );
            }
        },
        close: function() {
        //allFields.val( "" ).removeClass( "ui-state-error" );
        }
    });
                
    $( "#dialog-edit-form" ).dialog({
        autoOpen: false,
        height: 400,
        width: 300,
        modal: true,
        resizable: false,
        buttons: {
            "Update": function() {
                //allFields.removeClass( "ui-state-error" );
                if(checkEditMandatory() == false){
                    alert("Please fill in Mandatory Fields.");
                }else{
                    
                    
                    document.editForm.action=processUrl;
                    document.editForm.submit();
                        
                    
                }
            },
            Cancel: function() {
                $( this ).dialog( "close" );
            }
        },
        close: function() {
        //allFields.val( "" ).removeClass( "ui-state-error" );
        }
    });
                
    $( "#dialog-confirm" ).dialog({
        autoOpen: false,
        resizable: false,
        height:200,
        width: 350,
        modal: true,
        buttons: {
            "Delete this item": function() {
                $( this ).dialog( "close" );
                document.deleteForm.action=processUrl;
                document.deleteForm.submit();
            },
            Cancel: function() {
                $( this ).dialog( "close" );
            }
        }
    });

    $( "#dialog-message" ).dialog({
        autoOpen: false,
        modal: true,
        resizable: false,
        height:160,
        buttons: {
            Ok: function() {
                $( this ).dialog( "close" );
            }
        }
    });

    $( ".btnEdit" )
    .button()
    .click(function() {
        var id = document.getElementById("editid").value; 
        if(id == "") $( "#dialog-message" ).dialog( "open" );
        else {
            $( "#dialog-edit-form" ).dialog( "open" );
        }
    });
                              

    $( "#btnAdd" )
    .button()
    .click(function() {
        $( "#dialog-form" ).dialog( "open" );
        
    })
    
    $( ".btnDelete" )
    .button()
    .click(function() {
        var id = document.getElementById("editid").value; 
        if(id == "") $( "#dialog-message" ).dialog( "open" );
        else {
            $( "#dialog-confirm" ).dialog( "open" );
        }
    });
   
});    

function fnEdit(id){
    document.getElementById("editid").value=id;  
}

$(document).ready(function ()
{
    $( ".btnEdit" ).click(function() {
        var id = document.getElementById("editid").value; 
        editForm.elements["id"].value = id;
        $.ajax({ 
            cache: false,
            url: "getValues.jsp",
            data: "formId="+id+"&mode=form",
            success: function(data){
                var scData=eval(data); 
                var formName = scData[0].formName;
                editForm.elements["formName"].value = formName;
                //                    var numberOfPages = scData[0].numberOfPages;
                //                    editForm.elements["numberOfPages"].value = numberOfPages;
                var cbHeader = scData[0].cbHeader;
                editForm.elements["cbHeader"].value = cbHeader;
                var cbFooter = scData[0].cbFooter;
                editForm.elements["cbFooter"].value = cbFooter;
                var cbVoucher = scData[0].cbVoucher;
                editForm.elements["cbVoucher"].value = cbVoucher;
            }
        });
    })
                       
    $( ".btnDelete" ).click(function() {
        var id = document.getElementById("editid").value;
        deleteForm.elements["id"].value = id;
    })
})  

function checkMandatory(){ 
    var txtFormName = addForm.elements["formName"].value; 
    //    var cbVoucher = addForm.elements["cbVoucher"].value;
    var flag = true;
    if(txtFormName == null || txtFormName == "" || txtFormName == " "){ 
        addForm.elements["formName"].style.background = '#F88888';
        flag = false;
    } 
    else{ 
        addForm.elements["formName"].style.background = '#FFFFFF';
    } 
    //    if(cbVoucher == null || cbVoucher == "0"){
    //        addForm.elements["cbVoucher"].style.background = '#F88888';
    //        flag = false;
    //    } 
    //    else{
    //        addForm.elements["cbVoucher"].style.background = '#FFFFFF';
    //    }
    return flag;
}

function checkEditMandatory(){
    var txtFormName = editForm.elements["formName"].value; 
    //    var cbVoucher = editForm.elements["cbVoucher"].value;
    var flag = true;
    if(txtFormName == null || txtFormName == "" || txtFormName == " "){ 
        editForm.elements["formName"].style.background = '#F88888';
        flag = false;
    } 
    else{ 
        editForm.elements["formName"].style.background = '#FFFFFF';
    } 
    //    if(cbVoucher == null || cbVoucher == "0"){
    //        editForm.elements["cbVoucher"].style.background = '#F88888';
    //        flag = false;
    //    } 
    //    else{
    //        editForm.elements["cbVoucher"].style.background = '#FFFFFF';
    //    }
    return flag;
}

function fnseteditval(vid,v,vr){
    document.getElementById("editid").value=vid;     
}