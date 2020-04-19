
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
        integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <link rel="stylesheet" href="../style/style.css">
    <title>Registro</title>
</head>

<body>
<nav class="navbar navbar-light" style="background-color: #519CF1;">
    <a class="navbar-brand" href="index.php"><img src="../img/icon.png" alt="Icono de la pagina"> <img src="../img/jsg1.png" alt="Titulo de la app"></a>
    <a href="#" style="margin-left: 35%;"> <button class="btn btn-outline-dark" type="button">Registro</button></a>
    <a href="login.php"> <button class="btn btn-outline-dark" type="button">Login</button></a>
</nav>

<div class="container">
<div class="row" id="center" style="margin-top:5%;">

<div class="col-md-12">
<!-- Primero ira aqui el diseño dle nombre de la pagina en un col-md-12 -->
<h1>Registro</h1>

<div class="row">

<div class="col-md-3"></div>
<div class="col-md-6">
<form action="" method="POST">
    <br>
  <div class="form-group row">
      <div class="col-sm-1"></div>
    <label for="inputPassword"   id="user" class="col-sm-4 col-form-label">Nombre de Usuario: </label>
    <div class="col-sm-6">
      <input style="border: 1px solid black;" name="user"type="text" required class="form-control">
    </div>
  </div>
  <div class="form-group row">
  <div class="col-sm-1"></div>
    <label for="inputPassword"   class="col-sm-4 col-form-label">Contraseña:  </label>
    <div class="col-sm-6">
      <input style="border: 1px solid black;" name="pass" type="password" required class="form-control" id="inputPassword">
    </div>
  </div>
  <div class="form-group row">
  <div class="col-sm-1"></div>
    <label for="inputPassword"    class="col-sm-4 col-form-label">Repetir Contraseña:  </label>
    <div class="col-sm-6">
      <input style="border: 1px solid black;" name="reppass"type="password" required class="form-control" id="inputPassword">
    </div>
  </div>
  <div class="form-group row">
  <div class="col-sm-1"></div>
    <label for="inputPassword"    require class="col-sm-4 col-form-label">Email:  </label>
    <div class="col-sm-6">
      <input style="border: 1px solid black;" name="email"type="email" required class="form-control" id="inputPassword">
    </div>
  </div>
  <div class="form-group row">
    <div class="col-md-5"></div>
    <div class="col-md-2">
        <input type="submit" class="btn btn-outline-dark" value="Aceptar">
    </div>
    <div class="col-md-5"></div>
  </div>
</form>
</div>
<div class="col-md-3"></div>
</div>



<?php


if(isset($_POST["user"]) && isset($_POST["pass"]) && isset($_POST["reppass"]) && isset($_POST["email"])){

  if($_POST["pass"] == $_POST["reppass"]){
      require '../DAO/UsuariosDAO.php';
      require_once '../Modelos/Usuario.php';
        $usuario = new Usuario(null,$_POST["user"],$_POST["pass"],$_POST["email"]);
        $userDao = new UsuariosDAO();
        //Aqui antes de insertar comprobar si ese usuario ya existe en la bd.
        $totalUsers=$userDao->selectUsuarios();
        if($totalUsers!=null){
            foreach($totalUsers as $usu){

              if($usu->usuario == $_POST["user"]){
                print("Ese nombre de usuario ya existe en la Base de Datos, pruebe con otro");
                return;
              }
        
          }
        }
        $userDao->insertUsuario($usuario);
        //Aqui despues de cada insert hay que volver a hacer un select y enviar un correo con los usuarios registrados.
        header("Location: index.php");


        

    }else{
        print "El campo contraseña y repetir contraseña deben ser iguales";
    }
}

?>
</div>
</div>
<br>
<br>


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
