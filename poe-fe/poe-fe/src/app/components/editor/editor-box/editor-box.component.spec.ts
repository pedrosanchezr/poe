import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { EditorBoxComponent } from './editor-box.component';

describe('EditorBoxComponent', () => {
  let component: EditorBoxComponent;
  let fixture: ComponentFixture<EditorBoxComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ EditorBoxComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(EditorBoxComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
