<?php

class Post{
    //db stuff.
    private $coon;
    private $table = "RouteItem";

    //post properties.
    public $id;
    public $userid;
    public $name;
    public $phone;
    
    //contructor with db connection
    public function __construct($db) {
        $this -> conn = $db;
    }

    //getting posts from db
    public function read(){
        //create query
        $sql = " SELECT * FROM " . $table ;
        $stmt = $this -> conn -> prepare($sql);
        //PDO::FETCH_ASSOC 表示pdoStmt裡面的靜態成員
        $stmt -> execute();
        $arr = $stmt -> fetchAll(PDO::FETCH_ASSOC);
        return $arr;
    }

    


}


?>