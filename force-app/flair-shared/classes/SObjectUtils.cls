public class SObjectUtils {
  // TODO: deprecate
  public static Boolean isValidPicklistValue(
    Schema.SObjectField field,
    String val
  ) {
    return SObjectFieldUtils.isValidPicklistValue(field, val);
  }

  // TODO: deprecate
  public static List<String> getPicklistValues(Schema.SObjectField field) {
    return SObjectFieldUtils.getPicklistValues(field);
  }

  public static Boolean isChanged(
    Schema.SObjectField field,
    SObject newRecord,
    SObject oldRecord
  ) {
    return newRecord.get(field) != oldRecord.get(field);
  }

  public static UpdatedSObject[] changedRecords(
    Map<Id, SObject> newMap,
    Map<Id, SObject> oldMap
  ) {
    UpdatedSObject[] records = new List<UpdatedSObject>();

    for (Id recordId : newMap.keySet()) {
      records.add(
        new UpdatedSObject(newMap.get(recordId), oldMap.get(recordId))
      );
    }

    return records;
  }

  public static UpdatedSObject[] recordsThatChangedField(
    Schema.SObjectField field,
    Map<Id, SObject> newMap,
    Map<Id, SObject> oldMap
  ) {
    UpdatedSObject[] records = new List<UpdatedSObject>();

    for (Id recordId : newMap.keySet()) {
      if (isChanged(field, newMap.get(recordId), oldMap.get(recordId))) {
        records.add(
          new UpdatedSObject(newMap.get(recordId), oldMap.get(recordId))
        );
      }
    }

    return records;
  }

  public static UpdatedSObject[] recordsThatChangedAny(
    Schema.SObjectField[] fields,
    Map<Id, SObject> newMap,
    Map<Id, SObject> oldMap
  ) {
    UpdatedSObject[] records = new List<UpdatedSObject>();

    for (Id recordId : newMap.keySet()) {
      for (Schema.SObjectField field : fields) {
        if (isChanged(field, newMap.get(recordId), oldMap.get(recordId))) {
          records.add(
            new UpdatedSObject(newMap.get(recordId), oldMap.get(recordId))
          );

          break;
        }
      }
    }

    return records;
  }

  public static UpdatedSObject[] recordsThatChangedFieldsExcept(
    Set<Schema.SObjectField> fieldsToIgnore,
    Map<Id, SObject> newMap,
    Map<Id, SObject> oldMap
  ) {
    UpdatedSObject[] records = new List<UpdatedSObject>();

    if (!newMap.isEmpty()) {
      Set<Schema.SObjectField> allFields = flairFields(
        newMap.values()[0].getSObjectType(),
        true,
        true
      );

      for (Id recordId : newMap.keySet()) {
        for (Schema.SObjectField field : allFields) {
          if (
            !fieldsToIgnore.contains(field) &&
            isChanged(field, newMap.get(recordId), oldMap.get(recordId))
          ) {
            records.add(
              new UpdatedSObject(newMap.get(recordId), oldMap.get(recordId))
            );
            break;
          }
        }
      }
    }

    return records;
  }

  public static SObject[] getOldRecords(ChangedSObject[] changes) {
    SObject[] objs = new List<SObject>();

    for (ChangedSObject changed : changes) {
      objs.add(changed.oldRecord());
    }

    return objs;
  }

  public static SObject[] getNewRecords(ChangedSObject[] changes) {
    SObject[] objs = new List<SObject>();

    for (ChangedSObject changed : changes) {
      objs.add(changed.newRecord());
    }

    return objs;
  }

  public static Set<Id> setOfIds(Schema.SObjectField field, SObject[] objs) {
    Set<Id> response = new Set<Id>();

    for (SObject obj : objs) {
      Id id = (Id) obj.get(field);

      if (id != null) {
        response.add(id);
      }
    }

    return response;
  }

  public static Set<Id> setOfIds(
    Schema.SObjectField foreignKey,
    Schema.SObjectField field,
    SObject[] objs
  ) {
    Set<Id> response = new Set<Id>();

    for (SObject obj : objs) {
      SObject child = obj.getSObject(foreignKey);
      if (child == null) {
        continue;
      }

      Id id = (Id) child.get(field);
      if (id != null) {
        response.add(id);
      }
    }

    return response;
  }

  public static Set<Id> setOfIds(SObject[] objs) {
    return new Set<Id>(new Map<Id, SObject>(objs).keySet());
  }

  public static Set<Id> setOfIds(ChangedSObject[] objs) {
    Set<Id> response = new Set<Id>();

    for (ChangedSObject obj : objs) {
      Id id = obj.id();

      if (id != null) {
        response.add(id);
      }
    }

    return response;
  }

  public static Set<Id> setOfIds(
    Schema.SObjectField field,
    ChangedSObject[] objs
  ) {
    return setOfIds(field, objs, true);
  }

  public static Set<Id> setOfIds(
    Schema.SObjectField field,
    ChangedSObject[] objs,
    Boolean newValue
  ) {
    Set<Id> response = new Set<Id>();

    for (ChangedSObject obj : objs) {
      Id id = (Id) (newValue ? obj.newValue(field) : obj.oldValue(field));

      if (id != null) {
        response.add(id);
      }
    }

    return response;
  }

  public static List<Id> listOfIds(SObject[] objs) {
    List<Id> result = new List<Id>();
    for (SObject obj : objs) {
      result.add((Id) obj.get('Id'));
    }
    return result;
  }

  public static List<Object> listOfValues(
    Schema.SObjectField field,
    SObject[] objs
  ) {
    List<Object> response = new List<Object>();

    for (SObject obj : objs) {
      Object value = obj.get(field);

      if (value != null) {
        response.add(value);
      }
    }

    return response;
  }

  public static List<String> listOfValuesString(
    Schema.SObjectField field,
    SObject[] objs
  ) {
    List<String> response = new List<String>();
    for (Object obj : listOfValues(field, objs)) {
      response.add(String.valueOf(obj));
    }

    return response;
  }

  public static Map<Id, List<SObject>> groupByLookupField(
    Schema.SObjectField foreignKey,
    SObject[] objs
  ) {
    return groupByLookupField(foreignKey, objs, false);
  }

  public static Map<Id, List<SObject>> groupByLookupField(
    Schema.SObjectField foreignKey,
    SObject[] objs,
    Boolean excludeNullLookupField
  ) {
    Map<Id, List<SObject>> grouped = new Map<Id, List<SObject>>();

    for (SObject obj : objs) {
      Id key = (Id) obj.get(foreignKey);

      if (excludeNullLookupField && key == null) {
        continue;
      }

      if (grouped.get(key) == null) {
        grouped.put(key, new List<SObject>());
      }

      grouped.get(key).add(obj);
    }

    return grouped;
  }

  public static Map<String, List<SObject>> groupByStringLookupField(
    Schema.SObjectField foreignKey,
    SObject[] objs
  ) {
    Map<String, List<SObject>> grouped = new Map<String, List<SObject>>();

    for (SObject obj : objs) {
      String key = (String) obj.get(foreignKey);

      if (grouped.get(key) == null) {
        grouped.put(key, new List<SObject>());
      }

      grouped.get(key).add(obj);
    }

    return grouped;
  }

  public static Map<Pair, List<SObject>> groupByPairOfLookupFields(
    Schema.SObjectField fk1,
    Schema.SObjectField fk2,
    SObject[] objs
  ) {
    Map<Pair, List<SObject>> grouped = new Map<Pair, List<SObject>>();

    for (SObject obj : objs) {
      Pair key = Pair.of(obj.get(fk1), obj.get(fk2));

      if (grouped.get(key) == null) {
        grouped.put(key, new List<SObject>());
      }

      grouped.get(key).add(obj);
    }

    return grouped;
  }

  public static NewSObject[] newFromMap(Map<Id, SObject> newMap) {
    NewSObject[] newList = new List<NewSObject>();

    for (SObject obj : newMap.values()) {
      newList.add(new NewSObject(obj));
    }

    return newList;
  }

  public static NewSObject[] newFromSObjects(SObject[] sObjects) {
    NewSObject[] newList = new List<NewSObject>();

    for (SObject obj : sObjects) {
      newList.add(new NewSObject(obj));
    }

    return newList;
  }

  public static DeleteSObject[] deleteFromSObjects(SObject[] sObjects) {
    DeleteSObject[] deleteList = new List<DeleteSObject>();

    for (SObject obj : sObjects) {
      deleteList.add(new DeleteSObject(obj));
    }

    return deleteList;
  }

  public static UpdatedSObject[] updateFromSObjects(SObject[] sObjects) {
    UpdatedSObject[] updateList = new List<UpdatedSObject>();

    for (SObject obj : sObjects) {
      updateList.add(new UpdatedSObject(obj, obj));
    }

    return updateList;
  }

  public static Boolean fieldChangedTo(
    Schema.SObjectField field,
    Object value,
    ChangedSObject changes
  ) {
    if (changes.newValue(field) == changes.oldValue(field)) {
      return false;
    }

    return changes.newValue(field) == value;
  }

  public static Boolean fieldChangedFrom(
    Schema.SObjectField field,
    Object value,
    ChangedSObject changes
  ) {
    if (changes.newValue(field) == changes.oldValue(field)) {
      return false;
    }

    return changes.oldValue(field) == value;
  }

  public static Map<String, Schema.DisplayType> getFieldTypes(
    Schema.SObjectType sObjectType
  ) {
    Map<String, Schema.DisplayType> result = new Map<String, Schema.DisplayType>();

    for (Schema.DescribeFieldResult describeField : getFields(sObjectType)) {
      result.put(describeField.getName(), describeField.getType());
    }

    return result;
  }

  public static Set<Schema.DescribeFieldResult> getFields(
    Schema.SObjectType sObjectType
  ) {
    Set<Schema.DescribeFieldResult> result = new Set<Schema.DescribeFieldResult>();

    for (Schema.SObjectField field : allFields(sObjectType)) {
      result.add(field.getDescribe());
    }

    return result;
  }

  public static Schema.SObjectType getObjectByName(String objectApiName) {
    return ((SObject) Type.forName(objectApiName).newInstance())
      .getSObjectType();
  }

  public static Schema.SObjectField getFieldByName(
    Schema.SObjectType objectType,
    String fieldApiName
  ) {
    String[] tokens = fieldApiName.split('\\.');

    Map<String, Schema.SObjectField> objectFields = objectType
      .getDescribe()
      .fields.getMap();

    Schema.SObjectField field = objectFields.get(
      tokens.remove(0).replace('__r', '__c')
    );

    if (field == null) {
      return null;
    }

    Schema.DescribeFieldResult result = field.getDescribe();

    if (
      tokens.size() > 0 &&
      result != null &&
      result.getType() == Schema.DisplayType.REFERENCE
    ) {
      return getFieldByName(
        result.getReferenceTo()[0],
        String.join(tokens, '.')
      );
    }

    return field;
  }

  public static Schema.SObjectField getFieldByFullName(
    String fullFieldApiName
  ) {
    String[] tokens = fullFieldApiName.split('\\.');
    String objectName = tokens.remove(0);
    String fieldName = String.join(tokens, '.');

    Schema.SObjectType objectType = Schema.getGlobalDescribe().get(objectName);

    return getFieldByName(objectType, fieldName);
  }

  public static String getFieldLabel(
    Schema.SObjectType objectType,
    String fieldApiName
  ) {
    Schema.SObjectField field = getFieldByName(objectType, fieldApiName);
    return field != null ? field.getDescribe().getLabel() : null;
  }

  public static Map<String, Schema.DescribeFieldResult> getFieldsByName(
    Schema.SObjectType sObjectType
  ) {
    Map<String, Schema.DescribeFieldResult> result = new Map<String, Schema.DescribeFieldResult>();

    for (Schema.SObjectField field : allFields(sobjectType)) {
      Schema.DescribeFieldResult describeField = field.getDescribe();
      result.put(describeField.getName(), describeField);
    }

    return result;
  }

  public static Map<String, Schema.SObjectField> getObjectFieldsByObjectName(
    Schema.SObjectType sObjectType
  ) {
    Map<String, Schema.SObjectField> result = new Map<String, Schema.SObjectField>();

    for (Schema.SObjectField field : allFields(sobjectType)) {
      Schema.DescribeFieldResult describeField = field.getDescribe();
      result.put(describeField.getName(), field);
    }

    return result;
  }

  public static Set<Schema.SObjectField> customFields(
    Schema.SObjectType sobjectType
  ) {
    Set<Schema.SObjectField> customFields = new Set<Schema.SObjectField>();

    for (Schema.SObjectField field : allFields(sobjectType)) {
      if (field.getDescribe().isCustom()) {
        customFields.add(field);
      }
    }

    return customFields;
  }

  public static Set<Schema.SObjectField> allFields(
    Schema.SObjectType sobjectType
  ) {
    return new Set<Schema.SObjectField>(
      sobjectType.getDescribe().fields.getMap().values()
    );
  }

  public static Set<Schema.SObjectField> flairAndStandardFields(
    Schema.SObjectType sobjectType,
    Boolean skipAccessibilityCheck
  ) {
    return flairFields(sobjectType, true, skipAccessibilityCheck);
  }

  public static Set<Schema.SObjectField> flairAndStandardFields(
    Schema.SObjectType sobjectType
  ) {
    return flairFields(sobjectType, true, true);
  }

  public static Set<Schema.SObjectField> flairFields(
    Schema.SObjectType sobjectType,
    Boolean includeStandardFields,
    Boolean skipAccessibilityCheck
  ) {
    Set<Schema.SObjectField> fields = new Set<Schema.SObjectField>();
    for (Schema.SObjectField field : allFields(sobjectType)) {
      if (!skipAccessibilityCheck && !field.getDescribe().isAccessible()) {
        continue;
      }

      if (field.getDescribe().isCustom() && isFlairField(field)) {
        fields.add(field);
      } else if (!field.getDescribe().isCustom() && includeStandardFields) {
        fields.add(field);
      }
    }

    return fields;
  }

  public static Boolean isFlairField(Schema.SObjectField field) {
    return field.getDescribe().getName().startsWith(Constants.NAMESPACE + '__');
  }

  public static void mergeObjects(SObject main, SObject toMerge) {
    Map<String, Object> fieldsToValue = toMerge.getPopulatedFieldsAsMap();
    for (String fieldName : fieldsToValue.keySet()) {
      main.put(fieldName, fieldsToValue.get(fieldName));
    }
  }

  public static SObject[] filterBy(
    SObject[] objs,
    Schema.SObjectField field,
    Object value
  ) {
    List<SObject> filtered = new List<SObject>();
    for (SObject obj : objs) {
      if (obj.get(field) == value) {
        filtered.add(obj);
      }
    }
    return filtered;
  }

  public static SObject[] filterByNotEqual(
    SObject[] objs,
    Schema.SObjectField field,
    Object value
  ) {
    List<SObject> filtered = new List<SObject>();
    for (SObject obj : objs) {
      if (obj.get(field) != value) {
        filtered.add(obj);
      }
    }
    return filtered;
  }

  public static List<String> getFieldsetFields(
    Schema.SObjectType sobjectType,
    String fieldsetName
  ) {
    List<String> fieldApiNames = new List<String>();

    Schema.FieldSet fieldSetObj = sobjectType.getDescribe()
      .fieldSets.getMap()
      .get(fieldsetName);

    for (Schema.FieldSetMember fieldSetMemberObj : fieldSetObj.getFields()) {
      fieldApiNames.add(fieldSetMemberObj.getFieldPath());
    }

    return fieldApiNames;
  }

  public static List<String> getRequiredFields(Schema.SObjectType sobjectType) {
    List<String> requiredFields = new List<String>();
    for (Schema.SObjectField field : customFields(sObjectType)) {
      Schema.DescribeFieldResult describeField = field.getDescribe();
      if (
        !describeField.isNillable() &&
        describeField.getType() != Schema.DisplayType.BOOLEAN
      ) {
        requiredFields.add(describeField.getName());
      }
    }

    return requiredFields;
  }

  public static Schema.SObjectType forName(String objectName) {
    return GlobalDescribe.get(objectName);
  }

  // Checking if the field is populated in the query
  public static Boolean fieldIsPopulated(
    SObject data,
    Schema.SObjectField field
  ) {
    return fieldIsPopulated(data, field.getDescribe().getName());
  }

  public static Boolean fieldIsPopulated(SObject data, String fieldName) {
    return data.getPopulatedFieldsAsMap().containsKey(fieldName);
  }

  public static List<SObject> flatArray(List<List<SObject>> objArrays) {
    List<SObject> items = new List<SObject>();

    if (objArrays == null) {
      return items;
    }

    for (List<SObject> objArray : objArrays) {
      if (!CollectionUtils.isEmpty(objArray)) {
        items.addAll(objArray);
      }
    }

    return items;
  }

  public static SObject getById(SObject[] objects, Id id) {
    for (SObject obj : objects) {
      if (obj.get('Id') == id) {
        return obj;
      }
    }
    return null;
  }

  public static Map<Id, SObject> indexById(
    Schema.SObjectField idField,
    SObject[] objs
  ) {
    Map<Id, SObject> result = new Map<Id, SObject>();

    for (SObject obj : objs) {
      Id key = (Id) obj.get(idField);
      result.put(key, obj);
    }

    return result;
  }

  public static Map<Id, SObject> indexById(
    Schema.SObjectField fkField,
    Schema.SObjectField idField,
    SObject[] objs
  ) {
    Map<Id, SObject> result = new Map<Id, SObject>();

    for (SObject obj : objs) {
      SObject child = (SObject) obj.getSObject(fkField);
      if (child != null) {
        Id key = (Id) child.get(idField);
        result.put(key, obj);
      }
    }

    return result;
  }

  public static Object getSObjectValue(SObject sObj, String fullFieldApiName) {
    List<String> objRelList = fullFieldApiName.split('\\.');
    String fieldApiName = objRelList.get(objRelList.size() - 1);

    sObj = getLookupObject(objRelList, sObj);
    if (sObj == null) {
      return null;
    }

    return sObj.get(fieldApiName);
  }

  public static List<List<SObject>> chunkSObjectList(
    List<SObject> records,
    Integer chunkSize
  ) {
    List<List<SObject>> chunkedRecords = new List<List<SObject>>();
    Integer startIndex = 0;
    while (startIndex < records.size()) {
      Integer endIndex = startIndex + chunkSize;
      if (endIndex > records.size()) {
        endIndex = records.size();
      }
      List<SObject> subList = new List<SObject>();
      for (Integer i = startIndex; i < endIndex; i++) {
        subList.add(records[i]);
      }
      chunkedRecords.add(subList);
      startIndex = endIndex;
    }
    return chunkedRecords;
  }

  public static SObject getLookupObject(List<String> relList, SObject sObj) {
    for (Integer i = 0; i < (relList.size() - 1); i++) {
      sObj = sObj.getSObject(relList[i]);
    }
    return sObj;
  }

  public static SObject cloneWithoutLookupFields(SObject sObj) {
    SObject newObj = sObj.clone(false, false, false, false);

    Schema.SObjectField[] fields = sObj
      .getSObjectType()
      .getDescribe()
      .fields.getMap()
      .values();

    for (Schema.SObjectField field : fields) {
      Schema.DescribeFieldResult fieldDesc = field.getDescribe();
      Schema.sObjectType[] references = fieldDesc.getReferenceTo();
      if (
        fieldDesc.getName() != 'OwnerId' &&
        fieldDesc.isUpdateable() &&
        references.size() > 0
      ) {
        newObj.put(field, null);
      }
    }

    return newObj;
  }

  public static String getObjectName(Id id) {
    return id.getSObjectType().getDescribe().getName();
  }

  public static Boolean isFlairObject(Schema.SObjectType sobjectType) {
    String objectApiName = sobjectType.getDescribe().getName();

    return objectApiName.startsWith(Constants.NAMESPACE + '__');
  }

  public static Boolean isFlairId(Id id) {
    try {
      return isFlairObject(id.getSObjectType());
    } catch (Exception e) {
      return false;
    }
  }

  public static boolean hasSObjectField(
    String fieldName,
    Schema.SObjectType sobjectType
  ) {
    return sobjectType
      .getDescribe()
      .fields.getMap()
      .keySet()
      .contains(fieldName.toLowerCase());
  }

  public static Schema.SObjectType getObjectType(String objectName) {
    return Schema.getGlobalDescribe().get(objectName);
  }
}