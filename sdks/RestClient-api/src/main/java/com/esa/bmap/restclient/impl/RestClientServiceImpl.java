package com.esa.bmap.restclient.impl;

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

import com.esa.bmap.restclient.api.RestClientInterface;

@Component(service = RestClientInterface.class, immediate = true)
public class RestClientServiceImpl implements RestClientInterface {

	// The client to use to open the connection
	HttpClient client;

	@Activate
	public void activate() {
		// We initialize the httpclient
		client = new HttpClient();
		client.setHttpConnectionManager(new MultiThreadedHttpConnectionManager());
	}

	public String get(String url) throws ConnectException {

		String result = null;
		// Create a method instance.
		GetMethod method = new GetMethod(url);
		method.setRequestHeader("Accept", "application/json");

		try {
			// Execute the method.
			int statusCode = client.executeMethod(method);

			if (statusCode != HttpStatus.SC_OK) {
				System.err.println("Method failed: " + method.getStatusLine());
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
				System.err.println("Method failed: " + method.getStatusLine());
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
	public int delete(String url, Long id) throws ConnectException {

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
				System.err.println("Method failed: " + method.getStatusLine());
			}

		} catch (HttpException e) {
			throw new ConnectException(e.getMessage());
		} catch (IOException e) {
			throw new ConnectException(e.getMessage());
		} finally {
			// Release the connection.
			method.releaseConnection();
		}

		return statusCode;
	}

}
