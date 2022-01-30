module logger

pub fn log_request<T>(app &T) {
	println('>>>>>>>>>>>>>> logger start >>>>>>>>>>>>>>')
	println(app)
	println('<<<<<<<<<<<<<< logger end <<<<<<<<<<<<<<')
}