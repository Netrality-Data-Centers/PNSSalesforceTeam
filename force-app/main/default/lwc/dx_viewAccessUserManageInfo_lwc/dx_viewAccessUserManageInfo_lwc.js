import { LightningElement, wire, api } from 'lwc';
import getAccessUserManageInfo from "@salesforce/apex/DX_viewAccessUserManageInfo_ctr.getAccessUserManageInfo";
const actions = [
    { label: 'Edit', name: 'show_details' }
];

const columns = [
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
    { label: 'Contact Name', fieldName: 'Contact_Name'},
    { label: 'Position/Role', fieldName: 'Position_Role__c'},
    { label: 'Account Name', fieldName: 'Account_Name'}
];
export default class Dx_viewAccessUserManageInfo_lwc extends LightningElement {
    dataInfo = [];
    columns = columns;
    isEmpty = false;
    error = false;
    @api recordIdToFlow;
    isModalOpen = false;

    @wire(getAccessUserManageInfo)
    wiredAccessUserManageInfo({ error, data }) {
        if (data) {
            if(data.length > 0){
                var result = JSON.parse(JSON.stringify(data));
                for(var item in result){
                    var Contact_Name = result[item].Contact_Name__r.Name;
                    var Account_Name = result[item].Account_Name__r.Name;
                    result[item].Contact_Name = Contact_Name;
                    result[item].Account_Name = Account_Name;
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