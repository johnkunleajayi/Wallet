import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateCompany from '@salesforce/apex/GangMatesAPICompaniesUI.updateCompany';

export default class UpdateCompany extends LightningElement {
    @api companyId; // Passed from parent component or set dynamically
    @track company = {
        name: '',
        address: '',
        phone: '',
        registration_id: '',
        email_template: '',
        code: '',
        domain: '',
        payment_frequency: ''
    };

    // Options for payment frequency
    get paymentFrequencyOptions() {
        return [
            { label: 'Monthly', value: 'monthly' },
            { label: 'Weekly', value: 'weekly' },
            { label: 'Bi-weekly', value: 'bi-weekly' },
        ];
    }

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this.company[field] = event.target.value;
    }

    handleUpdate() {
        updateCompany({ companyId: this.companyId, requestBody: this.company })
            .then(() => {
                this.showToast('Success', 'Company Updated Successfully.', 'success');
            })
            .catch(error => {
                console.error('Error:', error);
                this.showToast('Error', 'A problem occurred during Company Update.', 'error');
            });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }
}
