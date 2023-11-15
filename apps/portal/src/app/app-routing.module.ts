import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { BaseModule } from './routes/base/base.module';

const routes: Routes = [
  {
    path: '',
    loadChildren: () => BaseModule
  },
  {
    path: '**',
    pathMatch: 'full',
    redirectTo: 'home'
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
