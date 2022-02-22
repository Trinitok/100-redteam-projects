module main

import server

fn main() {
	server.create_server() or { panic('$err')}
}