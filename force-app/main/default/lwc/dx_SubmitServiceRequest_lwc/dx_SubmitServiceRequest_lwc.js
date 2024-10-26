import { LightningElement, api, wire, track } from 'lwc';
import getRecordTypesForUserPermission from "@salesforce/apex/DX_SubmitServiceRequest_cls.getRecordTypesForUserPermission";
import CASE_OBJECT from "@salesforce/schema/Case";
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import ACCOUNT_OBJECT from "@salesforce/schema/Account";
import { getRecord } from "lightning/uiRecordApi";

import getCaseStatusValues from '@salesforce/apex/DX_SubmitServiceRequest_cls.getCaseStatusPicklistValues';
import getCaseTypePicklistValues from '@salesforce/apex/DX_SubmitServiceRequest_cls.getCaseTypePicklistValues';

const FIELDS = [
    "Case.OwnerId",
    "Case.CaseNumber",
    "Case.AccountId",
    "Case.Status",
    "Case.Priority",
    "Case.DX_Billing_Account_Number__c",
    "Case.DX_Xconnect_Order_Number__c",
    "Case.RecordTypeId",
    "Case.Type",
    "Case.DX_Site__c",
    "Case.DX_Reason_For_Hold__c",
    "Case.DX_Default_Account__c",
    "Case.DX_How_Help_You__c",
    "Case.DX_I_Accept__c",
    "Case.DX_Conditions__c",
    "Case.DX_Initiator_Title__c",
    "Case.DX_Order_Initiator__c",
    "Case.DX_Order_Date__c",
    "Case.DX_Requested_Due__c",
    "Case.DX_LOA_Attached__c",
    "Case.DX_Contract_Term__c",
    "Case.DX_Completion_Date__c",
    "Case.DX_Ports__c",
    "Case.DX_Tech_Contact_Name__c",
    "Case.DX_Cross_Connect_ID__c",
    "Case.DX_Rack_RU__c",
    "Case.DX_Connector_Type__c",
    "Case.DX_Tech_Contact_Tel__c",
    "Case.DX_Account_Name__c",
    "Case.DX_Site_Location__c",
    "Case.CreatedById",
    "Case.LastModifiedById",
];



export default class Dx_SubmitServiceRequest_lwc extends LightningElement {
    @api recordId;
    showRecordTypes = false;
    showFields = true;
    options = [];

    @track statusOptions = [];
    @track typesOptions = [];
    value;

    //Labels Fields Case
    OwnerId_lbl;
    CaseNumber_lbl;
    AccountId_lbl;
    Status_lbl;
    Priority_lbl;
    DX_Billing_Account_Number__c_lbl;
    DX_Xconnect_Order_Number__c_lbl;
    RecordTypeId_lbl;
    Type_lbl;
    DX_Site__c_lbl;
    DX_Reason_For_Hold__c_lbl;
    DX_Default_Account__c_lbl;
    DX_How_Help_You__c_lbl;
    DX_I_Accept__c_lbl;
    DX_Conditions__c_lbl;
    AccountId_lbl;
    DX_Initiator_Title__c_lbl;
    DX_Order_Initiator__c_lbl;
    DX_Order_Date__c_lbl;
    DX_Requested_Due__c_lbl;
    DX_LOA_Attached__c_lbl;
    DX_Contract_Term__c_lbl;
    DX_Completion_Date__c_lbl;
    DX_Ports__c_lbl;
    DX_Tech_Contact_Name__c_lbl;
    DX_Cross_Connect_ID__c_lbl;
    DX_Rack_RU__c_lbl;
    DX_Connector_Type__c_lbl;
    DX_Tech_Contact_Tel__c_lbl;
    DX_Account_Name__c_lbl;
    DX_Site_Location__c_lbl;
    CreatedById_lbl;
    LastModifiedById_lbl;

    //Value Fields Case
    OwnerId_value;
    CaseNumber_value;
    AccountId_value;
    Status_value;
    Priority_value;
    DX_Billing_Account_Number__c_value;
    DX_Xconnect_Order_Number__c_value;
    RecordTypeId_value;
    Type_value;
    DX_Site__c_value;
    DX_Reason_For_Hold__c_value;
    DX_Default_Account__c_value;
    DX_How_Help_You__c_value;
    DX_I_Accept__c_value;
    DX_Conditions__c_value;
    AccountId_value;
    DX_Initiator_Title__c_value;
    DX_Order_Initiator__c_value;
    DX_Order_Date__c_value;
    DX_Requested_Due__c_value;
    DX_LOA_Attached__c_value;
    DX_Contract_Term__c_value;
    DX_Completion_Date__c_value;
    DX_Ports__c_value;
    DX_Tech_Contact_Name__c_value;
    DX_Cross_Connect_ID__c_value;
    DX_Rack_RU__c_value;
    DX_Connector_Type__c_value;
    DX_Tech_Contact_Tel__c_value;
    DX_Account_Name__c_value;
    DX_Site_Location__c_value;
    CreatedById_value;
    LastModifiedById_value;

    //@wire(getRecord, { recordId: "$recordId", fields: FIELDS })
    @wire(getRecord, { recordId: "500VB00000BKUwTYAX", fields: FIELDS })
    recordInfo({ data, error }) {
        if (data) {
            //this.options = data;
        } else if (error) {

        }
    };

    handleClickNext(event) {
        console.log(event.target.label);
        this.showRecordTypes = false;
        this.showFields = true;
        console.log(this.propertyOrFunction);

    }
    handleChange(event) {
        const selectedOption = event.detail.value;
        console.log('Option selected with value: ' + selectedOption);
    }

    /*@wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    propertyOrFunction;*/

    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    caseInfo({ data, error }) {
        if (data) {
            var caseLabls = JSON.parse(JSON.stringify(data));
            console.log('data => ', data);
            console.log('data => ', caseLabls.fields.caseLabls);
            console.log(' =>OwnerId ', caseLabls.fields.OwnerId.label);

            this.OwnerId_lbl = data.fields.OwnerId.label;
            this.CaseNumber_lbl = data.fields.CaseNumber.label;
            this.AccountId_lbl = data.fields.AccountId.label;
            this.Status_lbl = data.fields.Status.label;
            this.Priority_lbl = data.fields.Priority.label;
            this.DX_Billing_Account_Number__c_lbl = data.fields.DX_Billing_Account_Number__c.label;
            this.DX_Xconnect_Order_Number__c_lbl = data.fields.DX_Xconnect_Order_Number__c.label;
            this.RecordTypeId_lbl = data.fields.RecordTypeId.label;
            this.Type_lbl = data.fields.Type.label;
            this.DX_Site__c_lbl = data.fields.DX_Site__c.label;
            this.DX_Reason_For_Hold__c_lbl = data.fields.DX_Reason_For_Hold__c.label;
            this.DX_Default_Account__c_lbl = data.fields.DX_Default_Account__c.label;
            this.DX_How_Help_You__c_lbl = data.fields.DX_How_Help_You__c.label;
            this.DX_I_Accept__c_lbl = data.fields.DX_I_Accept__c.label;
            this.DX_Conditions__c_lbl = data.fields.DX_Conditions__c.label;

            //Section A
            this.DX_Initiator_Title__c_lbl = data.fields.DX_Initiator_Title__c.label;
            this.DX_Order_Initiator__c_lbl = data.fields.DX_Order_Initiator__c.label;


            //Section B
            this.DX_Order_Date__c_lbl = data.fields.DX_Order_Date__c.label;
            this.DX_Requested_Due__c_lbl = data.fields.DX_Requested_Due__c.label;
            this.DX_LOA_Attached__c_lbl = data.fields.DX_LOA_Attached__c.label;
            this.DX_Contract_Term__c_lbl = data.fields.DX_Contract_Term__c.label;
            this.DX_Completion_Date__c_lbl = data.fields.DX_Completion_Date__c.label;

            //Section C
            this.DX_Ports__c_lbl = data.fields.DX_Ports__c.label;
            this.DX_Tech_Contact_Name__c_lbl = data.fields.DX_Tech_Contact_Name__c.label;
            this.DX_Cross_Connect_ID__c_lbl = data.fields.DX_Cross_Connect_ID__c.label;
            this.DX_Rack_RU__c_lbl = data.fields.DX_Rack_RU__c.label;
            this.DX_Connector_Type__c_lbl = data.fields.DX_Connector_Type__c.label;
            this.DX_Tech_Contact_Tel__c_lbl = data.fields.DX_Tech_Contact_Tel__c.label;

            //Section D
            this.DX_Account_Name__c_lbl = data.fields.DX_Account_Name__c.label;
            this.DX_Site_Location__c_lbl = data.fields.DX_Site_Location__c.label;

            //Section E
            this.CreatedById_lbl = data.fields.CreatedById.label;
            this.LastModifiedById_lbl = data.fields.LastModifiedById.label;

        } else if (error) {
            var result = JSON.parse(JSON.stringify(error));
        }
    };

    handleInputChange(event) {
        this.OwnerId_value = event.detail.value;
        console.log( event.detail.value );

        this.nameInputId = event.target.dataset.id; // Accessing the data-id attribute
        console.log('Input ID:', this.nameInputId);
    }

    handleSectionToggle(event) {
        const openSections = event.detail.openSections;

        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }

    @wire(getRecordTypesForUserPermission, {})
    getRecordTypes({ error, data }) {
        if (data) {
            this.options = data;
        } else if (error) {
            var result = JSON.parse(JSON.stringify(error));
        }
    };

    handleInputChange(event) {
        const field = event.target.label;
        if (field === 'Case ID') {
            this.caseId = event.target.value;
        } else if (field === 'Subject') {
            this.subject = event.target.value;
        } else if (field === 'Description') {
            this.description = event.target.value;
        } else if (field === 'Status') {
            this.status = event.target.value;
        }
    }

    handleUpsert() {
        const caseWrapper = {
            caseId: this.caseId,
            subject: this.subject,
            description: this.description,
            status: this.status
        };

        upsertCase({ caseWrapper })
            .then(() => {
                // Handle success
                console.log('Case upserted successfully.');
            })
            .catch(error => {
                // Handle error
                console.error('Error upserting case:', error);
            });
    }

    //status picklist
    @wire(getCaseStatusValues)
    wiredStatusOptions({ error, data }) {
        if (data) {
            this.statusOptions = data.map(status => {
                return { label: status, value: status };
            });
        } else if (error) {
            console.error(error);
        }
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    @wire(getCaseTypePicklistValues)
    wiredTypeOptions({ error, data }) {
        if (data) {
            this.typeOptions = data.map(types => {
                return { label: types, value: types };
            });
        } else if (error) {
            console.error(error);
        }
    }

}