import { LightningElement, wire } from 'lwc';
import getBillingsInfo from "@salesforce/apex/DX_viewBillingID_ctr.getBillingsInfo";

const columns = [
    { label: 'MRI ID Name', fieldName: 'Name' },
    { label: 'Building Name', fieldName: 'Building_Name__c'},
    { label: 'MRI Occupant Name', fieldName: 'MRI_Occupant_Name__c'}
];

export default class Dx_viewBillingID_lwc extends LightningElement {
    dataInfo = [];
    columns = columns;
    isEmpty = false;
    error = false;

    @wire(getBillingsInfo)
    wiredBillingsInfo({ error, data }) {
        if (data) {
            this.dataInfo = data;
            if(data.length === 0){this.isEmpty = true;} 
        } else if (error) {
            this.error = true;
            console.error(error);
        }
    }
}