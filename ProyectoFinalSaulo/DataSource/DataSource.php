<?php
class DataSource {
    private $host = "localhost";
    // private $db = "id13243509_jsgame";
    // private $user = "id13243509_saulo";
    // private $password = "H>i5B{3O~zwq-xdj";
        private $db = "jsgame";
        private $user = "root";
        private $password = "";
    private $dbh;
    /**
    * Método getter que devuelve el atributo dbh
    */
    public function getDbh() {
        return $this->dbh;
    }
    /**
    * Método que abre una conexión sobre base de datos
    */
    public function openConnection() {
        try {
            $dsn = "mysql:host=$this->host;dbname=$this->db";
            $this->dbh = new PDO($dsn, $this->user, $this->password);
            $this->dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        } catch (PDOException $e){
             echo $e->getMessage();
         }
     }
    /**
    * Método que cierra una conexión sobre base de datos
    */
    public function closeConnection() {
        $this->dbh = null;
    }
}