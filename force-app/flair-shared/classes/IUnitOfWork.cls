public interface IUnitOfWork {
  void registerNew(SObject obj);
  void registerNew(SObject[] objects);
  void registerDirty(SObject obj);
  void registerDirty(SObject[] objects);
  void registerToBeUpserted(SObject obj);
  void registerToBeUpserted(SObject[] objects);
  void registerToBeUpserted(SObject obj, Schema.SObjectField externalIdField);
  void registerToBeUpserted(SObject[] obj, Schema.SObjectField externalIdField);
  void registerDeleted(SObject obj);
  void registerDeleted(SObject[] objects);
  void commitWork();
}