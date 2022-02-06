module main

import os

fn request_rotation_count() int {
	for {
		rot_count := os.input('please input a number between 1-25>> ')
		
		if rot_count > 0 && rot_count < 26 {
			break
		}
		else {
			println('invalid rotation count.  please try again')
		}
	}

	return rot_count
}

fn validate_user_string_input(rot_string string) bool {
	for c in rot_string {
		if byte(c) < 65 || byte(c) > 122 {
			return false
		}
	}

	return true
}

fn request_input_to_rotate() string {
	for {
		mut rot_string := os.input('please input a string with only alpha characters>> ')

		is_valid := validate_user_string_input(rot_string)
		if !is_valid {
			println('Please input a string with characters from A-Z or a-z. No special chars or numbers')
		}
		else {
			return rot_string
		}
	}
}

fn rotate_upper(mut char_byte) byte {
	for i := 1; i <= rot_count; i ++ {
		char_byte = char_byte - 1
		if char_byte < 65 {
			char_byte = 90
		}
	}

	return char_byte
}

fn rotate_lower(mut char_byte) byte {
	for i := 1; i <= rot_count; i ++ {
		char_byte = char_byte - 1
		if char_byte < 97 {
			char_byte = 122
		}
	}

	return char_byte
}

fn rotate(user_input string, rot_count int) {
	rotated_byte_arr := []byte{ len: user_input.len }
	for c in user_input {
		mut char_byte := byte(c)

		if char_byte >= 65 && <= 90 {
			c = rotate_upper(mut char_byte)
		}
		else{
			c = rotate_lower(char_byte)
		}
	}
}

fn create_caesar_cipher() {
	rot_count := request_rotation_count()

	user_input := request_input_to_rotate()

	rotate(user_input, rot_count)
}

fn main() {
	create_caesar_cipher()
}