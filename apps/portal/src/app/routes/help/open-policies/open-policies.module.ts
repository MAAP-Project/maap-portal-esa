import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { OpenPoliciesRoutingModule } from './open-policies-routing.module';
import { OpenPoliciesComponent } from './open-policies.component';

@NgModule({
  declarations: [OpenPoliciesComponent],
  imports: [CommonModule, OpenPoliciesRoutingModule],
})
export class OpenPoliciesModule {}
