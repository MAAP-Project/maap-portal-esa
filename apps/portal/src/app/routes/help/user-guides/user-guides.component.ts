import { Component } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from '../../../../environments/environment';
import { FAQ } from '../../../services/faq/faq.model';
import { FaqService } from '../../../services/faq/faq.service';

@Component({
  selector: 'maap-esa-portal-user-guides',
  templateUrl: './user-guides.component.html',
  styleUrls: ['./user-guides.component.scss'],
})
export class UserGuidesComponent {
  faqList: Observable<FAQ[]>;
  documentationUrl: string;

  constructor(private faqService: FaqService) {
    this.faqList = this.faqService.getFAQList();
    this.documentationUrl = window.origin + environment.documentationUrl;
  }
}
