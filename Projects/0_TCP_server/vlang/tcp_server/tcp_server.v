module main

// There was an error about an openssl file not existing for vweb so I thought I would go even lower level
//  and use the builtin net library
// TCP Listener: https://github.com/vlang/v/blob/master/vlib/net/tcp.v#L209
import net
import io

import process_http_request_type

const (
	crlf     = '\r\n'
	msg_peek = 0x02
	max_read = 400
	msg_nosignal = 0x4000
)


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

fn get_client_body(mut tcp_conn &net.TcpConn) {
	
	println('here is the client request body:')
	for {
		mut line := tcp_conn.read_line()
		line = line.trim_space()
		if line == '\n'  || line == '' || line.len <= 0 {
			break
		}
		println(line.len)
		println(line.int())
	}
}

//  Process the client request
//  Try to print out the client headers and body for logging purposes
fn get_client_body_test(mut tcp_conn &net.TcpConn) ? {
	mut res := ''
	mut line := 0
	mut buf := []byte{}
	mut r := io.new_buffered_reader( reader: tcp_conn )
	for {
		println('entering readline')
		l := r.read_line() or { break }
		println('exiting readline')
		println('$l')
		end := r.end_of_stream()
		println('has stream ended? $end')
		if line != 0 || l == '\n' || r.end_of_stream() {
			break
		}
	}
	println(res)
}

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
	// get_client_headers(mut tcp_conn)
	
	// println('============ start get client body test ===========')
	// get_client_body_test(mut tcp_conn) ?
	// println('============ end get client body test ===========')
}

fn create_listener() ?string {
	socket_handle := 8080
	saddr := ':$socket_handle'  // ip format must match protocol.  so .ip is ipv4, .ip6 is ipv6
	addr := net.addr_from_socket_handle( socket_handle )
	println('size of address object')
	println(sizeof(addr))
	println('here is my addr')
	println(addr)
	addr_fam := addr.family()
	println('here is my addr family')
	println(addr_fam)
	// test := C.socket(.ip, net.SocketType.tcp, 0)
	// println('here is test')
	// println(test)
	mut listener := net.listen_tcp(.ip, saddr) or { return err }
	println('here is my listener')
	println(listener)

	mut tcp_conn := listener.accept()  or { return error('could not accept connection') }
	tcp_conn.write_string('thanks') ?
	get_client_meta(mut tcp_conn) ?
	tcp_conn.close() ?
	println('here is the tcp conn')
	println(tcp_conn)
	
	return 'listener finsihed'
}

/*
fn create_tcp_conn() ?{
	tcp_conn := net.dial_tcp('127.0.0.1') ?
	print(tcp_conn)
}
*/

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
