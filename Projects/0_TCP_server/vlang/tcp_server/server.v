module main

import (
	vweb
)
// A TCP Server will use a stream socket as opposed to a datagram socket
// datagram socket is reserved for udp
pub struct TCPServer {
	port int [required]
	vweb vweb.Context
}

fn create_tcp_server(port int) TCPServer {
	
}