public class UpdatedSObject implements ChangedSObject {
  private SObject oldRecord;
  private SObject newRecord;

  public UpdatedSObject(SObject newRecord, SObject oldRecord) {
    this.newRecord = newRecord;
    this.oldRecord = oldRecord;
  }

  public Id id() {
    return newRecord.Id;
  }

  public SObject oldRecord() {
    return oldRecord;
  }

  public SObject newRecord() {
    return newRecord;
  }

  public Object newValue(Schema.SObjectField field) {
    return newRecord.get(field);
  }

  public Object oldValue(Schema.SObjectField field) {
    return oldRecord.get(field);
  }

  public Decimal decimalDifference(Schema.SObjectField field) {
    return (Decimal) newValue(field) - (Decimal) oldValue(field);
  }

  public Boolean fieldChangedTo(Schema.SObjectField field, Object value) {
    return SObjectUtils.fieldChangedTo(field, value, this);
  }

  public Boolean fieldChangedFrom(Schema.SObjectField field, Object value) {
    return SObjectUtils.fieldChangedFrom(field, value, this);
  }

  public Boolean isChanged(Schema.SObjectField field) {
    return SObjectUtils.isChanged(field, newRecord, oldRecord);
  }

  public Boolean equals(Object obj) {
    if (!(obj instanceof ChangedSObject)) {
      return false;
    }

    return equals((UpdatedSObject) obj);
  }

  public Boolean equals(UpdatedSObject another) {
    return another.newRecord.Id == newRecord.Id &&
      another.oldRecord.Id == oldRecord.Id;
  }
}