import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';
import { News } from './news.model';

@Injectable({
  providedIn: 'root',
})
export class NewsService {
  constructor(private httpClient: HttpClient) {}

  getLatestNews() {
    const latestNewsFileUrl = environment.latestNewsFileUrl;
    return this.httpClient.get<News[]>(latestNewsFileUrl);
  }

  getNewsList() {
    const newsListFileUrl = environment.newsListFileUrl;
    return this.httpClient.get<News[]>(newsListFileUrl);
  }

  getNewsContent(newsPath: string) {
    const newsPrefixUrl = environment.newsPrefixUrl;
    return this.httpClient.get(newsPrefixUrl + newsPath + '.html', {
      responseType: 'text',
    });
  }
}
