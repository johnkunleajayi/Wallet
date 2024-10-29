import { LightningElement, track } from 'lwc';

export default class UserManagement extends LightningElement {
    // Tracked properties for data binding
    @track company_id = null;
    @track first_name = '';
    @track last_name = '';
    @track personal_email = '';
    @track domain_name = '';
    @track user_types = '';
    @track title = '';
    @track base_salary = null;
    @track department = '';
    @track allowances = null;
    @track office_location = '';
    @track start_date = null;
    @track manager_email = '';
    @track bank_name = '';
    @track account_number = '';
    @track roles = [];
    @track is_active = false;

    // Options for user types and roles
    get userTypeOptions() {
        return [
            { label: 'Admin', value: 'Admin' },
            { label: 'Employee', value: 'Employee' },
            { label: 'Manager', value: 'Manager' }
        ];
    }

    get roleOptions() {
        return [
            { label: 'Developer', value: 'Developer' },
            { label: 'Designer', value: 'Designer' },
            { label: 'Product Manager', value: 'Product Manager' },
            { label: 'Sales', value: 'Sales' }
        ];
    }

    // Handles input changes
    handleInputChange(event) {
        const field = event.target.dataset.id;

        // Update the tracked property with the new value
        if (field === 'roles') {
            this[field] = event.detail.value; // For multi-select combobox
        } else if (field === 'is_active') {
            this[field] = event.target.checked; // For checkbox
        } else {
            this[field] = event.target.value;
        }
    }

    handleSubmit() {
        // Gather form data for submission
        const userData = {
            company_id: this.company_id,
            first_name: this.first_name,
            last_name: this.last_name,
            personal_email: this.personal_email,
            domain_name: this.domain_name,
            user_types: this.user_types,
            title: this.title,
            base_salary: this.base_salary,
            department: this.department,
            allowances: this.allowances,
            office_location: this.office_location,
            start_date: this.start_date,
            manager_email: this.manager_email,
            bank_name: this.bank_name,
            account_number: this.account_number,
            roles: this.roles,
            is_active: this.is_active
        };

        console.log('User Data:', userData);

        // Further actions can be added, like saving data to the database or displaying a confirmation.
    }
}
