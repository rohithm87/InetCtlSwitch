
<?php   $device = array("Light 1","Light 2" );
        $values = array("OFF" => 0, "ON" => 1); ?>

<!------------------------------------------------------------>

<?php
function send_to_fifo($dev_num, $dev_state)
{
    $send_val = ($dev_num*16)+$dev_state;
    exec("/home/rohith/Projects/ProjectX/drive_uart.pl -u -- $send_val 2>&1", $output);
    return $output;
}

function send_via_socket($dev_num, $dev_state) 
{

   	$switch_val = ($dev_num*16)+$dev_state;
	
	$host    = "127.0.0.1";
	$port    = 5000;
	echo "<br>Sending: ".$switch_val. "<br>";
	$socket = socket_create(AF_INET, SOCK_STREAM, 0) or die("Could not create socket\n");
	$result = socket_connect($socket, $host, $port) or die("Could not connect to server\n");  

	$send_val = chr( $switch_val );	
	socket_write($socket, $send_val, strlen($send_val)) or die("Could not send data to server\n");
	// $result = socket_read ($socket, 1024) or die("Could not read server response\n");
	// echo "<br>$".$result;
	socket_close($socket); // close socket
}

function analyze_click( &$dev_num, &$dev_state ){

    global $device, $value; 
    $totaldevices = count($device);
    $dev_num= $totaldevices;
    $dev_state= count($value);
    for($counter = 0;$counter<$totaldevices;$counter++){
    #       echo $device[$counter].":". $_POST["dev$counter"]."<br>"; 
            if( $_POST["dev$counter"] ){
                    $dev_num=$counter;
                    $dev_state=$_POST["dev$counter"];
            }
    }
}
?>

