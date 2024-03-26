import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { IsAuthenticatedGuard } from '../../guards/is-authenticated/is-authenticated.guard';
import { DPSComponent } from './dps/dps.component';
import { OrchestratorComponent } from './orchestrator/orchestrator.component';
import { DeploymentComponent } from './deployment/deployment.component';
import { AdminComponent } from './admin/admin.component';

const routes: Routes = [
  {
    path: 'orchestrator',
    canActivate: [IsAuthenticatedGuard],
    component: OrchestratorComponent,
  },
  {
    path: 'DPS',
    canActivate: [IsAuthenticatedGuard],
    component: DPSComponent,
  },
  {
    path: 'Deployment',
    canActivate: [IsAuthenticatedGuard],
    component: DeploymentComponent,
  },
  {
    path: 'admin',
    canActivate: [],
    component: AdminComponent,
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class ToolsRoutingModule { }
