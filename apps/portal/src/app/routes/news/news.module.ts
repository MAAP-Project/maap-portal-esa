import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { SafeHTMLModule } from '../../pipes/safe-html/safe-html.module';

import { SharedModule } from '../../shared/shared.module';
import { ArticleComponent } from './article/article.component';
import { NewsRoutingModule } from './news-routing.module';
import { NewsComponent } from './news.component';

@NgModule({
  declarations: [NewsComponent, ArticleComponent],
  imports: [CommonModule, NewsRoutingModule, SharedModule, SafeHTMLModule],
})
export class NewsModule {}
