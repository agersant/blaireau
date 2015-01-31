package agersant.blaireau;
import haxe.io.Bytes;
import haxe.io.BytesData;
import js.Browser;
import js.d3.D3;
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
				trace(reader.result);
				trace(db.exec("SELECT * FROM Track"));
			}
		}
		
		D3.select("body")
			.append('div')
			.text(function() {
				return 'hi';
			})
			.style("background-color", "grey");
		
	}
	
}