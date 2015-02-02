package agersant.blaireau.charts;
import agersant.blaireau.analyze.Analyze;
import highcharts.Highcharts.Chart;
import highcharts.Highcharts.ChartType;
import highcharts.Highcharts.DataPoint;
import highcharts.Highcharts.Options;
import highcharts.Highcharts.SeriesOptions;
import highcharts.Highcharts.ZoomType;
import js.Browser;
import js.html.Node;
import sqljs.Database;

/**
 * ...
 * @author agersant
 */
class Charts
{

	public static function plotAlbumsByYear(db : Database) : Node
	{
		var data = Analyze.getAlbumsByYear(db);
		
		var plotElement = Browser.document.createDivElement();
		plotElement.setAttribute("class", "chart");
		
		var chartOptions = new Options();
		
		chartOptions.title.text = "Albums per year of release";
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
	
	public static function plotTracksByGenre(db : Database) : Node
	{
		var data = Analyze.getTracksPerGenre(db);
		
		var plotElement = Browser.document.createDivElement();
		plotElement.setAttribute("class", "chart");
		
		var chartOptions = new Options();
		
		chartOptions.title.text = "Tracks per genre";
		chartOptions.chart.zoomType = ZoomType.x;
		chartOptions.chart.renderTo = plotElement;
		chartOptions.chart.type = ChartType.column;
		
		chartOptions.yAxis.title.text = "Number of tracks";
		chartOptions.xAxis.labels.rotation = -70;
		chartOptions.xAxis.title.text = "Genre";
		chartOptions.xAxis.categories = [];
		
		chartOptions.series.push(new SeriesOptions());
		chartOptions.series[0].showInLegend = false;
		chartOptions.series[0].name = "Number of tracks";
		chartOptions.series[0].data = [];
		for (d in data)
		{
			chartOptions.xAxis.categories.push(d.genre);
			chartOptions.series[0].data.push(d.numTracks);
		}
		
		var chart = new Chart(chartOptions);
		return plotElement;
	}
	
}