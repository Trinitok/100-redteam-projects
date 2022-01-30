module main

// looking at the current vweb code, it looks like by default they use tcp
// https://github.com/vlang/v/blob/59ed4be49aa5af5a0fb9927fba6ccb3403969556/vlib/vweb/vweb.v#L382
import vweb

struct App {
    vweb.Context
}

fn log_request<T>(app &T) {
	println('>>>>>>>>>>>>>> logger start >>>>>>>>>>>>>>')
	println(app)
	println('<<<<<<<<<<<<<< logger end <<<<<<<<<<<<<<')
}

["/", "/hello"]
fn (mut app App) hello() vweb.Result {
	log_request(app)
	return app.text('Hello')
}

//  This is the easy TCP server that is recommended using the vweb tutorial for building a blog
//  Currently this has poor logging, although it does work.
//  My issue though is that the poor logging doesn't really allow me to see what I want
fn easy_tcp_server() {
	vweb.run(&App{}, 8080)
}

fn main() {
	easy_tcp_server()
}