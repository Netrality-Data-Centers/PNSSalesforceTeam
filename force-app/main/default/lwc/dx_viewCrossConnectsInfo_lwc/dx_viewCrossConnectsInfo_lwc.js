import { LightningElement, wire } from 'lwc';
import getCrossConnets from "@salesforce/apex/DX_viewCrossConnectsInformation_ctr.getCrossConnets";

const columns = [
    { label: 'Cross Connect ID', fieldName: 'Xconnect_ID__c' },
    { label: 'Building', fieldName: 'Building__c'},
    { label: 'Origination Account', fieldName: 'Origination_Account__c'},
    { label: 'Destination Account', fieldName: 'Destination_Account__c'},
    { label: 'Cross Connect Status', fieldName: 'Xconnect_Status__c'}
];

export default class Dx_viewCrossConnectsInfo_lwc extends LightningElement {
    dataInfo = [];
    columns = columns;
    isEmpty = false;
    error = false;

    @wire(getCrossConnets)
    wiredCrossConnetsInfo({ error, data }) {
        if (data) {
            this.dataInfo = data;
            if(data.length === 0){this.isEmpty = true;} 
        } else if (error) {
            this.error = true;
            console.error(error);
        }
    }
}