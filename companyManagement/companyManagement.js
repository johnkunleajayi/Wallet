import { LightningElement, track } from 'lwc';

export default class CompanyManagement extends LightningElement {
    // Tracked properties for data binding
    @track name = '';
    @track address = '';
    @track phone = '';
    @track registration_id = '';
    @track email_template = '';
    @track code = '';
    @track domain = '';
    @track payment_frequency = '';

    // Options for payment frequency
    get paymentFrequencyOptions() {
        return [
            { label: 'Monthly', value: 'Monthly' },
            { label: 'Quarterly', value: 'Quarterly' },
            { label: 'Annually', value: 'Annually' }
        ];
    }

    // Handles input changes
    handleInputChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
    }

    handleSubmit() {
        // Gather form data for submission
        const companyData = {
            name: this.name,
            address: this.address,
            phone: this.phone,
            registration_id: this.registration_id,
            email_template: this.email_template,
            code: this.code,
            domain: this.domain,
            payment_frequency: this.payment_frequency
        };

        console.log('Company Data:', companyData);

        // Further actions can be added, like saving data to the database or displaying a confirmation.
    }
}
