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

["/"]
fn (mut app App) hello() vweb.Result {
	log_request(app)
	return app.text('Hello')
}

fn easy_tcp_server() {
	vweb.run(&App{}, 8080)
}

fn main() {
	easy_tcp_server()

	// hard_tcp_server()
}