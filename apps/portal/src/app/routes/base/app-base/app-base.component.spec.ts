import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AppBaseComponent } from 'app-base.component';

describe('AppBaseComponent', () => {
  let component: AppBaseComponent;
  let fixture: ComponentFixture<AppBaseComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [AppBaseComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(AppBaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
