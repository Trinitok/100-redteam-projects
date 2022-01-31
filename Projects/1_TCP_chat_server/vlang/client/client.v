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

fn receive_message() {
	mut reader := io.new_buffered_reader(reader: tcp_conn)
	rbody := io.read_all(reader: reader) or { []byte{} }
	println(rbody.bytestr())
	println(rbody.len)
}

fn send_message() {
	message_to_send := os.input('input a message to send>> ')

	if message_to_send == 'FIN' {
		return
	}
	tcp_conn.write_string(message_to_send) or {
		panic('error writing message to server.  $err')
	}

	receive_message()
	tcp_conn.close() or { panic('Failed to close properly')}
}

fn keep_talking() {
	for {
		mut tcp_conn := net.dial_tcp('localhost:8080') or {
			panic('unable to connect to server.  $err')
		}
		// defer {
		// 	tcp_conn.close() or { panic('Failed to close properly')}
		// }

		send_message()
	}
}

fn main() {
	start_client()
	keep_talking()
}