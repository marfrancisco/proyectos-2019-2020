<?php


require_once 'IGamesDAO.php';
require '../DataSource/DataSource.php';
require '../Modelos/Game.php';

class GamesDAO implements IGamesDAO{
    

    public function selectGames()
    {
        $ds = new DataSource();
        $ds->openConnection();
        $games = array();
        try {
            $dbh = $ds->getDbh();
            $stmt = $dbh->prepare("SELECT id, nombre, puntuacion, id_usuario FROM game ");
            $stmt->setFetchMode(PDO::FETCH_ASSOC);
            $stmt->execute();
            while ($row = $stmt->fetch()) {
                $id = $row["id"];
                $nombre = $row["nombre"];
                $puntuacion = $row["puntuacion"];
                $id_usuario = $row["id_usuario"];
                $game = new Game($id, $nombre, $puntuacion, $id_usuario);
                array_push($games, $game);
            }
        } catch (PDOException $e) {
            echo $e->getMessage();
        }
        $ds->closeConnection();
        return $games;
    }

    public function insertGame($game)
    {
        //Falta la vista y implementar el metodo.
        $ds = new DataSource();
        $ds->openConnection();
        try {
            $dbh = $ds->getDbh();
            $stmt = $dbh->prepare("INSERT INTO game (nombre, puntuacion, id_usuario) VALUES (:nombre, :puntuacion, :id_usuario)");
            $nombre = $game->nombre;
            $puntuacion = $game->puntuacion;
            $id_usuario = $game->id_usuario;
            $stmt->bindParam(':nombre', $nombre);
            $stmt->bindParam(':puntuacion', $puntuacion);
            $stmt->bindParam(':id_usuario', $id_usuario);
            $stmt->setFetchMode(PDO::FETCH_ASSOC);
            $stmt->execute();
           } catch (PDOException $e) {
            echo $e->getMessage();
        }
        $ds->closeConnection();
    }
}

?>


