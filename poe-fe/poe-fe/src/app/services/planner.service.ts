import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class PlannerService {
  private readonly baseUrl = `${environment.api_url}/run`;

  constructor(private http: HttpClient) { }

  public executeInSGplan(domain: string, problem: string, timeout: number): Observable<string> {
    return this.http.post(`${this.baseUrl}/sgplan`, { domain, problem, timeout}, {responseType: 'text'});
  }
  
  public executeInOptic(domain: string, problem: string, timeout: number): Observable<string> {
    return this.http.post(`${this.baseUrl}/optic`, { domain, problem, timeout}, {responseType: 'text'});
  }
}
