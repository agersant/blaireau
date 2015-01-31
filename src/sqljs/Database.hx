package sqljs;
import js.html.Uint8Array;

/**
 * ...
 * @author agersant
 */
@:native("window.SQL.Database")
extern class Database
{
	public function new(data : Uint8Array)
	{
	}
	public function exec(query : String) : Dynamic
	{		
	}
}