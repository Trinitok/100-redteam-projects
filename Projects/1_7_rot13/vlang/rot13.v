module main

import os

/**
*
*  My rot13 implementation in V lang.  It is a copy of my caesar cipher implementation since 
*  this was effectively only changing a line or two.
*
*  As of right now it can only handle basic english alpha chars.  If you input any
*  kind of special character it will not be rotated.
*
*/

fn validate_user_string_input(rot_string string) bool {
	for c in rot_string {
		if (byte(c) < 65 || byte(c) > 122) && byte(c) != 32 {
			println('failed for character ')
			println(byte(c))
			return false
		}
	}

	return true
}

fn request_input_to_rotate() string {
	mut rot_string := os.input('please input a string with only alpha characters>> ')

	for {
		is_valid := validate_user_string_input(rot_string)
		if !is_valid {
			println('Please input a string with characters from A-Z or a-z. No special chars or numbers')
			rot_string = os.input('please input a string with only alpha characters>> ')
		}
		else {
			break
		}
	}

	return rot_string
}

fn rotate_upper(char_byte byte, rot_count int) byte {
	mut ret_byte := byte(0)

	for i in 0 .. rot_count {
		ret_byte = char_byte - 1
		if char_byte < 65 {
			ret_byte = 90
		}
	}

	return ret_byte
}

fn rotate_lower(char_byte byte, rot_count int) byte {
	mut ret_byte := char_byte

	for i in 0 .. rot_count {
		//  continually subtract 1 until the rotation count limit is met
		ret_byte = ret_byte - 1
		if char_byte < 97 {  //  if you hit the lowest possible lower alpha, then go back to the top
			ret_byte = 122
		}
	}

	return ret_byte
}

fn rotate(user_input string, rot_count int) {
	mut rotated_byte_arr := []byte{ len: user_input.len }
	for c in user_input {
		mut char_byte := byte(c)
		mut ret := byte(0)

		if char_byte >= 65 && char_byte <= 90 {
			ret = rotate_upper(char_byte, rot_count)
		}
		else if char_byte >= 97 && char_byte <= 122 {
			ret = rotate_lower(char_byte, rot_count)
		}
		else {
			ret = char_byte
		}
		rotated_byte_arr << ret
	}

	println('here is the final rotated string')
	println(rotated_byte_arr.reverse().bytestr())
}

fn create_caesar_cipher() {
	user_input := request_input_to_rotate()

	rotate(user_input, 13)
}

fn main() {
	test := "t"
	test_bytes := test.bytes()
	println(test_bytes)
	create_caesar_cipher()
}