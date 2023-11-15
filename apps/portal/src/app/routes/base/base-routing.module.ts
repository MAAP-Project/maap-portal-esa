import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AppBaseComponent } from './app-base/app-base.component';

const routes: Routes = [
  {
    path: '',
    component: AppBaseComponent,
    children: [
      {
        path: 'home',
        loadChildren: () =>
          import('../../routes/home/home.module').then((m) => m.HomeModule),
      },
      {
        path: 'login',
        loadChildren: () =>
          import('../../routes/login/login.module').then((m) => m.LoginModule),
      },
      {
        path: 'news',
        loadChildren: () =>
          import('../../routes/news/news.module').then((m) => m.NewsModule),
      },
      {
        path: 'explore',
        loadChildren: () =>
          import('../../routes/explore/explore.module').then(
            (m) => m.ExploreModule
          ),
      },
      {
        path: 'communities',
        loadChildren: () =>
          import('../../routes/communities/communities.module').then(
            (m) => m.CommunitiesModule
          ),
      },
      {
        path: 'tools',
        loadChildren: () =>
          import('../../routes/tools/tools.module').then((m) => m.ToolsModule),
      },
      {
        path: 'help',
        loadChildren: () =>
          import('../../routes/help/help.module').then((m) => m.HelpModule),
      },
      {
        path: '',
        pathMatch: 'full',
        redirectTo: 'home',
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class BaseRoutingModule {}
