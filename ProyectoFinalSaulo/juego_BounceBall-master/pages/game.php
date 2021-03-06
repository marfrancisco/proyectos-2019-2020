<?php
session_start();
setcookie("currentUser",$_SESSION['user'] );
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
    <title>BounceBall</title>
    <!-- Bootstrap core CSS -->
    <link href="../vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template -->
    <link href="https://fonts.googleapis.com/css?family=Catamaran:100,200,300,400,500,600,700,800,900" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Lato:100,100i,300,300i,400,400i,700,700i,900,900i"
          rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="../css/one-page-wonder.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/css/toastr.min.css" media="screen" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="../css/main.css"/>
    <script src="https://code.jquery.com/jquery-1.12.0.js"></script>
    <script type="text/javascript" src="http://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/js/toastr.min.js"></script>
    <!--<script src="../js/jquery-3.2.1.min.js"></script>-->
    <script src="../js/lib/phaser.js"></script>
    <script src="../js/Boot.js"></script>
    <script src="../js/Preloader.js"></script>
    <script src="../js/ScoreBoard.js"></script>
    <script src="../js/Instructions.js"></script>
    <script src="../js/Level1.js"></script>
    <script src="../js/Level2.js"></script>
    <script src="../js/Level3.js"></script>
    <script src="../js/Level4.js"></script>
    <script src="../js/MainMenu.js"></script>
    <script src="../js/main.js"></script>
</head>

<body>
<!-- Navigation -->
<br>
<p style="text-align: center;"> <a href="../../public_html/pagina-principal.php" > <button class="btn btn.primary"></button> Atras</a></p>
<!-- <script src="../js/script.js"></script> -->
<script src="../vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="../bundle.js"></script>
</body>

</html>