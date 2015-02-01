package agersant.blaireau;
import haxe.io.Bytes;
import haxe.io.BytesData;
import highcharts.Highcharts;
import highcharts.Highcharts.Options;
import js.Browser;
import js.html.ArrayBuffer;
import js.html.FileList;
import js.html.FileReader;
import js.html.FileReaderSync;
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
		var body = Browser.document.getElementsByTagName("body");
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
				var db = new Database(new Uint8Array(reader.result));
				render(db);
			}
		}
		
	}
	
	static function addMainContainer() : Node
	{
		Browser.document.querySelector("#main");
		var mainDiv = Browser.document.createDivElement();
		mainDiv.setAttribute("id", "main");
		Browser.document.body.appendChild(mainDiv);
		return mainDiv;
	}
	
	static function render(db : Database)
	{
		var container = addMainContainer();
		container.appendChild(plotAlbumsByYear(db));
	}
	
	static function plotAlbumsByYear(db : Database) : Node
	{
		var data = getAlbumsByYear(db);
		var plotElement = Browser.document.createDivElement();
		var chartOptions = new Options();
		chartOptions.title.text = "Oink oink";
		chartOptions.chart.renderTo = plotElement;
		chartOptions.chart.type = ChartType.bar;
		chartOptions.xAxis.categories = ["Apples", "Bananas", "Oranges"];
		chartOptions.yAxis.title.text = "Fruit eaten";
		chartOptions.series.push(new SeriesOptions());
		chartOptions.series.push(new SeriesOptions());
		chartOptions.series[0].data = [1, 0, 4];
		chartOptions.series[0].name = "Jane";
		chartOptions.series[1].data = [5, 7, 3];
		chartOptions.series[1].name = "John";
		var chart = new Chart(chartOptions);
		return plotElement;
	}
	
	static function getAlbumsByYear(db : Database) : Array<{year : Int, numAlbums : Int}>
	{
		var result = db.exec( "SELECT year, COUNT(*) AS numAlbums FROM Album GROUP BY year ORDER BY year ASC" );
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
}