import { Component } from '@angular/core';
import { Observable } from 'rxjs';
import { News } from '../../services/news/news.model';
import { NewsService } from '../../services/news/news.service';

@Component({
  selector: 'maap-esa-portal-news',
  templateUrl: './news.component.html',
  styleUrls: ['./news.component.scss'],
})
export class NewsComponent {
  newsList: Observable<News[]>;

  constructor(private newsService: NewsService) {
    this.newsList = this.newsService.getNewsList();
  }
}
