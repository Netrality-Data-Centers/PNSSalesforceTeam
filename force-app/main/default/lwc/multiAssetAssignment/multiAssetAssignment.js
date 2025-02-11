import { api, LightningElement, track } from 'lwc';

export default class MultiAssetAssignment extends LightningElement {
    @api
    assets;
    @api
    hallId;
    @api
    floorId;
    @api
    buildingId
    @api
    lightningFlow = 'Asset_Assignment';
    get flowInputVariables() {
        return [
            { name: 'buildingId', type: 'String', value: this.buildingId },
            { name: 'dataHallId', type: 'String', value: this.hallId },
            { name: 'floorId', type: 'String', value: this.floorId },
            { name: 'recordId', type: 'String', value: this.selectedAsset?.Id }
        ];
    }
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
            this.currentAssetIndex--;
        }
    }

    handleNextAsset() {
        if (!this.isLastAsset) {
            this.isBusy = true;
            this.currentAssetIndex++;
            this.isBusy = false;
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
    }


    // Initialize assets with assignment tracking
    connectedCallback() {
        if (this.assets) {
            this.assets = this.assets.map(asset => ({
                ...asset,
                isAssigned: false
            }));
        }
    }
    // Handle flow finish event
    handleFlowStatusChange(event) {
        if (event.detail.status === 'FINISHED') {
            // Mark current asset as assigned
            if (this.selectedAsset) {
                this.selectedAsset.isAssigned = true;
            }

            // Move to next unassigned asset if available
            if (!this.isLastAsset) {
                this.handleNextAsset();
            }
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