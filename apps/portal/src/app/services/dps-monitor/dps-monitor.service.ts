import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import {environment} from "../../../environments/environment";
import {OAuthService} from "angular-oauth2-oidc";

export interface ProcessInfo {
  elkDate: string,
  stageInExecutionTime: number,
  stageOutExecutionTime: number,
  processorExecutionTime: number,
  userName: string,
  processorName: string,
  startDate: string,
  endDate: string,
  status: string,
  cpuDuration: number,
  ramDuration: number,
  executionTime: number,
  cwlUrl: string,
  ramConsumed: number,
  cpuConsumed: number
}

@Injectable({
  providedIn: 'root'
})
export class DpsMonitorService {
  constructor(private httpClient: HttpClient, private oauthService: OAuthService) { }

  getProcessesInfos() {
    const url = environment.processUrl + '/monitor'
    return this.httpClient.get<ProcessInfo[]>(url,
        {
          headers: {
            'Authorization': 'bearer ' + this.oauthService.getAccessToken(),
          }
        }
    );
  }

  getJobResult(processorName: string | undefined) {
    const url = environment.processUrl + '/' + processorName + '/result'
    return this.httpClient.get<any>(url,
        {
          headers: {
            'Authorization': 'bearer ' + this.oauthService.getAccessToken(),
          }
        }
    );
  }
}
