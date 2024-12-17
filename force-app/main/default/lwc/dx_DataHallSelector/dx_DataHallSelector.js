import { LightningElement, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import getFloors from "@salesforce/apex/DX_PanelSelectorRacks_ctr.getFloors";
import getDataHalls from '@salesforce/apex/DX_PanelSelectorRacks_ctr.getDataHalls';

export default class Dx_DataHallSelector extends LightningElement {
    @api BuildingID;
    valueFloor = '';
    valueDataHall = '';
    optionsFloors = [];
    optionsDataHalls = [];
    @api selectedDataHallID;

    @wire(getFloors, {buildingId: "$BuildingID"})
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
        getDataHalls({ floorId: this.valueFloor })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsDataHalls = [...result];
                    }            
                    if(data.length === cero){
                        this.optionsDataHalls = [{ label: 'No data...', value: '' }];
                    }
                }else if (error) {
                    console.log(error);
                }
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleChangeDataHalls(event) {
        this.valueDataHall = event.detail.value;
        this.selectedDataHallID = this.valueDataHall;
        this.dispatchEvent(new FlowAttributeChangeEvent('selectedDataHallID', this.selectedDataHallID));
    }
}