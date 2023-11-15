import { Component, OnInit } from '@angular/core';
import { BehaviorSubject, firstValueFrom } from 'rxjs';
import { ProcessService } from '../../../services/process/process.service';
import { Message } from 'primeng/api';

@Component({
  selector: 'maap-esa-portal-dps',
  templateUrl: './dps.component.html',
  styleUrls: ['./dps.component.scss'],
})
export class DPSComponent implements OnInit {
  isProcessRunning: boolean = false;
  selectedAlgos: any;
  filtredAlgos: string[] = [];
  selectedAlgo: any;
  input_data: any = null;
  urls: string[] = [];
  inputs: any[] = [];
  parameters: any[] = [];
  data: any[] = [];
  messages: Message[] = []
  list_id: any[] = [];
  processes$ = new BehaviorSubject<any[] | null>(null);
  processAttributes$ = new BehaviorSubject<any[] | null>(null);

  iframeHeight = '1500px';
  argoUrl$ = new BehaviorSubject<string | null>(null);
  constructor(private processService: ProcessService) {
    this.getProcesses()
    this.iframeHeight =
      window.innerHeight -
      document.getElementsByTagName('maap-esa-portal-header')[0]?.scrollHeight +
      'px';
  }

  ngOnInit(): void {
  }

  addUrl() {
    this.urls.push('');
  }
  deleteUrl(index: any) {
    this.urls.splice(index, 1);
  }

  filterAlgo(event: any, processes: any[]): void {

    let filtered: any[] = [];
    let query = event.query;

    for (let i = 0; i < processes.length; i++) {
      let algo = processes[i];
      if (algo.title.toLowerCase().indexOf(query.toLowerCase()) >= 0) {
        filtered.push(algo);
      }
    }

    this.filtredAlgos = filtered;
  }

  onSelect(value: any) {
    if (this.selectedAlgos?.id !== this.selectedAlgo?.id) {
      this.urls = ['']
      this.isProcessRunning = false;
      this.argoUrl$.next(
        null
      );
      this.parameters = [];
      this.input_data = null;
      this.data = []
      this.list_id = [];
      this.getProcessesAttributes(value.id);

    }
  }

  onUnselect(event: any) {
    if (this.selectedAlgos?.id !== this.selectedAlgo?.id) {
      this.selectedAlgo = null;
      this.isProcessRunning = false;
      this.urls = [''];
      this.data = []
      this.list_id = [];
      this.parameters = [];
      this.argoUrl$.next(
        null
      );
    }
  }

  async getProcesses() {
    try {
      const res = await firstValueFrom(this.processService.getProcessesSecured());
      console.log("Getall", res);
      this.processes$.next(res);

    } catch (e) {
      console.log(e);
      this.messages = [{ severity: 'error', summary: 'Error', detail: "Server error" }];

    }
  }

  getProcessesAttributes(id: string) {
    this.processService.getProcessesAttributes(id).subscribe(result => {
      const process = result?.process;
      this.selectedAlgo = process;
      this.inputs = process?.inputs;
      if (this.inputs != null) {
        const input = this.inputs.find(item => item.id.includes('input'));

        if (input) {
          this.input_data = {
            id: input.id, label: input.title, abstract: input.abstract,
          }
        }
        const inputs = this.inputs.filter(item => !item.id.includes('input'))

        for (let i = 0; i < inputs.length; i++) {
          if (inputs[i].keywords[0].substr(9) != "null") {
            this.data[i] = inputs[i].keywords[0].substr(9)
          } else {
            this.data[i] = ""
          }
          this.parameters.push({
            id: inputs[i].id, label: inputs[i].title, abstract: inputs[i].abstract
          })
          this.list_id.push(inputs[i].id)
        }
        if (input) {
          this.list_id.push(input.id)
        }

      }
    });
  }

  ExecuteWorkflow(process: any) {
    let entry = []
    this.isProcessRunning = true;
    for (let i = 0; i < this.list_id.length; i++) {

      if (this.list_id[i].includes("input")) {
        entry.push({ id: this.list_id[i], data: "", href: JSON.stringify(this.urls) })
      } else {
        entry.push({ id: this.list_id[i], data: this.data[i], href: "" })
      }

    }
    this.processService.runWorkflow(process, entry).subscribe(async (res) => {
      if (res) {
        this.argoUrl$.next(
          res.message
        );
      } else {
        this.isProcessRunning = false;
      }

    })
  }

  trackByFn(index: any) {
    return index;
  }
}
