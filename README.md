**Portal**
==========

The MAAP Portal  is a static website hosted on S3 based on Angular 

Prerequisite
------------
Insall [nodejs 8.15.0](https://nodejs.org/en/about/previous-releases)  

Install aws cli https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
``` bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```
setup the env variables below :

``` bash
# Environment type for the build and the deployment ex : DEV, INT, VAL, PROD  
export MAAP_ENV_TYPE=<type of environment>

# AWS ACCESS KEY to deploy on an s3 bucket
export AWS_ACCESS_KEY_ID=<aws access key>

# AWS SECRET KEY to deploy on an s3 bucket
export AWS_SECRET_ACCESS_KEY=<aws secret access key>


#S3 ENDPOINT where the portal will be stored on s3
export S3_ENDPOINT=<s3 endpoint>

#Public bucket where the static site is hosted
export PUBLIC_BUCKET=<s3 public bucket>
```

Edit one of the provided configuration files  [here](apps/portal/src/environments)  depending on the platform you want to build and change the configuration having "changeme".
```
// Url of the service compliant OGC API Processing for the execution of a deployed service
  processUrl: 'https://changeme/wpst/processes',

// Url of the service compliant WPS-T for the deployment and undeployment
  deployUrl: 'https://changeme/wpst/processes',

// Url of the Vizualisation services and the DAS catalogues. 
  exploreUrl: 'https://changeme',

// Url of the container orchestrations service. 
  orchestratorUrl: 'https://changeme',

// Url of ADE service. 
  developmentUrl: 'https://changeme/',

// Url of the joint gitlab service
  gitlabUrl: 'https://changeme',

// Url of the NASA MAAP Home 
  nasaUrl: 'https://changeme/',

// Url to report a bug
  bugReportUrl: 'https://changeme',
  identityProviderConfig: {
    // Url of the Identity Provider
    issuer: 'https://changeme',

//clientId for the authenticatino to the issuer above  
    clientId: 'changeme',

    responseType: 'code',

    // set the scope for the permissions the client should request
    // Important: Request offline_access to get a refresh token
    scope: 'openid profile email offline_access roles',

    showDebugInformation: true,

    useIdTokenHintForSilentRefresh: false,
  },
  identityProviderConfigNASA: {
    // Url of the Identity Provider /.well-known/openid-configuration
    issuer: 'https://changeme',


    clientId: 'changeme',

    responseType: 'code',

    // set the scope for the permissions the client should request
    // Important: Request offline_access to get a refresh token
    scope: 'openid profile email offline_access roles',

    showDebugInformation: true,

    useIdTokenHintForSilentRefresh: false,
  },
  support_email: 'changeme'
};
```



Setup
------------

#### Build the portal with NX
See [README_NX.md](README_NX.md) for more details on nx.
``` bash
npm install

#For DEV
npx nx build portal --base-href=/portal-dev/ESA/ -c $development --skip-nx-cache


#For all
npx nx build portal --base-href=/portal-${MAAP_ENV_TYPE,,}/ESA/ -c $MAAP_ENV_TYPE --skip-nx-cache
```

#### Deploy the portal on s3


``` bash
aws s3 sync ./dist/apps/portal/ s3://$PUBLIC_BUCKET/portal-${MAAP_ENV_TYPE,,}/ESA/ --delete --endpoint $S3_ENDPOINT

```



Browser Support
---------------
- Chrome (latest)

License
-------
That is licensed under [Apache 2.0](https://opensource.org/licenses/Apache-2.0).

