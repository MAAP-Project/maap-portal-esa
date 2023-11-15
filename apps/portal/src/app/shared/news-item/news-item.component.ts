import { Component, Input } from '@angular/core';
import { News } from '../../services/news/news.model';

@Component({
  selector: 'maap-esa-portal-news-item',
  templateUrl: './news-item.component.html',
  styleUrls: ['./news-item.component.scss'],
})
export class NewsItemComponent {
  @Input()
  newsItem!: News;
}
