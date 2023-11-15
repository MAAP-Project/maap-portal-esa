import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { SafeHTMLPipe } from './safe-html.pipe';

@NgModule({
  declarations: [SafeHTMLPipe],
  imports: [CommonModule],
  exports: [SafeHTMLPipe],
})
export class SafeHTMLModule {}
