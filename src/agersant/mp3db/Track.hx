package agersant.mp3db;
import format.id3v2.Data.ParseError;
import format.id3v2.Reader;
import sys.db.Types.SEnum;
import sys.db.Types.SUInt;
import sys.io.File;
import ufront.db.ManyToMany;
import ufront.db.Object.BelongsTo;
import ufront.db.Object.HasOne;

/**
 * ...
 * @author agersant
 */
class Track extends ufront.db.Object
{
	var title : Null<String>;
	var trackNumber : Null<Int>;
	var album : Null<BelongsTo<Album>>;
	var countries : ManyToMany<Track, Country>;
	var genres : ManyToMany<Track, Genre>;
	
	public function new (tag : Reader)
	{
		super();
		title = tag.getTrackTitle();
		trackNumber = tag.getTrackNumber();
		
		// Album
		var albumName : String = tag.getAlbumName();
		var matchingAlbum = Album.manager.select($name == albumName);
		if (matchingAlbum == null)
		{
			matchingAlbum = new Album(tag);
			matchingAlbum.save();
		}
		album = matchingAlbum;
		
		// Countries
		var countryField = tag.getCustomTextInformation("Country");
		var countryNames = countryField == null ? new Array() : countryField.split(";");
		for (countryName in countryNames)
		{
			var matchingCountry = Country.manager.select($name == countryName);
			if (matchingCountry == null)
			{
				matchingCountry = new Country(countryName);
				matchingCountry.save();
			}
			countries.add(matchingCountry);
		}
		
		// Genres
		var genreNames = tag.getGenres();
		for (genreName in genreNames)
		{
			var matchingGenre = Genre.manager.select($name == genreName);
			if (matchingGenre == null)
			{
				matchingGenre = new Genre(genreName);
				matchingGenre.save();
			}
			genres.add(matchingGenre);
		}
		
	}
}