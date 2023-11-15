import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { SafePipeModule } from '../../pipes/safe/safe-pipe.module';
import { OrchestratorComponent } from './orchestrator/orchestrator.component';
import { ToolsRoutingModule } from './tools-routing.module';
import { FormsModule } from '@angular/forms';
import { TooltipModule } from 'primeng/tooltip';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { InputTextModule } from 'primeng/inputtext';
import { DeploymentComponent } from './deployment/deployment.component';
import { MessagesModule } from 'primeng/messages';
import { DPSComponent } from './dps/dps.component';

@NgModule({
  declarations: [
    OrchestratorComponent,
    DPSComponent,
    DeploymentComponent,
  ],
  imports: [
    CommonModule,
    ToolsRoutingModule,
    SafePipeModule,
    FormsModule,
    TooltipModule,
    AutoCompleteModule,
    InputTextModule,
    MessagesModule
  ],
})
export class ToolsModule { }
