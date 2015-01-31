package agersant.blaireau;

import agersant.blaireau.db.Album;
import agersant.blaireau.db.Country;
import agersant.blaireau.db.Genre;
import agersant.blaireau.db.Track;
import format.id3v2.Data.ParseError;
import format.id3v2.Reader;
import haxe.io.Path;
import sys.db.Connection;
import sys.db.Manager;
import sys.db.Sqlite;
import sys.db.TableCreate;
import sys.FileSystem;
import sys.io.File;
import ufront.db.ManyToMany;

/**
 * ...
 * @author agersant
 */

class MusicToDB extends mcli.CommandLine
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
        new mcli.Dispatch(Sys.args()).dispatch(new MusicToDB());
    }
	
	function initDB()
	{
		if (FileSystem.exists(output))
			FileSystem.deleteFile(output);
		db = Sqlite.open(output);
		Manager.cnx = db;
		Manager.initialize();
		TableCreate.create(Album.manager);	
		TableCreate.create(Country.manager);
		TableCreate.create(Genre.manager);
		TableCreate.create(Track.manager);
		ManyToMany.createJoinTable( Country, Track );
		ManyToMany.createJoinTable( Genre, Track );
	}
	
	function processPath(path : String) : Void
	{
		var isDirectory = false;
		try
		{
			isDirectory = FileSystem.isDirectory(path);
			if (!FileSystem.exists(path))
				return;
		}
		catch (d : Dynamic)
		{
			Sys.println('Error while opening $path');
			return;
		}
		if (isDirectory)
		{
			return browse(path);
		}
		else
		{
			return processFile(path);
		}
	}
	
	
	function browse(dir:String) : Void
	{
		for (file in FileSystem.readDirectory(dir))
		{
			var filePath : String = '$dir\\$file';
			processPath(filePath);
		}
	}
	
	function processFile(rawPath:String) : Void
	{
		var path = new Path(rawPath);
		if (path.ext.toLowerCase() != "mp3")
		{
			return;
		}
		
		var file = File.read(rawPath, true);
		try
		{
			Sys.println("Analyzing " + rawPath);
			var tag = new Reader(file);
			var track = new Track(tag);
			track.save();
		}
		catch (e : Dynamic)
		{
			if (e == ParseError.INVALID_HEADER_FILE_IDENTIFIER)
			{
				Sys.println("No ID3v2 tag: " + rawPath);
			}
			else
			{
				Sys.println(e);
				Sys.println("Error during ID3v2 parsing on: " + rawPath);
				throw e;
			}
		}
		file.close();
	}
	
}