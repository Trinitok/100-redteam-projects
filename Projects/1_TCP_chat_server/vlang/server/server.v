module server

import net
import time
import io
import os

fn read_message_from_client(mut tcp_conn net.TcpConn, addr net.Addr) {
	mut reader := io.new_buffered_reader(reader: tcp_conn)

	rbody := io.read_all(reader: reader) or { []byte{} }
	
	println('$addr: ' + rbody.bytestr())
	println(rbody.len)
}

fn write_message_to_client(mut tcp_conn net.TcpConn) bool {
	message_to_send := os.input('input a message to send>> ')

	if message_to_send == 'FIN' {
		return  true
	}
	tcp_conn.write_string(message_to_send) or {
		panic('error writing message to server.  $err')
	}

	return false
}

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
		go read_message_from_client(mut tcp_conn, addr)
		write_message_to_client(mut tcp_conn)


		tcp_conn.close() or { panic('Failed to close properly')}
	}
	
	return 'listener finished'
}