module cli_arg_parser

import os
import cli

pub fn parse_args() {
	mut app := cli.Command{
		name: 'app'
		description: 'netcat clone as part of the 100 redteam projects I am using to learn about things'
		usage: 'v run netcat.v -p <PORT>'
		execute: fn (cmd cli.Command) ? {
			println(cmd)
			return
		}
		flags: [
			cli.Flag {
				name: 'listen'
				description: 'Used to specify that this should listen for an incoming connection rather than initiate a connection to a remote host.'
				abbrev: 'l'
			},
			cli.Flag {
				flag: cli.FlagType.int
				name: 'port'
				description: 'source port'
				abbrev: 'p'
				
			}
		]
	}
	app.setup()
	app.parse(os.args)
}