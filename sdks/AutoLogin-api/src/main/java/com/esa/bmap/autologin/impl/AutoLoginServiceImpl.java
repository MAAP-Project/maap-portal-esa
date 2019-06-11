package com.esa.bmap.autologin.impl;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.esa.bmap.model.BmaapUser;
import com.esa.bmap.usermanagement.api.BmapUserServiceInterface;
import com.liferay.portal.kernel.model.User;
import com.liferay.portal.kernel.security.auto.login.AutoLogin;
import com.liferay.portal.kernel.security.auto.login.AutoLoginException;
import com.liferay.portal.kernel.service.ServiceContext;
import com.liferay.portal.kernel.service.UserLocalServiceUtil;
import com.liferay.portal.kernel.util.LocaleUtil;
import com.liferay.portal.kernel.util.PortalUtil;

/**
 * Hook used to auto connect a user by getting header http
 * @author capgemini
 *
 */
@Component(immediate = true )
public class AutoLoginServiceImpl implements AutoLogin {

	private static Logger LOG = LoggerFactory.getLogger(AutoLoginServiceImpl.class);
	private BmapUserServiceInterface bmapUserInterface;
	
	/**
	 * Initialisation of the the OSGI module to get a user
	 * @param algoInterface
	 */
	@Reference
	public void setUserManagementClientLocalService(BmapUserServiceInterface bmapUserInterface) {
		this.bmapUserInterface = bmapUserInterface;
	}


	
	@Override
	public String[] login(HttpServletRequest request, HttpServletResponse response) throws AutoLoginException {

		String[] credentials = null;
		System.out.println(request);
		try{
			//We get the company id, required to fecth a user
			long companyId = PortalUtil.getCompanyId(request);
			//We get the header value with the key
			String email = request.getHeader("email");
			String lastname = request.getHeader("lastname");
			String firstname = request.getHeader("firstname");
			LOG.info("email " + email);

			//All data exists
			if(lastname != null & firstname != null & email != null) {
				//We get the user in the database
				User user = UserLocalServiceUtil.fetchUserByEmailAddress(companyId, email);

				if(user == null) {
					//The user is not in the data base.
					//We create him with the role data specialist
					
					long creatorUserId=0;
					boolean autoPassword=false;
					//String password1="Default";
					//String password2="Default";
					boolean autoScreenName=false;
					String screenName = firstname.charAt(0) + lastname;
					String emailAddress=email;
					long facebookId=0;
					String openId=null;
					Locale locale=LocaleUtil.getDefault();
					String firstName= firstname;
					String middleName=null;
					String lastName=lastname;
					int prefixId=0;
					int suffixId=0;
					boolean male=true;
					int birthdayMonth=11;
					int birthdayDay=11;
					int birthdayYear=2000;
					String jobTitle=null;
					long[] groupIds=null;
					long[] organizationIds=null;
					long[] roleIds=null;
					long[] userGroupIds=null;
					boolean sendEmail=false;
					ServiceContext serviceContext = new ServiceContext();
					user = UserLocalServiceUtil.addUser(creatorUserId,	companyId, autoPassword,"Default",	"Default",	autoScreenName,
							screenName,	emailAddress,facebookId,openId,	locale,	firstName,middleName,lastName,prefixId,	suffixId,
							male,birthdayMonth,	birthdayDay,birthdayYear,jobTitle,groupIds,	organizationIds,roleIds,
							userGroupIds,sendEmail,serviceContext
							);
					LOG.info("user created "+user.toString());
					BmaapUser userLiferayToSendToTheBackEnd = new BmaapUser(user.getUserId(), user.getFullName());
					//We send the user to the back end
					bmapUserInterface.addABmapUser(userLiferayToSendToTheBackEnd);
					
				}
				//The user is already created, we login the user
				credentials = new String[3];
				//We return values
				credentials[0] = String.valueOf(user.getUserId());
				credentials[1] = user.getPassword();
				credentials[2] = String.valueOf(user.isPasswordEncrypted());
			}else {
				//We redirect to the login page
				LOG.info("no header specified");
			}


		}catch(Exception e){

			LOG.error(e.getStackTrace().toString());
		}
		return credentials;
	}



	@Override
	public String[] handleException(HttpServletRequest request, HttpServletResponse response, Exception e)
			throws AutoLoginException {
		// TODO Auto-generated method stub
		return new String[0];
	}


}
