package agersant.mp3db;

import haxe.io.Path;
import sys.db.Connection;
import sys.db.Manager;
import sys.db.Sqlite;
import sys.db.TableCreate;
import sys.FileSystem;

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
	
	var db : Connection;
	
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
			
		initDB();
		browse(Sys.getCwd() + source);
    }
	
	public static function main()
    {
        new mcli.Dispatch(Sys.args()).dispatch(new MP3DB());
    }
	
	function initDB()
	{
		if (FileSystem.exists(output))
			FileSystem.deleteFile(output);
		db = Sqlite.open(output);
		Manager.cnx = db;
		Manager.initialize();
		TableCreate.create(Track.manager);
	}
	
	function browse(dir:String) : Void
	{
		if (!FileSystem.exists(dir))
			return;
		if (!FileSystem.isDirectory(dir))
			return;
		for (file in FileSystem.readDirectory(dir))
		{
			var filePath : String = '$dir\\$file';
			try {
				if (FileSystem.isDirectory(filePath))
				{
					browse(filePath);
				}
				else
				{
					processFile(filePath);
				}
			}
			catch (e : Dynamic)
			{
				Sys.println('Error while analyzing $filePath');
			}
		}
	}
	
	function processFile(rawPath:String) : Void
	{
		var path = new Path(rawPath);
		if (path.ext.toLowerCase() != "mp3")
		{
			return;
		}
		var track = new Track(rawPath);
	}
	
}