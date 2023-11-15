import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CommunitiesRoutingModule } from './communities-routing.module';
import { CommunitiesComponent } from './communities.component';

@NgModule({
  declarations: [CommunitiesComponent],
  imports: [CommonModule, CommunitiesRoutingModule],
})
export class CommunitiesModule {}
