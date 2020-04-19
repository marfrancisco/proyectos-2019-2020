<?php
session_start();
setcookie("currentUser",$_SESSION['user'] );
?>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
        integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <link rel="stylesheet" href="../style/style.css">
    <script src="js/app.js"></script>
    <title>Index</title>
</head>

<body>
<nav class="navbar navbar-light" style="background-color: #519CF1;">
    <a class="navbar-brand" href="index.php"><img src="../img/icon.png" alt="Icono de la pagina"> <img src="../img/jsg1.png" alt="Titulo de la app"></a>
    <a href="puntuaciones.php"><button class="btn btn-outline-dark" type="button">Puntuaciones</button></a>
    <button class="btn btn-outline-dark" type="button"><?php print ($_SESSION["user"]) ?></button>
</nav>


<div class="container">

<br>
    <div class="row">
        <div class="col-sm-6">
            <div class="card">
            <div class="card-body">
                <!-- El comecocos no consegui hacer que funcione en local. probar a cuando subamos al server. -->
                <img src="../img/comecocos.png" style="width:100%;height:350px;" alt="Imagen del comecocos">
                <h5 class="card-title" style="text-align: center;">Comecocos</h5>
                <!-- <p style="text-align: center;"><a href="../Comecocos-gh-pages/html/juego.html"  class="btn btn-primary">Comecocos</a></p> -->
                <p style="text-align: center;"><a href="comecocos-no-operativo.php"  class="btn btn-primary">Comecocos</a></p>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="card">
            <div class="card-body">
                <img src="../img/bounceball.png" style="width:100%;height:350px;" alt="Imagen del Bounceball">
                <h5 class="card-title" style="text-align: center;">Bounceball</h5>
                <p style="text-align: center;"><a href="../juego_BounceBall-master/pages/game.php"  class="btn btn-primary">Bounceball</a></p>
                </div>
            </div>
        </div>
    </div>
    <br>
    <div class="row">
        <div class="col-sm-6">
            <div class="card">
            <div class="card-body">
                <img src="../img/cartas-pokemon.png" style="width:100%;height:350px;" alt="Imagen del comecocos">
                <h5 class="card-title" style="text-align: center;">Cartas pokemon</h5>
                <p style="text-align: center;"><a href="../Pokemon-Cards-gh-pages/juegoMedio.html"  class="btn btn-primary">Cartas pokemon</a></p>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="card">
            <div class="card-body">
                <img src="../img/zombi.png" style="width:100%;height:350px;" alt="Imagen del comecocos">
                <h5 class="card-title" style="text-align: center;">Zombi</h5>
                <p style="text-align: center;"><a href="../juegoMatarZombies-master/juego.php"  class="btn btn-primary">Zombi</a></p>
                </div>
            </div>
        </div>
    </div>
</div>
<br>
<br>
<br>
<div class="footer">
        <div class="col-md-12">
            <h4 style="text-align: center;">Copyright 2020 Saulo De la Santacruz Fernández</h4>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
        integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous">
    </script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
        integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous">
    </script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
        integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous">
    </script>
</body>

</html>