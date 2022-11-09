package com.esa.maap.visualisationoverlay.portlet.constants;

/**
 * @author tkossoko
 */
public class VisualisationOverlayPortletKeys {

	public static final String VISUALISATIONOVERLAY =
		"com_esa_maap_visualisationoverlay_portlet_VisualisationOverlayPortlet";
	
	/**
	 * ESA constants
	 */
	public static final String ESA_CARTO_SERVER_URL_KEY = "BMAP_GEOSERVER_URL";
	public static final String ESA_CARTO_SERVER_WORKSPACE_KEY = "BMAP_GEOSERVER_WORKSPACE";
	public static final String ESA_WMS_ENDPOINT_KEY = "BMAP_GEOSERVER_WMS_ENDPOINT";
	
	
	/*
	 * NASA constants
	 */
	public static final String NASA_CARTO_SERVER_URL_KEY = "NASA_CARTO_SERVER_URL";
	public static final String NASA_WMS_ENDPOINT_KEY = "NASA_WMS_ENDPOINT";
	

	public static final String GRANULE_NAME_PARAM = "granuleName";
	public static final String GRANULE_PARAM = "granule";
	public static final String COLLECTION_NAME_PARAM = "collectionName";
	public static final String DATA_OVERLAYLIST_PARAM = "dataOverlayList";
	public static final String PRIVACY_TYPE_PARAM = "privacyType";
	// triggers
	public static final String RASTER_COMPARISON_TRIGGER = "displayPlotComparisonTrigger";
	public static final String ROI_STATS_TRIGGER = "displayRoiStatsTrigger";

	public static final String ERROR_MESSAGE_ATTR = "errorMessage";

	// params
	public static final String STATS_MIN_PARAM = "statsMin";
	public static final String STATS_MAX_PARAM = "statsMax";
	public static final String STATS_AVG_PARAM = "statsAvg";
	public static final String FILE_TYPE_PARAM = "fileType";
	public static final String MIN_X_PARAM = "minX";
	public static final String MIN_Y_PARAM = "minY";
	public static final String MAX_X_PARAM = "maxX";
	public static final String MAX_Y_PARAM = "maxY";
	public static final String GRANULE_LIST_PARAM = "granuleList";
	public static final String GRANULE_RASTER_ID_PARAM = "granuleRasterId";
	public static final String GRANULE_ROI_ID_PARAM = "granuleRoiId";
	public static final String GRANULE_RASTER_XAXIS_PARAM = "granuleRasterXaxis";
	public static final String GRANULE_RASTER_YAXIS_PARAM = "granuleRasterYaxis";
	public static final String WKT_VECTOR_PARAM = "vectorWKT";

	public static final String GEOSERVER_WMS_PARAM = "geoserverWMS";
	public static final String GEOSERVER_WMTS_PARAM = "geoserverWMTS";
	
	public static final String NASA_CARTO_SERVER_WMS_PARAM = "NASACartoWMS";

}