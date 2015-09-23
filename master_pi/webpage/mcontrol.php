<html>
<head >
	<title>Rohith's Webpage</title>
</head>

<?php include 'process.php'?>

<style type="text/css">
#buttons
{
	text-align:center;
	width:300px;  
	height:150px;
	font-size:40px;
}
#buttonfont
{
	font-size:30px;
	
} 
</style>

<!------------------------------------------------------------>
<body bgcolor="#50B0FF">
<table width=100% >
<tr><td bgcolor="#606060">
Report all problems to RO
</td></tr>
<tr><td>
	<p style="font-size:50px; padding:10px;">HOME CONTROL PAGE
</td></tr>
<tr><td>

	<form action="mcontrol.php" method="post">
		<?php $totaldevices = count($device);?>
		<?php for($counter = 0;$counter<$totaldevices;$counter++){ ?>

		<br>
			 
			<span id="buttonfont"><?php echo $device[$counter]?> :</span>	
			<input type="submit" name="dev<?php echo $counter?>" value="ON" id="buttons"/>
			<input type="submit" name="dev<?php echo $counter?>" value="OFF"id="buttons"/>
		<?php } ?>


	</form>

<br><br>
</td></tr>
<tr><td>
	<?php 
		analyze_click( $dev_num, $dev_state ); 
		if($dev_num < $totaldevices){     		# dev_num == totaldevices if there is no click	
			echo	$device[$dev_num]." is switched ".$dev_state." [".$values[$dev_state]. "]<br>"	;
			$output= send_via_socket($dev_num, $values[$dev_state]); 
			foreach ($output as $iter){	echo "<pre> " . $iter . "</pre>"; }
		}
	?>
</td></tr>
</table>
</body>
</html>

<!------------------END-OF-PAGE --------------------->
