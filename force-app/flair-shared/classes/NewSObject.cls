public class NewSObject implements ChangedSObject {
  private SObject newRecord;

  public NewSObject(SObject newRecord) {
    this.newRecord = newRecord;
  }

  public Id id() {
    return newRecord.Id;
  }

  public Object newValue(Schema.SObjectField field) {
    return newRecord.get(field);
  }

  public SObject newRecord() {
    return newRecord;
  }

  public SObject oldRecord() {
    return null;
  }

  public Object oldValue(Schema.SObjectField field) {
    return null;
  }

  public Decimal decimalDifference(Schema.SObjectField field) {
    return (Decimal) newValue(field);
  }

  public Boolean fieldChangedTo(Schema.SObjectField field, Object value) {
    return SObjectUtils.fieldChangedTo(field, value, this);
  }

  public Boolean fieldChangedFrom(Schema.SObjectField field, Object value) {
    return SObjectUtils.fieldChangedFrom(field, value, this);
  }

  public Boolean isChanged(Schema.SObjectField field) {
    return newValue(field) != null;
  }

  public Boolean equals(Object obj) {
    return true;
  }

  public Boolean equals(UpdatedSObject another) {
    return true;
  }
}