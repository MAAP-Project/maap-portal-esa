package com.esa.bmap.data.impl;

import java.io.IOException;
import java.net.ConnectException;
import java.util.ArrayList;
import java.util.Collection;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.bedatadriven.jackson.datatype.jts.JtsModule;
import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.common.service.Common;
import com.esa.bmap.data.api.DataInterface;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;
import com.esa.bmap.restclient.api.RestClientInterface;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component(service = DataInterface.class, immediate = true)
public class DataServiceImpl implements DataInterface {

	private static String REST_URI;
	private static String ROOT_METHOD = "catalogue/granule";

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
	 */
	@Reference
	public void setDataCommonLocalService(Common commonService) {

		// We set the correct URI
		REST_URI = commonService.getValueFromKeyInPropertiesFile("BMAP_BACKEND_URL") + ROOT_METHOD;
		System.out.println(REST_URI);
		errorMessage = commonService.getValueFromKeyInPropertiesFile("back_end_error_global");
	}

	/**
	 * Get a Granule by its ID
	 * 
	 * @param id ID of the Granule 
	 */
	@Override
	public Granule getGranuleById(Long id) throws BmapException {

		Granule granule = null;

		try {

			String requestBody = restClient.get(REST_URI + "/" + id);

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
			mapper.registerModule(new JtsModule());
			granule = mapper.readValue(requestBody, Granule.class);

		} catch (Exception e) {
			System.out.println("Failed to get Granule by its ID : " + e.getStackTrace());
			throw new BmapException(errorMessage);
		}

		return granule;

	}
	/**
	 * Get a Granule by its name
	 * 
	 * @param name of the granule as so : Collectionname:@granuleName
	 */
	@Override
	public Granule getGranuleByName(String granuleName) throws BmapException {

		Granule granule = null;

		try {

			String requestBody = restClient.get(REST_URI + "/granulename/" + granuleName);

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
			mapper.registerModule(new JtsModule());
			granule = mapper.readValue(requestBody, Granule.class);

		} catch (Exception e) {
			System.out.println("Failed to get Granule by its name : " + e.getStackTrace());
			throw new BmapException(errorMessage);
		}

		return granule;

	}

	/**
	 * Get a Collection of Granule by a GranuleCriteria
	 * 
	 * @param granuleCriteria GranuleCriteria used for Search
	 */
	@Override
	public Collection<Granule> getGranuleByCriteria(GranuleCriteria granuleCriteria) throws BmapException {

		Collection<Granule> listOfGranule = new ArrayList<>();

		// Serialization of the given GranuleCriteria
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

		String body;
		try {
			body = mapper.writer().writeValueAsString(granuleCriteria);
			System.out.println(body);
		} catch (JsonProcessingException e) {
			throw new BmapException(
					"Granule Criteria couldn't be retrieved correctly, please contact the administrator");
		}

		// Call to backend service with the given dataCriteria
		String requestBody;
		try {
			System.out.println("requet url - " + REST_URI);
			System.out.println("body - " + body);
			requestBody = restClient.post(REST_URI, body);
		} catch (ConnectException e1) {
			throw new BmapException(errorMessage);
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
				throw new BmapException(
						"The Search results couldn't be retrieved correctly, please contact the administrator");
			}

		}

		return listOfGranule;

	}

}
