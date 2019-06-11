package Test.portlet;

import javax.portlet.Portlet;

import org.osgi.service.component.annotations.Component;

import com.liferay.portal.kernel.portlet.bridges.mvc.MVCPortlet;

import Test.constants.TestPortletKeys;

/**
 * @author liferay
 */
@Component(immediate = true, property = { "com.liferay.portlet.display-category=category.sample",
		"com.liferay.portlet.instanceable=true", "javax.portlet.display-name=Test Portlet",
		"javax.portlet.init-param.template-path=/", "javax.portlet.init-param.view-template=/view.jsp",
		"javax.portlet.name=" + TestPortletKeys.Test, "javax.portlet.resource-bundle=content.Language",
		"javax.portlet.security-role-ref=power-user,user" }, service = Portlet.class)
public class TestPortlet extends MVCPortlet {
//	private static final String LOG_HEADER = "[MY-FIRST-PORTLET]";
//	private static Logger LOG;
//
//	@Override
//	public void init(PortletConfig config) throws PortletException {
//		LOG = LoggerFactory.getLogger(this.getClass().getName());
//		String message = "Cette méthode est exécutée à l'initialisation du Portlet dans Liferay";
//		System.out.println(String.format("%s init() -> %s", LOG_HEADER, message));
//		super.init(config);
//
//		
//	}
//
//	@Override
//	public void render(RenderRequest request, RenderResponse response) throws PortletException, java.io.IOException {
//		String message = "Cette méthode est exécutée à l'affichage de la page";
//		System.out.println(String.format("%s render() -> %s", LOG_HEADER, message));
//
//		request.setAttribute("name", "Teddy K");
//		request.setAttribute("age", 23);
//		request.setAttribute("favoriteLanguages", new ArrayList<String>() {
//			{
//				add("Java");
//				add("SQL");
//				add("C");
//			}
//		});
//
//		super.render(request, response);
//	}
//
//	@Override
//	public void processAction(ActionRequest request, ActionResponse response)
//			throws PortletException, java.io.IOException {
//		String message = "Cette méthode est exécutée lors de la réception d'un formulaire";
//		System.out.println(String.format("%s processAction() -> %s", LOG_HEADER, message));
//		System.out.println(String.format("%s Texte du formulaire -> %s", LOG_HEADER, request.getParameter("field1")));
//
//		// Quand on reçoit la réponse, on la renvoie à la vue
//		request.setAttribute("field1", request.getParameter("field1"));
//		super.processAction(request, response);
//	}
//
//	@ProcessAction(name = "formSentWithAlloy")
//	public void formSentWithAlloy(ActionRequest request, ActionResponse response)
//			throws PortletException, java.io.IOException {
//		String message = "Formulaire Alloy";
//		System.out.println(String.format("%s formSentWithAlloy() -> %s", LOG_HEADER, message));
//		System.out.println(
//				String.format("%s Texte du formulaire Alloy -> %s", LOG_HEADER, request.getParameter("field2")));
//		// Ne pas utiliser super.processAction(request, response) lorsque la méthode est
//		// annotée avec `@ProcessAction`
//	}
//
//	@ProcessAction(name = "generate_portlets")
//	public void searchDataLocation(ActionRequest request, ActionResponse response) {
//		LOG.info("generate_portlets process action");
//		
//		int portletsCount = PortletLocalServiceUtil.getPortletsCount();
//		int count = Integer.parseInt((String) request.getParameter("count"));
//
//		Map<String, String> portletIdParams = new HashMap();
//
//		if (count == -1) {
//			portletIdParams.put("org_bmap_sample_rendering_portlet", "{mapid=4,user=test}");
//
//		} else {
//			for (int i = 0; i < count; i++) {
//				com.liferay.portal.kernel.model.Portlet portlet = PortletLocalServiceUtil.getPortlets()
//						.get(new Random().nextInt(portletsCount));
//				portletIdParams.put(portlet.getPortletId(), i + "/param");
//			}
//		}
//
//		request.setAttribute("portlets", portletIdParams);
//	}

}