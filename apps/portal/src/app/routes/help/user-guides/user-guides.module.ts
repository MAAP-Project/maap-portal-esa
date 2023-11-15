import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { SafeHTMLModule } from '../../../pipes/safe-html/safe-html.module';
import { FaqArticleComponent } from './faq-article/faq-article.component';
import { UserGuidesRoutingModule } from './user-guides-routing.module';
import { UserGuidesComponent } from './user-guides.component';

@NgModule({
  declarations: [UserGuidesComponent, FaqArticleComponent],
  imports: [CommonModule, UserGuidesRoutingModule, SafeHTMLModule],
})
export class UserGuidesModule {}
