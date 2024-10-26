import { LightningElement, track, api } from 'lwc';
import getAccountsByCaseId from '@salesforce/apex/DX_SubmitServiceRequest_cls.getAccountsByCaseId';

export default class dx_customLookup_lwc extends LightningElement {
    /*@track searchKey = '';
    @track results = [];
    @track isSearchOpen = false;

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
        this.isSearchOpen = this.searchKey !== '';

        // Call a method to fetch results based on searchKey
        this.fetchResults();
    }

    handleFocus() {
        this.isSearchOpen = true;
        this.fetchResults();
    }

    fetchResults() {
        // Simulate an API call to fetch results
        const allResults = [
            { id: '1', label: 'Account 1' },
            { id: '2', label: 'Account 2' },
            { id: '3', label: 'Account 3' }
        ];

        // Filter results based on the searchKey
        this.results = allResults.filter(result => 
            result.label.toLowerCase().includes(this.searchKey.toLowerCase())
        );
    }

    handleSelect(event) {
        const selectedId = event.target.key;
        const selectedLabel = event.target.innerText;

        // Do something with the selected result
        console.log('Selected:', selectedId, selectedLabel);
        
        // Reset search
        this.searchKey = selectedLabel;
        this.isSearchOpen = false;
        this.results = [];
    }*/

    @track accounts;
    @track accountName = '';
    @track selectedAccount; // To store the selected account
    @api caseId = '500VB00000BKUwTYAX';

    handleInputChange(event) {
        this.accountName = event.target.value;
        this.fetchAccounts();
    }

    fetchAccounts() {
        if (this.caseId) {
            getAccountsByCaseId({ caseId: this.caseId })
                .then(result => {
                    this.accounts = result;
                })
                .catch(error => {
                    this.accounts = undefined;
                    console.error('Error fetching accounts:', error);
                });
        }
    }

    handleAccountSelect(event) {
        const accountId = event.target.dataset.id;
        const accountName = event.target.dataset.name;

        this.selectedAccount = { Id: accountId, Name: accountName };
        this.accountName = accountName; // Update input with selected account name
        this.accounts = []; // Clear the account list after selection
    }

    handleRemoveSelection() {
        this.selectedAccount = undefined; // Clear the selected account
        this.accountName = ''; // Clear the input field
        this.fetchAccounts(); // Optionally fetch accounts again
    }
}