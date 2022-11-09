<!DOCTYPE html>

<#include init />

<html class="${root_css_class}" dir="<@liferay.language key="lang.dir" />" lang="${w3c_language_id}">

<head>
	<title>${the_title} - ${company_name}</title>

	<meta content="initial-scale=1.0, width=device-width" name="viewport" />

	<@liferay_util["include"] page=top_head_include />
</head>

<body class="${css_class}">

<@liferay_ui["quick-access"] contentId="#main-content" />

<@liferay_util["include"] page=body_top_include />

<@liferay.control_menu />

<div class="container-fluid" id="wrapper">
	<header id="banner" class="row" role="banner">
		<div id="heading" class="col-2">
			<div aria-level="1" class="site-title" role="heading">
				<a class="${logo_css_class}" href="${site_default_url}" title="<@liferay.language_format arguments="${site_name}" key="go-to-x" />">
					<img alt="${logo_description}" height="${site_logo_height}" src="${site_logo}" width="${site_logo_width}" />
				</a>
				
				<#if show_site_name>
					<span class="site-name" title="<@liferay.language_format arguments="${site_name}" key="go-to-x" />">
						${site_name}
					</span>
				</#if>
			</div>
		</div>



		<#if has_navigation && is_setup_complete>
			<#include "${full_templates_path}/navigation.ftl" />
		</#if>
		
		<#if !is_signed_in>
			<a  class="col-1" data-redirect="${is_login_redirect_required?string}" href="${sign_in_url}" id="sign-in" rel="nofollow">
				<!-- ${sign_in_text} -->
				<!-- <img id="signInImage" src="${themeDisplay.getPathThemeImages()}/outline-person_outline-24px.svg"/> -->
			</a>
		</#if>
	</header>

	<section id="content">
		<h2 class="hide-accessible" role="heading" aria-level="1">${the_title}</h2>

		<#if selectable>
			<@liferay_util["include"] page=content_include />
		<#else>
			${portletDisplay.recycle()}

			${portletDisplay.setTitle(the_title)}

			<@liferay_theme["wrap-portlet"] page="portlet.ftl">
				<@liferay_util["include"] page=content_include />
			</@>
		</#if>
	</section>

	<footer id="footer" role="contentinfo"> 	
		<div class="row" style "padding-top: 13px;">
			<div class="col-6" style="padding-top: 13px;">
		 		<img id="logoFooterNasa" src="${themeDisplay.getPathThemeImages()}/nasa.png" style="border: 0; float: left;" />
		 		<img id="logoFooterEsa" src="${themeDisplay.getPathThemeImages()}/esa_logo.png" style="border: 0; float: left;" />
			</div>
			<div class="col-6 footer-text" style="border: 0; float: right; padding-top: 13px;">
			
				MAAP is a collaboration between NASA and ESA. <br/>
				<a style="color: #28a745;" href="https://www.maap-project.org/">NASA MAAP</a> 	
			</div>
			
		</div>	

	</footer>
</div>

<@liferay_util["include"] page=body_bottom_include />

<@liferay_util["include"] page=bottom_include />

</body>

</html>