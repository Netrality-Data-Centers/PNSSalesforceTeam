import { LightningElement, api, wire } from 'lwc';
import { FlowAttributeChangeEvent } from 'lightning/flowSupport';
import getPorts from "@salesforce/apex/DX_ConnectPorts_ctr.getPorts";

export default class Dx_ConnectPorts_lwc extends LightningElement {
    @api panelId;
    @api lstFiberPair = [];
    valuePort = '';
    optionsPorts = [];

    @wire(getPorts, {panelId: "$panelId"})
    wiredPorts({ data }) {
        if (data) {
            const cero = 0;
            let result = null;
            if(data.length > cero){
                result = JSON.parse(JSON.stringify(data));
                this.optionsPorts = [...result];
            }            
            if(data.length === cero){
                this.optionsPorts = [{ label: 'No data...', value: '' }];
            }
        }
    }

    get hasFiberPair() {
        const cero = 0;
        return this.lstFiberPair && this.lstFiberPair.length > cero;
    }

    handleChangePort(event) {
        let foundIndex = null, nameFiber = '', tempList = '';
        this.valuePort = event.detail.value;
        nameFiber = event.target.name;
        foundIndex = this.lstFiberPair.findIndex(item => item.Name === nameFiber);
        tempList = JSON.parse(JSON.stringify(this.lstFiberPair));
        tempList[foundIndex].Port__c = this.valuePort;
        this.lstFiberPair = tempList; 
        this.dispatchEvent(new FlowAttributeChangeEvent('lstFiberPair', this.lstFiberPair));
    }
}