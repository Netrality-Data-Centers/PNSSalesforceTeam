import { LightningElement, wire, api } from 'lwc';
import getOpenServiceRequest from "@salesforce/apex/DX_viewOpenServiceRequest_ctr.getOpenServiceRequest";
//import { NavigationMixin } from 'lightning/navigation';
import dx_URL_Experience_Cloud_lbl from '@salesforce/label/c.DX_URL_Experience_Cloud'; 
import dx_NamePage_DetailsSR_Experience_Cloud_lbl from '@salesforce/label/c.DX_NamePage_DetailsSR_Experience_Cloud'; 
import dx_NamePage_EditSR_Experience_Cloud_lbl from '@salesforce/label/c.DX_NamePage_EditSR_Experience_Cloud'; 

export default class Dx_viewOpenServiceRequest_lwc extends LightningElement{
    dataInfo = [];
    isEmpty = false;
    error = false;
    @api recordIdToFlow;
    isModalOpen = false;

    @wire(getOpenServiceRequest)
    wiredOpenSR({ error, data }) {
        if (data) {
            if(data.length > 0){
                let result = JSON.parse(JSON.stringify(data));
                let recordType_Name;
                let isoDate;
                let date;
                let year;
                let month;
                let day;
                let formattedDate;
                let urlCaseNumber;
                for(var item in result){
                    recordType_Name = result[item].RecordType.Name;
                    result[item].RecordType_Name = recordType_Name;

                    isoDate = result[item].CreatedDate;
                    date = new Date(isoDate);
                    // Get date components
                    year = date.getUTCFullYear();
                    month = String(date.getUTCMonth() + 1).padStart(2, '0'); // Months are 0-indexed
                    day = String(date.getUTCDate()).padStart(2, '0');
                    // Format the date
                    formattedDate = `${year}-${month}-${day}`;
                    result[item].CreatedDate = formattedDate;

                    urlCaseNumber = dx_URL_Experience_Cloud_lbl + dx_NamePage_DetailsSR_Experience_Cloud_lbl + result[item].Id;
                    result[item].urlCaseNumber = urlCaseNumber;
                }
                this.dataInfo = [...result];
            }
            if(data.length === 0){this.isEmpty = true;}
        } else if (error) {
            this.error = true;            
            console.error(error);
        }
    }

    EditRow(event) {
        const url = dx_URL_Experience_Cloud_lbl + dx_NamePage_EditSR_Experience_Cloud_lbl + `recordIdToFlow=${event.target.value}`;
        window.location.href = url;
    }
}