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
		container.appendChild(plotAlbumsByYear(db));
	}
	
	static function plotAlbumsByYear(db : Database) : Node
	{
		var data = getAlbumsByYear(db);
		var plotElement = Browser.document.createDivElement();
		var chartOptions = new Options();
		
		chartOptions.title.text = "Albums per year of release";
		chartOptions.chart.width = 960;
		chartOptions.chart.height = 600;
		chartOptions.chart.zoomType = ZoomType.x;
		chartOptions.chart.renderTo = plotElement;
		chartOptions.chart.type = ChartType.column;
		
		chartOptions.yAxis.title.text = "Number of albums";
		chartOptions.xAxis.title.text = "Year";
		
		chartOptions.series.push(new SeriesOptions());
		chartOptions.series[0].showInLegend = false;
		chartOptions.series[0].name = "Number of albums";
		chartOptions.series[0].data = [];
		var seriesData = chartOptions.series[0].data;
		for (d in data)
		{
			var point = new DataPoint();
			point.x = d.year;
			point.y = d.numAlbums;
			seriesData.push(point);
		}
		
		var chart = new Chart(chartOptions);
		return plotElement;
	}
	
	static function getAlbumsByYear(db : Database) : Array<{year : Int, numAlbums : Int}>
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
}