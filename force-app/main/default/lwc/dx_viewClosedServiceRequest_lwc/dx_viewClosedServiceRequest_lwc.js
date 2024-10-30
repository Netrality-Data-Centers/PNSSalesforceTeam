import { LightningElement, wire } from 'lwc';
import getClosedServiceRequest from "@salesforce/apex/DX_viewClosedServiceRequest_ctr.getClosedServiceRequest";

const columns = [
    { label: 'SR Number', fieldName: 'DX_Case_Number__c' },
    { label: 'Category', fieldName: 'RecordType_Name'},
    { label: 'Type', fieldName: 'Type'},
    { label: 'Status', fieldName: 'Status'},
    { label: 'Site', fieldName: 'DX_Site__c'},
    { label: 'Closed ', fieldName: 'DX_Completion_Date__c'}
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
                var result = JSON.parse(JSON.stringify(data));
                for(var item in result){
                    var RecordType_Name = result[item].RecordType.Name;
                    result[item].RecordType_Name = RecordType_Name;
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