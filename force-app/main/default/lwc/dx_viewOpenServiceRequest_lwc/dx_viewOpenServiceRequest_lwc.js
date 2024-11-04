import { LightningElement, wire, api } from 'lwc';
import getOpenServiceRequest from "@salesforce/apex/DX_viewOpenServiceRequest_ctr.getOpenServiceRequest";

const actions = [
    { label: 'Edit', name: 'show_details' }
];

const columns = [
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
    { label: 'SR Number', fieldName: 'CaseNumber' },
    { label: 'Category', fieldName: 'RecordType_Name'},
    { label: 'Type', fieldName: 'Type'},
    { label: 'Status', fieldName: 'Status'},
    { label: 'Site', fieldName: 'DX_Site__c'},
    { label: 'SR Created Date', fieldName: 'CreatedDate'}
];

export default class Dx_viewOpenServiceRequest_lwc extends LightningElement {
    dataInfo = [];
    columns = columns;
    isEmpty = false;
    error = false;
    @api recordIdToFlow;
    isModalOpen = false;

    @wire(getOpenServiceRequest)
    wiredOpenSR({ error, data }) {
        if (data) {
            if(data.length > 0){
                var result = JSON.parse(JSON.stringify(data));
                for(var item in result){
                    var RecordType_Name = result[item].RecordType.Name;
                    result[item].RecordType_Name = RecordType_Name;


                    const isoDate = result[item].CreatedDate;
                    const date = new Date(isoDate);
                    // Get date components
                    const year = date.getUTCFullYear();
                    const month = String(date.getUTCMonth() + 1).padStart(2, '0'); // Months are 0-indexed
                    const day = String(date.getUTCDate()).padStart(2, '0');
                    // Format the date
                    const formattedDate = `${year}-${month}-${day}`;
                    result[item].CreatedDate = formattedDate;


                }
                this.dataInfo = [...result];
            }            
            if(data.length === 0){this.isEmpty = true;}
        } else if (error) {
            this.error = true;            
            console.error(error);
        }
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'show_details':
                this.showRowDetails(row);
                break;
            default:
        }
    }

    showRowDetails(row) {
        this.recordIdToFlow = row.Id;
        this.handleStartFlow();
    }

    handleStartFlow() {
        this.openModal();
    }

    handleFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            this.closeModal();
        }
    }

    get inputVariables() {
        return [
            {
                name: 'recordIdToFlow',
                type: 'String',
                value: this.recordIdToFlow
            }
        ];
    }

    openModal() {
        this.isModalOpen = true;
    }

    closeModal() {
        this.isModalOpen = false;
    }
}