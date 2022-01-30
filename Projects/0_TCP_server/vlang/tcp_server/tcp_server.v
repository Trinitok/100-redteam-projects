module main

// There was an error about an openssl file not existing for vweb so I thought I would go even lower level
//  and use the builtin net library
// TCP Listener: https://github.com/vlang/v/blob/master/vlib/net/tcp.v#L209
import net

import process_http_request_type

//  address includes both port and IP address from client
fn get_client_address(tcp_conn &net.TcpConn) ? {
	addr := tcp_conn.peer_addr() ?
	println('here is the client addr')
	println(addr)
}


//  internally calls the peer_addr function
//  https://github.com/vlang/v/blob/b778c1d097f80f1c23975e112c691a9b39facb96/vlib/net/tcp.v#L196
fn get_client_ip(tcp_conn &net.TcpConn) ? {
	ip := tcp_conn.peer_ip() ?
	println('here is the client ip')
	println(ip)
}

//  Try to get the client metadata from the request
fn get_client_meta(mut tcp_conn &net.TcpConn) ? {
	line := tcp_conn.read_line()
	req_type := line[0..5]
	if req_type.contains('GET') {
		process_http_request_type.process_get(line, mut tcp_conn)
	}
	else if req_type.contains('POST') {
		process_http_request_type.process_post(line, mut tcp_conn)
	}
	else {
		process_http_request_type.process_unknown(line, mut tcp_conn)
	}
	get_client_address(tcp_conn) ?
	get_client_ip(tcp_conn) ?
}

//  creates a TcpListener in V and listens for a connection
fn create_listener() ?string {
	socket_handle := 8080
	saddr := ':$socket_handle'  // ip format must match protocol.  so .ip is ipv4, .ip6 is ipv6
	mut buf := []byte{len: 2048}
	
	//  listens for a TCP connection
	mut listener := net.listen_tcp(.ip, saddr) or { return err }

	//  once the listener is created, accept will wait for a TCP connection to be made
	//  it will hang when trying to read sometimes
	mut tcp_conn := listener.accept()  or { return error('could not accept connection') }
	tcp_conn.read(mut &buf) or { println('issue when reading: $err') }
	println(buf)
	tcp_conn.write_string('thanks') ?
	tcp_conn.close() ?
	
	return 'listener finsihed'
}

fn hard_tcp_server() ?string {
	create_listener() ?

	// create_tcp_conn() ? // not the way to go as this is for already running servers and will establish a connection
	
	return 'tcp server finished!'
}

fn main() {
	println('hello world')
	// easy_tcp_server()

	hard_tcp_server() or { println(err) }
}
