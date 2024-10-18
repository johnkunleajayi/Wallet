import { LightningElement, track } from 'lwc';

export default class TopUpWallet extends LightningElement {
    @track amount = 0;
    @track serviceFee = 0;
    @track total = 0;

    get formattedServiceFee() {
        return `₦${this.serviceFee.toFixed(2)}`;
    }

    get formattedTotal() {
        return `₦${this.total.toFixed(2)}`;
    }

    handleAmountChange(event) {
        this.amount = parseFloat(event.target.value) || 0;
        this.serviceFee = this.amount * 0.0092;
        this.total = this.amount + this.serviceFee;
    }

    handlePayClick() {
        // Redirect to the specified URL
        window.location.href = 'https://checkout-v2.dev-flutterwave.com/v3/hosted/pay/e8ce5d8a6fbf062e5519';
    }
}
