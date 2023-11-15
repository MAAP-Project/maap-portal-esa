import { Component } from '@angular/core';
import { AuthenticationService } from './services/authentication/authentication.service';

@Component({
  selector: 'maap-esa-portal-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss'],
})
export class AppComponent {
  title = 'maap-portal';

  constructor(private authenticationService: AuthenticationService) {
      //check for the provider in the session storage
      let provider = sessionStorage.getItem("provider") ;
      if( provider == null){
        provider = 'NO_SESSION';
      }
      this.authenticationService.init(provider);
  }

  async download() {
    // const fileUrl = "https://gravitee-gateway.dev.esa-maap.org/s3/bmaap-dev/guillaume-poc/index.html"
    // try {
    //   const res = await firstValueFrom(this.httpClient.get(fileUrl, {
    //     headers: {
    //       'Authorization': 'bearer ' + this.oauthService.getAccessToken(),
    //     }
    //   }));
    //   console.log(res);
    // } catch (e) {
    //   console.log(e);
    // }
  }
}
