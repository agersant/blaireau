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
	
	
	
	public static function plotTracksPerGenrePerYear(db : Database) : Node
	{
		var data = Analyze.getTracksPerGenrePerYear(db);
		
		var plotElement = Browser.document.createDivElement();
		plotElement.setAttribute("class", "chart");
		
		var chartOptions = new Options();
		
		chartOptions.title.text = "Tracks per genre over time";
		chartOptions.chart.zoomType = ZoomType.xy;
		chartOptions.chart.renderTo = plotElement;
		chartOptions.chart.type = ChartType.spline;
		
		chartOptions.yAxis.title.text = "Number of tracks";
		chartOptions.xAxis.title.text = "Year";
		
		var seriesByGenre: Map<String, {totalTracks: Int, options: SeriesOptions}> = new Map();
		for (d in data)
		{
			var series = seriesByGenre.get(d.genre);
			var seriesOptions: SeriesOptions;
			if (series == null)
			{
				seriesOptions = new SeriesOptions();
				seriesOptions.name = d.genre;
				seriesOptions.data = [];
				series = {totalTracks: 0, options: seriesOptions};
				seriesByGenre.set(d.genre, series);
			}
			else
			{
				seriesOptions = series.options;
			}
			series.totalTracks += d.numTracks;
			var point = new DataPoint();
			point.x = d.year;
			point.y = d.numTracks;
			seriesOptions.data.push(point);
		}
		
		// Sort series by genre name
		var displaySeries = Lambda.array(seriesByGenre);
		displaySeries.sort(function(a, b) { return b.options.name < a.options.name ? 1 : -1; } );
		for (series in displaySeries)
			chartOptions.series.push(series.options);
		
		var chart = new Chart(chartOptions);
		
		// By default, only show the most important genres
		displaySeries.sort(function(a, b) { return b.totalTracks - a.totalTracks; } );
		var importantGenres = new Map();
		for (i in 0...displaySeries.length)
			if (i < 5)
				importantGenres.set(displaySeries[i].options.name, true);
		for (i in 0...chart.series.length)
		{
			var visible = importantGenres.exists(chart.series[i].name);
			chart.series[i].setVisible(visible, false);
		}
		chart.redraw();
		
		return plotElement;
	}
	
}