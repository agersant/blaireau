package agersant.blaireau.analyze;
import sqljs.Database;

/**
 * ...
 * @author agersant
 */
class Analyze
{

	public static function getAlbumsByYear(db : Database) : Array<{year : Int, numAlbums : Int}>
	{
		var result = db.exec( "SELECT year, COUNT(*) AS numAlbums FROM Album WHERE year IS NOT NULL GROUP BY year ORDER BY year ASC" );
		var columns : Array<String> = result[0].columns;
		var rows : Array<Array<Dynamic>> = result[0].values;
		
		var output = [];
		for (row in rows)
		{
			var value = { year: 0, numAlbums: 0 };
			for (i in 0...columns.length)
			{
				Reflect.setField(value, columns[i], row[i]);
			}
			output.push(value);
		}
		
		return output;
	}
	
	public static function getTracksPerGenre(db : Database) : Array<{genre : String, numTracks : Int}>
	{
		var result = db.exec( "SELECT Genre.name AS genre, COUNT(*) AS numTracks FROM _join_Genre_Track, Genre WHERE Genre.id = _join_Genre_Track.r1 GROUP BY Genre.id ORDER BY numTracks DESC" );
		var columns : Array<String> = result[0].columns;
		var rows : Array<Array<Dynamic>> = result[0].values;
		
		var output = [];
		for (row in rows)
		{
			var value = { genre: "", numTracks: 0 };
			for (i in 0...columns.length)
			{
				Reflect.setField(value, columns[i], row[i]);
			}
			output.push(value);
		}
		return output;
	}
	
}