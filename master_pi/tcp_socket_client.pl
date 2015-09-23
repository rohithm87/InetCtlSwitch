#!/usr/bin/perl
use IO::Socket::INET;
 
# auto-flush on socket
$| = 1;

if (@ARGV == 0){
  print "no data to send\n";
} 
else {
 
  # create a connecting socket
  my $socket = new IO::Socket::INET (
      PeerHost => '192.168.1.28',
      PeerPort => '26355',
      Proto => 'tcp',
  );
  die "cannot connect to the server $!\n" unless $socket;
  print "connected to the server\n";
   
  # data to send to a server
  my $req = "device $ARGV[0]";
  $socket->send($req);
  print "  sending: $req \n";
   
  # receive a response rom server
  while ($response = <$socket>) {
    print "  - $response\n";
  } 

  # notify server that request has been sent
  shutdown($socket, 1);

  $socket->close();
}
