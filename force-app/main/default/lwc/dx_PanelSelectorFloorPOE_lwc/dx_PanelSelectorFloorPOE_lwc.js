import { LightningElement, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import getFloors from "@salesforce/apex/DX_PanelSelectorFloorPOE_ctr.getFloors";
import getPOES from '@salesforce/apex/DX_PanelSelectorFloorPOE_ctr.getPOES';

export default class Dx_PanelSelectorFloorPOE_lwc extends LightningElement {
    @api buildingID;
    valueFloor = '';
    valuePOE = '';
    optionsFloors = [];
    optionsPOES = [];
    @api floorId;
    @api pOEId;

    @wire(getFloors, {buildingId: "$buildingID"})
    wiredFloors({ error, data }) {
        if (data) {
            const cero = 0;
            let result = null;
            if(data.length > cero){
                result = JSON.parse(JSON.stringify(data));
                this.optionsFloors = [...result];
            }            
            if(data.length === cero){
                this.optionsFloors = [{ label: 'No data...', value: '' }];
            }
        } else if (error) {
            console.log(error);
        }
    }

    handleChangeFloors(event) {
        this.valueFloor = event.detail.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('floorId', this.valueFloor));

        getPOES({ floorId: this.valueFloor })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsPOES = [...result];
                    }            
                    if(data.length === cero){
                        this.optionsPOES = [{ label: 'No data...', value: '' }];
                    }
                }else if (error) {
                    console.log(error);
                }
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleChangePOES(event) {
        this.valuePOE = event.detail.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('pOEId', this.valuePOE));
    }
}