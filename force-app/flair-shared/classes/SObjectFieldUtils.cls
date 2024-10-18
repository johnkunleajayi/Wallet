public class SObjectFieldUtils {
  private static Map<Schema.SObjectField, List<Schema.PicklistEntry>> picklistEntries = new Map<Schema.SObjectField, List<Schema.PicklistEntry>>();

  public static Boolean isValidPicklistValue(
    Schema.SObjectField field,
    String val
  ) {
    return getPicklistValues(field).contains(val);
  }

  public static List<String> getPicklistValues(Schema.SObjectField field) {
    List<String> values = new List<String>();
    for (Schema.PicklistEntry entry : getPicklistEntries(field)) {
      values.add(entry.getValue());
    }

    return values;
  }

  public static Map<String, String> getPicklistLabelByValue(
    Schema.SObjectField field
  ) {
    Map<String, String> result = new Map<String, String>();
    for (Schema.PicklistEntry entry : getPicklistEntries(field)) {
      result.put(entry.getValue(), entry.getLabel());
    }

    return result;
  }

  public static List<Schema.PicklistEntry> getPicklistEntries(
    Schema.SObjectField field
  ) {
    if (picklistEntries.get(field) == null) {
      picklistEntries.put(field, field.getDescribe().getPicklistValues());
    }

    return picklistEntries.get(field);
  }

  public static Schema.SObjectType getParentType(
    Schema.SObjectField foreignKey
  ) {
    return isForeignKey(foreignKey)
      ? foreignKey.getDescribe().getReferenceTo()[0]
      : null;
  }

  public static Boolean isForeignKey(Schema.SObjectField field) {
    return field.getDescribe().getType() == Schema.DisplayType.REFERENCE;
  }

  public static Boolean isFieldAccessible(Schema.SObjectField field) {
    return field.getDescribe().isAccessible();
  }

  public static Boolean areFieldsAccessible(Set<Schema.SObjectField> fields) {
    for (Schema.SObjectField field : fields) {
      if (!isFieldAccessible(field)) {
        return false;
      }
    }
    return true;
  }

  public static Object castValueToFieldType(
    String value,
    Schema.SObjectField field
  ) {
    if (value == null) {
      return null;
    }

    switch on field.getDescribe().getType() {
      when ID, REFERENCE {
        return Id.valueOf(value);
      }
      when DATE {
        return Date.valueOf(value);
      }
      when DATETIME {
        return Datetime.valueOf(value);
      }
      when BOOLEAN {
        return Boolean.valueOf(value);
      }
      when CURRENCY, DOUBLE, PERCENT {
        return Decimal.valueOf(value);
      }
      when INTEGER {
        return Integer.valueOf(value);
      }
      when LONG {
        return Long.valueOf(value);
      }
    }

    return value;
  }

  public static Boolean isLookupField(Schema.SObjectField field) {
    Boolean isLookupField = field.getDescribe().getReferenceTo().size() > 0;
    Boolean isExternalLookupField =
      isLookupField &&
      String.valueOf(field.getDescribe().getReferenceTo()[0]).endsWith('__x');
    return isLookupField && !isExternalLookupField;
  }
}