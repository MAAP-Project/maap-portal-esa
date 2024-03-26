import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { SafePipeModule } from '../../pipes/safe/safe-pipe.module';
import { OrchestratorComponent } from './orchestrator/orchestrator.component';
import { ToolsRoutingModule } from './tools-routing.module';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { TooltipModule } from 'primeng/tooltip';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { InputTextModule } from 'primeng/inputtext';
import { DeploymentComponent } from './deployment/deployment.component';
import { MessagesModule } from 'primeng/messages';
import { DPSComponent } from './dps/dps.component';
import { ButtonModule } from 'primeng/button';
import { TableModule } from 'primeng/table';
import { DialogModule } from 'primeng/dialog';
import { AdminComponent } from './admin/admin.component';
import { ProgressSpinnerModule } from "primeng/progressspinner";

@NgModule({
  declarations: [
    OrchestratorComponent,
    DPSComponent,
    DeploymentComponent,
    AdminComponent,
  ],
  imports: [
    CommonModule,
    ToolsRoutingModule,
    SafePipeModule,
    FormsModule,
    TooltipModule,
    AutoCompleteModule,
    InputTextModule,
    MessagesModule,
    ReactiveFormsModule,
    ButtonModule,
    TableModule,
    DialogModule,
    ProgressSpinnerModule
  ],
})
export class ToolsModule {}
