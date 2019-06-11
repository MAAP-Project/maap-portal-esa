package com.esa.bmap.data.api;

import java.util.Collection;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Granule;
import com.esa.bmap.model.GranuleCriteria;

public interface DataInterface {

	
	/**
	 * Get a data by its id
	 * @param id
	 * @return Data
	 */
	public Granule getGranuleById(Long id) throws BmapException;
	
	/**
	 * Get Data by a dataCriteria
	 * @return List<Data>
	 */
	public Collection<Granule> getGranuleByCriteria(GranuleCriteria granuleCriteria) throws BmapException;
	
	/**
	 * Get a Granule by its name
	 * 
	 * @param name of the granule as so : Collectionname:@granuleName
	 */
	public Granule getGranuleByName(String granuleName) throws BmapException;

}
