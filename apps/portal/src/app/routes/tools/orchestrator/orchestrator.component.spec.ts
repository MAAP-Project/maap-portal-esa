import { ComponentFixture, TestBed } from '@angular/core/testing';

import { OrchestratorComponent } from './orchestrator.component';

describe('OrchestratorComponent', () => {
  let component: OrchestratorComponent;
  let fixture: ComponentFixture<OrchestratorComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ OrchestratorComponent ]
    })
    .compileComponents();

    fixture = TestBed.createComponent(OrchestratorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
