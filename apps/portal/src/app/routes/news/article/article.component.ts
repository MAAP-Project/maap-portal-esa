import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { BehaviorSubject, firstValueFrom } from 'rxjs';
import { News } from '../../../services/news/news.model';
import { NewsService } from '../../../services/news/news.service';

@Component({
  selector: 'maap-esa-portal-article',
  templateUrl: './article.component.html',
  styleUrls: ['./article.component.scss'],
})
export class ArticleComponent {
  news$ = new BehaviorSubject<News | null>(null);
  newsContent$ = new BehaviorSubject<string | null>(null);

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private newsService: NewsService
  ) {
    this.route.params.subscribe((params) => {
      const id = params['id'];
      if (id) {
        this.loadArticleContent(id);
      } else {
        this.router.navigate(['/news']);
      }
    });
  }

  async loadArticleContent(id: number) {
    const newsList = await firstValueFrom(this.newsService.getNewsList());
    try {
      const news = newsList[id];
      if (!news) {
        this.router.navigate(['/news']);
      }
      this.news$.next(news);
      const content = await firstValueFrom(
        this.newsService.getNewsContent(news.path)
      );

      this.newsContent$.next(content);
    } catch (e) {
      console.log({ e });
      this.router.navigate(['/news']);
    }
  }
}
