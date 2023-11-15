import { AfterContentInit, Component } from '@angular/core';
import { Router, UrlSerializer } from '@angular/router';
import { BehaviorSubject, firstValueFrom } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { AuthenticationService } from '../../../services/authentication/authentication.service';

@Component({
  selector: 'maap-esa-portal-orchestrator',
  templateUrl: './orchestrator.component.html',
  styleUrls: ['./orchestrator.component.scss'],
})
export class OrchestratorComponent implements AfterContentInit {
  orchestratorUrl$ = new BehaviorSubject<string | null>(null);

  serviceAvailable = true;
  iframeHeight = '1500px';

  constructor(
    private authenticationService: AuthenticationService,
    private router: Router,
    private serializer: UrlSerializer
  ) {
    this.iframeHeight =
      window.innerHeight -
      document.getElementsByTagName('maap-esa-portal-header')[0]?.scrollHeight +
      'px';
  }

  private async _generateUrl() {
    const userProfil = (
      await firstValueFrom(this.authenticationService.userProfil$)
    ).info;
    const accessToken = this.authenticationService.accessToken;
    // TODO: remove this when copa support OIDC
    const tree = this.router.createUrlTree(['copa'], {
      queryParams: {
        user_first_name: userProfil.given_name,
        user_last_name: userProfil.family_name,
        user_email: userProfil.email,
        access_token: accessToken,
      },
    });
    this.orchestratorUrl$.next(
      environment.orchestratorUrl + this.serializer.serialize(tree)
    );
  }

  async ngAfterContentInit() {
    await this._generateUrl();
  }
}
