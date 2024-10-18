import { LightningElement, track, wire } from 'lwc';
import findUsers from '@salesforce/apex/UserSearchController.findUsers';

export default class MakePayment extends LightningElement {
    
    @track userInput = '';
    @track userOptions = [];
    @track showDropdown = false;
    @track paymentType = '';
    @track oneTimePaymentType; // Selected one-time payment type
    @track selectedPayslip; // Selected payslip
    @track selectedInvoice; // Selected invoice
    @track isOneTimeSelected = false; // Flag to show/hide one-time payment type
    @track isPaySlipSelected = false; // Flag to show/hide payslip dropdown
    @track isInvoiceSelected = false;
    @track isInvoiceSelected = false; // Flag to show/hide invoice dropdown
    @track showPaySlipInstructions = false; // Flag to show the Pay Slip instructions
    @track showInvoiceInstructions = false; // Flag to show the Pay Slip instructions
    @track isRecurringSelected = false; // Flag to show/hide frequency picklist
    @track frequency; // Selected frequency


    paymentTypeOptions = [
        { label: 'One Time', value: 'one_time' },
        { label: 'Recurring', value: 'recurring' }
    ];

    // Options for the one-time payment type picklist
    oneTimePaymentTypeOptions = [
        { label: 'Pay Slip', value: 'paySlip' },
        { label: 'Invoice', value: 'invoice' },
    ];

    // Options for the frequency picklist
frequencyOptions = [
    { label: 'Weekly', value: 'weekly' },
    { label: 'Bi-weekly', value: 'bi_weekly' },
    { label: 'Monthly', value: 'monthly' },
    { label: 'Quarterly', value: 'quarterly' },
    { label: 'Yearly', value: 'yearly' },
];

    // Handle change in Payment Type picklist
    handlePaymentTypeChange(event) {
        this.paymentType = event.detail.value; // Get selected value
        this.isOneTimeSelected = this.paymentType === 'one_time'; // Corrected value to match the dropdown option
        this.isRecurringSelected = this.paymentType === 'recurring'; // Show frequency picklist for Recurring
    }



    // Handle change in One Time Payment Type picklist
    handleOneTimePaymentTypeChange(event) {
        this.oneTimePaymentType = event.detail.value;
        this.isPaySlipSelected = this.oneTimePaymentType === 'paySlip'; // Show payslip dropdown if Pay Slip is selected
        this.isInvoiceSelected = this.oneTimePaymentType === 'invoice';
        this.showPaySlipInstructions = this.isPaySlipSelected; // Update the flag1
        this.showInvoiceInstructions = this.isInvoiceSelected; // Update the flag2
    }

    // Handle change in Frequency picklist
handleFrequencyChange(event) {
    this.frequency = event.detail.value;
}



    // Handle change in Select Payslip picklist
    handleSelectPayslipChange(event) {
        this.selectedPayslip = event.detail.value;
        // Add any additional logic for handling this selection if necessary
    }








    

    handleUserChange(event) {
        this.userInput = event.target.value;
        // Call the Apex method to find users
        if (this.userInput.length >= 1) {
            findUsers({ searchTerm: this.userInput })
                .then(result => {
                    this.userOptions = result.map(user => ({
                        label: user.Name,
                        value: user.Id
                    }));
                    this.showDropdown = true;
                })
                .catch(error => {
                    console.error('Error fetching users:', error);
                    this.userOptions = [];
                    this.showDropdown = false;
                });
        } else {
            this.userOptions = [];
            this.showDropdown = false;
        }
    }

    handleUserSelect(event) {
        const selectedUserId = event.currentTarget.dataset.id;
        const selectedUserName = event.currentTarget.dataset.name;
        this.userInput = selectedUserName;
        this.showDropdown = false;
        // Store the selected user ID for further processing if needed
        this.selectedUserId = selectedUserId;
    }

    handlePaymentDateChange(event) {
        const paymentDate = event.target.value;
        console.log('Selected Payment Date:', paymentDate);
    }

    handlePayClick() {
        // Redirect to the specified URL
        window.location.href = 'https://checkout-v2.dev-flutterwave.com/v3/hosted/pay/e8ce5d8a6fbf062e5519';
    }

    handleCancelClick() {
        // Clear all fields
        this.userInput = '';
        this.paymentType = '';
        this.oneTimePaymentType = '';
        this.userOptions = [];
        this.showDropdown = false;
    }
}
