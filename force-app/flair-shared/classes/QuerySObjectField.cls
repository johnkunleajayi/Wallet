public interface QuerySObjectField {
  Schema.SObjectField field();
  String toSOQL();
}