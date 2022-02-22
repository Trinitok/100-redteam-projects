module encryption

import caesar_cipher

pub fn encrypt_outbound_message(message_string_to_send string) string {
	encrypted_msg := caesar_cipher.create_caesar_cipher(message_string_to_send)

	println('the encrypted outbound message is: $encrypted_msg')

	return encrypted_msg
}