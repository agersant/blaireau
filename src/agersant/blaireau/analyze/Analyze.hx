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
		var result = db.exec('	SELECT year, COUNT(*) AS numAlbums
								FROM Album
								WHERE year IS NOT NULL
								GROUP BY year
								ORDER BY year ASC
							');
		return cast(mapSQLResult(result[0].columns, result[0].values));
	}
	
	public static function getTracksPerGenre(db : Database) : Array<{genre : String, numTracks : Int}>
	{
		var result = db.exec('	SELECT Genre.name AS genre, COUNT(*) AS numTracks
								FROM _join_Genre_Track, Genre
								WHERE Genre.id = _join_Genre_Track.r1
								GROUP BY Genre.id
								ORDER BY numTracks DESC
							');
		return cast(mapSQLResult(result[0].columns, result[0].values));
	}
	
	public static function getTracksPerGenrePerYear(db : Database) : Array<{genre: String, year : Int, numTracks : Int}>
	{
		var result = db.exec('	SELECT Genre.name AS genre, Album.year as year, COUNT(*) as numTracks
								FROM Track
								INNER JOIN Album ON Album.id = Track.albumID
								INNER JOIN _join_Genre_Track ON _join_Genre_Track.r2 = Track.id
								INNER JOIN Genre ON Genre.id = _join_Genre_Track.r1
								WHERE Album.year IS NOT NULL
								GROUP BY Genre.id, Album.year
							');
		return cast(mapSQLResult(result[0].columns, result[0].values));
	}
	
	public static function getTracksPerCountry(db : Database) : Array<{country: String, numTracks : Int}>
	{
		var result = db.exec('	SELECT Country.name AS country, COUNT(*) as numTracks
								FROM Track
								INNER JOIN _join_Country_Track ON _join_Country_Track.r2 = Track.id
								INNER JOIN Country ON Country.id = _join_Country_Track.r1
								GROUP BY Country.id
							');
		return cast(mapSQLResult(result[0].columns, result[0].values));
	}
	
	public static function getTracksPerGenrePerCountry(db : Database) : Array<{country: String, genre: String, numTracks : Int}>
	{
		var result = db.exec('	SELECT Country.name AS country, Genre.name AS genre, COUNT(*) AS numTracks
								FROM Country
								INNER JOIN _join_Country_Track ON _join_Country_Track.r1 = Country.id
								INNER JOIN Track ON Track.id = _join_Country_Track.r2
								INNER JOIN _join_Genre_Track ON _join_Genre_Track.r2 = Track.id
								INNER JOIN Genre ON Genre.id = _join_Genre_Track.r1
								GROUP BY Country.id, Genre.id
							');
		return cast(mapSQLResult(result[0].columns, result[0].values));
	}
	
	static function mapSQLResult (columns : Array<String>, rows : Array<Array<Dynamic>>) : Array<Dynamic>
	{
		var output = new Array();
		for (row in rows)
		{
			var value : Dynamic = {};
			for (i in 0...columns.length)
			{
				Reflect.setField(value, columns[i], row[i]);
			}
			output.push(value);
		}
		return output;
	}
	
}