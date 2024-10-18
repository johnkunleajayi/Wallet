public interface ChangedSObject {
  Id id();
  SObject newRecord();
  SObject oldRecord();
  Object newValue(Schema.SObjectField field);
  Object oldValue(Schema.SObjectField field);
  Decimal decimalDifference(Schema.SObjectField field);
  Boolean fieldChangedTo(Schema.SObjectField field, Object value);
  Boolean fieldChangedFrom(Schema.SObjectField field, Object value);
  Boolean isChanged(Schema.SObjectField field);
  Boolean equals(Object obj);
  Boolean equals(ChangedSObject another);
}