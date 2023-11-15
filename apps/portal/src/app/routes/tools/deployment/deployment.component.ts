import { Component, OnInit } from '@angular/core';
import { ProcessService } from '../../../services/process/process.service';
import { BehaviorSubject, firstValueFrom } from 'rxjs';
import { Message } from 'primeng/api';

@Component({
  selector: 'maap-esa-portal-deployment',
  templateUrl: './deployment.component.html',
  styleUrls: ['./deployment.component.scss'],
})
export class DeploymentComponent implements OnInit {
  executionUnit: string = ""
  deployedProcess: any;
  filteredProcess: any;
  processes$ = new BehaviorSubject<any[] | null>(null);
  messages: Message[] = []
  messagesDeploy: Message[] = []

  constructor(private processService: ProcessService) {
    this.getProcesses()
  }

  ngOnInit(): void { }

  filterProcesses(event: any, processes: any[]): void {

    let filtered: any[] = [];
    let query = event.query;
    console.log("querydeploy", query)

    for (let i = 0; i < processes.length; i++) {
      let algo = processes[i];
      if (algo.title.toLowerCase().indexOf(query.toLowerCase()) >= 0) {
        filtered.push(algo);
      }
    }

    this.filteredProcess = filtered;
    console.log("this.filteredProcess", this.filteredProcess)
  }

  async getProcesses() {
    try {
      const res = await firstValueFrom(this.processService.getProcessesSecured());
      console.log("Getall", res);
      this.processes$.next(res);

    } catch (e) {
      console.log(e);
    }
  }

  deploy(executionUnit: any) {

    this.processService.deployWorkflow(executionUnit).subscribe((res: any) => {
      console.log("resDeploy", res)
      if (res?.processSummary) {
        this.getProcesses();
        this.executionUnit = '';
        this.messages = [{ severity: 'success', summary: 'Success', detail: res?.processSummary.title + ' is successfully deployed', life: 6000 }];

      } else if (res?.description) {
        this.messages = [{ severity: 'error', summary: 'Error', detail: res?.code + ' : ' + res?.description, life: 6000 }];

      }
    })

  }
  onSelect(value: any) {
    this.deployedProcess = value
  }

  undeploy(id: any) {

    this.processService.undeploy(id).subscribe((res: any) => {
      console.log("rs undeploy", res)

      if (res?.id) {
        this.deployedProcess = null;
        this.getProcesses();
        this.messages = [{ severity: 'success', summary: 'Success', detail: 'Worfklow with id ' + res?.id + ' is successfully deleted', life: 6000 }];
      }

    })

  }
}
