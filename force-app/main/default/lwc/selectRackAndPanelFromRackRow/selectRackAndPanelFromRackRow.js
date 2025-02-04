import { LightningElement, api, track, wire } from 'lwc';
import getRacksForRackRow from '@salesforce/apex/CaseRelatedAssetSelectionController.getRacksForRackRow';
import getPanelsForRackRow from '@salesforce/apex/CaseRelatedAssetSelectionController.getPanelsForRackRow';
import { getPanelSceneSettings, generateUniqueId } from './settingsUtilities';
import LightningConfirm from 'lightning/confirm';
import { FlowNavigationBackEvent, FlowNavigationNextEvent, FlowNavigationFinishEvent } from "lightning/flowSupport";

export default class SelectRackAndPanelFromRackRow extends LightningElement {
    @track urlParams = {};
    queryParams;
    //pass this if we want to get a row of racks and panels for selection
    @track _recordId;
    @api get recordId() {
        return this._recordId;
    }
    set recordId(value) {
        this._recordId = value;
    }
    @api isSelection;
    @api desiredSelectionSizes;
    @track selectedSelectionSize;
    @track totalSizeToAllocate = 0;
    @track selectedPanelAssignmentItem;
    @track templateInteractionDefinition;
    @api templateId;
    @api hasSelection;
    @api selectedPanelAssignments;
    @api sourceAsset;
    @track racks;
    @track panels;
    @api allPanelsAssigned = false;
    @track columns = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Starting Position', fieldName: 'Starting_Position_RU__c', type: 'number' },
        { label: 'Height (RU)', fieldName: 'Height_RU__c', type: 'number' },
        { label: 'Rack', fieldName: 'Rack__c', type: 'text' }
    ];
    @track selectedPanelAssignmentIndex = 0;

    async connectedCallback() {

        if (this.isSelection && this.desiredSelectionSizes) {
            this.totalSizeToAllocate = this.desiredSelectionSizes.reduce((acc, curr) => acc + curr, 0);
            this.selectedPanelAssignments = this.desiredSelectionSizes.map((size) => {
                return {
                    StartingPosition: null,
                    Size: size,
                    RackId: null,
                    Asset: null
                };
            });
            this.selectedPanelAssignments[0].Asset = this.sourceAsset.Id;

            this.selectedPanelAssignmentItem = this.selectedPanelAssignments[0];
            this.selectedPanelAssignmentIndex = 0;
        }
        if (this.recordId) {
            this.templateInteractionDefinition = getPanelSceneSettings();
            this.getRacks();
            this.getPanels();

            await this.processRackRowCanvasScene();
        }
    }
    get hasselectedPanelAssignmentItem() {
        return this.isSelection && this.selectedPanelAssignmentItem != null;
    }
    async getRacks() {
        this.racks = await getRacksForRackRow({ rackRowId: this.recordId }).catch(error => {
            console.error(error);
        });
    }
    async getPanels() {
        this.panels = await getPanelsForRackRow({ rackRowId: this.recordId }).catch(error => {
            console.error(error);
        });
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
        if (!this.isSelection) {
            this.placedDraggableItemsWithRecords.find((itm) => { return itm.recordId == event.detail })
        }
    }
    handleElementClicked(event) {
        debugger;
        if (this.isSelection) {
            let result = JSON.parse(JSON.stringify(event.detail));
            if (result.name == "Vacant") {
                let rackCanvasId = result.droppableArea;
                let droppableAreaMap = this.placedDroppableAreasWithRecords.find(itm => itm.id == rackCanvasId);
                let rackId = droppableAreaMap.recordId;
                let rackName = this.racks.find(itm => itm.Id == rackId).Name;
                let droppableArea = this.droppableAreas.find(itm => itm.id == rackCanvasId);
                let itemsBeneath = droppableArea.draggableItems.filter((itm) => { return itm.orderIndex < result.orderIndex });
                // sum the items beneath height
                let startingPosition = itemsBeneath.reduce((acc, itm) => { return acc + itm.height }, 0);
                this.confirmPanelAssignment(rackName, rackId, startingPosition)
            }
            else
                this.publishMessageToUser("Please select an available Panel position marked Vacant", "error");
        }
    }
    publishMessageToUser(message, variant = "info") {
        let notificationComponent = this.template.querySelector('RDraw-local-notifications');
        if (notificationComponent) {
            notificationComponent.addNotification(message, variant);
        }
    }
    get allHaveSelected() {
        if (this.selectedPanelAssignments && this.selectedPanelAssignments.length > 0 && this.isSelection) {
            return this.selectedPanelAssignments.every((itm) => { return itm.RackId != null && itm.StartingPosition != null });
        }
        return false;
    }
    get percentComplete() {
        if (this.selectedPanelAssignments && this.selectedPanelAssignments.length > 0 && this.isSelection) {
            return (this.selectedPanelAssignments.filter(itm => itm.RackId != null && itm.StartingPosition != null).length / this.selectedPanelAssignments.length) * 100;
        }
        return 0;
    }
    async handleSave() {
        console.log("save");
        let message = "Are you sure you want to save the panel assignments?";
        let submessage = "This will save the panel assignments and create new Assets, this cannot be undone.";
        let confirm = await LightningConfirm.open({
            message: submessage,
            variant: "header",
            label: message
        });
        if (confirm) {
            this.confirmAndMoveToNextStep();
        }
    }
    confirmAndMoveToNextStep() {
        debugger;
        this.allPanelsAssigned = true;
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }
    get hasTemplateInteractionDefinition() {
        return this.templateInteractionDefinition != null;
    }

    get hasRackRowCalculatedCanvasScene() {
        return this.rackRowCalculatedCanvasScene != null;
    }
    @track rackRowCalculatedCanvasScene = null;

    getTemplateForDroppableArea(size) {
        let template = this.templateInteractionDefinition.droppableAreaTemplates.find(itm => itm.name.replace("U", "") == size);
        return template;
    }
    getTemplateForDraggableItem(size, available = false) {
        let label = size + (available ? "-Available" : "-Unavailable");
        let template = this.templateInteractionDefinition.draggableItemTemplates.find(itm => itm.name == label);
        return template;
    }
    panelSizes = [1, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48];
    rackSizes = [40, 42, 43, 44, 45, 48];
    generatePlacedDropplableArea(templateId, name, recordId, width = 12, height = 48) {
        let droppableArea = {
            draggableItems: [],
            id: generateUniqueId(),
            name: name,
            recordId: recordId,
            templateId: templateId
        }
        return droppableArea;
    }
    async confirmPanelAssignment(rackName, rackId, startingPosition) {
        //use lightning confirm to confirm the assignment
        let confirm = await LightningConfirm.open({
            message: "Are you sure you want to assign this panel to " + rackName + " at position " + startingPosition + "?",
            variant: "header",
            label: "Confirm"
        });
        if (confirm) {
            this.selectedPanelAssignmentItem.RackId = rackId;
            this.selectedPanelAssignmentItem.StartingPosition = startingPosition;
            this.selectedPanelAssignmentIndex++
            this.selectedPanelAssignmentItem = this.selectedPanelAssignments[this.selectedPanelAssignmentIndex];
        }
    }
    generatePlacedDraggableItem(templateId, name, recordId, width = 10, height = 1) {
        let draggableItem = {
            id: generateUniqueId(),
            name: name,
            recordId: recordId,
            value: recordId,
            x: 0,
            y: 0,
            length: 0,
            labelText: name,
            width: width,
            height: height,
            rotation: 0,
            templateId: templateId
        }
        return draggableItem;
    }
    clearCanvas() {
        let canvas = this.template.querySelector('RDraw-canvas2-d');
        if (canvas) {
            for (let i = 0; i < this.placedDraggableItemsWithRecords.length; i++) {
                let draggableItem = this.placedDraggableItemsWithRecords[i];
                canvas.removeElement({ id: draggableItem.id });
            }
            for (let i = 0; i < this.placedDroppableAreasWithRecords.length; i++) {
                let droppableArea = this.placedDroppableAreasWithRecords[i];
                canvas.removeElement({ id: droppableArea.id });
            }
        }
    }
    async processRackRowCanvasScene() {
        if (this.canvasLoaded) {
            let racks = this.racks;
            let panels = this.panels;
            let droppableAreas = [];
            for (const rack of racks) {
                let size = rack.Number_of_Rack_Units__c;
                let rackTemplate = this.getTemplateForDroppableArea(size);
                let panelsForRack = panels.filter(itm => itm.Rack__c == rack.Id);
                let droppableArea = this.generatePlacedDropplableArea(rackTemplate.id, rack.Name, rack.Id, rackTemplate.width, rackTemplate.height);
                // sort the panels for rack by Starting_Position__c
                panelsForRack = panelsForRack.sort((a, b) => a.Starting_Position_RU__c - b.Starting_Position_RU__c);
                let orderIndex = 0;
                //find the max panelSize that will fit before the next panel, if we touch the panel, look at it's Height_RU__c and get the template, add it and then continue until the size is populated
                let currentPosition = 0;
                while (currentPosition < size) {
                    let panel = panelsForRack.find(itm => itm.Starting_Position_RU__c > currentPosition);

                    if (panel) {

                        // Calculate space until next panel
                        let spaceUntilPanel = panel.Starting_Position_RU__c - currentPosition;

                        // Find largest template that fits in space
                        let maxTemplateSize = Math.max(...this.panelSizes.filter(s => s <= spaceUntilPanel));
                        if (this.isSelection && this.selectedPanelAssignmentItem.Size)
                            maxTemplateSize = this.selectedPanelAssignmentItem.Size;
                        if (maxTemplateSize) {
                            // Add template for empty space
                            let emptyTemplate = this.getTemplateForDraggableItem(maxTemplateSize, true);
                            let draggableItem = this.generatePlacedDraggableItem(emptyTemplate.id, 'Vacant', '', emptyTemplate.width, emptyTemplate.height);
                            draggableItem.orderIndex = orderIndex;
                            droppableArea.draggableItems.push(draggableItem);
                            currentPosition += maxTemplateSize;
                            orderIndex = orderIndex + 1;
                        }
                        // Add template for panel
                        let panelTemplate = this.getTemplateForDraggableItem(panel.Height_RU__c, false);
                        let draggableItem = this.generatePlacedDraggableItem(panelTemplate.id, panel.Name, panel.Id, panelTemplate.width, panelTemplate.height);
                        draggableItem.orderIndex = orderIndex;
                        droppableArea.draggableItems.push(draggableItem);
                        currentPosition += panel.Height_RU__c;
                        orderIndex = orderIndex + 1;
                    } else {
                        // No more panels, fill remaining space
                        let remainingSpace = size - currentPosition;
                        let maxTemplateSize = Math.max(...this.panelSizes.filter(s => s <= remainingSpace));

                        if (maxTemplateSize) {
                            let emptyTemplate = this.getTemplateForDraggableItem(maxTemplateSize, true);
                            let draggableItem = this.generatePlacedDraggableItem(emptyTemplate.id, 'Vacant', '', emptyTemplate.width, emptyTemplate.height);
                            draggableItem.orderIndex = orderIndex;
                            droppableArea.draggableItems.push(draggableItem);
                            currentPosition += maxTemplateSize;
                            orderIndex = orderIndex + 1;
                        } else {
                            // Can't fit any more templates
                            break;
                        }
                    }
                }
                droppableAreas.push(droppableArea);
            }
            this.droppableAreas = droppableAreas;
            await this.addDroppableAreasAndItemsToCanvas();
        }
        else {
            this.pendingProcessRackRowCanvasScene = true;
        }
    }
    @track droppableAreas = [];
    async addDroppableAreasAndItemsToCanvas() {
        let canvas = this.template.querySelector('RDraw-canvas2-d');
        if (canvas) {

            for (let i = 0; i < this.droppableAreas.length; i++) {
                let droppableArea = this.droppableAreas[i];
                await new Promise(async (resolve, reject) => {
                    try {
                        // droppableArea.draggableItems.forEach((itm, index) => {
                        //     itm.orderIndex = droppableArea.draggableItems.length - 1 - index;
                        // });
                        let draggableItems = droppableArea.draggableItems;
                        droppableArea.draggableItems = [];
                        droppableArea.draggable = false;
                        let areaAdded = await canvas.addDroppableArea(droppableArea);
                        droppableArea.draggableItems = draggableItems;
                        if (droppableArea.recordId)
                            this.placedDroppableAreasWithRecords.push({ recordId: droppableArea.recordId, id: areaAdded.id });
                        let areaId = areaAdded.id;
                        //order the draggable items by orderIndex
                        draggableItems = draggableItems.sort((a, b) => a.orderIndex - b.orderIndex);
                        for (const itm of draggableItems) {
                            itm.x = areaAdded.x;
                            itm.y = areaAdded.y + itm.orderIndex;
                            itm.labelFontSize = 60;
                            itm.isDraggable = false;
                            itm.parentAreaId = areaId;
                            console.log('adding draggable item', itm);
                            // console.log('item.orderIndex:' + itm.orderIndex);
                            let draggableItemAdded = await canvas.addDraggableItem(itm);
                            if (itm.recordId)
                                this.placedDraggableItemsWithRecords.push({ recordId: itm.recordId, id: draggableItemAdded.id });

                            console.log(draggableItemAdded);
                        }
                        this.currentItemOnCanvas = await canvas.getItemsOnCanvas();
                        resolve();
                    } catch (error) {
                        reject(error);
                    }
                });
            }
        }
    }
    @track placedDroppableAreasWithRecords = [];
    @track placedDraggableItemsWithRecords = [];
    getCanvasIdFromRecordId(recordId, canvasType) {
        let currentItemOnCanvas = JSON.parse(JSON.stringify(this.currentItemOnCanvas));
        if (currentItemOnCanvas) {
            if (canvasType == "Rack") {
                let rack = currentItemOnCanvas.placedDroppableAreas.find
            }
            else if (canvasType == "Panel") {

            }
        }

    }
    @track currentItemOnCanvas = null;
    get canvasClass() {
        return this.hasSelection ? 'canvas-with-sidebar' : '';
    }

    renderedCallback() {
        this.toggleSidebar();
    }

    toggleSidebar() {
        const sidebar = this.template.querySelector('.sidebar');
        if (sidebar) {
            if (this.hasSelection) {
                sidebar.classList.add('open');
            } else {
                sidebar.classList.remove('open');
            }
        }
    }
    get canvasSize() {
        if (this.isSelection && this.hasSelection || !this.isSelection) {
            return 8;
        }
        return 12;
    }
    get sidebarSize() {
        if (this.isSelection && this.hasSelection || !this.isSelection) {
            return 4;
        }
        return 0;
    }
    handlePanelHover(event) {
        let panelId = event.currentTarget.dataset.panel;
        let jointObject = this.placedDraggableItemsWithRecords.find(itm => itm.recordId == panelId);
        if (jointObject) {
            let id = jointObject.id;
            let canvas = this.template.querySelector('RDraw-canvas2-d');
            if (canvas) {
                let flashParameters = {
                    id: id
                };
                canvas.flashAndMoveToElementByRecord({ flashParameters })
            }
        }
    }
}