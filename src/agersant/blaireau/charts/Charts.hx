package agersant.blaireau.charts;
import agersant.blaireau.analyze.Analyze;
import highcharts.Highcharts;
import highcharts.Highcharts.Chart;
import highcharts.Highcharts.ChartType;
import highcharts.Highcharts.DataPoint;
import highcharts.Highcharts.HighchartsMap;
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
	
	static inline var CSS_CLASS_FULL_CHART : String = "full_chart";
	static inline var CSS_CLASS_QUARTER_CHART : String = "quarter_chart";

	public static function plotAlbumsByYear(db : Database) : Node
	{
		var data = Analyze.getAlbumsByYear(db);
		
		var plotElement = Browser.document.createDivElement();
		plotElement.setAttribute("class", CSS_CLASS_FULL_CHART);
		
		var options = new Options();
		
		options.credits.enabled = false;
		options.title.text = "Albums per year of release";
		options.chart.zoomType = ZoomType.x;
		options.chart.renderTo = plotElement;
		options.chart.type = ChartType.column;
		
		options.yAxis.title.text = "Number of albums";
		options.xAxis.title.text = "Year";
		
		options.series.push(new SeriesOptions());
		options.series[0].showInLegend = false;
		options.series[0].name = "Number of albums";
		options.series[0].data = [];
		var seriesData = options.series[0].data;
		for (d in data)
		{
			var point = new DataPoint();
			point.x = d.year;
			point.y = d.numAlbums;
			seriesData.push(point);
		}
		
		var chart = new Chart(options);
		return plotElement;
	}
	
	public static function plotTracksByGenre(db : Database) : Node
	{
		var data = Analyze.getTracksPerGenre(db);
		
		var plotElement = Browser.document.createDivElement();
		plotElement.setAttribute("class", CSS_CLASS_FULL_CHART);
		
		var options = new Options();
		
		options.credits.enabled = false;
		options.title.text = "Tracks per genre";
		options.chart.zoomType = ZoomType.x;
		options.chart.renderTo = plotElement;
		options.chart.type = ChartType.column;
		
		options.yAxis.title.text = "Number of tracks";
		options.xAxis.labels.rotation = -70;
		options.xAxis.title.text = "Genre";
		options.xAxis.categories = [];
		
		options.series.push(new SeriesOptions());
		options.series[0].showInLegend = false;
		options.series[0].name = "Number of tracks";
		options.series[0].data = [];
		for (d in data)
		{
			options.xAxis.categories.push(d.genre);
			options.series[0].data.push(d.numTracks);
		}
		
		var chart = new Chart(options);
		return plotElement;
	}
	
	public static function plotTracksPerGenrePerYear(db : Database) : Node
	{
		var data = Analyze.getTracksPerGenrePerYear(db);
		
		var plotElement = Browser.document.createDivElement();
		plotElement.setAttribute("class", CSS_CLASS_FULL_CHART);
		
		var options = new Options();
		
		options.credits.enabled = false;
		options.title.text = "Tracks per genre over time";
		options.chart.zoomType = ZoomType.xy;
		options.chart.renderTo = plotElement;
		options.chart.type = ChartType.spline;
		
		options.yAxis.title.text = "Number of tracks";
		options.xAxis.title.text = "Year";
		
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
			options.series.push(series.options);
		
		var chart = new Chart(options);
		
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
	
	public static function plotTracksPerCountry(db : Database) : Node
	{
		var data = Analyze.getTracksPerCountry(db);
		
		var plotElement = Browser.document.createDivElement();
		plotElement.setAttribute("class", CSS_CLASS_FULL_CHART);
		
		var options = new Options();
		options.credits.enabled = false;
		options.title.text = "Tracks per country";
		options.chart.renderTo = plotElement;
		
		var maxTracks = 0;
		
		var mapSeriesContent = [];
		for (d in data)
		{
			if (d.country == "United States") // HACK
				d.country = "United States of America";
			var dataPoint = new DataPoint();
			dataPoint.name = d.country;
			dataPoint.key = d.country;
			dataPoint.value = d.numTracks;
			mapSeriesContent.push(dataPoint);
			maxTracks = Math.round(Math.max(maxTracks, d.numTracks));
		}
		
		var colorAxisOptions = new ColorAxisOptions();
		colorAxisOptions.min = 0;
		colorAxisOptions.max = maxTracks;
		colorAxisOptions.stops = [
			[0, "#E4FF7A"],
			[0.25, "#FFE81A"],
			[0.5, "#FFBD00"],
			[0.75, "#FFA000"],
			[1.0, "#FC7F00"],
		];
		options.colorAxis = colorAxisOptions;
		
		var mapSeries = new SeriesOptions();
		mapSeries.name = "Number of tracks";
		mapSeries.mapData = Reflect.getProperty(Highcharts.maps, 'custom/world');
		mapSeries.data = mapSeriesContent;
		mapSeries.joinBy = ["name", "key"];
		options.series.push(mapSeries);
		
		var chart = new HighchartsMap(options);
		
		return plotElement;
	}
	
	public static function plotTracksPerGenrePerCountry(db : Database) : Node
	{
		
		var maxCountries : Int = 8;
		var maxGenres : Int = 10;
		
		var data = Analyze.getTracksPerGenrePerCountry(db);
		var container = Browser.document.createDivElement();
		
		var numTracksPerCountryMap = new Map();
		var genresPerCountry = new Map();
		for (d in data)
		{
			if (!numTracksPerCountryMap.exists(d.country))
				numTracksPerCountryMap.set(d.country, 0);
			var current = numTracksPerCountryMap.get(d.country);
			numTracksPerCountryMap.set(d.country, current + d.numTracks);
			
			if (!genresPerCountry.exists(d.country))
				genresPerCountry.set(d.country, []);
			var ar = genresPerCountry.get(d.country);
			ar.push({ genre: d.genre, numTracks: d.numTracks });
		}
		
		// Sort countries by numTracks
		var numTracksPerCountryArray = [];
		for (country in numTracksPerCountryMap.keys())
		{
			var numTracks = numTracksPerCountryMap.get(country);
			numTracksPerCountryArray.push({country: country, numTracks: numTracks });
		}
		numTracksPerCountryArray.sort(function(a, b) { return b.numTracks - a.numTracks; } );
		
		var countriesToDisplay = Math.floor(Math.min(maxCountries, numTracksPerCountryArray.length));
		for (countryIndex in 0...countriesToDisplay)
		{
			var countryName = numTracksPerCountryArray[countryIndex].country;
			var countryData = genresPerCountry.get(countryName);
			countryData.sort(function(a, b) { return b.numTracks - a.numTracks; } );
			var genresToDisplay = Math.floor(Math.min(maxGenres, countryData.length));
				
			var plotElement = Browser.document.createDivElement();
			plotElement.setAttribute("class", CSS_CLASS_QUARTER_CHART);
			container.appendChild(plotElement);
			
			var options = new Options();
			options.credits.enabled = false;
			options.title.text = countryName;
			options.chart.renderTo = plotElement;
			options.chart.type = ChartType.bar;
			
			options.yAxis.title.text = "Number of tracks";
			options.xAxis.title.text = "Genre";
			options.xAxis.categories = [];
			
			options.series.push(new SeriesOptions());
			options.series[0].showInLegend = false;
			options.series[0].name = "Number of tracks";
			options.series[0].data = [];
			for (genreIndex in 0...genresToDisplay)
			{
				options.xAxis.categories.push(countryData[genreIndex].genre);
				options.series[0].data.push(countryData[genreIndex].numTracks);
			}
			
			var chart = new Chart(options);
				
		}
		
		
		return container;
	}
	
}