package agersant.mp3db;
import format.mp3.Reader;
import sys.db.Types.SEnum;
import sys.io.File;

/**
 * ...
 * @author agersant
 */
class Track extends ufront.db.Object
{
	var title : String;
	var country : SEnum<Country>;
	
	public function new(path : String)
	{
		super();
		var file = File.read(path, true);
		var mp3 = new Reader(file);
	}
}