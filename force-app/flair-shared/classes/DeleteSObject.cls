public class DeleteSObject implements ChangedSObject {
  private SObject oldRecord;

  public DeleteSObject(SObject oldRecord) {
    this.oldRecord = oldRecord;
  }

  public Id id() {
    return oldRecord.Id;
  }

  public Object newValue(Schema.SObjectField field) {
    return null;
  }

  public Object oldValue(Schema.SObjectField field) {
    return oldRecord.get(field);
  }

  public SObject newRecord() {
    return null;
  }

  public SObject oldRecord() {
    return oldRecord;
  }

  public Decimal decimalDifference(Schema.SObjectField field) {
    return (Decimal) oldValue(field);
  }

  public Boolean fieldChangedTo(Schema.SObjectField field, Object value) {
    return SObjectUtils.fieldChangedTo(field, value, this);
  }

  public Boolean fieldChangedFrom(Schema.SObjectField field, Object value) {
    return SObjectUtils.fieldChangedFrom(field, value, this);
  }

  public Boolean isChanged(Schema.SObjectField field) {
    return oldValue(field) != null;
  }

  public Boolean equals(Object obj) {
    return true;
  }

  public Boolean equals(UpdatedSObject another) {
    return true;
  }
}