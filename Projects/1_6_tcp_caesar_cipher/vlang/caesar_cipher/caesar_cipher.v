module caesar_cipher

import rand

pub fn create_caesar_cipher(input string) string {

	//  the random seed is not very secure.  It will always return the same random int for the same input string
	//  Just a word of warning in the future that this could give way to easy decryption or decyphering of random seeds
	rot_count := rand.intn(24)
	println('the rotation count is: $rot_count')

	rotated_str := rotate(input, rot_count)

	return rotated_str
}

fn rotate_upper(char_byte byte, rot_count int) byte {
	mut ret_byte := byte(0)

	for _ in 0 .. rot_count {
		ret_byte = char_byte - 1
		if char_byte < 65 {
			ret_byte = 90
		}
	}

	return ret_byte
}

fn rotate_lower(char_byte byte, rot_count int) byte {
	mut ret_byte := char_byte

	for _ in 0 .. rot_count {
		//  continually subtract 1 until the rotation count limit is met
		ret_byte = ret_byte - 1
		if char_byte < 97 {  //  if you hit the lowest possible lower alpha, then go back to the top
			ret_byte = 122
		}
	}

	return ret_byte
}

fn rotate(user_input string, rot_count int) string {
	mut rotated_byte_arr := []byte{ len: user_input.len }
	for c in user_input {
		mut char_byte := byte(c)
		mut ret := byte(0)

		if char_byte >= 65 && char_byte <= 90 {
			ret = rotate_upper(char_byte, rot_count)
		}
		else{
			ret = rotate_lower(char_byte, rot_count)
		}

		//  will input the characters into an array backwards.  be sure to reverse when printing
		rotated_byte_arr << ret
	}

	rotated_string := rotated_byte_arr.reverse().bytestr()

	return rotated_string
}

fn validate_user_string_input(rot_string string) bool {
	for c in rot_string {
		if byte(c) < 65 || byte(c) > 122 {
			return false
		}
	}

	return true
}