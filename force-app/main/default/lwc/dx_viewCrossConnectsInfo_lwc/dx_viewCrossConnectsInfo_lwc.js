import { LightningElement, wire } from 'lwc';
import getCrossConnets from "@salesforce/apex/DX_viewCrossConnectsInformation_ctr.getCrossConnets";

const columns = [
    { label: 'Cross Connect ID', fieldName: 'Xconnect_ID__c' },
    { label: 'Building', fieldName: 'Building__c'},
    { label: 'Origination Account', fieldName: 'Origination_Account_Name'},
    { label: 'Destination Account', fieldName: 'Destination_Account_Name'},
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
            if(data.length > 0){
                var result = JSON.parse(JSON.stringify(data));
                for(var item in result){
                    var Destination_Account_Name = result[item].Destination_Account__r.Name;
                    var Origination_Account_Name = result[item].Origination_Account__r.Name;
                    result[item].Origination_Account_Name = Origination_Account_Name;
                    result[item].Destination_Account_Name = Destination_Account_Name;
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