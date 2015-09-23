#!/usr/bin/perl
#tcpserver.pl

use IO::Socket::INET;
use Device::BCM2835;

Device::BCM2835::init() || die "Could not init library";

# Set RPi pin 11 to be an output
Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_11, 
                            &Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);

#=====================================================================

# flush after every write
$| = 1;

my ($socket,$client_socket);
my ($peeraddress,$peerport);

# creating object interface of IO::Socket::INET modules which internally does
# socket creation, binding and listening at the specified port address.
$socket = new IO::Socket::INET (
				LocalHost => '127.0.0.1',
				LocalPort => '5000',
				Proto => 'tcp',
				Listen => 5,
				Reuse => 1
				) or die "ERROR in Socket Creation : $!\n";

$sock_address = $socket->sockhost();
$sock_port = $socket->sockport();
print "Starting HAS serevr on $sock_address:$sock_port\n";

while(1)
{
# waiting for new client connection.
$client_socket = $socket->accept();

# get the host and port number of newly connected client.
$sock_address = $client_socket->peerhost();
$sock_port = $client_socket->peerport();

#print "Client Connected: $sock_address:$sock_port\n";

$data = "server";
print $client_socket "Server Ready\n"; 
# $client_socket->send($data);

while( $data ne undef ){
	$data = <$client_socket>;

	if ( $data ne undef ){ 	
		chomp ($data);
		my $curdate = `date +"%b %d %R"`;
		chomp $curdate;
		print "== ".$curdate ." > ".ord($data)."\n";
    		my $temp_val = (ord($data) & 1)^1;
		Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_11, $temp_val);
	 	#send_to_slave($temp_val);	
		}
	}
sleep (0.01);
print "----\n";
}

$socket->close();

sub send_to_slave {
 
  my $outData = (shift(@_))?0:1; 

  # create a connecting socket
  my $socket = new IO::Socket::INET (
      PeerHost => '192.168.1.28',
      PeerPort => '26355',
      Proto => 'tcp',
  );
  unless ($socket){
    print "  Slave server error: $!\n";
    return ;
  }
   
  # data to send to a server
  my $req = "device $outData \r\n";
  $socket->send($req);
  print "  connected to slave. sending: $req \n";
   
  # receive a response rom server
  while ($response = <$socket>) {
    print "  - $response\n";
  } 

  # notify server that request has been sent
  shutdown($socket, 1);

  $socket->close();
}

