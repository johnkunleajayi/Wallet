import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateUser from '@salesforce/apex/GangMatesAPIUserUI.updateUser';

export default class UpdateUser extends LightningElement {
    @api userId; // Pass userId from parent component if needed
    @track user = {
        company_id: null,
        first_name: '',
        last_name: '',
        domain_name: '',
        user_types: '',
        title: '',
        base_salary: null,
        department: '',
        allowances: null,
        personal_email: '',
        office_location: '',
        start_date: null,
        manager_email: '',
        documents: [],
        password: '',
        bank_name: '',
        account_number: ''
    };

    handleInputChange(event) {
        const field = event.target.name;
        this.user[field] = event.target.value;
    }

    handleFileChange(event) {
        const files = event.target.files;
        this.user.documents = Array.from(files);
    }

    handleUpdate() {
        updateUser({ 
            userId: this.userId,
            request: this.user 
        })
        .then(() => {
            this.showToast('Success', 'User updated successfully', 'success');
        })
        .catch(error => {
            this.showToast('Error', error.body.message, 'error');
        });
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        }));
    }
}
