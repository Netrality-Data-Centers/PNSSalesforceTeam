import { LightningElement, api, track, wire } from 'lwc';
import getRackRowTemplateInteractionDefinition from '@salesforce/apex/CaseRelatedAssetSelectionController.getRackRowTemplateInteractionDefinition';
import getCanvasSceneForRackRow from '@salesforce/apex/CaseRelatedAssetSelectionController.getCanvasSceneForRackRow';
export default class SelectRackFromRackRow extends LightningElement {
    @track urlParams = {};
    queryParams;
    //pass this if we want to get a row of racks and panels for selection
    @track _rackRowId;
    @api get rackRowId() {
        return this._rackRowId;
    }
    set rackRowId(value) {
        this._rackRowId = value;
    }
    @api rackId; //pass this if we want to get a specific rack and its panels for selection
    @api isSelection;
    @api desiredSelectionSize;
    @track templateInteractionDefinition;
    @api templateId;
    @api hasSelection;

    async connectedCallback() {

        debugger;
        // this.getURLParameters();
        // this.rackRowId = this.urlParams.rackRowId;
        // this.rackId = this.urlParams.rackId;
        // this.isSelection = this.urlParams.isSelection;
        // this.desiredSelectionSize = this.urlParams.desiredSelectionSize;
        if (this.rackRowId) {
            await this.getRackRowTemplateInteractionDefinition();
            await this.getSceneSettingsForRackRow();
            await this.processRackRowCanvasScene();
        } else if (this.rackId) {
            debugger;
        }
    }
    @track canvasLoaded = false;
    handleCanvasLoaded() {
        this.canvasLoaded = true;
        if (this.pendingProcessRackRowCanvasScene) {
            this.processRackRowCanvasScene();
        }
    }
    handleElementHovered(event) {
        console.log(event.detail + "hovered");
    }
    handleElementClicked(event) {
        debugger;
    }
    getURLParameters() {
        this.urlParams = {};

        const url = new URL(window.location.href);

        // Get the query string parameters
        const urlParameters = new URLSearchParams(url.search);

        // Example: Iterate over all parameters
        urlParameters.forEach((value, key) => {
            this.urlParams[key] = value;
        });
    }
    get hasTemplateInteractionDefinition() {
        return this.templateInteractionDefinition != null;
    }
    getRackRowTemplateInteractionDefinition() {
        let param = { rackRowId: this.rackRowId };
        return new Promise((resolve, reject) => {
            getRackRowTemplateInteractionDefinition(param).then(result => {
                this.templateInteractionDefinition = JSON.parse(result.RDraw__Settings__c);
                resolve();
            }).catch(error => {
                reject(error);
            });
        });
    }

    get hasRackRowCalculatedCanvasScene() {
        return this.rackRowCalculatedCanvasScene != null;
    }
    @track rackRowCalculatedCanvasScene = null;
    getSceneSettingsForRackRow() {
        return new Promise((resolve, reject) => {
            let param = { rackRowId: this.rackRowId };
            getCanvasSceneForRackRow(param).then(result => {
                debugger;

                this.rackRowCalculatedCanvasScene = result;
                resolve();
                //iterate over the result 
            }).catch(error => {
                reject(error);
            });
        });
    }
    async processRackRowCanvasScene() {
        debugger;
        if (this.canvasLoaded) {
            let canvas = this.template.querySelector('RDraw-canvas2-d');
            let droppableAreas = JSON.parse(JSON.stringify(this.rackRowCalculatedCanvasScene.placedDroppableAreas));
            for (const droppableArea of droppableAreas) {
                await new Promise(async (resolve, reject) => {
                    try {
                        droppableArea.draggableItems.forEach((itm, index) => {
                            itm.orderIndex = droppableArea.draggableItems.length - 1 - index;
                        });
                        let draggableItems = droppableArea.draggableItems;
                        droppableArea.draggableItems = [];
                        let areaAdded = await canvas.addDroppableArea(droppableArea);
                        let areaId = areaAdded.id;
                        for (const itm of draggableItems) {
                            itm.parentAreaId = areaId;
                            canvas.addDraggableItem(itm);
                        }
                        resolve();
                    } catch (error) {
                        reject(error);
                    }
                });
            }
        }
        else {
            this.pendingProcessRackRowCanvasScene = true;
        }
    }
    get canvasClass() {
        return this.hasSelection ? 'canvas-with-sidebar' : '';
    }

    renderedCallback() {
        this.toggleSidebar();
    }

    toggleSidebar() {
        const sidebar = this.template.querySelector('.sidebar');
        if (this.hasSelection) {
            sidebar.classList.add('open');
        } else {
            sidebar.classList.remove('open');
        }
    }
}