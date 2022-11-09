package com.esa.maap.usermanagement.api;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.BmaapUser;

public interface BmapUserServiceInterface {

	/**
	 * add a new User after a registration
	 * Service called by a hook
	 * @param BmapUser
	 * @return Aalgorithm
	 * @throws BmapException 
	 */
	BmaapUser addABmapUser(BmaapUser user) throws BmapException;
	


	/**
	 * delete a user by id
	 * @param idUser
	 * @int int status code 200 its a success, 404, the algo is note found and 500 we have an internal server error
	 */
	int deleteBmapUser(int id) throws BmapException;


	/**
	 * Get the user by it's id
	 * @param idUser
	 * @return Algorithm
	 * @throws BmapException
	 */
	BmaapUser getBmapUserById(int id) throws BmapException;
}
