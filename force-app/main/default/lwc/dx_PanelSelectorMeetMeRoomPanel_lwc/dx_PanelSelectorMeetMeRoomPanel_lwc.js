import { LightningElement, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import getMeetMeRoom from "@salesforce/apex/DX_PanelSelectorMeetMeRoomPanel_ctr.getMeetMeRoom";
import getPanel from '@salesforce/apex/DX_PanelSelectorMeetMeRoomPanel_ctr.getPanel';

export default class Dx_PanelSelectorMeetMeRoomPanel_lwc extends LightningElement {
    @api buildingID;
    valueMeetMeRoom = '';
    valuePanel = '';
    optionsMeetMeRooms = [];
    optionsPanels = [];
    @api meetMeRoomId;
    @api panelId;
    @api isThereAPanel = false;
    @api accountId;

    @wire(getMeetMeRoom, {buildingId: "$buildingID"})
    wiredFloors({ data }) {
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
        }
    }

    handleChangeMeetMeRooms(event) {
        this.valueMeetMeRoom = event.detail.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('meetMeRoomId', this.valueMeetMeRoom));

        getPanel({ accountId: this.accountId, meetMeRoomId: this.valueMeetMeRoom })
            .then(data => {
                if (data) {
                    const cero = 0;
                    let result = null;
                    if(data.length > cero){
                        result = JSON.parse(JSON.stringify(data));
                        this.optionsPanels = [...result];
                        this.funtionIsThereAPanel(true);
                    }            
                    if(data.length === cero){
                        this.optionsPanels = [{ label: 'No data...', value: '' }];
                        this.funtionIsThereAPanel(false);
                    }
                }
            });
    }

    funtionIsThereAPanel(isThereAPanel) {
        this.isThereAPanel = isThereAPanel;
        this.dispatchEvent(new FlowAttributeChangeEvent('isThereAPanel', this.isThereAPanel));
    }

    handleChangePanels(event) {
        this.valuePanel = event.detail.value;
        this.dispatchEvent(new FlowAttributeChangeEvent('panelId', this.valuePanel));
    }

}