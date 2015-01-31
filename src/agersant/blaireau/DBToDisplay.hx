package agersant.blaireau;
import haxe.io.Bytes;
import haxe.io.BytesData;
import js.Browser;
import js.d3.D3;
import js.d3.selection.Selection;
import js.html.ArrayBuffer;
import js.html.FileList;
import js.html.FileReader;
import js.html.FileReaderSync;
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
	
	static function addMainContainer() : Selection
	{
		D3.select("#main").remove();
		D3.select("body").append("div").attr("id", "main");
		return D3.select("#main");
	}
	
	static function render(db : Database)
	{
		var container = addMainContainer();
		plotAlbumsByYear(db, container);
	}
	
	static function plotAlbumsByYear(db : Database, container : Selection)
	{
		
		var data = getAlbumsByYear(db);
		
		var margin = { top: 20, right: 30, bottom: 30, left: 40 };
		var width = 960 - margin.left - margin.right;
		var height = 500 - margin.top - margin.bottom;
		
		var x = D3.scale.ordinal()
			.domain(D3.range(
				D3.min(data, function(d) { return d.year; } ),
				1 + D3.max(data, function(d) { return d.year; } )
			))
			.rangeRoundBands([0, width]);
		var getX = function(i) { return (untyped x)(i); };
			
		var y = D3.scale.linear()
			.domain([0, D3.max(data, function(d) { return d.numAlbums; } )])
			.range([height, 0]);
		var getY = function(i) { return (untyped y)(i); };
		
		var chart = container.append("svg")
			.attr("id", "plotAlbumsByYear")
			.attr("class", "chart")
			.attr("viewBox", "0 0 " + width + " " + height)
			.attr("width", width + margin.left + margin.right)
			.attr("height", height + margin.top + margin.bottom)
			.append("g")
				 .attr("id", "content")
				 .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
		
		// Data
		chart.selectAll("#content").data(data)
			.enter().append("g")
				.attr("class", "bar" )
				.attr("transform", function(d) {
					return "translate(" + getX(d.year) + ", 0)"; 
				} );
		
		var bar = chart.selectAll(".bar");
		
		bar.append("rect")
			.attr("y", function(d) { return getY(d.numAlbums); } )
			.attr("height", function(d) { return height - getY(d.numAlbums); } )
			.attr("width", x.rangeBand());
		
		bar.append("text")
			.attr("x", x.rangeBand()/2 )
			.attr("y", function(d) { return getY(d.numAlbums) + 3; } )
			.attr("dy", ".75em")
			.text(function(d) { return d.year; } );
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