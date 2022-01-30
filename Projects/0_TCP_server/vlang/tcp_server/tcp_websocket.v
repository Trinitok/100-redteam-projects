module main

import net
import net.websocket

//  As of right now this does not work.
//  This is using code copy-pasted from the WebSockets objects in V.
//  So far I only get `there was an error while listening: net: socket error: 47; could not create new socket`
fn main() {
	socket_handle := 8081
	saddr := ':$socket_handle'  // ip format must match protocol.  so .ip is ipv4, .ip6 is ipv6
	addr := net.addr_from_socket_handle( socket_handle )
	println('size of address object')
	println(sizeof(addr))
	println('here is my addr')
	println(addr)
	addr_fam := addr.family()

	mut server := websocket.new_server(addr_fam, socket_handle, '')

	server.on_connect(fn (mut s websocket.ServerClient) ?bool {
		// here you can look att the client info and accept or not accept
		// just returning a true/false
		if s.resource_name != '/' {
			panic('unexpected resource name in test')
			return false
		}
		return true
	}) ?
	server.on_message(fn (mut ws websocket.Client, msg &websocket.Message) ? {
		match msg.opcode {
			.pong { ws.write_string('pong') or { panic(err) } }
			else { ws.write(msg.payload, msg.opcode) or { panic(err) } }
		}
	})

	server.on_close(fn (mut ws websocket.Client, code int, reason string) ? {
		// not used
	})

	server.listen() or { println('there was an error while listening: $err') }

	server.free()
}