import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class PlannerService {
  private readonly base_url = "https://poe-be.herokuapp.com/run"

  constructor(private http: HttpClient) { }

  public executeInSGplan(domain: string, problem: string, timeout: number): Observable<string> {
    return this.http.post(`${this.base_url}/sgplan`, { domain, problem, timeout}, {responseType: 'text'});
  }
  
  public executeInOptic(domain: string, problem: string, timeout: number): Observable<string> {
    return this.http.post(`${this.base_url}/optic`, { domain, problem, timeout}, {responseType: 'text'});
  }
}
