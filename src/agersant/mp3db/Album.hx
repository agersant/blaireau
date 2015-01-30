package agersant.mp3db;
import format.id3v2.Reader;
import ufront.db.Object.HasMany;

/**
 * ...
 * @author agersant
 */
class Album extends ufront.db.Object
{

	var name : Null<String>;
	var tracks : HasMany<Track>;
	
	public function new(tag : Reader) 
	{
		super();
	}
	
}