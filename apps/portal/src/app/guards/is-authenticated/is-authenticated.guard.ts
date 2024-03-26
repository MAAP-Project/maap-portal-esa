import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  CanActivate,
  CanActivateChild,
  CanLoad,
  Route,
  Router,
  RouterStateSnapshot,
  UrlSegment,
  UrlTree,
} from '@angular/router';
import { Observable } from 'rxjs';
import { AuthenticationService } from '../../services/authentication/authentication.service';
import { AuthorizationService } from '../../services/authorization/authorization.service';

@Injectable({
  providedIn: 'root',
})
export class IsAuthenticatedGuard
  implements CanActivate, CanActivateChild, CanLoad
{
  constructor(
    private authenticationService: AuthenticationService,
    private authorizationService: AuthorizationService,
    private router: Router
  ) {}

  async _isAuthenticated() {
    const isAuthenticated = this.authenticationService.isAuthenticated;
    if (isAuthenticated) {
      return true;
    }
    return this.router.parseUrl('/home');
  }

  async _canActivate() {
    const canActivate = this.authorizationService.canActivate;
    if (canActivate) {
      return true;
    }
    return this.router.parseUrl('/home');
  }

  async canActivate(
    _route: ActivatedRouteSnapshot,
    _state: RouterStateSnapshot
  ): Promise<boolean | UrlTree> {
    return await this._isAuthenticated() && this._canActivate();
  }

  canActivateChild(
    _childRoute: ActivatedRouteSnapshot,
    _state: RouterStateSnapshot
  ):
    | boolean
    | UrlTree
    | Observable<boolean | UrlTree>
    | Promise<boolean | UrlTree> {
    return this._isAuthenticated();
  }

  canLoad(
    _route: Route,
    _segments: UrlSegment[]
  ):
    | boolean
    | UrlTree
    | Observable<boolean | UrlTree>
    | Promise<boolean | UrlTree> {
    return this._isAuthenticated();
  }
}
