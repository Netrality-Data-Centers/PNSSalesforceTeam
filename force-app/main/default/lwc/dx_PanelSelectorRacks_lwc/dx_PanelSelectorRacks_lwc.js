import { LightningElement, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import getFloors from "@salesforce/apex/DX_PanelSelectorRacks_ctr.getFloors";
import getDataHalls from '@salesforce/apex/DX_PanelSelectorRacks_ctr.getDataHalls';
import getMeetMeRooms from '@salesforce/apex/DX_PanelSelectorRacks_ctr.getMeetMeRooms';
import getRacks from '@salesforce/apex/DX_PanelSelectorRacks_ctr.getRacks';

export default class Dx_PanelSelectorRacks_lwc extends LightningElement {
    @api BuildingID;
    @api floorID;
    @api datHallID;
    @api meetMeRoomID;
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
                this.optionsFloors = [{ label: 'choose one...', value: '' },...result];

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

                            // makes sure the pre-selection belongs to the same data hall
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
        getMeetMeRooms({ dataHallId: this.datHallID })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsMeetMeRooms = [{ label: 'choose one...', value: '' },...result];

                        //prefilling value from flow
                        if(this.meetMeRoomID){

                            // makes sure the pre-selection belongs to the meet me rooms
                            let prefilled = this.optionsMeetMeRooms.find(item => item.value === this.meetMeRoomID);
                            this.meetMeRoomID =  prefilled ? prefilled.value:'';

                            //executes handleChangeFloors method
                            let input = this.template.querySelector('[data-name="MeetMeRooms"]');
                            input.dispatchEvent(new CustomEvent('change', {detail: {value: this.meetMeRoomID}}));
                        }
                    }            
                    if(data.length === cero){
                        this.optionsMeetMeRooms = [{ label: 'No data...', value: '' }];

                        //executes handleChangeFloors method
                        let input = this.template.querySelector('[data-name="MeetMeRooms"]');
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

    handleChangeMeetMeRooms(event) {
        this.meetMeRoomID = event.detail.value;
        getRacks({ meetMeRoomId: this.meetMeRoomID })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsRacks = [{ label: 'choose one...', value: '' },...result];

                        //prefilling value from flow
                        if(this.rackId){

                            // makes sure the pre-selection belongs to the meet me rooms
                            let prefilled = this.optionsRacks.find(item => item.value === this.rackId);
                            this.rackId =  prefilled ? prefilled.value:'';

                            //executes handleChangeFloors method
                            let input = this.template.querySelector('[data-name="Racks"]');
                            input.dispatchEvent(new CustomEvent('change', {detail: {value: this.rackId}}));
                        }
                    }            
                    if(data.length === cero){
                        this.optionsRacks = [{ label: 'No data...', value: '' }];

                         //executes handleChangeFloors method
                         let input = this.template.querySelector('[data-name="Racks"]');
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

    handleChangeRacks(event) {
        this.rackId = event.detail.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('rackId', this.rackId));
    }
    
}