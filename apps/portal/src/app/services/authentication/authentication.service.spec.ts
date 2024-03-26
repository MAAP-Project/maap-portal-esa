import { TestBed, inject } from '@angular/core/testing';
import {
  HttpClientTestingModule,
  HttpTestingController,
} from '@angular/common/http/testing';
import { AuthenticationService } from './authentication.service';

describe('AuthenticationService', () => {
  let service: AuthenticationService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [AuthenticationService],
    });
    service = TestBed.inject(AuthenticationService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  it('should make a PUT request with the correct parameters', inject(
    [AuthenticationService],
    (AuthenticationService: AuthenticationService) => {
      const jwtMock = {
        accessToken: 'AccessToken',
        refreshToken: 'RefreshToken',
      };
      const expectedUrl = 'http://example.com/access_token.json';

      AuthenticationService.jwt_s3_storage(jwtMock);

      const request = httpMock.expectOne(expectedUrl);

      expect(request.request.method).toBe('PUT');
      expect(request.request.headers.get('Authorization')).toBe(
        'bearer AccessToken'
      );
      expect(request.request.params.get('private')).toBe('true');

      const expectedBlob = new Blob([JSON.stringify(jwtMock)], {
        type: 'application/json',
      });
      const expectedFile = new File([expectedBlob], 'access_token.json');

      expect(request.request.body).toEqual(expectedFile);

      // Simulate a successful response
      request.flush({ success: true });

      // Ensure that your success callback is called
      // Add your specific expectations or assertions based on the success callback
    }
  ));
});
