import { LightningElement, api, track } from 'lwc';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
import getRelatedAssets from '@salesforce/apex/CaseRelatedAssetSelectionController.getRelatedAssets';

const COLUMNS = [
    { label: 'Asset Name', fieldName: 'Name' },
    // { label: 'Serial Number', fieldName: 'SerialNumber' },
    { label: 'Status', fieldName: 'Status' },
    // { label: 'Product', fieldName: 'Product2Name' },
    { label: 'Asset Type', fieldName: 'Asset_Type__c' }
];

export default class CaseRelatedAssetSelectionForAssignment extends LightningElement {
    @api caseId;
    @api selectedAssets = [];
    @api numberOfSelectedAssets = 0;
    caseName;
    assets = [];
    columns = COLUMNS;
    error;

    unlocatedAssets = [];
    locatedAssets = [];
    @track selectedUnlocatedAssets = [];
    @track selectedLocatedAssets = [];

    connectedCallback() {
        this.loadAssets();
    }

    async loadAssets() {
        try {
            console.log('Loading assets for case:', this.caseId);
            const data = await getRelatedAssets({ caseId: this.caseId });
            console.log('Received data:', JSON.stringify(data));
            if (data) {
                this.assets = data.assets.map(asset => ({
                    Id: asset.Id,
                    Name: asset.Name,
                    SerialNumber: asset.SerialNumber,
                    Status: asset.Status,
                    Product2Name: asset.Product2?.Name || '',
                    Asset_Location__c: asset.Asset_Location__c,
                    Asset_Type__c: asset.Asset_Type__c
                }));
                this.caseName = data.caseName;
                this.filterAssets();
            }
        } catch (error) {
            console.error('Error loading assets:', error);
            this.error = error;
            this.assets = [];
            this.caseName = undefined;
        }
    }

    get hasAssets() {
        return this.assets && this.assets.length > 0;
    }

    get cardTitle() {
        return `Related Assets to ${this.caseName || 'Service Request'}`;
    }

    filterAssets() {
        this.unlocatedAssets = this.assets.filter(asset => !asset.Asset_Location__c);
        this.locatedAssets = this.assets.filter(asset => asset.Asset_Location__c);
    }

    handleUnlocatedSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedUnlocatedAssets = [...selectedRows];
        console.log('Selected unlocated assets:', JSON.stringify(this.selectedUnlocatedAssets));
    }

    handleLocatedSelection(event) {
        const selectedRows = event.detail.selectedRows;
        this.selectedLocatedAssets = [...selectedRows];
        console.log('Selected located assets:', JSON.stringify(this.selectedLocatedAssets));
    }

    get isNextButtonDisabled() {
        const totalSelections = (this.selectedUnlocatedAssets?.length || 0) +
            (this.selectedLocatedAssets?.length || 0);
        return totalSelections === 0;
    }

    handleNext() {
        this.validateSelection();
    }
    get hasSelectedAssets() {
        return this.numberOfSelectedAssets > 0;
    }
    get numberOfSelectedAssets() {
        return [...this.selectedUnlocatedAssets, ...this.selectedLocatedAssets].length;
    }
    validateSelection() {
        const selectedAssets = [...this.selectedUnlocatedAssets, ...this.selectedLocatedAssets];
        this.selectedAssets = selectedAssets;
        this.numberOfSelectedAssets = this.selectedAssets.length;
        // Dispatch FlowNavigationNextEvent
        if (selectedAssets.length > 0) {
            const navigateNextEvent = new FlowNavigationNextEvent();
            this.dispatchEvent(navigateNextEvent);
        }
    }
}