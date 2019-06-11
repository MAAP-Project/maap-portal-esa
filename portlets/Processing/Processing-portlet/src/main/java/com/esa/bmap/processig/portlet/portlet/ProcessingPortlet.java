package com.esa.bmap.processig.portlet.portlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.portlet.Portlet;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;
import javax.portlet.ResourceRequest;
import javax.portlet.ResourceResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.esa.bmap.algorithm.api.AlgorithmServiceInterface;
import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.common.service.Common;
import com.esa.bmap.model.Algorithm;
import com.esa.bmap.model.AlgorithmCriteria;
import com.esa.bmap.processig.portlet.constants.ProcessingPortletKeys;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.liferay.portal.kernel.model.Role;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.servlet.SessionMessages;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.WebKeys;


/**
 * @author liferay
 */
@Component(
		immediate = true,
		property = {
				"com.liferay.portlet.display-category=Processing",
				"com.liferay.portlet.instanceable=true",
				"javax.portlet.display-name=Processing-portlet",
				"javax.portlet.init-param.template-path=/",
				"javax.portlet.init-param.view-template=/view.jsp",
				"javax.portlet.name=" + ProcessingPortletKeys.Processing,
				"javax.portlet.resource-bundle=content.Language",
				"javax.portlet.security-role-ref=power-user,user"
		},
		service = Portlet.class
		)
public class ProcessingPortlet extends MVCPortlet {

	private static Logger LOG;
	private static final String AlgoDeveloper = "Algorithm Developer";
	private static final String Administrator = "Administrator";

	private String BMAP_ECLIPSECHE_URL;
	private String BMAP_GITLAB_URL;
	private String BMAP_JUPYTER_URL;
	private String BMAP_COPA_URL;


	private AlgorithmServiceInterface algoService;

	@Override
	public void init (PortletConfig config) throws PortletException {
		LOG = LoggerFactory.getLogger(this.getClass().getName());
		LOG.info("Portlet init ");
		super.init(config);
	}

	/**
	 * We tell to OSGI to instantiate a algorithm service for use
	 * @param restClient
	 */
	@Reference
	public void setAlgorithmClientLocalService(AlgorithmServiceInterface algoService) {
		this.algoService = algoService;
	}

	@Reference
	public void setPlaceCommonLocalService(Common commonService) {

		BMAP_ECLIPSECHE_URL = commonService.getValueFromKeyInPropertiesFile("BMAP_ECLIPSECHE_URL");
		BMAP_GITLAB_URL = commonService.getValueFromKeyInPropertiesFile("BMAP_GITLAB_URL");
		BMAP_JUPYTER_URL = commonService.getValueFromKeyInPropertiesFile("BMAP_JUPYTER_URL");
		BMAP_COPA_URL = commonService.getValueFromKeyInPropertiesFile("BMAP_COPA_URL");
	}

	/**
	 * During the render we get the path of variables
	 */
	@Override
	public void render (RenderRequest request, RenderResponse response)
			throws PortletException, java.io.IOException {

		//We get all the algorithms in the database, for the view
		try {
			//List<Algorithm> listOfAlgo = this.algoService.getAllAlgorithmsList();
			Map<String, List<String>> lisTopicProject =  this.algoService.getListFilteredByTopicAndProject();
			//We send the list to the view
			request.setAttribute("lisTopicProject", lisTopicProject);

			//We get also the last ten algorithms
			List<Algorithm> listAlgo = this.algoService.getLastTenAlgorithms();
			request.setAttribute("listAlgo",listAlgo);

		} catch (BmapException e) {
			request.setAttribute("errorMessage", "Impossible to get all of algorithms. Please contact the administrator");
			SessionMessages.add(request, "error");
		}

		ThemeDisplay themeDisplay = (ThemeDisplay)request.getAttribute(WebKeys.THEME_DISPLAY);
		User user = themeDisplay.getUser();
		long userId = themeDisplay.getRealUserId(); // themeDisplay.getUserId();
		String fname = themeDisplay.getUser().getFirstName();
		String lname = themeDisplay.getUser().getLastName();
		String email = themeDisplay.getUser().getEmailAddress();
		String password = themeDisplay.getUser().getPassword();

		//We get the role of the user
		List<Role> userRoles = user.getRoles();
		for(Role userRole : userRoles) {
			System.out.println(userRole.getName());
			if(userRole.getName().equals(AlgoDeveloper) || userRole.getName().equals(Administrator)) {
				request.setAttribute("ROLE", userRole.getName());
				LOG.info("user role is "+ userRole.getName());
				break;
			}
		}

		LOG.info("user id is "+ userId);


		//We set the correct url
		request.setAttribute("BMAP_ECLIPSECHE_URL", BMAP_ECLIPSECHE_URL);
		request.setAttribute("BMAP_GITLAB_URL", BMAP_GITLAB_URL);
		request.setAttribute("BMAP_JUPYTER_URL", BMAP_JUPYTER_URL);
		request.setAttribute("BMAP_COPA_URL", BMAP_COPA_URL);
		request.setAttribute("user_id", userId);
		request.setAttribute("fname", fname);
		request.setAttribute("lname", lname);
		request.setAttribute("email", email);
		request.setAttribute("password", password);

		super.render(request, response);
	}

	/**
	 * Method catching ajax request. If new search, pass the Data Criteria to OSGI
	 * Data-api module to get resultlist If addItem request, add a new Data to the
	 * layer list
	 */
	@Override
	public void serveResource(ResourceRequest resourceRequest, ResourceResponse resourceResponse) {
		LOG.info("ServeResource for id : " + resourceRequest.getResourceID());

		//We get the resource called
		if (resourceRequest.getResourceID().equals("researchAlgo") || resourceRequest.getResourceID().equals("tags")) {

			try {
				LOG.info(resourceRequest.getResourceID());

				//We get the data 
				String listCriteria = resourceRequest.getParameter("listCriteria");
				String tags = resourceRequest.getParameter("tags");

				if(listCriteria != null) {
					//We convert tje json string to arrayList
					ObjectMapper mapper = new ObjectMapper();
					mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
					JavaType criteriaCollection = mapper.getTypeFactory().constructCollectionType(List.class,
							String.class);
					List<String> listOfCriteria = mapper.readerFor(criteriaCollection).readValue(listCriteria);

					//We have a list of string, we create the algorithm criteria
					Map<String, List<String>> listTopicProject = new HashMap<String, List<String>>();
					for(String criteria : listOfCriteria) {
						if(criteria.contains("/")) {
							//We have topic and project selected
							String [] arrayOfTopicAndProject = criteria.split("/");
							String topic = arrayOfTopicAndProject[0];
							String project = arrayOfTopicAndProject[1];
							//If we don't have this topic as key
							if(!listTopicProject.containsKey(topic)) {
								//We add the topic in the list
								List<String> listOfProject =  new ArrayList<String>();
								listOfProject.add(project);
								listTopicProject.put(topic, listOfProject);
							}else {
								//We already have the key in the map
								List<String> listOfProject = listTopicProject.get(topic);
								listOfProject.add(project);
							}
						}else {
							//We add the topic in the list
							List<String> listOfProject =  new ArrayList<String>();
							listTopicProject.put(criteria, listOfProject);
						}
					}
					LOG.info(listTopicProject.toString());

					AlgorithmCriteria algoCriteria = new AlgorithmCriteria(listTopicProject, tags);
					//We send the algocriteria to the osgi for the back end
					List<Algorithm> algoList = algoService.searchAlgorithmWithmAlgoCriteria(algoCriteria);

					//We return the result thanks to printwriter
					PrintWriter printout = resourceResponse.getWriter();

					String jsonString = mapper.writeValueAsString(algoList);
					printout.print(jsonString);
					LOG.info(jsonString);
				}

			} catch (IOException e) {
				resourceRequest.setAttribute("errorMessage", "Impossible to get algorithms. Please contact the administrator");
				SessionMessages.add(resourceRequest, "error");
				LOG.error(e.getMessage());
			} catch (BmapException e) {
				resourceRequest.setAttribute("errorMessage", "Impossible to get algorithms. Please contact the administrator");
				SessionMessages.add(resourceRequest, "error");
				LOG.error(e.getMessage());
			}

		}
	}


}