public inherited sharing class UnitOfWork implements IUnitOfWork {
  private Boolean skipCRUD = false;
  private Boolean systemMode = false;
  private Map<Schema.SObjectType, Schema.SObjectField> upsertExternalIdFieldsMapping = new Map<Schema.SObjectType, Schema.SObjectField>();
  private Map<Schema.SObjectType, SObject[]> newRecords = new Map<Schema.SObjectType, SObject[]>();
  private Map<Schema.SObjectType, Map<Id, SObject>> dirty = new Map<Schema.SObjectType, Map<Id, SObject>>();
  private Map<Schema.SObjectType, Map<Schema.SObjectField, SObject[]>> upsertRecords = new Map<Schema.SObjectType, Map<Schema.SObjectField, SObject[]>>();
  private Map<Schema.SObjectType, SObject[]> deleted = new Map<Schema.SObjectType, SObject[]>();

  public class UnitOfWorkException extends Exception {
  }

  public void registerNew(SObject obj) {
    addToList(newRecords, obj);
  }

  public void registerNew(SObject[] objects) {
    for (SObject obj : objects) {
      addToList(newRecords, obj);
    }
  }

  public void registerDirty(SObject obj) {
    addToList(dirty, obj);
  }

  public void registerDirty(SObject[] objects) {
    for (SObject obj : objects) {
      addToList(dirty, obj);
    }
  }

  public void registerToBeUpserted(SObject obj) {
    registerToBeUpserted(obj, null);
  }

  public void registerToBeUpserted(SObject[] objects) {
    for (SObject obj : objects) {
      addToUpsertList(obj, null);
    }
  }

  public void registerToBeUpserted(
    SObject obj,
    Schema.SObjectField externalIdField
  ) {
    addToUpsertList(obj, externalIdField);
  }

  public void registerToBeUpserted(
    SObject[] objects,
    Schema.SObjectField externalIdField
  ) {
    for (SObject obj : objects) {
      addToUpsertList(obj, externalIdField);
    }
  }

  public void registerDeleted(SObject obj) {
    addToList(deleted, obj);
  }

  public void registerDeleted(SObject[] objects) {
    for (SObject obj : objects) {
      addToList(deleted, obj);
    }
  }

  public UnitOfWork addUpsertExternalIdField(
    Schema.SObjectType objectType,
    Schema.SObjectField upsertExternalIdField
  ) {
    this.upsertExternalIdFieldsMapping.put(objectType, upsertExternalIdField);
    return this;
  }

  public UnitOfWork skipCRUD() {
    skipCRUD = true;
    return this;
  }

  public Boolean isSkipCRUD() {
    return skipCRUD;
  }

  public UnitOfWork systemMode() {
    systemMode = true;
    return this;
  }

  public void commitWork() {
    commitCreatable();
    commitUpdatable();
    commitUpsertable();
    commitDeletable();
  }

  private void commitCreatable() {
    for (Schema.SObjectType sObjectType : newRecords.keySet()) {
      SObject[] objs = newRecords.get(sObjectType);

      if (
        !skipCrud &&
        !systemMode &&
        !sObjectType.getDescribe().isCreateable()
      ) {
        throw new UnitOfWorkException(
          'Class ' + String.valueOf(sObjectType) + ' is not createable.'
        );
      }

      if (systemMode) {
        insert as system objs;
      } else {
        insert objs;
      }
    }

    newRecords = new Map<Schema.SObjectType, SObject[]>();
  }

  private void commitUpdatable() {
    if (dirty.size() == 0) {
      return;
    }

    for (Schema.SObjectType sObjectType : dirty.keySet()) {
      SObject[] objs = dirty.get(sObjectType).values();

      if (
        !skipCrud &&
        !systemMode &&
        !sObjectType.getDescribe().isUpdateable()
      ) {
        throw new UnitOfWorkException(
          'Class ' + String.valueOf(sObjectType) + ' is not updateable.'
        );
      }

      if (systemMode) {
        update as system objs;
      } else {
        update objs;
      }
    }

    dirty = new Map<Schema.SObjectType, Map<Id, SObject>>();
  }

  private void commitUpsertable() {
    if (upsertRecords.size() == 0) {
      return;
    }

    for (Schema.SObjectType sObjectType : upsertRecords.keySet()) {
      if (
        !skipCrud &&
        !systemMode &&
        (!sObjectType.getDescribe().isCreateable() ||
        !sObjectType.getDescribe().isUpdateable())
      ) {
        throw new UnitOfWorkException(
          'Class ' + String.valueOf(sObjectType) + ' is not upsertable.'
        );
      }

      Map<Schema.SObjectField, SObject[]> externalIdMap = upsertRecords.get(
        sObjectType
      );
      for (Schema.SObjectField externalId : externalIdMap.keySet()) {
        SObject[] objsToUpsert = upsertRecords.get(sObjectType).get(externalId);
        if (externalId == null) {
          Database.upsert(objsToUpsert);
        } else {
          Database.upsert(objsToUpsert, externalId);
        }
      }
    }

    upsertRecords = new Map<Schema.SObjectType, Map<Schema.SObjectField, SObject[]>>();
  }

  private void commitDeletable() {
    if (deleted.size() == 0) {
      return;
    }

    for (Schema.SObjectType sObjectType : deleted.keySet()) {
      SObject[] objs = deleted.get(sObjectType);

      if (!skipCrud && !systemMode && !sObjectType.getDescribe().isDeletable()) {
        throw new UnitOfWorkException(
          'Class ' + String.valueOf(sObjectType) + ' is not deletable.'
        );
      }
      if (systemMode) {
        delete as system objs;
      } else {
        delete objs;
      }
    }

    deleted = new Map<Schema.SObjectType, SObject[]>();
  }

  private void addToList(
    Map<Schema.SObjectType, SObject[]> uowList,
    SObject obj
  ) {
    Schema.SObjectType sObjectType = obj.getSObjectType();

    if (uowList.get(sObjectType) == null) {
      uowList.put(sObjectType, new List<SObject>());
    }

    uowList.get(sObjectType).add(obj);
  }

  private void addToList(
    Map<Schema.SObjectType, Map<Id, SObject>> uowList,
    SObject obj
  ) {
    Schema.SObjectType sObjectType = obj.getSObjectType();

    if (uowList.get(sObjectType) == null) {
      uowList.put(sObjectType, new Map<Id, SObject>());
    }

    uowList.get(sObjectType).put(obj.Id, obj);
  }

  private void addToUpsertList(
    SObject obj,
    Schema.SObjectField externalIdField
  ) {
    Schema.SObjectType sObjectType = obj.getSObjectType();
    if (upsertRecords.get(sObjectType) == null) {
      Map<Schema.SObjectField, SObject[]> externalFieldsMap = new Map<Schema.SObjectField, SObject[]>();
      upsertRecords.put(sObjectType, externalFieldsMap);
    }
    if (upsertRecords.get(sObjectType).get(externalIdField) == null) {
      upsertRecords.get(sObjectType).put(externalIdField, new List<SObject>());
    }
    upsertRecords.get(sObjectType).get(externalIdField).add(obj);
  }
}