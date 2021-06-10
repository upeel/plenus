var processUrl = "genheaderprocess.jsp";
function isNormalInteger(str) {
    return /^\+?(0|[1-9]\d*)$/.test(str);
}
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
                //alert("Please fill in Mandatory Fields.");
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
        height: 300,
        width: 400,
        modal: true,
        resizable: false,
        buttons: {
            "Update": function() {
                //allFields.removeClass( "ui-state-error" );
                if(checkEditMandatory() == false){
                //alert("Please fill in Mandatory Fields.");
                }else{
                   
                    document.editForm.action=processUrl;
                    document.editForm.submit();
                          
                      
                // $( this ).dialog( "close" );
                    
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
        var vid = editForm.elements["id"].value;
        $.ajax({ 
            cache: false,
            url: "getValues.jsp",
            data: "genId="+vid+"&mode=gen",
            success: function(data){ 
                var scData=eval(data); 
                var txtGenName = scData[0].txtGenName;
                var txtGenDigit = scData[0].txtGenDigit;
                var txtGenStart = scData[0].txtGenStart;
                editForm.elements["txtGenName"].value = txtGenName;
                editForm.elements["txtGenDigit"].value = txtGenDigit;
                editForm.elements["txtGenStart"].value = txtGenStart;
            }
        });
    })  
                       
    $( ".btnDelete" ).click(function() {
        var id = document.getElementById("editid").value;
        deleteForm.elements["id"].value = id;
    })
})  

function checkMandatory(){ 
    var txtGenName = addForm.elements["txtGenName"].value; 
    var txtGenDigit = addForm.elements["txtGenDigit"].value;
    var txtGenStart = addForm.elements["txtGenStart"].value;
    if(txtGenName == null || txtGenName == "" || txtGenName == " "){
        addForm.elements["txtGenName"].style.background = '#F88888';
        return false;
    } else{ 
        addForm.elements["txtGenName"].style.background = '#FFFFFF';
    } 
    
    if(txtGenDigit == null || txtGenDigit == ""){
        addForm.elements["txtGenDigit"].style.background = '#F88888';
        alert("Please fill in all Mandatory Fields!");
        return false;
    } else if(!isNormalInteger(txtGenDigit)){
        addForm.elements["txtGenDigit"].style.background = '#F88888';
        alert("Please fill in only Integer for No. of Digit!");
        return false;
    } else if(parseInt(txtGenDigit) <=0){
        addForm.elements["txtGenDigit"].style.background = '#F88888';
        alert("No. of Digit have to be at least 1!");
        return false;
    } else{
        addForm.elements["txtGenDigit"].style.background = '#FFFFFF';
    }
    
    if(txtGenStart == null || txtGenStart == ""){
        addForm.elements["txtGenStart"].style.background = '#F88888';
        alert("Please fill in all Mandatory Fields!");
        return false;
    } else if(!isNormalInteger(txtGenStart)){
        addForm.elements["txtGenStart"].style.background = '#F88888';
        alert("Please fill in only Integer for Start No.!");
        return false;
    } else{
        addForm.elements["txtGenStart"].style.background = '#FFFFFF';
    }
    return true;
}

function checkEditMandatory(){ 
    var txtGenName = editForm.elements["txtGenName"].value; 
    var txtGenDigit = editForm.elements["txtGenDigit"].value;
    var txtGenStart = editForm.elements["txtGenStart"].value;
    if(txtGenName == null || txtGenName == "" || txtGenName == " "){
        editForm.elements["txtGenName"].style.background = '#F88888';
        alert("Please fill in all Mandatory Fields!");
        return false;
    } else{ 
        editForm.elements["txtGenName"].style.background = '#FFFFFF';
    } 
    if(txtGenDigit == null || txtGenDigit == ""){
        editForm.elements["txtGenDigit"].style.background = '#F88888';
        alert("Please fill in all Mandatory Fields!");
        return false;
    } else if(!isNormalInteger(txtGenDigit)){
        editForm.elements["txtGenDigit"].style.background = '#F88888';
        alert("Please fill in only Integer for No. of Digit!");
        return false;
    } else if(parseInt(txtGenDigit) <=0){
        editForm.elements["txtGenDigit"].style.background = '#F88888';
        alert("No. of Digit have to be at least 1!");
        return false;
    } else{
        editForm.elements["txtGenDigit"].style.background = '#FFFFFF';
    }
    
    if(txtGenStart == null || txtGenStart == ""){
        editForm.elements["txtGenStart"].style.background = '#F88888';
        alert("Please fill in all Mandatory Fields!");
        return false;
    } else if(!isNormalInteger(txtGenStart)){
        editForm.elements["txtGenStart"].style.background = '#F88888';
        alert("Please fill in only Integer for Start No.!");
        return false;
    } else{
        editForm.elements["txtGenStart"].style.background = '#FFFFFF';
    }
    return true;
}


function fnseteditval(vid,v,vr){
    document.getElementById("editid").value=vid;     
}