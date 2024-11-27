<?php
    class functions{
        //data members or member variables
        private $db;
        private $sql;
        private $result;

        //constructor
        function __construct()
        {
            require_once 'DbConnection.php';
            //Creating an instance of class Dbconnection
            $this->db = new Dbconnection;

            //Calling the methods : connect() of class Dbconnection
            $this->db->connect();
        }

        //destructor
        function __destruct()
        {
            //Close the connection 
            $this->db->connect()->close();
        }

        //methods
        public function insert_data($tablename, $fields, $values){
            //Count fields in array
            $count = count($fields);
            //generate insert statement
            //syntax: INSERT INTO tablename(call, col2,...) VALUES(val1,val2,...);
            $this->sql = "INSERT INTO $tablename(";
            for($i=0; $i < $count; $i++){
                $this->sql .= $fields[$i];
                if($i < $count -1){
                    $this->sql .= ",";
                }else{
                    $this->sql .= ") VALUES(";
                }
            }
            for ($i=0; $i < $count; $i++){
                $this->sql .= "'".$values[$i]."'";
                if($i < $count -1){
                    $this->sql .= ",";
                }else{
                    $this->sql .= ");";
                }
            }
           // return $this->sql;
            //execute insert statement
            $this->result = $this->db->connect()->query($this->sql);
            if($this->result === TRUE){
                return true;
            }else{
                return false;
            }
        }
        public function login_user($username,$password){
            $user= stripslashes($username);
            $pwd=stripslashes($password);
            $user = $this->db->connect()->real_escape_string($user);
            $pwd = $this->db->connect()->real_escape_string($pwd);
            $md5=md5($pwd);
            $this->sql="Select * from tbluser where Username='$user' and Userpassword='$md5'";

            $this->result = $this -> db->connect()->query($this->sql);
            if(mysqli_num_rows($this->result)==1){
                return mysqli_fetch_assoc($this->result);
            }
            else{
                return false;
            }
        }
    }
?>
