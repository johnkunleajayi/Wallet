import { LightningElement, track, wire } from 'lwc';
import getEmployeesByLocation from '@salesforce/apex/EmployeeController.getEmployeesByLocation';

export default class EmployeeTable extends LightningElement {
    @track employees = [];
    @track error;
    @track isLoading = true;

    columns = [
        { label: 'Employee Name', fieldName: 'Name', type: 'text' },
        { label: 'Employee Number', fieldName: 'Employee_Number__c', type: 'text' },
        { label: 'Location', fieldName: 'Location__c', type: 'text' },
        { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date', 
          typeAttributes: { year: "numeric", month: "2-digit", day: "2-digit" } }
    ];

    connectedCallback() {
        this.fetchEmployees('Lagos');
        this.fetchEmployees('Abuja');
    }

    fetchEmployees(location) {
        getEmployeesByLocation({ location })
            .then((data) => {
                this.employees = [...this.employees, ...data.map(emp => ({
                    ...emp,
                    id: emp.Id // Add an id property for key-field
                }))];
                this.isLoading = false;
            })
            .catch((error) => {
                this.error = error;
                this.isLoading = false;
            });
    }
}
