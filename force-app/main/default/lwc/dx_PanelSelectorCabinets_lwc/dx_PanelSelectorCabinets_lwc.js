import { LightningElement, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import getFloors from "@salesforce/apex/DX_PanelSelectorCabinets_ctr.getFloors";
import getDataHalls from '@salesforce/apex/DX_PanelSelectorCabinets_ctr.getDataHalls';
import getCages from '@salesforce/apex/DX_PanelSelectorCabinets_ctr.getCages';
import getCabinets from '@salesforce/apex/DX_PanelSelectorCabinets_ctr.getCabinets';

export default class Dx_PanelSelectorCabinets_lwc extends LightningElement {
    @api buildingID;
    valueFloor = '';
    valueDataHall = '';
    valueCage = '';
    valueCabinet = '';
    optionsFloors = [];
    optionsDataHalls = [];
    optionsCages = [];
    optionsCabinets = [];
    @api cabinetId;

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
        getCages({ dataHallId: this.valueDataHall })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsCages = [...result];
                    }            
                    if(data.length === cero){
                        this.optionsCages = [{ label: 'No data...', value: '' }];
                    }
                }else if (error) {
                    console.log(error);
                }
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleChangeCages(event) {
        this.valueCage = event.detail.value;
        getCabinets({ cageId: this.valueCage })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsCabinets = [...result];
                    }            
                    if(data.length === cero){
                        this.optionsCabinets = [{ label: 'No data...', value: '' }];
                    }
                }else if (error) {
                    console.log(error);
                }
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleChangeCabinets(event) {
        this.valueCabinet = event.detail.value;
        this.cabinetId = this.valueCabinet;
        this.dispatchEvent(new FlowAttributeChangeEvent('cabinetId', this.cabinetId));
    }
}