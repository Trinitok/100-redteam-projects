module server

import net
import time
import io

pub fn create_server() ?string {
	socket_handle := 8080
	saddr := ':$socket_handle'  // ip format must match protocol.  so .ip is ipv4, .ip6 is ipv6
	
	//  listens for a TCP connection
	mut listener := net.listen_tcp(.ip6, saddr) or { return err }
	println('listening on: $saddr')

	//  once the listener is created, accept will wait for a TCP connection to be made
	//  it will hang when trying to read sometimes
	for {
		mut tcp_conn := listener.accept() or {
			listener.close() or {}
			panic('Failed to accept connection.\nErr Code: $err.code\nErr Message: $err.msg')
		}
		addr := tcp_conn.peer_addr() or { panic('issue finding peer addr $err') }
		// tcp_conn.set_read_timeout(60 * time.second)
		println('connection received from: $addr')

		mut reader := io.new_buffered_reader(reader: tcp_conn)
		rbody := io.read_all(reader: reader) or { []byte{} }
		println('$addr: ' + rbody.bytestr())
		println(rbody.len)
		tcp_conn.close() or { panic('Failed to close properly')}
	}
	
	return 'listener finished'
}