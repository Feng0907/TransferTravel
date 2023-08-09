<?php
    //headers
    header('content-type:application:json;charset=utf8');
    header('Access-Control-Allow-Origin: *');
    // header('Access-Control-Allow-Methods:POST');

    //initializing our api
    include_once('../core/initialize.php');

    //instantiate post

    $post = new Post($db);

    $result = $post -> read();
    $num = count($result);

    if($num > 0){
        echo json_encode($result);
        // $post_arr = array();
        // $post_arr['data'] = array();

        // while($row = $result -> fetch(PDO::FETCH_ASSOC)){
        //     exract($row);
        //     $post_item = array(
        //         'id' => $id;
        //         'userid' => $userid;
        //         'name' => $name;
        //         'phone' => $phone;
        //     );
        //     array_push($post_arr['data'], $post_item);
        // }
        // echo json_encode($post_arr);
    } else {
        echo json_encode(array('mwssage' => 'No posts found.'));
    }


?>