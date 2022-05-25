function show(){
    var pswrd = document.getElementById('pswrd');
    var icon = document.querySelector('.fas');
    if (pswrd.type === "password") {
     pswrd.type = "text";
     pswrd.style.marginTop = "20px";
     icon.style.color = "#7f2092";
    }else{
     pswrd.type = "password";
     icon.style.color = "grey";
    }
   }