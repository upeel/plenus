String.prototype.startsWith = function(str){
    return (this.match("^"+str)==str)
}
String.prototype.endsWith = function(str){
    return (this.match(str+"$")==str)
}
String.prototype.beginsWith = function(t, i) {
    if (i==false) {
        return (t == this.substring(0, t.length));
    } else {
        return (t.toLowerCase()== this.substring(0, t.length).toLowerCase());
    }
} 

var preEl ;
var orgBColor;
var orgTColor;
function HighLightTR(el, backColor){
    if(typeof(preEl)!='undefined') { 
        preEl.bgColor=orgBColor;     //alert(preEl.bgColor); 
    }
    orgBColor = el.bgColor; //alert(orgBColor);  
    el.bgColor=backColor; //alert(el.bgColor);
  
    preEl = el;
}

function fnTextAreaMaxLength(id, maxLength) {
    var remarkValue = $("#" + id).val();
    if (remarkValue.length > maxLength) {
        $("#" + id).val(remarkValue.substr(0, maxLength));
    }
}

function limitText(limitField, limitNum){ //alert("1");
    //document.frm.counter.value = limitNum - limitField.value.length;
    if(limitField.value.length > limitNum - 1){
      //  document.frm.counter.value = limitNum - limitField.value.length;
        return false;
    }else{
       // document.frm.counter.value = limitNum - limitField.value.length;
        return true;
    }  
}


var digitsOnly = /[1234567890]/g;
var integerOnly = /[0-9\.]/g;
var alphaOnly = /[A-Za-z]/g;
var usernameOnly = /[0-9A-Za-z\._-]/g;

function restrictInput(myfield, e, restrictionType, checkdot){ //alert("111");
    if (!e) var e = window.event;
    if (e.keyCode) code = e.keyCode;
    else if (e.which) code = e.which;
    var character = String.fromCharCode(code);

    // if user pressed esc... remove focus from field...
    if (code==27) {
        this.blur();
        return false;
    }

    // ignore if the user presses other keys
    // strange because code: 39 is the down key AND ' key...
    // and DEL also equals .
    if (!e.ctrlKey && code!=9 && code!=8 && code!=36 && code!=37 && code!=38 && (code!=39 || (code==39 && character=="'")) && code!=40) {
        if (character.match(restrictionType)) {
            if(checkdot){
                //return !isNaN(myfield.value.toString() + character);
                return true;
            } else {
                return true;
            }
        } else {
            return false;
        }
    }else{
        return false;
    }
}


function fnSetToCurrency(id){ //alert("1");
    var enteredValue = document.getElementById(id).value; //alert("2 : enteredValue : "+enteredValue);
    //alert("trimmed :"+enteredValue.substring(1));
    //alert($('input[value^="$"]').val());
    //enteredValue = enteredValue.substring(1);
    if(enteredValue=="" || enteredValue==null) {
        enteredValue = "$0.00";  
        //alert("2:a : enteredValue : "+enteredValue);
        document.getElementById(id).value = enteredValue;
    } 
   
    else if(!enteredValue.beginsWith("$")) { 
        var newValue = parseFloat(enteredValue).toFixed(2);  //alert("3 : newValue : "+newValue);
        if(isNaN(newValue)) {
            newValue = "0.00";
        }
        document.getElementById(id).value = "$"+newValue;
    //alert(document.getElementById(id).value);
    }
    else if(enteredValue.beginsWith("$")){        
        newValue = parseFloat(enteredValue.substring(1)); // alert("3 : newValue : "+newValue);
        if(isNaN(newValue)) {
            newValue = "0.00";
        } //alert("3 : a: newValue : "+newValue);
        document.getElementById(id).value = "$"+newValue.toFixed(2);
    }
}

function fnSetToNumber(id){ //alert("1");
    var enteredValue = document.getElementById(id).value; //alert("2 : enteredValue : "+enteredValue);
    //alert("trimmed :"+enteredValue.substring(1));
    //alert($('input[value^="$"]').val());
    //enteredValue = enteredValue.substring(1);
    if(enteredValue=="" || enteredValue==null) {
        enteredValue = "0";  
        //alert("2:a : enteredValue : "+enteredValue);
        document.getElementById(id).value = enteredValue;
    } 
   
    else { 
        var newValue = parseInt(enteredValue);  //alert("3 : newValue : "+newValue);
        if(isNaN(newValue)) {
            newValue = 0;  //alert("4 : enteredValue : "+enteredValue);
        }
        document.getElementById(id).value = newValue;
    //alert(document.getElementById(id).value);
    }  
}

function fnSetToPercentage(id){ //alert("1");
    var enteredValue = document.getElementById(id).value; //alert("2 : enteredValue : "+enteredValue);
    if(enteredValue=="" || enteredValue==null || isNaN(enteredValue)) {
        enteredValue = "0%";  
        //alert("2:a : enteredValue : "+enteredValue);
        document.getElementById(id).value = enteredValue;
    } 
    else if(enteredValue.startsWith("-")) {       
        document.getElementById(id).value = enteredValue.substring(1)+"%";
    //alert(document.getElementById(id).value);
    }
    else if(!enteredValue.endsWith("%")) {       
        document.getElementById(id).value = enteredValue+"%";
    //alert(document.getElementById(id).value);
    }
}

function fnChecking(id){
    var check = true;
    if(id == ""){
        alert("Please Select a Row");
        check = false;
    }else{
        check = true;
    }    
    return check;
}
            
function fnOpenWindow(vaction,url,mainFormUrl,arguments){        
    //var arguments = 'width=320, height=200,top=100,left=100,resizable=0,toolbar=0,location=0,directories=0,addressbar=0,scrollbars=0,status=1,menubar=0';
                
    if(vaction == "Add"){
        url= url+"?mode=ADD";  
    }else if(vaction == "Update"){
        var id = document.getElementById("editid").value;
        if(fnChecking(id)){
            url = url+"?mode=UPDATE&id="+id;
        }else{
            url = "";
        }
    }else if (vaction == "Delete"){
        fnDelete(mainFormUrl);                    
    }     
                
    if(vaction == "Add" || vaction == "Update"){
        if(url == ""){
            window.open(mainFormUrl,"_self");
        }else{
            var targetwin = window.open(url, "", arguments);
        }
        targetwin.focus();
    }
}
            
function fnDelete(url){
    var id = document.getElementById("editid").value;
    var check = fnChecking(id);
    if(check){
        var answer = confirm("Please confirm to delete selected row.");
        if(answer){
            document.form.action=url+"?mode=delete&id="+id;
            document.form.method="post";
            document.form.submit();
        }
    }
}
            
var lastclick="";
var lastcolor="";
function fnseteditvalue(vid,v,vr){
    document.getElementById("editid").value=vid;     
    var lastctd=lastclick;
    if(lastctd!=""){
        lastctd.style.background=lastcolor;
    }
    lastcolor = document.getElementById(vr).getAttribute('bgcolor');
    document.getElementById(vr).style.backgroundColor="#BBB";
    lastclick=v;
}
           
function fnChangePointer(obj){
    obj.style.cursor='pointer';
}

function fnExportToExcel(url){
    document.location.href = url;
}

function fnUpload(url){
    window.open(url,'mywin','width=600, height=150,top=100,left=100, toolbar=no,menubar=no,scrollbars=no,copyhistory=no,resizable=no');  
}