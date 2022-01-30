module main

const (
	server_port = '8080'
)

//  This is basically a recreation of
//  https://github.com/vlang/v/blob/e32c65c3222baefa64e1c33bffa49d12b80adef9/vlib/net/tcp_simple_client_server_test.v
fn poke_server() {
	msg := 'hello!  this is a test response'

	mut client := net.dial_tcp('localhost:$server_port') or { panic(err) }

	client.write_string(msg) or {
			println('failed to write the message to the server')
		}

	resp := client.read_line()
	client.close() ?
	println(resp)
}

fn main() {
	poke_server()
}