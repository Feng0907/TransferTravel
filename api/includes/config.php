<?php
$dbms = "mysql";
$host = "localhost";
$dbName = "TransferTravel";
$dsn = "$dbms:host=$host;dbname=$dbName;";
$db_name = 'Feng'; 
$db_password = 'QazEdcRfv357';
try{
 $db = new PDO($dsn, $db_name, $db_password);
 $db ->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
 $db ->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
 $db ->setAttribute(PDO::ATTR_PERSISTENT, true);
//  $db ->setAttribute(PDO::ATTR_STRINGIFY_FETCHES, false);
//  $main->setAttribute(PDO::ATTR_ORACLE_NULLS, PDO::NULL_TO_STRING);
} catch(PDOException $e){
 echo $e->getMessage();
}

?>