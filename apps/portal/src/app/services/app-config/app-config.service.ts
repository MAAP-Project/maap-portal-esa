import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { AppConfig } from './app-config.interface';
import { firstValueFrom } from 'rxjs';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class AppConfigService {
  private _config!: AppConfig;

  get config() {
    return this._config;
  }

  constructor(private httpClient: HttpClient) {}

  async loadConfig() {
    const configUrl = environment.configUrl;
    this._config = await firstValueFrom(
      this.httpClient.get<AppConfig>(configUrl)
    );
  }
}

export function appConfigServiceFactory(appConfigService: AppConfigService) {
  return () => appConfigService.loadConfig();
}
