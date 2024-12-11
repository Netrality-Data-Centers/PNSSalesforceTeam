import { LightningElement, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import getFloors from "@salesforce/apex/DX_PanelSelectorRacks_ctr.getFloors";
import getDataHalls from '@salesforce/apex/DX_PanelSelectorRacks_ctr.getDataHalls';
import getMeetMeRooms from '@salesforce/apex/DX_PanelSelectorRacks_ctr.getMeetMeRooms';
import getRacks from '@salesforce/apex/DX_PanelSelectorRacks_ctr.getRacks';

export default class Dx_PanelSelectorRacks_lwc extends LightningElement {
    @api BuildingID;
    valueFloor = '';
    valueDataHall = '';
    valueMeetMeRoom = '';
    valueRack = '';
    optionsFloors = [];
    optionsDataHalls = [];
    optionsMeetMeRooms = [];
    optionsRacks = [];
    @api rackId;

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
        getMeetMeRooms({ dataHallId: this.valueDataHall })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsMeetMeRooms = [...result];
                    }            
                    if(data.length === cero){
                        this.optionsMeetMeRooms = [{ label: 'No data...', value: '' }];
                    }
                }else if (error) {
                    console.log(error);
                }
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleChangeMeetMeRooms(event) {
        this.valueMeetMeRoom = event.detail.value;
        getRacks({ meetMeRoomId: this.valueMeetMeRoom })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsRacks = [...result];
                    }            
                    if(data.length === cero){
                        this.optionsRacks = [{ label: 'No data...', value: '' }];
                    }
                }else if (error) {
                    console.log(error);
                }
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleChangeRacks(event) {
        this.valueRack = event.detail.value;
        this.rackId = this.valueRack;
        this.dispatchEvent(new FlowAttributeChangeEvent('rackId', this.rackId));
    }
    
}