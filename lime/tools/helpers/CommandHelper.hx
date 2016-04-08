package lime.tools.helpers;


import lime.project.HXProject;
import lime.project.Platform;


class CommandHelper {
	
	
	public static function format(command:CLICommand) {
		var count = command.args.length;
		for(i in 0...command.args.length) {
			
			var arg = command.args[i];
			if( arg.length >= 3 && StringTools.startsWith(arg, "-D") ) {
				
				command.args[i] = "-D";
				command.args.insert(i + 1, arg.substr(3));
				
			}
		}
	}
	
	public static function executeCommands (commands:Array <CLICommand>):Void {
		
		for (c in commands) {
			format(c);
			LogHelper.info("executing : " + c.command+" "+ c.args+"\n");
			Sys.command(c.command, c.args);
		}
		
	}
	
	
	public static function toString(command:CLICommand) {
		
		return command.command + " " + command.args.join(" ");
		
	}
	
	inline static function build(command, args):CLICommand {
		
		return { command:command, args:args };
		
	}
	
	public static function openFile (file:String):CLICommand {
		
		if (PlatformHelper.hostPlatform == Platform.WINDOWS) {
			
			return build("start", [ file ]);
			
		} else if (PlatformHelper.hostPlatform == Platform.MAC) {
			
			return build("/usr/bin/open", [ file ]);
			
		} else {
			
			return build("/usr/bin/xdg-open", [ file ]);
			
		}
		
	}
	
	
	public static function interpretHaxe (mainFile:String):CLICommand {
		
		return build("haxe",  [ "-main", mainFile, "--interp" ]);
		
	}
	
	
	public static function fromSingleString (command:String):CLICommand {
		
		var args:Array<String> = command.split (" ");
		command = args.shift ();
		return build(command, args);
		
	}
	
	
}