import { TestBed } from '@angular/core/testing';

import { DpsMonitorService } from './dps-monitor.service';

describe('DpsMonitorService', () => {
  let service: DpsMonitorService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(DpsMonitorService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
