import { LightningElement, wire } from 'lwc';
import getCrossConnets from "@salesforce/apex/DX_viewCrossConnectsInformation_ctr.getCrossConnets";

const columns = [
    { label: 'Cross Connect ID', fieldName: 'Name' },
    { label: 'Building', fieldName: 'Building_Name'},
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
                let result = JSON.parse(JSON.stringify(data));
                let Destination_Account_Name;
                let Origination_Account_Name;
                let Building_Name;
                for(let item in result){
                    Destination_Account_Name = result[item].Destination_Account__r?.Name || '';
                    Origination_Account_Name = result[item].Origination_Account__r?.Name || '';
                    result[item].Origination_Account_Name = Origination_Account_Name;
                    result[item].Destination_Account_Name = Destination_Account_Name;

                    Building_Name = result[item].Building__r?.Name || '';
                    result[item].Building_Name = Building_Name;
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