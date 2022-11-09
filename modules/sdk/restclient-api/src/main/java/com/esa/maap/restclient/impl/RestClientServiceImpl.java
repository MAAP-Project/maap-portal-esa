package com.esa.maap.restclient.impl;

import java.io.IOException;
import java.io.InputStream;
import java.io.StringWriter;
import java.net.ConnectException;
import java.nio.charset.StandardCharsets;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.MultiThreadedHttpConnectionManager;
import org.apache.commons.httpclient.methods.DeleteMethod;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.StringRequestEntity;
import org.apache.commons.io.IOUtils;
import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.maap.restclient.api.RestClientInterface;

@Component(service = RestClientInterface.class, immediate = true)
public class RestClientServiceImpl implements RestClientInterface {

	public static final Logger LOG = LoggerFactory.getLogger(RestClientServiceImpl.class);
	
	// The client to use to open the connection
	HttpClient client;

	@Activate
	public void activate() {
		// We initialize the httpclient
		client = new HttpClient();
		client.setHttpConnectionManager(new MultiThreadedHttpConnectionManager());
	}

	public String get(String url) throws ConnectException, BmapException {
		LOG.info("GET method called with url: {} ", url);
		String result = null;
		// Create a method instance.
		GetMethod method = new GetMethod(url);
		method.setRequestHeader("Accept", "application/json");

		try {
			// Execute the method.
			int statusCode = client.executeMethod(method);

			if (statusCode != HttpStatus.SC_OK) {
				LOG.info("Method failed: {} ", method.getStatusLine());
				throw new BmapException("Method failed: " + method.getStatusLine());
			}

			// Read the response body.
			InputStream responseBody = method.getResponseBodyAsStream();

			// Deal with the response.
			// Use caution: ensure correct character encoding and is not binary data

			StringWriter writer = new StringWriter();
			IOUtils.copy(responseBody, writer, StandardCharsets.UTF_8.name());

			result = new String(writer.toString());

		} catch (HttpException e) {
			throw new ConnectException(e.getMessage());
		} catch (IOException e) {
			throw new ConnectException(e.getMessage());
		} finally {
			// Release the connection.
			method.releaseConnection();
		}

		return result;
	}

	@Override
	public String post(String url, String body) throws ConnectException {
		LOG.info("POST method called with url {}  and body: {} " , url, body);
		String result = null;

		// Create a method instance.
		PostMethod method = new PostMethod(url);
		method.setRequestHeader("Accept", "application/json");

		try {

			StringRequestEntity requestEntity = new StringRequestEntity(body, "application/json", "UTF-8");

			// Execute the method.
			method.setRequestEntity(requestEntity);
			int statusCode = client.executeMethod(method);

			// We get the status code
			if (statusCode != HttpStatus.SC_OK) {
				LOG.info("Method failed: {}" , method.getStatusLine());
				throw new ConnectException("Method failed: " + method.getStatusLine());
			}

			// Read the response body.
			InputStream responseBody = method.getResponseBodyAsStream();

			// Deal with the response.
			// Use caution: ensure correct character encoding and is not binary data

			StringWriter writer = new StringWriter();
			IOUtils.copy(responseBody, writer, StandardCharsets.UTF_8.name());

			result = new String(writer.toString());

		} catch (HttpException e) {
			LOG.info(e.getMessage());
			throw new ConnectException(e.getMessage());
		} catch (IOException e) {
			LOG.info(e.getMessage());
			throw new ConnectException(e.getMessage());
		} finally {
			// Release the connection.
			method.releaseConnection();
		}

		return result;

	}

	@Override
	public int delete(String url, Long id) throws ConnectException {
		LOG.info("DELETE method called with url " + url + " and id: " + id);
		// We create the effective url
		url = url + "/" + id;

		// By default it's an error. If everything is ok, we should get 200
		int statusCode = 500;
		// Create a method instance.
		DeleteMethod method = new DeleteMethod(url);
		method.setRequestHeader("Accept", "application/json");

		try {
			// Execute the method.
			statusCode = client.executeMethod(method);

			if (statusCode != HttpStatus.SC_OK) {
				LOG.info("Method failed: {}", method.getStatusLine());
			}

		} catch (HttpException e) {
			LOG.info(e.getMessage());
			throw new ConnectException(e.getMessage());
		} catch (IOException e) {
			LOG.info(e.getMessage());
			throw new ConnectException(e.getMessage());
		} finally {
			// Release the connection.
			method.releaseConnection();
		}

		return statusCode;
	}

}
