import { Component } from '@angular/core';
import { AppConfigService } from '../../../services/app-config/app-config.service';
import { Observable } from 'rxjs';
import { AuthenticationService } from '../../../services/authentication/authentication.service';
import { environment } from '../../../../environments/environment';

@Component({
  selector: 'maap-esa-portal-footer',
  templateUrl: './footer.component.html',
  styleUrls: ['./footer.component.scss'],
})
export class FooterComponent {
  isAuthenticated$: Observable<boolean>;
  supportEmail = ""
  constructor(
    private authenticationService: AuthenticationService,
    private appConfigService: AppConfigService,
    ){
      this.isAuthenticated$ = this.authenticationService.isAuthenticated$;
      this.supportEmail = environment.support_email;
  }

}
