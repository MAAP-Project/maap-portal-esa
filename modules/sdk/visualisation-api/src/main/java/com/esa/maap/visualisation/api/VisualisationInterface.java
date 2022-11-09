package com.esa.maap.visualisation.api;

import com.esa.bmap.common.exceptions.BmapException;

/**
 * @author edupin
 *
 */
public interface VisualisationInterface {
	
	//OGC Services
	//WMS
	public static final String WMS_SERVICE = "?service=WMS&version=1.1.0";
	//Operations
	public static final String GET_MAP_REQUEST = "request=GetMap";
	//Operation Parameters
	public static final String LAYERS_PARAM = "layers";
	public static final String BBOX_PARAM = "bbox";
	public static final String WIDTH_PARAM = "width";
	public static final String HEIGHT_PARAM = "height";
	public static final String SRS_PARAM = "srs";
	public static final String ENV_PARAM = "ENV";
	public static final String FORMAT_PNG_PARAM = "format=image%2Fpng";
	/**
	 * Get Raster frequency Histogram
	 * 
	 * @param granuleUR id of the granule (collection:@granuleName)
	 * @return json String with frequency Values
	 * @throws BmapException
	 */
	public String getRasterHistogram(String granuleUR) throws BmapException;


	/**
	 * Get Raster custom profile from given coordinates
	 * 
	 * @param granuleUR id of the granule (collection:@granuleName)
	 * @param wkt line geometry to extract
	 * @return json with pixel values
	 * @throws BmapException
	 */
	public String getRasterCustomProfile(String granuleUR, String wkt) throws BmapException;

	/**
	 * Get Raster statistics from given wkt
	 * 
	 * @param granuleUR (collection:@granuleName)
	 * @param wkt String wkt geometry used to subset the raster with
	 * @return json with statistics values
	 * @throws BmapException
	 */
	public String getRasterSubsetStats(String granuleUR, String wkt) throws BmapException;
	
	/**
	 * Get Raster statistics from given roi
	 * 
	 * @param granuleRasterUR String raster (collection:@granuleName)
	 * @param granuleRoiUR String granule shapefile used to get the stats (collection:@granuleName)
	 * @return json String representing zonal stats
	 * @throws BmapException
	 */
	public String getRasterRoiSubsetStats(String granuleRasterUR, String granuleRoiUR) throws BmapException;
	
	/**
	 * Get plot comparison between two rasters 
	 * @param xGranuleRasterUR raster file path that will be placed in x axis
	 * @param yGranuleRasterUR raster file path that will be placed in y axis
	 * @param wkt geometry used to cop the given rasters to resample
	 * @return json String with the raster's axes that will be used for scatter plotting
	 * @throws BmapException
	 */
	public abstract String getRasterPlotComparison(String xGranuleRasterUR,String yGranuleRasterUR, String wkt) throws BmapException;
}
