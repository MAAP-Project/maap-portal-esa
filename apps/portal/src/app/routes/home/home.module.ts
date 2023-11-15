import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { SharedModule } from '../../shared/shared.module';

import { CarouselSlideDirective } from './home-carousel/carousel/carousel-slide.directive';
import { CarouselComponent } from './home-carousel/carousel/carousel.component';
import { HomeCarouselComponent } from './home-carousel/home-carousel.component';
import { HomeRoutingModule } from './home-routing.module';
import { HomeComponent } from './home.component';

@NgModule({
  declarations: [
    HomeComponent,
    CarouselSlideDirective,
    CarouselComponent,
    HomeCarouselComponent,
  ],
  imports: [CommonModule, HomeRoutingModule, SharedModule],
})
export class HomeModule {}
