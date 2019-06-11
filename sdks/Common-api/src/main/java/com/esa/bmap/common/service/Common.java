/*
 * $Id$
 *
 * ======================================================
 *
 * Project : Biomass
 * Produit par Capgemini.
 *
 * ======================================================
 * HISTORIQUE
 * FIN-HISTORIQUE
 * ======================================================
 */
package com.esa.bmap.common.service;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.osgi.service.component.annotations.Component;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Capgemini
 * @version 0.0.1
 */
@Component(service = Common.class, immediate = true)
public class Common {
	

	/**
	 * Return the value of a key in the properties file
	 * 
	 * @param key
	 *            requested
	 * @return property value
	 */
	public String getValueFromKeyInPropertiesFile(String key) {
		Logger LOG = LoggerFactory.getLogger(this.getClass().getName());
		LOG.info("Getting " + key + " value from Common Service");

		String value = null;
		if (System.getenv(key) != null) {
			LOG.info("Getting " + key + " value from System variable: " + System.getenv(key));
			value = System.getenv(key);

		} else {

			InputStream input = null;
			try {

				String resourceName = "configuration.properties"; // could also be a constant
				ClassLoader loader = Thread.currentThread().getContextClassLoader();
				Properties props = new Properties();
				try (InputStream resourceStream = loader.getResourceAsStream(resourceName)) {
					// load a properties file
					props.load(resourceStream);
					value = props.getProperty(key);
				}
			} catch (IOException ex) {
				//TODO: find a way to use logger in OSGI module
				//e.printStackTrace();
				System.err.println(ex.getMessage());
			} finally {
				if (input != null) {
					try {
						input.close();
					} catch (IOException e) {
						//TODO: find a way to use logger in OSGI module
						System.err.println(e.getMessage());
						//e.printStackTrace();
					}
				}
			}

		}
		return value;
	}

}
