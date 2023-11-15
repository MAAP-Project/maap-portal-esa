import { Component } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { BehaviorSubject, firstValueFrom } from 'rxjs';
import { FAQ } from '../../../../services/faq/faq.model';
import { FaqService } from '../../../../services/faq/faq.service';

@Component({
  selector: 'maap-esa-portal-faq-article',
  templateUrl: './faq-article.component.html',
  styleUrls: ['./faq-article.component.scss'],
})
export class FaqArticleComponent {
  faq$ = new BehaviorSubject<FAQ | null>(null);
  faqContent$ = new BehaviorSubject<string | null>(null);

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private faqService: FaqService
  ) {
    this.route.params.subscribe((params) => {
      const id = params['id'];
      if (id) {
        this.loadArticleContent(id);
      } else {
        this.router.navigate(['/help/user-guides']);
      }
    });
  }

  async loadArticleContent(id: number) {
    const faqList = await firstValueFrom(this.faqService.getFAQList());
    try {
      const faq = faqList[id];
      if (!faq) {
        this.router.navigate(['/help/user-guides']);
      }
      this.faq$.next(faq);
      const content = await firstValueFrom(
        this.faqService.getFAQContent(faq.path)
      );

      this.faqContent$.next(content);
    } catch (e) {
      console.log({ e });
      this.router.navigate(['/help/user-guides']);
    }
  }
}
