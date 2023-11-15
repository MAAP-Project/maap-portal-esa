import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { OAuthService } from 'angular-oauth2-oidc';
import { environment } from '../../../environments/environment';
import { map, Observable } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class ProcessService {
  constructor(private httpClient: HttpClient, private oauthService: OAuthService) { }

  getProcessesSecured() {
    const processes = environment.processUrl;
    return this.httpClient.get<any>(processes, {
      headers: {
        'Authorization': 'bearer ' + this.oauthService.getAccessToken(),
      }
    }).pipe(map(result => result.processes));
  }

  getProcessesAttributes(userId: string = '64132b4e7ae9b45d7b471331') {
    const process = environment.processUrl;
    return this.httpClient.get<any>(process + '/' + userId,
      {
        headers: {
          'Authorization': 'bearer ' + this.oauthService.getAccessToken(),
        }
      }
    )
  }

  runWorkflow(process: any, inputs: any): Observable<any> {
    const url = environment.processUrl + '/' + process.id + '/jobs'
    return this.httpClient.post(url, {
      "inputs": inputs, "outputs": [],
      "mode": "ASYNC",
      "response": "RAW"
    }, {
      headers: {
        'Authorization': 'bearer ' + this.oauthService.getAccessToken(),
      }
    })
  }

  deployWorkflow(href: any) {
    const url = environment.deployUrl
    return this.httpClient.post(url, {
      executionUnit: [{ href: href }]
    }, {
      headers: {
        'Authorization': 'bearer ' + this.oauthService.getAccessToken(),
      }
    }
    )
  }
  undeploy(id: string) {
    const url = environment.deployUrl + '/' + id
    return this.httpClient.delete(url,
      {
        headers: {
          'Authorization': 'bearer ' + this.oauthService.getAccessToken(),
        }
      }
    );
  }

}

