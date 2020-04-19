<?php

class Game{
    
    private $id;
    private $nombre;
    private $puntuacion;
    private $id_usuario;


    public function __construct($id, $nombre, $puntuacion, $id_usuario) {
        $this->id = $id;
        $this->nombre = $nombre;
        $this->puntuacion = $puntuacion;
        $this->id_usuario = $id_usuario;

        }

        
       
    function __get($get){
        return $this->$get;
    }

}
?>