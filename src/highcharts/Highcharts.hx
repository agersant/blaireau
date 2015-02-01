package highcharts;

/**
 * ...
 * @author agersant
 */

@:native("Highcharts")
extern class Highcharts
{
	public static function setOptions(options : Options) : Void {}
}

@:native("Highcharts.Chart")
extern class Chart
{
	public function new(options : Options) {}
	public var options : Options;
	public function print() : Void {}
	public function redraw() : Void {}
	public function reflow() : Void {}
	public function showLoading(str : String) : Void {}
}

class ChartType
{
	public static inline var area: String = "area";
	public static inline var arearange: String = "arearange";
	public static inline var areaspline: String = "areaspline";
	public static inline var areasplinerange: String = "areasplinerange";
	public static inline var bar: String = "bar";
	public static inline var boxplot: String = "boxplot";
	public static inline var bubble: String = "bubble";
	public static inline var column: String = "column";
	public static inline var columnrange: String = "columnrange";
	public static inline var errorbar: String = "errorbar";
	public static inline var funnel: String = "funnel";
	public static inline var gauge: String = "gauge";
	public static inline var heatmap: String = "heatmap";
	public static inline var line: String = "line";
	public static inline var pie: String = "pie";
	public static inline var pyramid: String = "pyramid";
	public static inline var scatter: String = "scatter";
	public static inline var series: String = "series";
	public static inline var solidgauge: String = "solidgauge";
	public static inline var spline: String = "spline";
	public static inline var waterfall: String = "waterfall";
}

class Options
{
	public function new() {}
	public var chart: ChartOptions = new ChartOptions();
	public var series: Array<SeriesOptions> = [];
	public var title: TitleOptions = new TitleOptions();
	public var xAxis: AxisOptions = new AxisOptions();
	public var yAxis: AxisOptions = new AxisOptions();
}

class AxisOptions
{
	public function new() {}
	public var categories : Array<String>;
	public var title : AxisTitleOptions = new AxisTitleOptions();
}

class AxisTitleOptions
{
	public function new() {}
	public var text : String;
}

class ChartOptions
{
	public function new() {}
	public var renderTo : js.html.Node;
	public var type : String;
}

class SeriesOptions
{
	public function new() {}
	public var data : Array<Dynamic> = [];
	public var name : String;
}

class TitleOptions
{
	public function new() {}
	public var align: String; // TODO static strings
	public var floating: Null<Bool>;
	public var margin: Null<Float>;
	public var style: Dynamic; // TODO
	public var text: String;
	public var useHTML: Null<Bool>;
	public var verticalAlign: Dynamic; // TODO
	public var x: Null<Float>;
	public var y: Null<Float>;
}