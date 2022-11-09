package com.esa.maap.data.impl;

import java.io.IOException;
import java.net.ConnectException;
import java.util.Collection;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.bedatadriven.jackson.datatype.jts.JtsModule;
import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;
import com.esa.maap.common.service.Common;
import com.esa.maap.data.api.DataInterface;
import com.esa.maap.restclient.api.RestClientInterface;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component(service = DataInterface.class, immediate = true)
public class DataServiceImpl implements DataInterface {

	private static String REST_URI;
	private static String ROOT_URL;
	private static String ROOT_METHOD_CATALOGUE_GRANULE = "catalogue/granule";
	private static String GRANULE_NAME_PATH = "/granulename/";
	private static String ROOT_METHOD_COLLECTIONNAMES = "catalogue/granule/collections/names";
	private static String SHARING_PATH = "/share/";
	private String errorMessage;

	// The rest client to call web services
	private RestClientInterface restClient;

	@Activate
	public void activate() {

	}

	/**
	 * Instanciation of a restClient for use
	 * 
	 * @param restClient
	 */
	@Reference
	public void setDataClientLocalService(RestClientInterface restClient) {
		this.restClient = restClient;
	}

	/**
	 * Instanciation of a common service for use
	 * 
	 * @param restClient
	 * @throws BmapException
	 */
	@Reference
	public void setDataCommonLocalService(Common commonService) throws BmapException {
		// We set the correct URI
		REST_URI = commonService.getValueFromKeyInPropertiesFile("BMAP_BACKEND_URL") + ROOT_METHOD_CATALOGUE_GRANULE;
		ROOT_URL = commonService.getValueFromKeyInPropertiesFile("BMAP_BACKEND_URL");
		LOG.info(REST_URI);
		errorMessage = commonService.getValueFromKeyInPropertiesFile("back_end_error_global");
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Granule getGranuleById(String granuleUr) throws BmapException {

		Granule granule = null;

		try {

			String requestBody = restClient.get(REST_URI + "/" + granuleUr);

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
			mapper.registerModule(new JtsModule());
			granule = mapper.readValue(requestBody, Granule.class);

		} catch (Exception e) {
			LOG.info("Failed to get Granule by its ID : " + e.getStackTrace());
			throw new BmapException(e.getMessage(), e);
		}

		return granule;

	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Granule getGranuleByName(String granuleName) throws BmapException {

		Granule granule = null;

		try {

			String requestBody = restClient.get(REST_URI + GRANULE_NAME_PATH + granuleName);

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
			mapper.registerModule(new JtsModule());
			granule = mapper.readValue(requestBody, Granule.class);
			LOG.debug(granule.toString());

		} catch (Exception e) {

			throw new BmapException("Failed to get Granule by its name : ", e);
		}

		return granule;

	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Collection<Granule> getGranuleByCriteria(GranuleCriteria granuleCriteria) throws BmapException {

		Collection<Granule> listOfGranule;

		// Serialization of the given GranuleCriteria
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

		String body;
		try {

			body = mapper.writer().writeValueAsString(granuleCriteria);
			LOG.info(body);
		} catch (JsonProcessingException e) {
			throw new BmapException("Failed to transform granule Criteria to String", e);
		}

		// Call to backend service with the given dataCriteria
		String requestBody;
		try {
			LOG.info(REST_URI);
			requestBody = restClient.post(REST_URI, body);

		} catch (ConnectException e1) {
			throw new BmapException("Failed to execute post method for connection reason", e1);
		}
		if (requestBody.isEmpty() || requestBody == null) {
			throw new BmapException("No Granule found with given criteria");

		} else {
			// Deserialization of the returned Collection of Data
			mapper.registerModule(new JtsModule());
			JavaType dataCollectionJavaType = mapper.getTypeFactory().constructCollectionType(Collection.class,
					Granule.class);
			try {
				listOfGranule = mapper.readerFor(dataCollectionJavaType).readValue(requestBody);
			} catch (IOException e) {
				throw new BmapException(e.getMessage(), e);
			}

		}

		return listOfGranule;

	}

	/**
	 * {@inheritDoc}
	 */
	public String sharePrivateData(String granuleUR) throws BmapException {
		String response = null;
		try {

			response = restClient.get(REST_URI + SHARING_PATH + granuleUR);
			LOG.info(REST_URI + SHARING_PATH + granuleUR);

		} catch (Exception e) {
			LOG.info("Failed to share private user data : {} ", e.getStackTrace());
			throw new BmapException("Failed to share private granule", e);
		}
		return response;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public String collectionTOJson(Collection<Granule> granuleCollection) throws BmapException {
		return null;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public String getBiomassCollectionNames() throws BmapException {

		String collectionNames = null;

		try {
			String urlString = ROOT_URL + ROOT_METHOD_COLLECTIONNAMES;
		
			collectionNames=restClient.get(urlString);
			

		} catch (Exception e) {
			LOG.error(e.getMessage(), e);
			throw new BmapException("Failed to get List of collection Names: ", e);
		}

		return collectionNames;

	}

}
