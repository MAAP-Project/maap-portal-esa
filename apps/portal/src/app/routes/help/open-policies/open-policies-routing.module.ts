import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { OpenPoliciesComponent } from './open-policies.component';

const routes: Routes = [
  {
    path: '',
    component: OpenPoliciesComponent,
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class OpenPoliciesRoutingModule {}
