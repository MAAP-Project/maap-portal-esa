import { Component } from '@angular/core';
import { AuthenticationService } from '../../services/authentication/authentication.service';

@Component({
  selector: 'maap-esa-portal-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
})
export class LoginComponent {
  constructor(private authenticationService: AuthenticationService) {}

  login_esa() {
    this.authenticationService.login_esa();
  }

}
