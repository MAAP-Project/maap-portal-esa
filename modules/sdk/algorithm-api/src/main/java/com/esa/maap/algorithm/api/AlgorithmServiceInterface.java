package com.esa.maap.algorithm.api;

import java.util.Collection;
import java.util.List;
import java.util.Map;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Algorithm;
import com.esa.bmap.model.AlgorithmCriteria;

public interface AlgorithmServiceInterface {
	
	/**
	 * add a new Algorithm (admin who can use this option)
	 * @param algorithm
	 * @return Aalgorithm
	 * @throws BmapException 
	 */
	Algorithm addAlgorithm(Algorithm algorithm) throws BmapException;
	


	/**
	 * delete an algorithm by id
	 * @param idAlgo
	 * @int int status code 200 its a success, 404, the algo is note found and 500 we have an internal server error
	 */
	int deleteAlgorithm(int id) throws BmapException;


	/**
	 * Get the algorithm by it's id
	 * @param idAlgorithm
	 * @return Algorithm
	 * @throws BmapException
	 */
	Algorithm getAlgorithmById(int idAlgorithm) throws BmapException;
	

	/**
	 * Get the algorithm by it's url; The url used to clone a repo
	 * @param String git url
	 * @return Algorithm
	 * @throws BmapException
	 */
	Algorithm getAlgorithmByUrl(String url) throws BmapException;
	
	/**
	 * Find algorithm using single criteria
	 * @Deprecated use searchAlgorithmWithmAlgoCriteria instead
	 * @return
	 */
	Collection<Algorithm> searchAlgorithm(String criteria) throws BmapException;
	
	/**
	 * Find algorithm using criteria
	 * @return List<Algorithm>
	 */
	List<Algorithm> searchAlgorithmWithmAlgoCriteria(AlgorithmCriteria algoCriteria) throws BmapException;
	
	/**
	 * Return all algorithms in the data base
	 * @return Collection<Algorithm> 
	 * @throws BmapException
	 */
	Map<String, Map<String, List<Algorithm>>>  getAllAlgorithms() throws BmapException;
	
	/**
	 * Return all algorithms in the data base
	 * @return Collection<Algorithm> 
	 * @throws BmapException
	 */
	List<Algorithm> getAllAlgorithmsList() throws BmapException;
	
	/**
	 * Return the ten last published algorithms in the data base
	 * @return List<Algorithm> 
	 * @throws BmapException
	 */
	List<Algorithm> getLastTenAlgorithms() throws BmapException;
	
	/**
	 * Return list of topics and project inside it
	 * @return CMap<String, List<String>> 
	 * @throws BmapException
	 */
	AlgoTopicDto getListFilteredByTopicAndProject() throws BmapException;
}
