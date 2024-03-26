import { Injectable, OnInit } from '@angular/core';
import { environment } from 'apps/portal/src/environments/environment';
import { Observable , BehaviorSubject, observable } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { OAuthService } from 'angular-oauth2-oidc';
import { JwtHelperService } from '@auth0/angular-jwt';


@Injectable({
  providedIn: 'root',
})
export class AuthorizationService implements OnInit {
  private _canActivate$ = new BehaviorSubject<boolean>(false);
  private _isAdmin$ = new BehaviorSubject<boolean>(false);

  get canActivate$() {
    return this._canActivate$.asObservable();
  }

  get isAdmin$() {
    return this._isAdmin$.asObservable();
  }

  constructor(
              private jwtHelper: JwtHelperService,
              private httpClient: HttpClient, 
              private oauthService: OAuthService,
              ) {
   }
  ngOnInit(): void {
    this.getAllowToolsPermission()
  }

  getCurrentUserGroup(){
    const decoded_token = this.jwtHelper.decodeToken(this.oauthService.getAccessToken())
    return decoded_token.realm_access.roles
  }

  getAllowToolsPermission(): Observable<any> {
    const url = environment.authorizationURL
    const response = this.httpClient.post(url,
      {
        "input": {
          "groups": this.getCurrentUserGroup()
      }
      }
      , {
        headers: {
          'Authorization': 'bearer ' + this.oauthService.getAccessToken(),
        }
      })
    return response
  }

  get canActivate(): Observable<boolean> {
    this.getAllowToolsPermission().subscribe(res =>{
      this._canActivate$.next(res.result)
    })
    return this._canActivate$;
  }

  get isAdmin(): Observable<boolean>{
    var userGroups = this.getCurrentUserGroup()
    if(userGroups.indexOf(environment.adminGroup) !== -1) {
      this._isAdmin$.next(true);
    }
    return this._isAdmin$;
  }

}


