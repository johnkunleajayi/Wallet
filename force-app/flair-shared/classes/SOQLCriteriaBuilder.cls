public class SOQLCriteriaBuilder implements ISOQLCriteria {
  private ISOQLCriteria[] conditions = new List<ISOQLCriteria>();

  private abstract class Condition implements ISOQLCriteria {
    public abstract String toSOQL();

    private String processValue(Object value) {
      if (value instanceof String) {
        return '\'' + String.escapeSingleQuotes((String) value) + '\'';
      }

      if (value instanceof Id) {
        return '\'' + (Id) value + '\'';
      }

      if (value instanceof Long) {
        return String.valueOf(value) + '.0';
      }

      if (value instanceof List<Object>) {
        String[] segments = new List<String>();

        for (Object v : (List<Object>) value) {
          segments.add(processValue(v));
        }

        return '(' + String.join(segments, ', ') + ')';
      }

      if (value instanceof Date) {
        return String.valueOf((Date) value);
      }

      if (value instanceof Datetime) {
        return ((Datetime) value).formatGMT('yyyy-MM-dd\'T\'HH:mm:ssZ');
      }

      return String.valueOf(value);
    }
  }

  private abstract class SimpleCondition extends Condition {
    private QuerySObjectField field;
    private Object value;

    private abstract String getOperator();

    public SimpleCondition(QuerySObjectField field, Object value) {
      this.field = field;
      this.value = value;
    }

    private virtual Boolean shouldFail() {
      return false;
    }

    private virtual Boolean shouldSkip() {
      return false;
    }

    public virtual override String toSOQL() {
      if (shouldFail()) {
        return 'Id = NULL';
      }

      if (shouldSkip()) {
        return '';
      }

      return field.toSOQL() + ' ' + getOperator() + ' ' + processValue(value);
    }
  }

  private class RawCondition extends Condition {
    public String rawExpression;
    public RawCondition(String rawExpression) {
      this.rawExpression = rawExpression;
    }
    public override String toSOQL() {
      return rawExpression;
    }
  }

  private class NotEquals extends SimpleCondition {
    public NotEquals(QuerySObjectField field, Object value) {
      super(field, value);
    }

    private override String getOperator() {
      return '!=';
    }
  }

  private class Equals extends SimpleCondition {
    public Equals(QuerySObjectField field, Object value) {
      super(field, value);
    }

    private override String getOperator() {
      return '=';
    }
  }

  private class Likes extends SimpleCondition {
    public Likes(QuerySObjectField field, Object value) {
      super(field, value);
    }

    private override String getOperator() {
      return 'LIKE';
    }
  }

  private class NotLikes extends SimpleCondition {
    public NotLikes(QuerySObjectField field, Object value) {
      super(field, value);
    }

    private override String getOperator() {
      return 'LIKE';
    }

    public override String toSOQL() {
      if (shouldFail()) {
        return 'Id = NULL';
      }

      if (shouldSkip()) {
        return '';
      }

      return 'NOT ' +
        field.toSOQL() +
        ' ' +
        getOperator() +
        ' ' +
        processValue(value);
    }
  }

  private class GreaterThan extends SimpleCondition {
    public GreaterThan(QuerySObjectField field, Object value) {
      super(field, value);
    }

    private override String getOperator() {
      return '>';
    }
  }

  private class GreaterThanEqual extends SimpleCondition {
    public GreaterThanEqual(QuerySObjectField field, Object value) {
      super(field, value);
    }

    private override String getOperator() {
      return '>=';
    }
  }

  private class LessThan extends SimpleCondition {
    public LessThan(QuerySObjectField field, Object value) {
      super(field, value);
    }

    private override String getOperator() {
      return '<';
    }
  }

  private class LessThanEqual extends SimpleCondition {
    public LessThanEqual(QuerySObjectField field, Object value) {
      super(field, value);
    }

    private override String getOperator() {
      return '<=';
    }
  }

  private class InList extends SimpleCondition {
    public InList(QuerySObjectField field, List<Object> value) {
      super(field, ListUtils.removeNulls(value));
    }

    public InList(QuerySObjectField field, Set<Object> value) {
      this(field, new List<Object>(value));
    }

    private override Boolean shouldFail() {
      return ((List<Object>) value).isEmpty();
    }

    private override String getOperator() {
      return 'IN';
    }
  }

  private class NotInList extends SimpleCondition {
    public NotInList(QuerySObjectField field, List<Object> value) {
      super(field, ListUtils.removeNulls(value));
    }

    protected override Boolean shouldSkip() {
      return ((List<Object>) value).isEmpty();
    }

    private override String getOperator() {
      return 'NOT IN';
    }
  }

  public SOQLCriteriaBuilder whereIn(
    Schema.SObjectField field,
    List<Object> value
  ) {
    addCondition(new InList(new SimpleQuerySObjectField(field), value));
    return this;
  }

  public SOQLCriteriaBuilder whereIn(
    Schema.SObjectField foreignKey,
    Schema.SObjectField field,
    List<Object> value
  ) {
    addCondition(
      new InList(new CompositeQuerySObjectField(foreignKey, field), value)
    );

    return this;
  }

  public SOQLCriteriaBuilder whereGreaterThan(
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(new GreaterThan(new SimpleQuerySObjectField(field), value));
    return this;
  }

  public SOQLCriteriaBuilder whereGreaterThan(
    Schema.SObjectField foreignKey,
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(
      new GreaterThan(new CompositeQuerySObjectField(foreignKey, field), value)
    );
    return this;
  }

  public SOQLCriteriaBuilder whereGreaterThanEquals(
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(
      new GreaterThanEqual(new SimpleQuerySObjectField(field), value)
    );
    return this;
  }

  public SOQLCriteriaBuilder whereGreaterThanEquals(
    Schema.SObjectField foreignKey,
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(
      new GreaterThanEqual(
        new CompositeQuerySObjectField(foreignKey, field),
        value
      )
    );
    return this;
  }

  public SOQLCriteriaBuilder whereLessThan(
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(new LessThan(new SimpleQuerySObjectField(field), value));
    return this;
  }

  public SOQLCriteriaBuilder whereLessThanEquals(
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(new LessThanEqual(new SimpleQuerySObjectField(field), value));
    return this;
  }

  public SOQLCriteriaBuilder whereLessThanEquals(
    Schema.SObjectField foreignKey,
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(
      new LessThanEqual(
        new CompositeQuerySObjectField(foreignKey, field),
        value
      )
    );
    return this;
  }

  public SOQLCriteriaBuilder whereNotIn(
    Schema.SObjectField field,
    List<Object> value
  ) {
    addCondition(new NotInList(new SimpleQuerySObjectField(field), value));
    return this;
  }

  public SOQLCriteriaBuilder whereNotEquals(
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(new NotEquals(new SimpleQuerySObjectField(field), value));
    return this;
  }

  public SOQLCriteriaBuilder whereNotEquals(
    Schema.SObjectField foreignKey,
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(
      new NotEquals(new CompositeQuerySObjectField(foreignKey, field), value)
    );
    return this;
  }

  public SOQLCriteriaBuilder whereEquals(
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(new Equals(new SimpleQuerySObjectField(field), value));
    return this;
  }

  public SOQLCriteriaBuilder whereEquals(
    Schema.SObjectField foreignKey,
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(
      new Equals(new CompositeQuerySObjectField(foreignKey, field), value)
    );
    return this;
  }

  public SOQLCriteriaBuilder whereEquals(
    Schema.SObjectField foreignKey1,
    Schema.SObjectField foreignKey2,
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(
      new Equals(
        new CompositeQuerySObjectField(
          foreignKey1,
          new CompositeQuerySObjectField(foreignKey2, field)
        ),
        value
      )
    );
    return this;
  }

  public SOQLCriteriaBuilder whereLikes(
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(new Likes(new SimpleQuerySObjectField(field), value));
    return this;
  }

  public SOQLCriteriaBuilder whereLikes(
    Schema.SObjectField foreignKey,
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(
      new Likes(new CompositeQuerySObjectField(foreignKey, field), value)
    );
    return this;
  }

  public SOQLCriteriaBuilder whereNotLikes(
    Schema.SObjectField field,
    Object value
  ) {
    addCondition(new NotLikes(new SimpleQuerySObjectField(field), value));
    return this;
  }

  public SOQLCriteriaBuilder addCondition(ISOQLCriteria condition) {
    conditions.add(condition);
    return this;
  }

  public SOQLCriteriaBuilder addOrConditions(List<ISOQLCriteria> orConditions) {
    addCondition(new OrCriteria(orConditions));
    return this;
  }

  public SOQLCriteriaBuilder whereRaw(String rawExpression) {
    addCondition(new RawCondition(rawExpression));
    return this;
  }

  public String toSOQL() {
    return SOQLCriteriaUtils.joinWithAnd(conditions);
  }
}