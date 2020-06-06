import { Component, OnInit } from '@angular/core';
import { PlannerService } from 'src/app/services/planner.service';

@Component({
  selector: 'app-editor',
  templateUrl: './editor.component.html',
  styleUrls: ['./editor.component.scss']
})
export class EditorComponent implements OnInit {
  public domainContent: string;
  public problemContent: string;
  public output = "Execute your problem to get the output here...";
  public alertMessage = "";

  constructor(private plannerService: PlannerService) { }

  ngOnInit(): void {
  }

  public executeInSGPlan(timeout: number) {
    this.plannerService.executeInSGplan(this.domainContent, this.problemContent, timeout).subscribe(
      (res) => {
        this.output = res;
        this.alertMessage = "";
      },
      (err) => {
        console.log(err);
        this.alertMessage = err.message;
      }
    );
  }

  public executeInOptic(timeout: number) {
    this.plannerService.executeInOptic(this.domainContent, this.problemContent, timeout).subscribe(
      (res) => {
        this.output = res;
        this.alertMessage = "";
      },
      (err) => {
        console.log(err);
        this.alertMessage = err.message;
      }
    );
  }
}
