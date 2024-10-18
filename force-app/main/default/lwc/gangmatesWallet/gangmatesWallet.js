import { LightningElement } from 'lwc';
import GANGMATES_WALLET_CSS from './gangmatesWallet.css';

export default class GangmatesWallet extends LightningElement {
    static styles = GANGMATES_WALLET_CSS;

    utilityPreviewIcon = 'utility:toggle_on';
    utilityPreviewOffIcon = 'utility:toggle_off';

    // Set to true to make the preview visible by default
    isPreviewVisible = false; // Changed from false to true

    // Sample data for demonstration
    balance = 150000; // Example balance
    deposits = 200000; // Example deposits
    expenses = 50000; // Example expenses

    // Adding Naira sign to the data
    get formattedBalance() {
        return `₦${this.balance.toLocaleString()}`;
    }

    get formattedDeposits() {
        return `₦${this.deposits.toLocaleString()}`;
    }

    get formattedExpenses() {
        return `₦${this.expenses.toLocaleString()}`;
    }
    

    // Toggles the preview state
    togglePreview() {
        this.isPreviewVisible = !this.isPreviewVisible;
    }

    // Getter for the preview icon name
    get previewIconName() {
        return this.isPreviewVisible ? this.utilityPreviewIcon : this.utilityPreviewOffIcon;
    }

    // Getter for icon class (optional, if you want to apply specific styles)
    get iconClass() {
        return this.isPreviewVisible ? 'icon-visible' : 'icon-hidden'; // You can define CSS classes as needed
    }

    // Method to handle Top Up button click
    handleTopUpClick() {
        // Navigate to the specified Top Up page
        window.location.href = 'https://aisha-demo-june24-flair1.lightning.force.com/lightning/n/Top_Up_Page';
    }

    // Method to handle Pay button click
    handlePayClick() {
        // Navigate to the specified Payment page
        window.location.href = 'https://aisha-demo-june24-flair1.lightning.force.com/lightning/n/Payment_Page';
    }
}
