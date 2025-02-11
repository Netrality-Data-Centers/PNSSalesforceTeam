import { LightningElement, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import getFloors from "@salesforce/apex/DX_PanelSelectorCabinets_ctr.getFloors";
import getDataHalls from '@salesforce/apex/DX_PanelSelectorCabinets_ctr.getDataHalls';
import getCages from '@salesforce/apex/DX_PanelSelectorCabinets_ctr.getCages';
import getCabinets from '@salesforce/apex/DX_PanelSelectorCabinets_ctr.getCabinets';

export default class Dx_PanelSelectorCabinets_lwc extends LightningElement {
    @api buildingID;
    @api floorID;
    @api datHallID;
    @api cageID;
    
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
                this.optionsFloors = [{ label: 'choose one...', value: '' },...result];
               console.log("Test");
                //prefilling value from flow
                if(this.floorID){

                    // makes sure the pre-selection belongs to the same building
                    let prefilled = this.optionsFloors.find(item => item.value === this.floorID);
                    this.floorID =  prefilled ? prefilled.value:'';

                    //executes handleChangeFloors method
                    let input = this.template.querySelector('[data-name="Floors"]');
                    input.dispatchEvent(new CustomEvent('change', {detail: {value: this.floorID}}));
                }
               
            }            
            if(data.length === cero){
                this.optionsFloors = [{ label: 'No data...', value: '' }];

                //executes handleChangeFloors method
                let input = this.template.querySelector('[data-name="Floors"]');
                input.dispatchEvent(new CustomEvent('change', {detail: {value: ''}}));
            }
        } else if (error) {
            console.log(error);
        }
    }

    handleChangeFloors(event) {
        this.floorID = event.detail.value;
        getDataHalls({ floorId: this.floorID })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsDataHalls = [{ label: 'choose one...', value: '' },...result];

                        //prefilling value from flow
                        if(this.datHallID){

                            // makes sure the pre-selection belongs to the same building
                            let prefilled = this.optionsDataHalls.find(item => item.value === this.datHallID);
                            this.datHallID =  prefilled ? prefilled.value:'';

                            //executes handleChangeFloors method
                            let input = this.template.querySelector('[data-name="DataHalls"]');
                            input.dispatchEvent(new CustomEvent('change', {detail: {value: this.datHallID}}));
                        }
                    }            
                    if(data.length === cero){
                        this.optionsDataHalls = [{ label: 'No data...', value: '' }];

                        //executes handleChangeFloors method
                        let input = this.template.querySelector('[data-name="DataHalls"]');
                        input.dispatchEvent(new CustomEvent('change', {detail: {value: ''}}));
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
        this.datHallID = event.detail.value;
        getCages({ dataHallId: this.datHallID })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsCages = [{ label: 'choose one...', value: '' },...result];
                        
                        //prefilling value from flow
                        if(this.cageID){

                            // makes sure the pre-selection belongs to the same building
                            let prefilled = this.optionsCages.find(item => item.value === this.cageID);
                            this.cageID =  prefilled ? prefilled.value:'';

                            //executes handleChangeFloors method
                            let input = this.template.querySelector('[data-name="Cages"]');
                            input.dispatchEvent(new CustomEvent('change', {detail: {value: this.cageID}}));
                        }

                    }            
                    if(data.length === cero){
                        this.optionsCages = [{ label: 'No data...', value: '' }];

                        //executes handleChangeFloors method
                        let input = this.template.querySelector('[data-name="Cages"]');
                        input.dispatchEvent(new CustomEvent('change', {detail: {value: ''}}));
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
        this.cageID = event.detail.value;
        getCabinets({ cageId: this.cageID })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsCabinets = [{ label: 'choose one...', value: '' },...result];

                        //prefilling value from flow
                        if(this.cabinetId){

                            // makes sure the pre-selection belongs to the same building
                            let prefilled = this.optionsCabinets.find(item => item.value === this.cabinetId);
                            this.cabinetId =  prefilled ? prefilled.value:'';

                            //executes handleChangeFloors method
                            let input = this.template.querySelector('[data-name="Cabinets"]');
                            input.dispatchEvent(new CustomEvent('change', {detail: {value: this.cabinetId}}));
                        }
                    }            
                    if(data.length === cero){
                        this.optionsCabinets = [{ label: 'No data...', value: '' }];

                        //executes handleChangeFloors method
                        let input = this.template.querySelector('[data-name="Cabinets"]');
                        input.dispatchEvent(new CustomEvent('change', {detail: {value: ''}}));
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
        this.cabinetId = event.detail.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('cabinetId', this.cabinetId));
    }
}