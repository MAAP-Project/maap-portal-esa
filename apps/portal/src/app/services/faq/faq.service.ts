import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { FAQ } from './faq.model';

@Injectable({
  providedIn: 'root',
})
export class FaqService {
  constructor(private httpClient: HttpClient) {}

  getFAQList() {
    const faqListFileUrl = environment.faqListFileUrl;
    return this.httpClient.get<FAQ[]>(faqListFileUrl);
  }

  getFAQContent(faqPath: string) {
    const faqPrefixUrl = environment.faqPrefixUrl;
    return this.httpClient.get(faqPrefixUrl + faqPath + '.html', {
      responseType: 'text',
    });
  }
}
