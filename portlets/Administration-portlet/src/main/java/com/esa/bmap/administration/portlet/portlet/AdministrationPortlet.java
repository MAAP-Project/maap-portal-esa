package com.esa.bmap.administration.portlet.portlet;

import java.io.File;
import java.lang.reflect.Method;
import java.net.URISyntaxException;
import java.util.List;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.Portlet;
import javax.portlet.PortletConfig;
import javax.portlet.PortletException;
import javax.portlet.ProcessAction;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;

import com.esa.bmap.administration.portlet.constants.AdministrationPortletKeys;
import com.esa.bmap.algorithm.api.AlgorithmServiceInterface;
import com.esa.bmap.common.exceptions.BmapException;
import com.esa.bmap.model.Algorithm;
import com.esa.bmap.model.BmaapUser;
import com.esa.bmap.model.Executable;
import com.esa.bmap.usermanagement.api.BmapUserServiceInterface;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;
import com.liferay.portal.kernel.servlet.SessionErrors;
import com.liferay.portal.kernel.servlet.SessionMessages;

/**
 * @author liferay
 */
@Component(
		immediate = true,
		property = {
				"com.liferay.portlet.display-category=Administration",
				"com.liferay.portlet.instanceable=true",
				"javax.portlet.display-name=Administration-portlet Portlet",
				"javax.portlet.init-param.template-path=/",
				"javax.portlet.init-param.view-template=/view.jsp",
				"javax.portlet.name=" + AdministrationPortletKeys.Administration,
				"javax.portlet.resource-bundle=content.Language",
				"javax.portlet.security-role-ref=power-user,user"
		},
		service = Portlet.class
		)
public class AdministrationPortlet extends MVCPortlet {

	private static Logger LOG;

	//Services imported to be used
	private AlgorithmServiceInterface algocatalogueInterface;
	private BmapUserServiceInterface bmapUserInterface;

	@Override
	public void init(PortletConfig config) throws PortletException {
		LOG = LoggerFactory.getLogger(this.getClass().getName());
		String message = "Initialisation of the admin catalogue portlet";
		LOG.info(message);

		super.init(config);
	}

	/**
	 * The first time we render the page, we get the list of the users in the liferay
	 * @param request
	 * @param response
	 * @throws PortletException
	 * @throws java.io.IOException
	 */
	@Override
	public void render(RenderRequest request, RenderResponse response) throws PortletException, java.io.IOException {
		//When send the user list to the ihm 
		this.userList(request);
		super.render(request, response);
	}

	/**
	 * Initialisation of the the OSGI module to delete or add an algorithm
	 * @param algoInterface
	 */
	@Reference
	public void setAlgoCatalogueClientLocalService(AlgorithmServiceInterface algoInterface) {
		this.algocatalogueInterface = algoInterface;
	}

	/**
	 * Initialisation of the the OSGI module to get a user
	 * @param algoInterface
	 */
	@Reference
	public void setUserManagementClientLocalService(BmapUserServiceInterface bmapUserInterface) {
		this.bmapUserInterface = bmapUserInterface;
	}

	/**
	 * Action launched when the algo is deleted
	 * @param request
	 * @param response
	 * @throws PortletException
	 */
	@ProcessAction(name = "deleteAlgoAction")
	public void deleteAlgoAction(ActionRequest request, ActionResponse response)
			throws PortletException {
		//First we get the algorithm withit's u
		Algorithm algo;
		try {
			algo = algocatalogueInterface.getAlgorithmByUrl(request.getParameter("algoSourceUrl"));
			//If the algo exists we can start the deletion
			if(algo != null) {
				int status = algocatalogueInterface.deleteAlgorithm(algo.getId());

				if(status == HttpStatus.OK.value()) {
					request.setAttribute("sucessMessage", "Algorithm deleted successfuly");
					SessionMessages.add(request, "success");
				}else if(status == HttpStatus.NOT_FOUND.value()) {
					request.setAttribute("errorMessage", "Algorithm not found");
					SessionErrors.add(request, "error");
				}else {
					//Internal server error
					request.setAttribute("errorMessage", "Algorithm not found");
					SessionErrors.add(request, "error");
				}
			}else {
				request.setAttribute("errorMessage", "Algorithm not found");
				SessionErrors.add(request, "error");
			}
		} catch (BmapException e) {
			//We have another error the process
			request.setAttribute("errorMessage", e.getMessage());
			SessionErrors.add(request, "error");
		}
	}

	@ProcessAction(name = "addAlgoAction")
	public void addAlgoAction(ActionRequest request, ActionResponse response)
			throws PortletException {

		//First, we verify if the algorithm is already in the database
		Algorithm algo;
		try {
			algo = algocatalogueInterface.getAlgorithmByUrl(request.getParameter("algoSourceUrl2"));
			if(algo != null) {

				//Error
				request.setAttribute("errorMessage", "The Algorithm "+ algo.getName() +" is already in the algorithm store");
				SessionErrors.add(request, "error");
			}else {

				//We get all of the information
				String algoSourceUrl = request.getParameter("algoSourceUrl2");
				String dockerImageUrl = request.getParameter("dockerImageUrl");
				int author = Integer.parseInt(request.getParameter("author"));
				String applicationZone = request.getParameter("applicationZone");
				String averageTime = request.getParameter("averageTime");
				String currentVer = request.getParameter("currentVer");

				BmaapUser user;
				user = this.bmapUserInterface.getBmapUserById(author);
				if(user == null) {
					//Internal server error
					request.setAttribute("errorMessage", "The author is unkonwn in the platforme. Please contact the administrator");
					SessionErrors.add(request, "error");
				}else {
					//We set the information about the algorithm
					algo = new Algorithm();
					algo.setApplicationZone(applicationZone);
					algo.setAverageTime(averageTime);
					algo.setCurrentVersion(currentVer);
					System.out.println(algo.getClass().getClassLoader());
					try {
						System.out.println(new File(Algorithm.class.getProtectionDomain().getCodeSource().getLocation().toURI()).getPath());
					} catch (URISyntaxException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					for(Method m : algo.getClass().getMethods()) {
						System.out.println(m);
					}

					
					algo.setGitUrl(algoSourceUrl);
					Executable exe = new Executable(null, dockerImageUrl);
					algo.setExecutable(exe);
					algo.setAuthor(user);

					algo = this.algocatalogueInterface.addAlgorithm(algo);

					if(algo.getId() != null) {
						request.setAttribute("sucessMessage", "Algorithm "+algo.getName() +" added successfuly to the algorithm store");
						request.setAttribute("algoSourceUrl2Id", "test");
						SessionMessages.add(request, "success");
					}
				}
			}
		} catch (BmapException e) {
			request.setAttribute("errorMessage", e.getMessage());
			SessionErrors.add(request, "error");
		}

	}

	/**
	 * We get the list of the users
	 * @param request
	 */
	private void userList(RenderRequest request) {
		// Todo Logic for user code
		int countUser = UserLocalServiceUtil.getUsersCount();
		LOG.info("User Present In DB" + countUser);
		List < User > users = UserLocalServiceUtil.getUsers(0, countUser);
		request.setAttribute("users", users);
	}


}