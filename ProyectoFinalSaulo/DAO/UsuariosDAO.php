<?php

require_once 'IUsuariosDAO.php';
require '../DataSource/DataSource.php';
require '../Modelos/Usuario.php';

class UsuariosDAO implements IUsuariosDAO
{

    public function insertUsuario($usuario)
    {
        //Falta la vista y implementar el metodo.
        $ds = new DataSource();
        $ds->openConnection();
        try {
            $dbh = $ds->getDbh();
            $stmt = $dbh->prepare("INSERT INTO usuario (usuario, password, email) VALUES (:usuario, :password, :email)");
            $user = $usuario->usuario;
            $password = $usuario->password;
            $email = $usuario->email;
            $stmt->bindParam(':usuario', $user);
            $stmt->bindParam(':password', $password);
            $stmt->bindParam(':email', $email);
            $stmt->setFetchMode(PDO::FETCH_ASSOC);
            $stmt->execute();
           } catch (PDOException $e) {
            echo $e->getMessage();
        }
        $ds->closeConnection();
    }


    public function selectUsuarios()
    {
        $ds = new DataSource();
        $ds->openConnection();
        $usuarios = array();
        try {
            $dbh = $ds->getDbh();
            $stmt = $dbh->prepare("SELECT id, usuario, password, email FROM usuario ");
            $stmt->setFetchMode(PDO::FETCH_ASSOC);
            $stmt->execute();
            while ($row = $stmt->fetch()) {
                $id = $row["id"];
                $user = $row["usuario"];
                $password = $row["password"];
                $email = $row["email"];
                $usuario = new Usuario($id, $user, $password, $email);
                array_push($usuarios, $usuario);
            }
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
        $ds->closeConnection();
        return $usuarios;
    }
}

?>