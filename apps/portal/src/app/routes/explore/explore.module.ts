import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { SafePipeModule } from '../../pipes/safe/safe-pipe.module';
import { ExploreRoutingModule } from './explore-routing.module';
import { ExploreComponent } from './explore.component';

@NgModule({
  declarations: [ExploreComponent],
  imports: [CommonModule, ExploreRoutingModule, SafePipeModule],
})
export class ExploreModule {}
