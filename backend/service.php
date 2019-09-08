<?php
define("db_servername", "localhost");
define("db_username", "root");
define("db_password", "halili");
define("db_name", "eduprog");

function get_db_connection(){
    $conn = mysqli_connect(db_servername, db_username, db_password, db_name);
    return $conn;
}

//. 0 = database error, 1 = success, 2 = user not registered, 3 = incorrect password 
function check_login($user_name, $user_password){
    $ret = 0;
    $conn = get_db_connection();
    $user_name = mysqli_real_escape_string ($conn, $user_name);
    $user_password = md5($user_password);
    $query = "select * from users where user_name = '$user_name'";
    
    if ($conn){
        $result = mysqli_query($conn, $query);
        if (mysqli_num_rows($result) > 0) {
            while($row = mysqli_fetch_assoc($result)) {
                if ($row['user_password'] == $user_password){
                    $ret = 1;
                }else{
                    $ret = 3;
                }
                break;
            }
        }else{
            $ret = 2;
        }
    }else{
        $ret = 0;
    }

    return $ret;
}

function get_param($par){
    if (isset($_POST[$par])){
        return $_POST[$par];
    }

    return null;
}

//. handle request
$_cmd = get_param("cmd");

$response = array(
    "code" => -1,
    "desc" => "",
    "cmd" => ""
);
if ($_cmd == "login"){
    $_user = get_param("u");
    $_passw = get_param("p");

    $ret_login = check_login($_user, $_passw);

    $response["cmd"] = $_cmd;
    $response["code"] = $ret_login ;
    if ($ret_login == 0){
        $_desc = "Database error.";
    }else if($ret_login == 1){
        $_desc = "Success.";
    }else if($ret_login == 2){
        $_desc = "User not registered.";
    }else if($ret_login == 1){
        $_desc = "Incorrect password.";
    }else{
        $_desc = "Unknown.";
    }
    $response["desc"] = $_desc;
}


echo json_encode($response);
?>