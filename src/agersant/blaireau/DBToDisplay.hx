package agersant.blaireau;
import agersant.blaireau.charts.Charts;
import js.Browser;
import js.html.FileList;
import js.html.FileReader;
import js.html.Node;
import js.html.Uint8Array;
import sqljs.Database;


/**
 * ...
 * @author agersant
 */

class DBToDisplay
{

	public static function main() 
	{
		var body = Browser.document.body;
		var fileInput = Browser.document.createInputElement();
		fileInput.type = "file";
		Browser.document.body.appendChild(fileInput);
		
		fileInput.onchange = function(event : Dynamic)
		{
			var files : FileList = event.target.files;
			var reader : FileReader = new FileReader();
			reader.readAsArrayBuffer(files.item(0));
			reader.onload = function(d : Dynamic)
			{
				fileInput.remove();
				var db = new Database(new Uint8Array(reader.result));
				render(db);
			}
		}
		
	}
	
	static function addMainContainer() : Node
	{
		var mainDiv = Browser.document.querySelector("#main");
		if (mainDiv != null)
			mainDiv.remove();
		mainDiv = Browser.document.createDivElement();
		mainDiv.setAttribute("id", "main");
		Browser.document.body.appendChild(mainDiv);
		return mainDiv;
	}
	
	static function render(db : Database)
	{
		var container = addMainContainer();
		container.appendChild(Charts.plotAlbumsByYear(db));
		container.appendChild(Charts.plotTracksByGenre(db));
		container.appendChild(Charts.plotTracksPerGenrePerYear(db));
		container.appendChild(Charts.plotTracksPerCountry(db));
		container.appendChild(Charts.plotTracksPerGenrePerCountry(db));
	}
	
}