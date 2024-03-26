import { Injectable, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders, HttpResponse } from '@angular/common/http';
import { OAuthService } from 'angular-oauth2-oidc';
import { BehaviorSubject, ReplaySubject } from 'rxjs';
import { environment } from '../../../environments/environment';
import { AuthorizationService } from '../authorization/authorization.service';

export interface UserProfil {
  info: {
    email: string;
    family_name: string;
    given_name: string;
    name: string;
  };
}

interface JWT {
  accessToken: string;
  refreshToken: string;
  authDate: number;
}

@Injectable({
  providedIn: 'root',
})
export class AuthenticationService implements OnInit {
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
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
  constructor(
    private oauthService: OAuthService,
    private httpClient: HttpClient,
    private authorizationService: AuthorizationService
  ) {
    this.oauthService.events.subscribe((event) => {
      console.log('Event received ' + event.type);
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
  ngOnInit(): void {
    throw new Error('Method not implemented.');
  }

  async init(provider: string) {
    try {
      console.warn('Before ALL');
      console.warn(this.oauthService);
      if (provider == 'ESA') {
        console.log('Setup config ESA');
        this.oauthService.configure(environment.identityProviderConfig);
        await this.oauthService.loadDiscoveryDocumentAndTryLogin();
      } else {
        console.log('AuthenticationService : No session');
      }
      if (
          this.oauthService.hasValidIdToken() ||
          this.oauthService.hasValidAccessToken()
      ) {
        const jwt = {
          accessToken: this.oauthService.getAccessToken(),
          refreshToken: this.oauthService.getRefreshToken(),
          authDate: this.oauthService.getAccessTokenExpiration(),
        };
        console.log('jwt ', jwt);
        this.jwt_s3_storage(jwt);
        this._isAuthenticated$.next(true);
        const userProfil = await this.oauthService.loadUserProfile();
        const canActivate = await this.authorizationService.canActivate;
        const isAdmin = await this.authorizationService.isAdmin;
        this._userProfil$.next(userProfil as UserProfil);
      } else {
        this._isAuthenticated$.next(false);
      }
      this.oauthService.setupAutomaticSilentRefresh();
    } catch {
      console.error('The Tools are disabled due to authentication failure');
      console.error(this.oauthService);
      this._isAuthenticated$.next(false);
    }
  }

  async jwt_s3_storage(jwt: JWT) {
    const url = environment.s3Url + '/access_token.json';
    const blob = new Blob([JSON.stringify(jwt)], { type: 'application/json' });
    const file = new File([blob], 'access_token.json');
    let headers = new HttpHeaders().set(
      'Authorization',
      'bearer ' + jwt.accessToken
    );
    const options = {
      params: { private: true },
      headers,
    };
    return this.httpClient.put(url, file, options).subscribe({
      next: (data) => {
        console.log('SUCCESS :', data);
      },
      error: (error) => {
        console.log('ERROR :', error);
      },
    });
  }

  login_esa() {
    //setup esa configuration
    this.init('ESA');
    sessionStorage.setItem('provider', 'ESA');
    this.oauthService.initCodeFlow();
  }

  logout() {
    this.oauthService.logOut();
  }
}
