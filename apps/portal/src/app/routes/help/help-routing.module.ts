import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { HelpComponent } from './help.component';

const routes: Routes = [
  {
    path: '',
    component: HelpComponent,
    children: [
      {
        path: 'user-guides',
        loadChildren: () =>
          import('./user-guides/user-guides.module').then(
            (m) => m.UserGuidesModule
          ),
      },
      {
        path: 'terms-of-service',
        loadChildren: () =>
          import('./terms-of-service/terms-of-service.module').then(
            (m) => m.TermsOfServiceModule
          ),
      },
      {
        path: 'open-policies',
        loadChildren: () =>
          import('./open-policies/open-policies.module').then(
            (m) => m.OpenPoliciesModule
          ),
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class HelpRoutingModule {}
