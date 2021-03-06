package;


import format.SVG;
import haxe.io.Path;
import helpers.LogHelper;
import helpers.PathHelper;
import helpers.PlatformHelper;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.geom.Matrix;
import project.Architecture;
import sys.io.File;
import sys.io.Process;
import sys.FileSystem;


class SVGExport {
	
	
	#if (neko && (haxe_210 || haxe3))
	public static function __init__ () {
		
		var haxePath = Sys.getEnv ("HAXEPATH");
		var command = (haxePath != null && haxePath != "") ? haxePath + "/haxelib" : "haxelib";
		
		var process = new Process (command, [ "path", "lime" ]);
		var path = "";
		
		try {
			
			var lines = new Array <String> ();
			
			while (true) {
				
				var length = lines.length;
				var line = process.stdout.readLine ();
				
				if (length > 0 && StringTools.trim (line) == "-D lime") {
					
					path = StringTools.trim (lines[length - 1]);
					
				}
				
				lines.push (line);
         		
   			}
   			
		} catch (e:Dynamic) {
			
			process.close ();
			
		}
		
		path += "/legacy/ndll/";
		
		switch (PlatformHelper.hostPlatform) {
			
			case WINDOWS:
				
				untyped $loader.path = $array (path + "Windows/", $loader.path);
				
			case MAC:
				
				untyped $loader.path = $array (path + "Mac/", $loader.path);
				untyped $loader.path = $array (path + "Mac64/", $loader.path);
				
			case LINUX:
				
				var arguments = Sys.args ();
				var raspberryPi = false;
				
				for (argument in arguments) {
					
					if (argument == "-rpi") raspberryPi = true;
					
				}
				
				if (raspberryPi) {
					
					untyped $loader.path = $array (path + "RPi/", $loader.path);
					
				} else if (PlatformHelper.hostArchitecture == Architecture.X64) {
					
					untyped $loader.path = $array (path + "Linux64/", $loader.path);
					
				} else {
					
					untyped $loader.path = $array (path + "Linux/", $loader.path);
					
				}
			
			default:
			
		}
		
	}
	#end
	
	
	public static function main () {
		
		var arguments = Sys.args ();
		
		/*if (arguments.length > 0) {
			
			// When the command-line tools are called from haxelib, 
			// the last argument is the project directory and the
			// path SWF is the current working directory 
			
			var lastArgument = "";
			
			for (i in 0...arguments.length) {
				
				lastArgument = arguments.pop ();
				if (lastArgument.length > 0) break;
				
			}
			
			lastArgument = new Path (lastArgument).toString ();
			
			if (((StringTools.endsWith (lastArgument, "/") && lastArgument != "/") || StringTools.endsWith (lastArgument, "\\")) && !StringTools.endsWith (lastArgument, ":\\")) {
				
				lastArgument = lastArgument.substr (0, lastArgument.length - 1);
				
			}
			
			if (FileSystem.exists (lastArgument) && FileSystem.isDirectory (lastArgument)) {
				
				Sys.setCwd (lastArgument);
				
			}
			
		}*/
		
		var words = new Array<String> ();
		
		for (arg in arguments) {
			
			if (arg == "-verbose") {
				
				LogHelper.verbose = true;
				
			} else {
				
				words.push (arg);
				
			}
			
		}
		
		if (words.length > 4 && words[0] == "process") {
			
			try {
				
				var inputPath = words[1];
				var width = Std.parseInt (words[2]);
				var height = Std.parseInt (words[3]);
				var outputPath = words[4];
				
				var svg = new SVG (File.getContent (inputPath));
				var backgroundColor = 0x00FFFFFF;
				
				var shape = new Shape ();
				svg.render (shape.graphics, 0, 0, width, height);
				
				var bitmapData = new BitmapData (width, height, true, backgroundColor);
				bitmapData.draw (shape);
				
				File.saveBytes (outputPath, bitmapData.encode ("png"));
				
			} catch (e:Dynamic) {
				
				LogHelper.error (e);
				
			}
			
		}
		
	}
	
	
}