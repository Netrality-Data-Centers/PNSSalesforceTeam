import { api, LightningElement, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import modaloverride from "@salesforce/resourceUrl/RDraw__modaloverride";
import { FlowNavigationNextEvent } from 'lightning/flowSupport';
export default class MultiAssetAssignment extends LightningElement {
    @api assets;
    @api hallId;
    @api hallName
    @api floorId;
    @api floorName
    @api buildingId
    @api buildingName
    @track cabinetId
    @track cageId
    @track panelId
    @track cabinetName
    @track cageName
    @track panelName
    @api
    lightningFlow = 'Asset_Assignment';

    @track isBusy = true;
    // Validate that lightningFlow is provided
    get hasLightningFlow() {
        return this.lightningFlow && this.lightningFlow.trim().length > 0;
    }
    // Map to store asset-to-location mappings
    assetLocations = new Map();

    // Track selected location
    selectedLocation = null;

    // Getter to check if save should be disabled
    get isSaveDisabled() {
        return !this.selectedLocation || !this.assetLocations.size;
    }
    // ... existing imports and class declaration ...

    // Add these properties
    currentAssetIndex = 0;

    // Getters for asset navigation
    get selectedAsset() {
        return this.assets ? this.assets[this.currentAssetIndex] : null;
    }

    get isFirstAsset() {
        return this.currentAssetIndex === 0;
    }

    get isLastAsset() {
        return this.currentAssetIndex === (this.assets?.length - 1);
    }
    get allAssetsAssigned() {
        return this.assets?.every(asset => asset.isAssigned);
    }
    // Getters for progress tracking
    get assignedCount() {
        return this.assets?.filter(asset => asset.isAssigned).length || 0;
    }

    get totalAssets() {
        return this.assets?.length || 0;
    }

    get progressPercentage() {
        return Math.round((this.assignedCount / this.totalAssets) * 100) || 0;
    }

    get progressStyle() {
        return `transform: rotate(${this.progressPercentage * 3.6}deg)`;
    }

    get progressPath() {
        const x = Math.cos((this.progressPercentage * 3.6 - 90) * Math.PI / 180);
        const y = Math.sin((this.progressPercentage * 3.6 - 90) * Math.PI / 180);
        return this.progressPercentage > 50
            ? `M 0 0 v -1 A 1 1 0 ${this.progressPercentage > 75 ? 1 : 0} 1 ${x} ${y} z`
            : `M 0 0 v -1 A 1 1 0 0 1 ${x} ${y} z`;
    }

    // Navigation methods
    handlePreviousAsset() {
        if (!this.isFirstAsset) {
            this.isBusy = true;
            this.currentAssetIndex--;
            setTimeout(() => {
                this.isBusy = false;
            }, 500);
        }
    }

    handleNextAsset() {
        if (!this.isLastAsset) {
            this.isBusy = true;
            this.currentAssetIndex++;
            setTimeout(() => {
                this.isBusy = false;
            }, 500);
        } else {
            if (this.allAssetsAssigned) {
                this.celebrateCompletion();
            }
        }
    }
    @api celebrateOnAllAssetsAssigned = false;
    celebrateCompletion() {
        if (this.celebrateOnAllAssetsAssigned) {
            let relatedEmojis = '🗄️⚡🖥️🧑‍💻💾🛜🔒📈';
            let notificationComponent = this.template.querySelector('RDraw-local-notifications');
            if (notificationComponent) {
                notificationComponent.addConfetti("medium", "normal", "emoji", relatedEmojis);
            }
        }
    }
    @track _flowInputVariables = [
        { name: 'recordId', type: 'String', isSelected: true, value: this.selectedAsset?.Id, hideInPillsList: true },
        { name: 'buildingId', type: 'String', isSelected: true, value: this.buildingId, label: 'Building: ' + this.buildingName },
        { name: 'floorId', type: 'String', isSelected: true, value: this.floorId, label: 'Floor: ' + this.floorName },
        { name: 'dataHallId', type: 'String', isSelected: true, value: this.hallId, label: 'Data Hall: ' + this.hallName },
        { name: 'cabinetId', type: 'String', isSelected: false, value: this.cabinetId, label: 'Cabinet: ' + this.cabinetName },
        { name: 'cageId', type: 'String', isSelected: false, value: this.cageId, label: 'Cage: ' + this.cageName },
        { name: 'panelId', type: 'String', isSelected: false, value: this.panelId, label: 'Panel: ' + this.panelName }
    ]
    get flowInputVariables() {
        let inptVariables = this._flowInputVariables;
        inptVariables.forEach(variable => {
            switch (variable.name) {
                case 'recordId':
                    variable.value = this.selectedAsset?.Id;
                    variable.label = 'Asset: ' + this.selectedAsset?.Name;
                    break;
                case 'buildingId':
                    variable.value = this.buildingId;
                    variable.label = 'Building: ' + this.buildingName;
                    break;
                case 'floorId':
                    variable.value = this.floorId;
                    variable.label = 'Floor: ' + this.floorName;
                    break;
                case 'dataHallId':
                    variable.value = this.hallId;
                    variable.label = 'Data Hall: ' + this.hallName;
                    break;
                case 'cabinetId':
                    variable.value = this.cabinetId;
                    variable.label = 'Cabinet: ' + this.cabinetName;
                    break;
                case 'cageId':
                    variable.value = this.cageId;
                    variable.label = 'Cage: ' + this.cageName;
                    break;
                case 'panelId':
                    variable.value = this.panelId;
                    variable.label = 'Panel: ' + this.panelName;
                    break;
                default:
                    break;
            }
        });
        return inptVariables;
    }
    get selectedFlowInputVariablesForPills() {
        return this.flowInputVariables.filter(variable => variable.isSelected && !variable.hideInPillsList);
    }
    get selectedFlowInputVariables() {
        return this.flowInputVariables.filter(variable => variable.isSelected);
    }
    get selectedFormattedFlowInputVariables() {
        return this.selectedFlowInputVariables.map(variable => {
            return {
                name: variable.name,
                type: variable.type,
                value: variable.value,
            }
        });
    }
    handlePillRemove(event) {
        const pillName = event.detail.name;
        const pillToRemove = this.flowInputVariables.find(variable => variable.name === pillName);
        if (pillToRemove) {
            pillToRemove.isSelected = false;
        }
    }
    // Save method
    handleSave() {
        // Dispatch event with mapped assets
        const mappedAssets = Array.from(this.assetLocations.entries()).map(([assetId, location]) => ({
            assetId,
            location
        }));

        this.dispatchEvent(new CustomEvent('assetmapping', {
            detail: mappedAssets
        }));
        // Move to the next step in the flow
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    constructor() {
        super();
        debugger;
    }
    // Initialize assets with assignment tracking
    connectedCallback() {
        debugger;
        loadStyle(this, modaloverride).then(() => {
            if (this.assets) {
                this.assets = this.assets
                    .map(asset => ({
                        ...asset,
                        isAssigned: false
                    }))
                    .sort((a, b) => {
                        const priorityTypes = ['Cage', 'Cabinet', 'Panel'];
                        const aPriority = priorityTypes.includes(a.Asset_Type__c) ? 0 : 1;
                        const bPriority = priorityTypes.includes(b.Asset_Type__c) ? 0 : 1;
                        if (aPriority !== bPriority) {
                            return aPriority - bPriority;
                        }
                        return a.Asset_Type__c.localeCompare(b.Asset_Type__c);
                    });

            }
            this.isBusy = false;
        });
    }
    // Handle flow finish event
    handleFlowStatusChange(event) {
        if (event.detail.status !== 'STARTED' && event.detail.status !== 'ERROR' && event.detail.status !== 'PAUSED') {
            debugger;
            this.isBusy = true;
            let cabinetId = event.detail?.outputVariables?.find((elem) => { return elem.name == 'cabinetId' })?.value
            let cageId = event.detail?.outputVariables?.find((elem) => { return elem.name == 'cageId' })?.value;
            let cabinetName = event.detail?.outputVariables?.find((elem) => { return elem.name == 'cabinetName' })?.value;
            let cageName = event.detail?.outputVariables?.find((elem) => { return elem.name == 'cageName' })?.value;
            if (cabinetId && cabinetName) {
                this.cabinetId = cabinetId;
                this.cabinetName = cabinetName;
                let flowInputVariables = [...this.flowInputVariables];
                let cabinetVariable = flowInputVariables.find(variable => variable.name === 'cabinetId');
                if (cabinetVariable) {
                    cabinetVariable.isSelected = true;
                }
                this._flowInputVariables = flowInputVariables;
            }
            if (cageId && cageName) {
                this.cageId = cageId;
                this.cageName = cageName;
                let flowInputVariables = [...this.flowInputVariables];
                let cageVariable = flowInputVariables.find(variable => variable.name === 'cageId');
                if (cageVariable) {
                    cageVariable.isSelected = true;
                }
                this._flowInputVariables = flowInputVariables;
            }
            this.publishMessageToUser('Asset was allocated successfully', 'success');
            if (this.selectedAsset) {
                this.selectedAsset.isAssigned = true;
            }

            // Move to next unassigned asset if available
            if (!this.isLastAsset) {
                this.handleNextAsset();
            }
            else {
                if (this.allAssetsAssigned) {
                    this.celebrateCompletion();
                }
                else {
                    // find the asset that is not assigned
                    let unassignedAsset = this.assets.find(asset => !asset.isAssigned);
                    if (unassignedAsset) {
                        this.isBusy = true;
                        this.currentAssetIndex = this.assets.indexOf(unassignedAsset);
                        setTimeout(() => {
                            this.isBusy = false;
                        }, 500);
                    }
                }
            }
        } else if (event.detail.status === 'ERROR') {
            this.publishMessageToUser('Error allocating asset', 'error');
        }
    }
    publishMessageToUser(message, variant = "info") {
        let notificationComponent = this.template.querySelector('RDraw-local-notifications');
        if (notificationComponent) {
            notificationComponent.addNotification(message, variant);
        }
    }

    // // Handle mapping an asset to the selected location
    // handleAssetMapRequest(event) {
    //     const assetId = event.currentTarget.dataset.id;
    //     if (this.selectedLocation) {
    //         // Add to map
    //         this.assetLocations.set(assetId, this.selectedLocation);

    //         // Update asset status
    //         const asset = this.assets.find(a => a.Id === assetId);
    //         if (asset) {
    //             asset.isAssigned = true;
    //         }
    //     }
    // }

    // Handle when a location is selected on the map
    handleLocationSelect(event) {
        this.selectedLocation = event.detail;
    }
    /* 
        For the list of assets, we want to see the visual using the RDraw-canvas2-d component and listen for 
    */
}