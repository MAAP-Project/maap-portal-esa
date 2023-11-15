import { Component } from '@angular/core';
import { communities } from './communities.data';

@Component({
  selector: 'maap-esa-portal-communities',
  templateUrl: './communities.component.html',
  styleUrls: ['./communities.component.scss'],
})
export class CommunitiesComponent {
  communitiesList;
  constructor() {
    this.communitiesList = communities;
  }
}
