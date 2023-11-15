import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FaqArticleComponent } from './faq-article.component';

describe('FaqArticleComponent', () => {
  let component: FaqArticleComponent;
  let fixture: ComponentFixture<FaqArticleComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [FaqArticleComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(FaqArticleComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
