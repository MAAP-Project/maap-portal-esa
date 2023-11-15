import { Injectable } from '@angular/core';
import { OAuthService } from 'angular-oauth2-oidc';
import { BehaviorSubject, ReplaySubject } from 'rxjs';
import { environment } from '../../../environments/environment';


interface UserProfil {
  info: {
    email: string;
    family_name: string;
    given_name: string;
    name: string;
  };
}

@Injectable({
  providedIn: 'root',
})
export class AuthenticationService {
  // private _authConfig = null;

  private _isAuthenticated$ = new BehaviorSubject<boolean>(false);
  private _userProfil$ = new ReplaySubject<UserProfil>(1);

  get isAuthenticated$() {
    return this._isAuthenticated$.asObservable();
  }

  get isAuthenticated() {
    return this.oauthService.hasValidAccessToken();
  }

  get userProfil$() {
    return this._userProfil$.asObservable();
  }

  get accessToken() {
    return this.oauthService.getAccessToken();
  }

  delay(ms: number) {
    return new Promise( resolve => setTimeout(resolve, ms) );
  } 
  constructor(private oauthService: OAuthService) {
    this.oauthService.events.subscribe((event) => {
      console.log("Event received "+ event.type);
      if (!this.oauthService.discoveryDocumentLoaded) {
        return;
      }
      if (
        
        event.type == 'token_received' ||
        event.type == 'silently_refreshed' ||
        event.type == 'token_refreshed'
      ) {
        this._isAuthenticated$.next(true);
      } else if (
        event.type == 'code_error' ||
        event.type == 'logout' ||
        event.type == 'silent_refresh_error' ||
        event.type == 'token_refresh_error' ||
        event.type == 'token_error'
      ) {
        this._isAuthenticated$.next(false);
      }
    });
  }

  async init(provider : string) {
    try {
      console.warn("Before ALL");

      console.warn(this.oauthService );
      if(provider=='ESA'){
        console.log("Setup config ESA");
        this.oauthService.configure(environment.identityProviderConfig);
        await this.oauthService.loadDiscoveryDocumentAndTryLogin();
      } else if (provider=='NASA') {
        console.log("Setup config NASA");
        this.oauthService.configure(environment.identityProviderConfigNASA);
        await this.oauthService.loadDiscoveryDocumentAndTryLogin();
      } else {
        console.log("AuthenticationService : No session")
      }

      if (
        this.oauthService.hasValidIdToken() ||
        this.oauthService.hasValidAccessToken()
      ) {
        this._isAuthenticated$.next(true);
        const userProfil = await this.oauthService.loadUserProfile();
        this._userProfil$.next(userProfil as UserProfil);
      } else {
        this._isAuthenticated$.next(false);
      }
      this.oauthService.setupAutomaticSilentRefresh();
    } catch {
      console.error("TOOLS disble because authentication failed ESA or NASA");
      console.error(this.oauthService);
      this._isAuthenticated$.next(false);
    }
  }

  login_esa() {
    //setup esa configuration
    this.init('ESA');
    sessionStorage.setItem("provider","ESA");
    this.oauthService.initCodeFlow();
  }

  login_nasa() {
    //setup nasa configuration
    this.init('NASA');
    sessionStorage.setItem("provider","NASA");
    this.oauthService.initCodeFlow();
  }

  logout() {
    this.oauthService.logOut();
  }
}
