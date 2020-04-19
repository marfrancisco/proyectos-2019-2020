<?php

class Usuario{
    
    private $id;
    private $usuario;
    private $password;
    private $email;


    public function __construct($id, $usuario, $password, $email) {
        $this->id = $id;
        $this->usuario = $usuario;
        $this->password = $password;
        $this->email = $email;

        }

        
       
    function __get($get){
        return $this->$get;
    }

}
?>