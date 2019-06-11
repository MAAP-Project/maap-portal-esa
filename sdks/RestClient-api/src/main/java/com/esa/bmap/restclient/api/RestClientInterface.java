package com.esa.bmap.restclient.api;

import java.net.ConnectException;

public interface RestClientInterface {

	/**
	 * Send a get request to the back end and get the result 
	 * under a String format
	 * @param url
	 * @return
	 */
	public String get(String url) throws ConnectException;
	
	
	/**
	 * Send a post request to the back end and get the result
	 * under a String format
	 * @param url
	 * @param body
	 * @return
	 */
	public String post(String url, String body) throws ConnectException;
	
	
	/**
	 * Delete an object in the back end using the id
	 * @param id
	 * @return
	 */
	public int delete(String url, Long id) throws ConnectException;
}
