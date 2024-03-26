import { Component, OnInit } from '@angular/core';
import { Event, NavigationStart, Router } from '@angular/router';
import { Observable, ReplaySubject } from 'rxjs';
import { AppConfigService } from '../../../services/app-config/app-config.service';
import { AuthenticationService, UserProfil  } from '../../../services/authentication/authentication.service';
import { environment } from '../../../../environments/environment';
import { AuthorizationService } from '../../../services/authorization/authorization.service';

@Component({
  selector: 'maap-esa-portal-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.scss'],
})
export class HeaderComponent implements OnInit {
  isAuthenticated$: Observable<boolean>;
  isAdmin$:Observable<boolean>;
  canActivate$: Observable<boolean>;
  userProfil$!: Observable<UserProfil>;
  userName="";
  maintenanceInProgress = false;
  maintenanceText = '';
  developmentUrl = environment.developmentUrl;
  gitlabUrl = environment.gitlabUrl;

  constructor(
    private authenticationService: AuthenticationService,
    private authorizationService: AuthorizationService,
    private appConfigService: AppConfigService,
    private router: Router
  ) {
    this.isAuthenticated$ = this.authenticationService.isAuthenticated$;
    this.isAdmin$ = this.authorizationService.isAdmin$;
    this.canActivate$ = this.authorizationService.canActivate$
    this.maintenanceInProgress =
      this.appConfigService.config.maintenance.inProgress;
    this.maintenanceText = this.appConfigService.config.maintenance.text;
    this.router.events.subscribe(this.handleNavigationChange);
  }
  ngOnInit(): void {
    this.userProfil$=this.authenticationService.userProfil$;
    var userName = "";
    this.userProfil$.subscribe(res => {this.userName = res.info.name})
  }

  logout() {
    this.authenticationService.logout();
  }

  toggleResponsiveMenu() {
    const nav = document.getElementById('header-nav');
    if (nav) {
      if (nav.style.maxHeight == '1000px') {
        nav.style.maxHeight = '0px';
      } else {
        nav.style.maxHeight = '1000px';
      }
    }
  }

  submenuToggleResponsiveMenu(event: MouseEvent) {
    if (!event.target) {
      return;
    }
    const target = event.target as HTMLElement;
    const parentNode = target.parentNode?.parentNode;

    if (!parentNode) {
      return;
    }

    parentNode
      .querySelector('.sub-menu')
      ?.classList.toggle('sub-menu-responsive-show');
  }

  handleNavigationChange(event: Event) {
    if (event instanceof NavigationStart) {
      if (window.matchMedia('only screen and (max-width: 1023px)').matches) {
        const nav = document.getElementById('header-nav');
        if (nav) {
          nav.style.maxHeight = '0px';
        }

        const elements = document.getElementsByClassName('sub-menu');

        for (let i = 0; i < elements.length; i++) {
          const element = elements.item(i);

          element?.classList.remove('sub-menu-responsive-show');
        }
      }
    }
  }
}
