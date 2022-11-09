package com.esa.maap.algorithm.impl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.osgi.service.component.annotations.Activate;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Algorithm;
import com.esa.bmap.model.AlgorithmCriteria;
import com.esa.maap.algorithm.api.AlgoTopicDto;
import com.esa.maap.algorithm.api.AlgorithmServiceInterface;
import com.esa.maap.common.service.Common;
import com.esa.maap.restclient.api.RestClientInterface;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Algorithm service used to request the back end Data are used for the
 * algorithm catalogue
 * 
 * @author tkossoko
 *
 */
@Component(service = { AlgorithmServiceInterface.class }, immediate = true)
public class AlgorithmServiceImpl implements AlgorithmServiceInterface {

	public static final Logger LOG = LoggerFactory.getLogger(AlgorithmServiceImpl.class);

	private static String REST_URI;
	private static String ROOT_METHOD = "catalogue/algorithms";

	// The rest client to call web services
	private RestClientInterface restClient;

	@Activate
	public void activate() {

	}

	/**
	 * Instanciation of a restClient for use
	 * 
	 * @param restClient
	 */
	@Reference
	public void setDataClientLocalService(RestClientInterface restClient) {
		this.restClient = restClient;
	}

	/**
	 * Instanciation of a common service for use
	 * 
	 * @param restClient
	 * @throws BmapException
	 */
	@Reference
	public void setDataCommonLocalService(Common commonService) throws BmapException {
		// We set the correct URI
		REST_URI = commonService.getValueFromKeyInPropertiesFile("BMAP_BACKEND_URL") + ROOT_METHOD;

	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Algorithm addAlgorithm(Algorithm algorithm) throws BmapException {

		Algorithm algo = null;

		String body;
		try {

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
			body = mapper.writer().writeValueAsString(algorithm);
			// Call to backend service
			String requestBody;
			requestBody = restClient.post(REST_URI, body);
			// We deserialize the object
			algo = mapper.readValue(requestBody, Algorithm.class);

		} catch (Exception e) {

			throw new BmapException(
					"Error while creating the algorithm. Please check if your algorithm is in the public repository",
					e);
		}

		return algo;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public int deleteAlgorithm(int id) throws BmapException {

		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		int statusCode;
		try {
			// Call to backend service
			statusCode = restClient.delete(REST_URI, Long.parseLong(id + ""));
		} catch (IOException e) {
			throw new BmapException("Impossible to delete this algorithm.", e);
		}

		return statusCode;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Algorithm getAlgorithmById(int idAlgorithm) throws BmapException {

		Algorithm algo = null;
		String body = null;

		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		try {
			body = mapper.writer().writeValueAsString(idAlgorithm);
			// Call to backend service
			String requestBody;
			requestBody = restClient.get(REST_URI + "/" + body);

			// We deserialize the object
			algo = mapper.readValue(requestBody, Algorithm.class);
		} catch (IOException e) {
			throw new BmapException("Impossible to get this algorithm. Please contact the administrator", e);
		}

		return algo;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Collection<Algorithm> searchAlgorithm(String criteria) throws BmapException {
		Collection<Algorithm> listOfAlgo = null;

		ObjectMapper mapper = new ObjectMapper();
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		try {

			// Call to backend service
			String requestBody;
			requestBody = restClient.get(REST_URI + "/search?criteria=" + criteria);

			// We deserialize the object
			if (!requestBody.isEmpty()) {
				JavaType algorithmCollection = mapper.getTypeFactory().constructCollectionType(List.class,
						Algorithm.class);
				listOfAlgo = mapper.readerFor(algorithmCollection).readValue(requestBody);
			}
		} catch (IOException e) {
			throw new BmapException("Impossible to get this algorithm. Please contact the administrator", e);
		}

		return listOfAlgo;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Map<String, Map<String, List<Algorithm>>> getAllAlgorithms() throws BmapException {
		List<Algorithm> listOfAlgorithm = new ArrayList<>();
		Map<String, Map<String, List<Algorithm>>> listOfAlgoByTopic = new HashMap<>();

		try {
			String requestBody = restClient.get(REST_URI);

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

			if (!requestBody.isEmpty()) {
				JavaType algorithmCollection = mapper.getTypeFactory().constructCollectionType(List.class,
						Algorithm.class);
				listOfAlgorithm = mapper.readerFor(algorithmCollection).readValue(requestBody);
				// On we have all the algorithms in a list
				// We create a map by topic and by project

				// First we set the list of topic and project
				for (Algorithm algo : listOfAlgorithm) {
					String topic = algo.getTopic();
					if (topic != null && !topic.equals("null")) {
						listOfAlgoByTopic.put(topic, new HashMap<>());
					}

				}

				// For each topic we create a list of algorithms
				for (Entry<String, Map<String, List<Algorithm>>> topic : listOfAlgoByTopic.entrySet()) {
					String topicName = topic.getKey();
					Map<String, List<Algorithm>> projectMap = topic.getValue();

					// We iterate on the list of the algorithm
					for (Algorithm algo : listOfAlgorithm) {
						// if they have the same topic, we set the project
						if (topicName.equals(algo.getTopic())) {
							// We add a project
							projectMap.put(algo.getProject(), new ArrayList<>());
						}
					}

				}

				// Then we add the algorithm in each project
				for (Entry<String, Map<String, List<Algorithm>>> topic : listOfAlgoByTopic.entrySet()) {
					Map<String, List<Algorithm>> projectMap = topic.getValue();

					for (Entry<String, List<Algorithm>> project : projectMap.entrySet()) {
						List<Algorithm> algoList = project.getValue();

						// We iterate on the list of the algorithm
						for (Algorithm algo : listOfAlgorithm) {
							// if they have the same topic, we set the project
							if (project.getKey().equals(algo.getProject())) {
								// We add a project
								algoList.add(algo);
							}
						}
					}
				}
			}

		} catch (Exception e) {
			throw new BmapException("Error when retrieving the algorithm list {} ", e);
		}
		return listOfAlgoByTopic;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public Algorithm getAlgorithmByUrl(String url) throws BmapException {
		LOG.info("Get algorithm by url {} ", url);
		List<Algorithm> listOfAlgorithm = new ArrayList<>();
		Algorithm algoToReturn = null;

		try {
			String requestBody = restClient.get(REST_URI);

			LOG.info("The request body is {}", requestBody);
			
			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

			if (!requestBody.isEmpty()) {
				JavaType algorithmCollection = mapper.getTypeFactory().constructCollectionType(List.class,
						Algorithm.class);

				LOG.info(new File(Algorithm.class.getProtectionDomain().getCodeSource().getLocation().toURI())
						.getPath());

				listOfAlgorithm = mapper.readerFor(algorithmCollection).readValue(requestBody);
				LOG.info("We have all this algo {} ", listOfAlgorithm.size());
				// On we have all the algorithms in a list
				// We create a map by topic and by project

				// First we set the list of topic and project
				for (Algorithm algo : listOfAlgorithm) {
					LOG.info("In the list we have {} ", algo.getGitUrlSource());
					if (algo.getGitUrlSource().equals(url)) {
						algoToReturn = algo;
						LOG.info("We found the algo {} ", algoToReturn.getGitUrlSource());
						break;
					}
				}
			}

		} catch (Exception e) {
			LOG.info(e.getMessage());
			throw new BmapException("Error when retrieving the algorithm", e);
		}
		LOG.info("The algo to return is  {} ", algoToReturn);
		return algoToReturn;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<Algorithm> getAllAlgorithmsList() throws BmapException {
		List<Algorithm> listOfAlgorithm = new ArrayList<>();

		try {
			String requestBody = restClient.get(REST_URI);

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
			if (!requestBody.isEmpty()) {
				JavaType algorithmCollection = mapper.getTypeFactory().constructCollectionType(List.class,
						Algorithm.class);
				// We convert the string to list of algorithms
				listOfAlgorithm = mapper.readerFor(algorithmCollection).readValue(requestBody);

			}
		} catch (Exception e) {
			throw new BmapException("Error when retrieving the algorithm list", e);
		}
		return listOfAlgorithm;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public AlgoTopicDto getListFilteredByTopicAndProject() throws BmapException {
		List<Algorithm> listOfAlgorithm = new ArrayList<>();
		Map<String, List<String>> listOfAlgoByTopic = new HashMap<>();
		AlgoTopicDto algoTopicDto = null;
		try {
			String requestBody = restClient.get(REST_URI);

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

			if (!requestBody.isEmpty()) {
				JavaType algorithmCollection = mapper.getTypeFactory().constructCollectionType(List.class,
						Algorithm.class);
				listOfAlgorithm = mapper.readerFor(algorithmCollection).readValue(requestBody);
				// On we have all the algorithms in a list
				// We create a map by topic and by project

				// First we set the list of topic and project
				for (Algorithm algo : listOfAlgorithm) {
					String topic = algo.getTopic();
					if (topic != null && !topic.equals("null")) {
						listOfAlgoByTopic.put(topic, new ArrayList<>());
					}

				}

				// For each topic we create a list of
				for (Entry<String, List<String>> topic : listOfAlgoByTopic.entrySet()) {
					String topicName = topic.getKey();
					List<String> projectList = topic.getValue();

					// We iterate on the list of the algorithm
					for (Algorithm algo : listOfAlgorithm) {
						// if they have the same topic, we set the project
						// We check if it is not in the list already
						if (topicName.equals(algo.getTopic()) && !projectList.contains(algo.getProject())) {
							// We add a project
							projectList.add(algo.getProject());
						}
					}
				}
				
				//We prapare the list of algo and the topics ad projects
				algoTopicDto = new AlgoTopicDto(listOfAlgoByTopic, listOfAlgorithm);
			}

		} catch (Exception e) {
			throw new BmapException("Error when retrieving the algorithm list", e);
		}
		return algoTopicDto;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<Algorithm> getLastTenAlgorithms() throws BmapException {
		List<Algorithm> listOfAlgorithm = new ArrayList<>();

		try {
			String requestBody = restClient.get(REST_URI);

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

			if (!requestBody.isEmpty()) {
				JavaType algorithmCollection = mapper.getTypeFactory().constructCollectionType(List.class,
						Algorithm.class);
				listOfAlgorithm = mapper.readerFor(algorithmCollection).readValue(requestBody);
			}

		} catch (Exception e) {
			throw new BmapException("Error when retrieving the algorithm list", e);
		}
		return listOfAlgorithm;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	public List<Algorithm> searchAlgorithmWithmAlgoCriteria(AlgorithmCriteria algoCriteria) throws BmapException {

		List<Algorithm> listOfAlgorithm = new ArrayList<>();
		String body;
		try {

			ObjectMapper mapper = new ObjectMapper();
			mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
			body = mapper.writer().writeValueAsString(algoCriteria);
			// Call to backend service
			String requestBody;
			requestBody = restClient.post(REST_URI + "/search/criteria", body);
			// We deserialize the object
			if (!requestBody.isEmpty()) {
				JavaType algorithmCollection = mapper.getTypeFactory().constructCollectionType(List.class,
						Algorithm.class);
				listOfAlgorithm = mapper.readerFor(algorithmCollection).readValue(requestBody);
			}

		} catch (IOException e) {
			throw new BmapException("Impossible to create an algorithm. Please contact the administrator", e);
		}

		return listOfAlgorithm;
	}
}
