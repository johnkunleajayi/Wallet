public class SObjectTypeUtils {
  private static Map<Schema.SObjectType, Map<String, Schema.SObjectField>> sobjectFields = new Map<Schema.SObjectType, Map<String, Schema.SObjectField>>();
  private static Map<Schema.SObjectType, Map<Schema.SObjectField, Schema.ChildRelationship>> sobjectChildRelationships = new Map<Schema.SObjectType, Map<Schema.SObjectField, Schema.ChildRelationship>>();

  public static Schema.SObjectField getIdField(Schema.SObjectType sobjectType) {
    return getSObjectField(sobjectType, 'Id');
  }

  public static Schema.SObjectField getNameField(
    Schema.SObjectType sobjectType
  ) {
    return getSObjectField(sobjectType, 'Name');
  }

  public static Schema.SObjectField getExternalIdField(
    Schema.SObjectType sobjectType
  ) {
    return getSObjectField(sobjectType, 'ExternalId');
  }

  public static Schema.SObjectField getSObjectField(
    Schema.SObjectType sobjectType,
    String fieldApiName
  ) {
    return getSObjectFields(sobjectType).get(fieldApiName);
  }

  public static Set<Schema.SObjectField> getSObjectFields(
    Schema.SObjectType objectType,
    List<String> fieldApiNames
  ) {
    Map<String, Schema.SObjectField> objectFields = getSObjectFields(
      objectType
    );

    Set<Schema.SObjectField> result = new Set<Schema.SObjectField>();
    for (String fieldApiName : fieldApiNames) {
      Schema.SObjectField field = objectFields.get(fieldApiName);
      if (field != null) {
        result.add(field);
      }
    }

    return result;
  }

  public static Schema.ChildRelationship getChildRelationshipByForeignKey(
    Schema.SObjectType sobjectType,
    Schema.SObjectField sobjectField
  ) {
    return getSObjectChildRelationships(sobjectType).get(sobjectField);
  }

  public static Map<String, Schema.SObjectField> getSObjectFields(
    Schema.SObjectType sobjectType
  ) {
    if (sobjectFields.get(sobjectType) == null) {
      sobjectFields.put(sobjectType, sobjectType.getDescribe().fields.getMap());
    }

    return sobjectFields.get(sobjectType);
  }

  public static Map<Schema.SObjectField, Schema.ChildRelationship> getSObjectChildRelationships(
    Schema.SObjectType sobjectType
  ) {
    if (sobjectChildRelationships.get(sobjectType) == null) {
      Map<Schema.SObjectField, Schema.ChildRelationship> result = new Map<Schema.SObjectField, Schema.ChildRelationship>();
      for (
        Schema.ChildRelationship rel : sobjectType.getDescribe()
          .getChildRelationships()
      ) {
        result.put(rel.getField(), rel);
      }

      sobjectChildRelationships.put(sobjectType, result);
    }

    return sobjectChildRelationships.get(sobjectType);
  }
}