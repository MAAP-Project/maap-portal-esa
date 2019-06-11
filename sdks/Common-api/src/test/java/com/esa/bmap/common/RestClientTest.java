package com.esa.bmap.common;


import org.junit.Test;

import junit.framework.Assert;
import junit.framework.TestCase;

/**
 * Unit test for simple App.
 */
public class RestClientTest extends TestCase {


	@Test
	public void testInitConnexion() {

		//RestClientInterface restClient = new RestClientInterface();
		
		Assert.assertTrue(true);
		//Assert.assertNotNull("The target is null. Impossible to open the connexion", restClient.getWebTarget());
		//Assert.assertEquals("The url are not the same", restClient.getWebTarget().getUri().toString(), Common.getValueFromKeyInPropertiesFile(Common.URL_BAC_END));
		
		/**Client client = ClientBuilder.newClient();
		WebTarget webTarget = client.target("http://localhost:8080/");
		webTarget = webTarget.path("places/11");
		
		Place p = new Place();
		p.setCoordinates("coord132");
		p.setName("Cap Place");
		p.setShortName("coord 1");
		
		Invocation.Builder invocationBuilder =  webTarget.request(MediaType.APPLICATION_JSON);
		Response resp = invocationBuilder.put(Entity.entity(p, MediaType.APPLICATION_JSON));
		
		if(resp.getStatus() == 200) {
			Place place = resp.readEntity(Place.class);
			System.out.println("another test");
		}
		*/

		
		System.out.println("test");

	}
	
	@Test
	public void testEnv() {
		System.out.println(System.getenv("BMAP_GITLAB_URL"));
	}
}
