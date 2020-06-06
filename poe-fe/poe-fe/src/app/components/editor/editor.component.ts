import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-editor',
  templateUrl: './editor.component.html',
  styleUrls: ['./editor.component.scss']
})
export class EditorComponent implements OnInit {
  public domainContent: String;
  public problemContent: String;

  constructor() { }

  ngOnInit(): void {
  }

  public executeInSGPlan(timeout: number) {
    console.log("Clicked on sgplan");
    console.log(timeout);
  }

  public executeInOptic(timeout: number) {
    console.log("Clicked on optic");
    console.log(timeout);
  }
}
