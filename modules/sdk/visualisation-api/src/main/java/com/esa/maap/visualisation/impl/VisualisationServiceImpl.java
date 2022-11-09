package com.esa.maap.visualisation.impl;

import java.net.ConnectException;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.maap.common.service.Common;
import com.esa.maap.data.api.DataInterface;
import com.esa.bmap.model.visualisation.GranuleRoiSubset;
import com.esa.bmap.model.visualisation.GranuleWktSubset;
import com.esa.bmap.model.visualisation.PlotComparisonHolder;
import com.esa.maap.restclient.api.RestClientInterface;
import com.esa.maap.visualisation.api.VisualisationInterface;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * @author edupin
 *
 */
@Component(service = VisualisationInterface.class, immediate = true)
public class VisualisationServiceImpl implements VisualisationInterface {

	private static String REST_URI;
	
	//backend rest methods
	private static final String VISUALISATION_ROOT_METHOD = "visualisation";
	private static final String RASTER_HISTOGRAM_METHOD = "/raster/histogram/";
	private static final String CUSTOM_PROFILE_METHOD = "/raster/customProfile";
	private static final String SUBSET_STATS_METHOD = "/raster/basicStatsSubset";
	private static final String ROI_STATS_METHOD = "/raster/basicStatsRoiSubset";
	private static final String RASTER_COMPARISON_METHOD = "/comparison/rasterComparison";

	// The rest client to call web services
	private RestClientInterface restClient;

	private DataInterface dataService;

	@Activate
	public void activate() {

	}

	/**
	 * Instanciation of a restClient to use
	 * 
	 * @param restClient
	 */
	@Reference
	public void setRestClientLocalService(RestClientInterface restClient) {
		this.restClient = restClient;
	}

	/**
	 * Instanciation of a data service to use
	 * 
	 * @param dataClient
	 */
	@Reference
	public void setDataService(DataInterface dataClient) {
		this.dataService = dataClient;
	}

	/**
	 * Instanciation of a common service to use
	 * 
	 * @param restClient
	 * @throws BmapException
	 */
	@Reference
	public void setCommonService(Common commonService) throws BmapException {

		// We set the correct URI
		REST_URI = commonService.getValueFromKeyInPropertiesFile("BMAP_BACKEND_URL");
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public String getRasterHistogram(String granuleUR) throws BmapException {

		String json = null;

		try {

			json = restClient.get(REST_URI + VISUALISATION_ROOT_METHOD + RASTER_HISTOGRAM_METHOD + granuleUR);

		} catch (Exception e) {

			throw new BmapException(e.getMessage(), e);

		}

		return json;
	}

	/**
	 * {@inheritDoc}
	 */
	public String getRasterCustomProfile(String granuleUR, String wkt) throws BmapException {

		String json = null;

		GranuleWktSubset granuleWktSubset = new GranuleWktSubset(granuleUR, wkt);

		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		String body;
		try {
			body = mapper.writer().writeValueAsString(granuleWktSubset);
			json = restClient.post(REST_URI + VISUALISATION_ROOT_METHOD + CUSTOM_PROFILE_METHOD, body);

		} catch (JsonProcessingException | ConnectException e) {
			throw new BmapException(e.getMessage(), e);
		}

		return json;
	}

	/**
	 * {@inheritDoc}
	 */
	public String getRasterSubsetStats(String granuleUR, String wkt) throws BmapException {
		String json = null;

		GranuleWktSubset granuleWktSubset = new GranuleWktSubset(granuleUR, wkt);
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		String body;
		try {
			body = mapper.writer().writeValueAsString(granuleWktSubset);
			json = restClient.post(REST_URI + VISUALISATION_ROOT_METHOD + SUBSET_STATS_METHOD, body);

		} catch (Exception e) {
			throw new BmapException(e.getMessage(), e);
		}

		return json;
	}

	/**
	 * {@inheritDoc}
	 */
	public String getRasterRoiSubsetStats(String granuleRasterUR, String granuleRoiUR) throws BmapException {
		String json = null;

		GranuleRoiSubset granuleRoiSubset = new GranuleRoiSubset(granuleRasterUR, granuleRoiUR);
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		String body;
		try {
			body = mapper.writer().writeValueAsString(granuleRoiSubset);
			json = restClient.post(REST_URI + VISUALISATION_ROOT_METHOD + ROI_STATS_METHOD, body);

		} catch (Exception e) {
			throw new BmapException(e.getMessage(), e);
		}

		return json;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public String getRasterPlotComparison(String xGranuleRasterUR, String yGranuleRasterUR, String wkt)
			throws BmapException {
		String json = null;

		PlotComparisonHolder plotComparisonHolder = new PlotComparisonHolder(xGranuleRasterUR, yGranuleRasterUR, wkt);
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		String body;
		try {
			body = mapper.writer().writeValueAsString(plotComparisonHolder);
			json = restClient.post(REST_URI + VISUALISATION_ROOT_METHOD + RASTER_COMPARISON_METHOD, body);

		} catch (Exception e) {
			throw new BmapException(e.getMessage(), e);
		}

		return json;

	}
}
