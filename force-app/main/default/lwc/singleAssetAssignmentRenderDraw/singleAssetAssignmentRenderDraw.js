import { LightningElement, api } from 'lwc';

export default class SingleAssetAssignmentRenderDraw extends LightningElement {
    @api asset;
    @api hallId;
    @api floorId;
    @api buildingId;

    get assetType() {
        return this.asset.Type__c;
    }
    get isCabinet() {
        return this.assetType == 'Cabinet';
    }
    get isPanel() {
        return this.assetType == 'Panel';
    }
    get isRack() {
        return this.assetType == 'Rack';
    }

}