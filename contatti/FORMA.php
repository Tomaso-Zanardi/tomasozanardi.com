<?php

    if(isset($_POST['email']) && $_POST['email'] !=''){
    

        if( filter_var($_POST['email'], FILTER_VALIDATE_EMAIL) ){

            // submit the form
            $userName = $_POST['name'];
            $userEmail = $_POST['email'];
            $messageSubject = $_POST['subject'];
            $message = $_POST['message'];


            $to = "zanardit@hu-berlin.de";
            $body = "";

            $body .= "Da: ".$userName. "\r\n";
            $body .= "Email: ".$userEmail. "\r\n";
            $body .= "Oggetto: ".$messageSubject. "\r\n";
            $body .= "Messaggio: ".$message. "\r\n";

            mail($to,$messageSubject,$body);
        }


    
    }

?>

<style>
.label{font-family: Palatino Linotype;


}

</style>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contatti</title>
    <link rel="icon" type="image/x-icon" href="../immagini/favic.png">
    <link rel="stylesheet" href="../CSS/2.css" media="all">
    
</head>
<div class="topnav">
  <a href="../index.html">Home</a>
</div>  
<body>

    <div class="container">
            <form action="FORMA.php" method="POST" class="form">
                <div class="form-group">
                    <label for="name" class="form-label">Nome</label>
                    <input style="font-family: Palatino Linotype;" type="text" class="form-control" id="name" name="name" placeholder="Nome" tabindex="1" required>
                </div>
                <div class="form-group">
                    <label for="email" class="form-label">Indirizzo Email</label>
                    <input style="font-family: Palatino Linotype;" type="email" class="form-control" id="email" name="email" placeholder="la_tua_mail@blablabla.it" tabindex="2" required>
                </div>
                <div class="form-group">
                    <label for="subject" class="form-label">Oggetto</label>
                    <input style="font-family: Palatino Linotype;" type="text" class="form-control" id="subject" name="subject" placeholder="Ciao Tom!..." tabindex="3" required>
                </div>
                <div class="form-group">
                    <label for="message" class="form-label">Messaggio</label>
                    <textarea style="font-family: Palatino Linotype;" class="form-control" rows="5" cols="50" id="message" name="message" placeholder="Scivi qui il tuo messaggio..." tabindex="4"></textarea>
                </div>
                <div>
                    <button type="submit" class="btn" style="font-family: Palatino Linotype;">Invia il messaggio!</button>
                </div>
            </form>
    </div>
</body>

</html>