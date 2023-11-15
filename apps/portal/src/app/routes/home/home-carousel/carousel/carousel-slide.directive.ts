import { Directive, TemplateRef } from '@angular/core';

let nextId = 0;

@Directive({ selector: 'ng-template[maapEsaPortalCarouselSlide]' })
export class CarouselSlideDirective {
  id = `carousel-slide-${nextId++}`;

  constructor(public tplRef: TemplateRef<any>) {}
}
