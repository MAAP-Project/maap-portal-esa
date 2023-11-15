import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';

import { AppBaseComponent } from './app-base/app-base.component';
import { BaseRoutingModule } from './base-routing.module';
import { FooterComponent } from './footer/footer.component';
import { HeaderComponent } from './header/header.component';

@NgModule({
  declarations: [AppBaseComponent, FooterComponent, HeaderComponent],
  imports: [CommonModule, BaseRoutingModule],
})
export class BaseModule {}
