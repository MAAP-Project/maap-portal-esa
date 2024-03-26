const baseHref = '/portal-val/ESA';

export const environment = {
  production: true,
  baseHref,
  configUrl: baseHref + '/config/config.json',
  latestNewsFileUrl: baseHref + '/assets/news/latest_news.json',
  newsListFileUrl: baseHref + '/assets/news/news.json',
  newsPrefixUrl: baseHref + '/assets/news/',
  faqListFileUrl: baseHref + '/assets/faq/faq.json',
  faqPrefixUrl: baseHref + '/assets/faq/',
  documentationUrl: baseHref + '/docs/index.html',
  authorizationURL : 'https://changeme',
  adminURL : 'https://changeme',
  adminGroup : 'changeme',
  processUrl: 'https://changeme',
  deployUrl: 'https://changeme',
  argoUrl: 'https://changeme',
  s3Url: 'https://changeme',
  exploreUrl: 'https://changeme',
  orchestratorUrl: 'https://changeme',
  developmentUrl: 'https://changeme/',
  gitlabUrl: 'https://changeme',
  nasaUrl: 'https://changeme/',
  bugReportUrl:
    'https://changeme',
  identityProviderConfig: {
    // Url of the Identity Provider
    issuer: 'https://changeme',

    // URL of the SPA to redirect the user to after login
    redirectUri: window.location.origin + baseHref + '/home',

    clientId: 'changeme',

    responseType: 'code',

    // set the scope for the permissions the client should request
    // Important: Request offline_access to get a refresh token
    scope: 'openid profile email offline_access roles',

    showDebugInformation: true,

    useIdTokenHintForSilentRefresh: false,
  },
  support_email: 'changeme',
};
