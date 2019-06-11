package com.esa.bmap.usermanagement.impl;
import java.io.IOException;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.common.service.Common;
import com.esa.bmap.model.BmaapUser;
import com.esa.bmap.restclient.api.RestClientInterface;
import com.esa.bmap.usermanagement.api.BmapUserServiceInterface;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;


/**
 * BmapUser service  used to request the back end
 * to add or delete a user
 * @author tkossoko
 *
 */
@Component(service = {BmapUserServiceInterface.class}, immediate = true )
public class BmapUserServiceImpl implements BmapUserServiceInterface {

	private static String REST_URI;
	private static String ROOT_METHOD = "bmapuser";
	private Common commonService;
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
		this.commonService = commonService;
		REST_URI = commonService.getValueFromKeyInPropertiesFile("BMAP_BACKEND_URL") + ROOT_METHOD;
		errorMessage = commonService.getValueFromKeyInPropertiesFile("back_end_error_global");

	}
	@Override
	public BmaapUser addABmapUser(BmaapUser user) throws BmapException {

		BmaapUser bmapUser = null;
		
		String body;
		try {
			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
			body = mapper.writer().writeValueAsString(user);
			// Call to backend service
			String requestBody;
			requestBody = restClient.post(REST_URI, body);
			//We deserialize the object
			bmapUser = mapper.readValue(requestBody, BmaapUser.class);
			
		} catch (IOException e) {
			throw new BmapException("Impossible to create an user. Please contact the administrator");
		}
		
		return bmapUser;
	}

	@Override
	public int deleteBmapUser(int id) throws BmapException {
		
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		int statusCode;
		try {
			// Call to backend service
			statusCode = restClient.delete(REST_URI, Long.parseLong(id+""));
		} catch (IOException e) {
			throw new BmapException("Impossible to delete this user.");
		}

		return statusCode;
	}

	@Override
	public BmaapUser getBmapUserById(int id) throws BmapException {
		
		BmaapUser bmapUser = null;
		String body = null;
		
		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		try {
			body = mapper.writer().writeValueAsString(id);
			// Call to backend service
			String requestBody;
			requestBody = restClient.get(REST_URI+"/"+body);
			
			//We deserialize the object
			bmapUser = mapper.readValue(requestBody, BmaapUser.class);
		} catch (IOException e) {
			throw new BmapException("Impossible to get this user. Please contact the administrator");
		}

		return bmapUser;
	}

}
