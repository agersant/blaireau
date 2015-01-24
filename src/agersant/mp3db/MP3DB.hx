package agersant.mp3db;

import neko.Lib;

/**
 * ...
 * @author agersant
 */

class MP3DB extends mcli.CommandLine
{

	/**
	 * Output file
	 */
	public var output : String;
	
	/**
	 * Show this message
	 */
	public function help()
	{
		// TODO
		Sys.println(this.showUsage());
		Sys.exit(0);
	}
	
	public function runDefault(source : String) : Void
    {
		if (output == null)
			output = "output.db";
			
        Sys.println('$source -> $output');
    }
	
	public static function main()
    {
        new mcli.Dispatch(Sys.args()).dispatch(new MP3DB());
    }
	
}