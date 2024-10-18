public class GlobalDescribe {
  private static Map<String, Schema.SObjectType> objectMap = new Map<String, Schema.SObjectType>{
    'flair__Absence_Category__c' => flair__Absence_Category__c.sObjectType
  };

  public static Schema.SObjectType get(String objectName) {
    Schema.SObjectType obj = objectMap.get(objectName);

    return obj == null ? Schema.getGlobalDescribe().get(objectName) : obj;
  }
}