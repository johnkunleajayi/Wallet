public class SimpleQuerySObjectField implements QuerySObjectField {
  private Schema.SObjectField field;

  public SimpleQuerySObjectField(Schema.SObjectField field) {
    this.field = field;
  }

  public String toSOQL() {
    return field.getDescribe().getName();
  }

  public Schema.SObjectField field() {
    return this.field;
  }
}
