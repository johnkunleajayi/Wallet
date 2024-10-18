@isTest
public class CalendarsFactory {
  private flair__Calendar__c current;

  public CalendarsFactory(flair__Calendar__c current) {
    this.current = current;
  }

  public CalendarsFactory() {
    this.current = new flair__Calendar__c(flair__Type__c = 'PUBLIC_HOLIDAY');
  }

  public CalendarsFactory name(String name) {
    current.Name = name;
    return this;
  }

  public CalendarsFactory startDate(Date startDate) {
    current.flair__Start_Date__c = startDate;
    return this;
  }

  public CalendarsFactory endDate(Date endDate) {
    current.flair__End_Date__c = endDate;
    return this;
  }

  public flair__Calendar__c create() {
    insert current;
    return current;
  }

  public flair__Calendar__c build() {
    return current;
  }
}