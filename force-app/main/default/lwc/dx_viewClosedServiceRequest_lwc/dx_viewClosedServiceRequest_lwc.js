import { LightningElement, wire } from 'lwc';
import getClosedServiceRequest from "@salesforce/apex/DX_viewClosedServiceRequest_ctr.getClosedServiceRequest";

const columns = [
    { label: 'SR Number', fieldName: 'CaseNumber' },
    { label: 'Category', fieldName: 'RecordType_Name'},
    { label: 'Type', fieldName: 'Type'},
    { label: 'Status', fieldName: 'Status'},
    { label: 'Site', fieldName: 'DX_Site__c'},
    { label: 'SR Closed Date', fieldName: 'ClosedDate'}
];

export default class Dx_viewClosedServiceRequest_lwc extends LightningElement {
    dataInfo = [];
    columns = columns;
    isEmpty = false;
    error = false;

    @wire(getClosedServiceRequest)
    wiredClosedSR({ error, data }) {
        if (data) {
            if(data.length > 0){
                let result = JSON.parse(JSON.stringify(data));
                let recordType_Name;
                let isoDate;
                let date;
                let year;
                let month;
                let day;
                let formattedDate;
                for(var item in result){
                    recordType_Name = result[item].RecordType.Name;
                    result[item].RecordType_Name = recordType_Name;

                    isoDate = result[item].ClosedDate;
                    date = new Date(isoDate);
                    // Get date components
                    year = date.getUTCFullYear();
                    month = String(date.getUTCMonth() + 1).padStart(2, '0'); // Months are 0-indexed
                    day = String(date.getUTCDate()).padStart(2, '0');
                    // Format the date
                    formattedDate = `${year}-${month}-${day}`;
                    result[item].ClosedDate = formattedDate;
                }
                this.dataInfo = [...result];
            }      
            if(data.length === 0){this.isEmpty = true;}
        } else if (error) {
            this.error = true;            
            console.error(error);
        }
    }
}