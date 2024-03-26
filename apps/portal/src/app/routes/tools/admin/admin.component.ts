import { Component, OnInit } from '@angular/core';
import { environment } from 'apps/portal/src/environments/environment';
import { HttpClient, HttpResponse, HttpErrorResponse } from '@angular/common/http';
import { FormControl, FormGroup } from '@angular/forms';
import { OAuthService } from 'angular-oauth2-oidc';
import { Observable } from 'rxjs';
import { AuthenticationService } from '../../../services/authentication/authentication.service';
import { AuthorizationService } from '../../../services/authorization/authorization.service';
// import {MatRadioModule} from '@angular/material/radio';

@Component({
  selector: 'maap-esa-portal-admin',
  templateUrl: './admin.component.html',
  styleUrls: ['./admin.component.scss'],
})
export class AdminComponent implements OnInit {
  adminToken : string = "";
  // opaRequestBody : any = "[{\"op\": \"add\",\"path\": \"DLR\",\"value\": [{\"action\":\"read\",\"resource\":\"bucket_name/shared/dlr/**\"}]}]";  
  opaRequestBody : any = [
    {
        "op": "add",
        "path": "DLR",
        "value": [                      
                    {   
                    "action":"read","resource":"bucket_name/shared/dlr/**" 
                } 
            ]
    }
    ];
  requestBodyJson : string = JSON.stringify(this.opaRequestBody, undefined, 4) 
  group : string = "";
  groupForListing : string = "";
  urlPath : string = "";
  serviceFilter : string = "";
  operation : string = "add";
  path : string = "";
  action: string = "";
  resource : string = "";
  operationType : string = "POST";
  sendAdminRequestBody : any;
  opaDataJson : string = "";
  opaDataResponseCode : number | undefined;
  isAdminTokenValide : boolean = false;

  isAuthenticated$: Observable<boolean>;
  isAdmin$:Observable<boolean>;

  formType = new FormGroup({
    type: new FormControl('rawBody'),
  });

  constructor(
    private httpClient: HttpClient, 
    private oauthService: OAuthService,
    private authenticationService: AuthenticationService,
    private authorizationService: AuthorizationService
  ) {
    this.isAuthenticated$ = this.authenticationService.isAuthenticated$;
    this.isAdmin$ = this.authorizationService.isAdmin$;
  }

  ngOnInit(): void {}

  EditPermission(){
    const adminUrl = environment.adminURL
    let url = ``


    if (this.formType.controls['type'].value === 'formBody'){
      if (this.operation === "add"){
        this.sendAdminRequestBody = [
          {
              "op": this.operation,
              "path": this.path,
              "value": [
                  {
                      "action": this.action,
                      "resource": this.resource
                  }
              ]
          }
      ];
      }
      else {
        this.sendAdminRequestBody = [
          {
              "op": this.operation,
              "path": this.path
          }
      ];
      }

      const response = this.httpClient.post(url,
        this.requestBodyJson
        , {
          headers: {
            'x-gravitee-api-key': this.adminToken,
          }
        }
        ).subscribe(data => {console.log("ok")} )
      
        return response
    }
    else{
      url = `${adminUrl}/${this.urlPath}`;
      if (this.operationType === 'POST'){
        console.log('url : ' + url )
        const response = this.httpClient.post(url,
          this.requestBodyJson
          , {
            headers: {
              'x-gravitee-api-key': this.adminToken,
            }
          }
          ).subscribe({next : data => {console.log("ok")}} )
          
          return response
      }
      else {
        const response = this.httpClient.patch(url,
          this.requestBodyJson
          , {
            headers: {
              'x-gravitee-api-key': this.adminToken,
            }
          }
          ).subscribe({next : data => {console.log("ok")}} )
          
          return response
      }
    }
  
  }

  listResources(serviceFilter : string | undefined){
    const adminUrl = environment.adminURL
    let url = "";
    if (serviceFilter===""){
      url = adminUrl + "?pretty=true"
    }
    else{
      url = adminUrl + "/"+ serviceFilter + "?pretty=true"
    }
    
    const response = this.httpClient.get(url
      , {
        headers: {
          'x-gravitee-api-key': this.adminToken,
        },
        observe: 'response',
      }
      ).subscribe({next : (data: HttpResponse<any>) => {
        if (data.status === 200 || data.status === 202){
          this.opaDataJson = JSON.stringify(data.body, undefined, 4) 
          this.opaDataResponseCode = data.status;
          this.isAdminTokenValide = true;
        }
      },
      error:  (error: HttpErrorResponse) => {
        if (error.status === 401 ) {
          this.opaDataJson = ""
          this.isAdminTokenValide = false;
        }
      },}
       );
      return response
  }

  validateAdminToken(){
    if (this.adminToken){
      this.listResources("");
    }
    else{
      this.isAdminTokenValide = false;
    }
  }

  filterOpaData(){
    this.listResources(this.serviceFilter);
  } 
}
