module process_http_request_type

import net

//  Processes a TCP HTTP request's headers
//  the separation between HTTP header and body is the \r\n line with nothing else
//  So if I trim that line then it will likely show as an empty string
fn process_request_headers(mut tcp_conn &net.TcpConn) {
	println('here are the client request headers:')
	for {
		mut line := tcp_conn.read_line()
		line = line.trim_space()
		if line == '\n'  || line == '' || line.len <= 0 {
			break
		}
		println(line)
	}
}

//  Currently this is a recreation of the V TcpConn struct's read_ptr function
// https://github.com/vlang/v/blob/e32c65c3222baefa64e1c33bffa49d12b80adef9/vlib/net/tcp.v#L87
//  I have added a bunch of caveman debug lines
fn read_ptr(mut c &net.TcpConn, buf_ptr &byte, len int) ?int {
	println('entering read_ptr')
	println('executing wrap_read_result with handle: $c.sock.handle ptr: $buf_ptr len: $len')
	mut res := C.recv(c.sock.handle, buf_ptr, len, 0)
	println('here is the result from C.recv: $res')
	println('exit wrap_read_result')
	$if trace_tcp ? {
		eprintln('<<< TcpConn.read_ptr  | c.sock.handle: $c.sock.handle | buf_ptr: ${ptr_str(buf_ptr)} len: $len | res: $res')
	}
	println('check if result greater than 0')
	if res > 0 {
		$if trace_tcp_data_read ? {
			eprintln('<<< TcpConn.read_ptr  | 1 data.len: ${res:6} | data: ' +
				unsafe { buf_ptr.vstring_with_len(res) })
		}
		println('returning $res')
		return res
	}
	println('check error code')
	code := C.errno
	if code == int(C.EWOULDBLOCK) {
		c.wait_for_read() ?
		res = C.recv(c.sock.handle, voidptr(buf_ptr), len, 0)
		println('here is the result from C.recv: $res')
		$if trace_tcp ? {
			eprintln('<<< TcpConn.read_ptr  | c.sock.handle: $c.sock.handle | buf_ptr: ${ptr_str(buf_ptr)} len: $len | res: $res')
		}
		$if trace_tcp_data_read ? {
			if res > 0 {
				eprintln('<<< TcpConn.read_ptr  | 2 data.len: ${res:6} | data: ' +
					unsafe { buf_ptr.vstring_with_len(res) })
			}
		}
		println('returning socket error with')
		println(res)
		return net.socket_error(res)
	} else {
		// net.wrap_error(code) ?
		println('net: socket error: $code')
	}
	println('return none')
	return none
}

//  This is a copy-paste of a couple lines from the V WebSocket struct's socket_read_ptr
//  https://github.com/vlang/v/blob/1ba839dc3bb527ec73eddac6b7c191f0861b8b3f/vlib/net/websocket/io.v#L31
fn socket_read_ptr(mut conn &net.TcpConn, buf_ptr &byte, len int) ?int {
	println('entering socket_read_ptr')
	lock {
		if conn.sock.handle <= 1 {
			return error('ERROR: this socket is currently closed')
		}
		else {
			for {
				println('entering read_ptr with buf_ptr: $buf_ptr and len: $len')
				r := read_ptr(mut conn, buf_ptr, len) or {
					if err.code == net.err_timed_out_code {
						println('read_ptr timed out')
						continue
					}
					println('leaving socket_read_ptr with err: $err')
					return err
				}
				println('leaving socket_read_ptr with: $r')
				return r
			}
		}
	}
	println('leaving socket_read_ptr with null')
	return none
}

//  Process the body of a HTTP request
//  Right now this hangs when trying to read the last and final character
//  When the TCP HTTP body is sent from the browser
//  If the request is sent via curl then it is just fine and exits gracefully
fn process_body(mut conn &net.TcpConn) ?string {
	if conn.get_blocking() {
		conn.set_blocking(false) or {return error('Error when nonblocking: $err')}
	}
	println('body func')
	buf_size := 2048
	mut total_bytes_read := 0
	mut msg := [2048]byte{}
	mut buffer := [1]byte{} 
	for total_bytes_read < buf_size { 
		println('entering socket_read_ptr')
		bytes_read := socket_read_ptr(mut conn, &buffer[0], 1) ?
		println('leaving socket_read_ptr')
		if bytes_read == 0 {
			return error_with_code('unexpected no response from handshake', 5)
		}
		msg[total_bytes_read] = buffer[0]
		println('is con blocking?')
		println(conn.get_blocking())
		println('current msg')
		println(msg[..total_bytes_read].bytestr())
		total_bytes_read++
		if total_bytes_read > 5 && msg[total_bytes_read - 1] == 0 {
			break
		}
	}
	res := msg[..total_bytes_read].bytestr()
	println('here is the result')
	print(res)
	return res
}

//  HTTP GET only has HTTP headers
//  once those are processed we can stop
//  they end once the \r\n is entered for a line
pub fn process_get(request_line string, mut conn &net.TcpConn) {
	println('received a GET request for: $request_line')
	process_request_headers(mut conn)
}

//  HTTP POST will have a body associated
pub fn process_post(request_line string, mut conn &net.TcpConn) {
	println('received a POST request for: $request_line')
	// process_request_headers(mut conn)
	process_body(mut conn) or { println(err) }
}

//  For an unrecognized HTTP header
//  At this time this is anything that is not a GET or POST
pub fn process_unknown(request_line string, mut conn &net.TcpConn) {
	println('unknown request type has been made: $request_line')
}