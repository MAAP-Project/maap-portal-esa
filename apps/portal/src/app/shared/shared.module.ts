import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { RouterModule } from '@angular/router';
import { NewsItemComponent } from './news-item/news-item.component';

@NgModule({
  declarations: [NewsItemComponent],
  imports: [CommonModule, RouterModule],
  exports: [NewsItemComponent],
})
export class SharedModule {}
