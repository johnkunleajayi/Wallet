public class CompositeQuerySObjectField implements QuerySObjectField {
  private Schema.SObjectField foreignKey;
  private QuerySObjectField field;

  public CompositeQuerySObjectField(
    Schema.SObjectField foreignKey,
    QuerySObjectField field
  ) {
    this.foreignKey = foreignKey;
    this.field = field;
  }

  public CompositeQuerySObjectField(
    Schema.SObjectField foreignKey,
    Schema.SObjectField field
  ) {
    this.foreignKey = foreignKey;
    this.field = new SimpleQuerySObjectField(field);
  }

  public String toSOQL() {
    return prefix() + field.toSOQL();
  }

  public Schema.SObjectField field() {
    return this.field.field();
  }

  private String prefix() {
    if (foreignKey == RecordType.SObjectType) {
      return 'RecordType.';
    }

    return foreignKey.getDescribe().getRelationshipName() + '.';
  }
}
