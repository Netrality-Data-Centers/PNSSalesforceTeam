import { LightningElement, api, wire } from 'lwc';
import dxNamePageDetailsSRExperienceCloudLabel from '@salesforce/label/c.DX_NamePage_DetailsSR_Experience_Cloud';
import dxURLExperienceCloudLabel from '@salesforce/label/c.DX_URL_Experience_Cloud'; 
import getOpenServiceRequest from "@salesforce/apex/DX_viewOpenServiceRequest_ctr.getOpenServiceRequest";
import { NavigationMixin } from 'lightning/navigation';

const actions = [
    { label: 'View Details', name: 'show_details' }
],
columns = [
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
    { fieldName: 'CaseNumber', label: 'SR Number' },
    { fieldName: 'recordTypeName', label: 'Category'},
    { fieldName: 'Type', label: 'Type'},
    { fieldName: 'Status', label: 'Status'},
    { fieldName: 'DX_Site__c', label: 'Site'},
    { fieldName: 'CreatedDate', label: 'SR Created Date'}
];

export default class Dx_viewOpenServiceRequest_lwc extends NavigationMixin (LightningElement){
    dataInfo = [];
    columns = columns;
    isEmpty = false;
    error = false;
    @api recordIdToFlow;
    strRecordtoflow = 'recordIdToFlow=';
    url = dxURLExperienceCloudLabel + dxNamePageDetailsSRExperienceCloudLabel + this.strRecordtoflow;

    @wire(getOpenServiceRequest)
    wiredOpenSR({ error, data }) {
        if (data) {
            const cero = 0;
            let result = null;
            if(data.length > cero){
                result = JSON.parse(JSON.stringify(data));
                this.funtionIteratorData(result);
            }            
            if(data.length === cero){this.isEmpty = true;}
        } else if (error) {
            this.error = true;
        }
    }

    handleRowAction(event) {
        const objEvent = event;
        switch (objEvent.detail.action.name) {
            case 'show_details':
                this.handleNavigate(objEvent.detail.row);
                break;
            default:
                // Do nothing
        }
    }

    funtionIteratorData(result){
        let item = null;
        for( item in result ){
            result[item] = this.funtionFormatRecordType( item, result );
            result[item] = this.funtionFormatDate( item, result );
        }
        this.dataInfo = [...result];
    }

    funtionFormatRecordType( item, result ){
        let recordTypeName = null;
        recordTypeName = result[item].RecordType.Name;
        result[item].recordTypeName = recordTypeName;
        return result[item];
    }

    funtionFormatDate( item, result ){
        const indexStar = 2, monthPlusone = 1;
        let date = null, day = null, formattedDate = null, isoDate = null, month = null, year = null;
        isoDate = result[item].CreatedDate;
        date = new Date(isoDate);
        // Get date components
        year = date.getUTCFullYear();
        month = String(date.getUTCMonth() + monthPlusone).padStart(indexStar, '0');
        day = String(date.getUTCDate()).padStart(indexStar, '0');
        // Format the date
        formattedDate = `${year}-${month}-${day}`;
        result[item].CreatedDate = formattedDate;
        return result[item];
    }

    handleNavigate(row) {
        // Using NavigationMixin to navigate to an Case record page
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                objectApiName: 'Case',
                actionName: 'view'
            }
        });
    }
}