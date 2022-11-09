package com.esa.maap.data.api;

import java.util.Collection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;

public interface DataInterface {

	public final static Logger LOG = LoggerFactory.getLogger(DataInterface.class);

	/**
	 * Get a data by its id
	 * 
	 * @param id
	 * @return Data
	 */
	public Granule getGranuleById(String id) throws BmapException;

	/**
	 * Method to get a collection of granules by a given granuleCriteria
	 * 
	 * @param granuleCriteria GranuleCriteria containing research criteria
	 * @return Collection of granules matching the given criteria
	 * @throws BmapException
	 */
	public Collection<Granule> getGranuleByCriteria(GranuleCriteria granuleCriteria) throws BmapException;

	/**
	 * Get a Granule by its name
	 * 
	 * @param granuleUr id of the granule as so : Collectionname:@granuleName
	 */
	public Granule getGranuleByName(String granuleUr) throws BmapException;

	/**
	 * Share a user private data
	 * 
	 * @param granuleUr id of the granule as so : Collectionname:@granuleName
	 */
	public String sharePrivateData(String granuleUr) throws BmapException;

	/**
	 * Method to transform granule collection to json
	 * 
	 * @param granuleCollection
	 * @return
	 * @throws BmapException
	 */
	String collectionTOJson(Collection<Granule> granuleCollection) throws BmapException;

	/**
	 * Method to get all collectionNames from available Biomass Collections
	 * @return
	 * @throws BmapException
	 */
	String getBiomassCollectionNames() throws BmapException;

}
