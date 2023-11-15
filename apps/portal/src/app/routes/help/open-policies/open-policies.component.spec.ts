import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OpenPoliciesComponent } from './open-policies.component';

describe('OpenPoliciesComponent', () => {
  let component: OpenPoliciesComponent;
  let fixture: ComponentFixture<OpenPoliciesComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [OpenPoliciesComponent],
    }).compileComponents();

    fixture = TestBed.createComponent(OpenPoliciesComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
