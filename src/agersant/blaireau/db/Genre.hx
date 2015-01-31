package agersant.blaireau.db;
import format.id3v2.Reader;
import ufront.db.ManyToMany;

/**
 * ...
 * @author agersant
 */
class Genre extends ufront.db.Object
{

	var name : String;
	var tracks : ManyToMany<Genre, Track>;
	
	public function new(_name:String) 
	{
		super();
		name = _name;
	}
	
	public function getName() : String
	{
		return name;
	}
	
	public function getTracks() : List<Track>
	{
		var output = new List();
		for (track in tracks)
			output.add(track);
		return output;
	}
	
}