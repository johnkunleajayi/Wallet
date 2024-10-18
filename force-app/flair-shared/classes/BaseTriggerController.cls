public abstract with sharing class BaseTriggerController implements TriggerHandler.Controller {
  public void run() {
    run(false);
  }

  public void run(Boolean skipOrgCacheCheck) {
    if (!skipOrgCacheCheck && SkipTriggersService.isSkippingTriggers()) {
      return;
    }

    runDelete();
    runInsert();
    runUndelete();
    runUpdate();
  }

  public virtual void beforeDelete(Map<Id, SObject> oldValues) {
    System.debug('No before update implemented');
  }

  public virtual void beforeInsert(SObject[] newValues) {
    System.debug('No before insert implemented');
  }

  public virtual void beforeUndelete(Map<Id, SObject> newValues) {
    System.debug('No before update implemented');
  }

  public virtual void beforeUpdate(
    Map<Id, SObject> newValues,
    Map<Id, SObject> oldValues
  ) {
    System.debug('No before update implemented');
  }

  public virtual void afterDelete(Map<Id, SObject> oldValues) {
    System.debug('No after delete implemented');
  }

  public virtual void afterInsert(Map<Id, SObject> newValues) {
    System.debug('No after insert implemented');
  }

  public virtual void afterUndelete(Map<Id, SObject> newValues) {
    System.debug('No after undelete implemented');
  }

  public virtual void afterUpdate(
    Map<Id, SObject> newValues,
    Map<Id, SObject> oldValues
  ) {
    System.debug('No after update implemented');
  }

  private void runDelete() {
    if (Trigger.isDelete) {
      if (Trigger.isBefore) {
        beforeDelete(Trigger.oldMap);
      }
      if (Trigger.isAfter) {
        afterDelete(Trigger.oldMap);
      }
    }
  }

  private void runInsert() {
    if (Trigger.isInsert) {
      if (Trigger.isBefore) {
        beforeInsert(Trigger.new);
      }

      if (Trigger.isAfter) {
        afterInsert(Trigger.newMap);
      }
    }
  }

  private void runUndelete() {
    if (Trigger.isUndelete) {
      if (Trigger.isBefore) {
        beforeUndelete(Trigger.newMap);
      }
      if (Trigger.isAfter) {
        afterUndelete(Trigger.newMap);
      }
    }
  }

  private void runUpdate() {
    if (Trigger.isUpdate) {
      if (Trigger.isBefore) {
        beforeUpdate(Trigger.newMap, Trigger.oldMap);
      }
      if (Trigger.isAfter) {
        afterUpdate(Trigger.newMap, Trigger.oldMap);
      }
    }
  }
}