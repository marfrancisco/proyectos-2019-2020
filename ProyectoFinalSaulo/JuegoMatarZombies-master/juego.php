<?php
session_start();
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.2/css/bootstrap.min.css" integrity="sha384-PsH8R72JQ3SOdhVi3uxftmaW6Vc51MKb0q5P2rRUpPvrszuE4W1povHYgTpBfshb"
        crossorigin="anonymous">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.css">
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js"></script>

    <link rel="stylesheet" href="style/juego.css">

    <title>Juego</title>
</head>

<body>
    <div class="contenedor" id="contenedor">
        <div class="totalMonster" id="totalMonster">10</div>
        <div class="time" id="time">0</div>
        <div class="municion" id="municion">10</div>
        <div class="boton" id="boton"  style="width: 150px;">
            <button class="btn btn-danger" id="btnStart" onclick="startJuego(true)">EMPEZAR PARTIDA CON MIRA</button>
            <br><button class="btn btn-danger" id="btnStartArma" onclick="startJuego(false)">EMPEZAR PARTIDA CON ARMA</button>
        </div>
        <div class="botonesFinal" id="botonesFinal">
        <form action="" method="POST">
            <input type="hidden" name="puntos" value="2000">
            <input type="submit" class="btn btn-danger" value="Atras" style="width: 210px;"></input>
        </form>
        </div>
        <div id="arma"></div>
        <h1 id="txtAv">Selecciona un Avatar</h1>
        <div class="contAvatar">
            <div class="selecAcatar" id="avatar1" onclick="selectAvat(this.id, '<?php print $_SESSION['user']?>')"></div>
            <div class="selecAcatar" id="avatar2" onclick="selectAvat(this.id, '<?php print $_SESSION['user']?>')"></div>
            <div class="selecAcatar" id="avatar3" onclick="selectAvat(this.id, '<?php print $_SESSION['user']?>')"></div>
            <div class="selecAcatar" id="avatar4" onclick="selectAvat(this.id, '<?php print $_SESSION['user']?>')"></div>
        </div>
    </div>
    <script src="js/juego.js"></script>
    <script>
        var miedo = document.createElement('audio');
        miedo.setAttribute('src', 'Sounds/miedo.mp3');
        miedo.play();
    </script>
</body>
<?php

if (isset($_POST["puntos"])){

    require '../DAO/GamesDAO.php';
    require_once '../Modelos/Game.php';
    $puntos = $_POST["puntos"];
    $juego ="zombies";
    $iduser= $_POST["iduser"];
    $gameDao = new GamesDAO();
    $games = $gameDao->selectGames();

    $exist=false;

    foreach($game as $games){
        print("<script> alert(".print_r("hola").")</script>");
            if($game->nombre==$juego && $game->id_usuario==$iduser){
    
                $exist=true;
            }
    }
    

    if($exist){
        return;
    }
    else{
        
        // header("Location: ../public_html/pagina-principal.php");
        $newgame = Game($juego, $puntos, $iduser);

        $gameDao->insertGame($newgame);
        

    }



}

?>
</html>