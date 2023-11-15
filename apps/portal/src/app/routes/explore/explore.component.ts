import { Component, ElementRef, ViewChild } from '@angular/core';
import { environment } from '../../../environments/environment';

@Component({
  selector: 'maap-esa-portal-explore',
  templateUrl: './explore.component.html',
  styleUrls: ['./explore.component.scss'],
})
export class ExploreComponent {
  exploreUrl: string;

  @ViewChild('exploreFrame') exploreFrame!: ElementRef;

  constructor() {
    this.exploreUrl = environment.exploreUrl;
  }

  expand() {
    (this.exploreFrame.nativeElement as HTMLIFrameElement).requestFullscreen();
  }
}
