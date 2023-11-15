import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { FaqArticleComponent } from './faq-article/faq-article.component';
import { UserGuidesComponent } from './user-guides.component';

const routes: Routes = [
  {
    path: '',
    component: UserGuidesComponent,
  },
  {
    path: 'faq/:id',
    component: FaqArticleComponent,
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class UserGuidesRoutingModule {}
