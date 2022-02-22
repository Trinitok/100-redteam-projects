module main

import net
import io
import time
import os

fn start_client() {
	mut tcp_conn := net.dial_tcp('localhost:8080') or {
		panic('unable to connect to server.  $err')
	}
	defer {
		tcp_conn.close() or { panic('Failed to close properly')}
	}

	message_to_send := os.input('input a message to send>> ')

	tcp_conn.write_string(message_to_send) or {
		panic('error writing message to server.  $err')
	}
}

fn receive_message(mut tcp_conn net.TcpConn) {
	mut reader := io.new_buffered_reader(reader: tcp_conn)
	rbody := io.read_all(reader: reader) or { []byte{} }
	println(rbody.bytestr())
	println(rbody.len)
}

fn send_message(mut tcp_conn net.TcpConn) bool {
	message_to_send := os.input('input a message to send>> ')

	if message_to_send == 'FIN' {
		return  true
	}
	tcp_conn.write_string(message_to_send) or {
		panic('error writing message to server.  $err')
	}

	// receive_message(mut tcp_conn)

	return false
}

fn receive_message_from_server(tcp_conn net.TcpConn) {
	mut reader := io.new_buffered_reader(reader: tcp_conn)

	rbody := io.read_all(reader: reader) or { []byte{} }
	
	println('server: ' + rbody.bytestr())
	println(rbody.len)
}

fn keep_talking() {

	for {
		mut tcp_conn := net.dial_tcp('localhost:8080') or {
			panic('unable to connect to server.  $err')
		}
		defer {
			tcp_conn.close() or { panic('Failed to close properly')}
		}

		go receive_message(mut tcp_conn)

		finished := send_message(mut tcp_conn)

		if finished {
			break
		}
	}
}

fn main() {
	start_client()
	keep_talking()
}