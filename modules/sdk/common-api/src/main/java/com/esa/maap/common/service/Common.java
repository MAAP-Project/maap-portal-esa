package com.esa.maap.common.service;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.osgi.service.component.annotations.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.esa.bmap.common.exceptions.BmapException;

/**
 * @author Capgemini
 * @version 0.0.1
 */
@Component(service = Common.class, immediate = true)
public class Common {

	public static final String RESSOURCE_PROPERTIES = "configuration.properties";

	private static final String MESSAGESFILE = "messages.properties";
	private static final  Logger LOG = LoggerFactory.getLogger(Common.class);

	/**
	 * Return the value of a key in the properties file
	 * 
	 * @param key requested
	 * @return property value
	 * @throws BmapException
	 */
	public String getValueFromKeyInPropertiesFile(String key) throws BmapException {
		LOG.info("Getting {} value from Common Service",  key );

		String value = null;
		if (System.getenv(key) != null) {
			LOG.info("Retrieving {} value from System variable: {} ", key , System.getenv(key));
			value = System.getenv(key);

		} else {
			LOG.info("Retrieving {}  value from property file: {} ", key , System.getenv(key));
			InputStream resourceStream = null;
			try {

				ClassLoader loader = Thread.currentThread().getContextClassLoader();
				Properties props = new Properties();

				resourceStream = loader.getResourceAsStream(RESSOURCE_PROPERTIES);

				// load a properties file
				props.load(resourceStream);
				value = props.getProperty(key);

			} catch (IOException ex) {
				throw new BmapException("Failed retrieve" + key + " property ", ex);
			} finally {
				if (resourceStream != null) {
					try {
						resourceStream.close();
					} catch (IOException e) {
						throw new BmapException("Failed to close InputStream", e);
					}
				}
			}

		}
		return value;
	}

	/**
	 * Return the value of a key in the properties file.
	 * 
	 * @param key The key to read.
	 * @return The value of the key.
	 * @throws BmapException
	 */
	public static String getMessageValue(String key) {

		String value = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Properties properties = new Properties();

		try (InputStream resourceStream = loader.getResourceAsStream(MESSAGESFILE)) {

			// load a properties file
			properties.load(resourceStream);
			value = properties.getProperty(key);

		} catch (Exception e) {

			LOG.error("Failed to retrieve property", e);
		}

		return value;
	}
}
