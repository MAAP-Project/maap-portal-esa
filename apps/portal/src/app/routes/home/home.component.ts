import { HttpClient } from '@angular/common/http';
import { Component } from '@angular/core';
import { Observable } from 'rxjs';
import { News } from '../../services/news/news.model';
import { NewsService } from '../../services/news/news.service';

@Component({
  selector: 'maap-esa-portal-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss'],
})
export class HomeComponent {
  newsList: Observable<News[]>;

  constructor(
    private httpClient: HttpClient,
    private newsService: NewsService
  ) {
    this.newsList = this.newsService.getLatestNews();
  }
}
