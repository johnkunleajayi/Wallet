public class QueryFactory {
  private final String CURRENCY_ISO_CODE_FIELD = 'CurrencyIsoCode';
  private final String[] WHITELIST_SYSTEM_FIELDS = new List<String>{
    'Id',
    'Name',
    'CreatedDate',
    'IsDeleted',
    'RecordTypeId',
    CURRENCY_ISO_CODE_FIELD
  };

  private Set<Schema.SObjectField> objectFields {
    get {
      if (objectFields == null) {
        objectFields = SObjectUtils.flairAndStandardFields(sObjectType);
      }

      return objectFields;
    }
    set;
  }

  private Set<QuerySObjectField> fields {
    get {
      if (fields == null) {
        fields = new Set<QuerySObjectField>();

        for (
          Schema.SObjectField field : new Set<Schema.SObjectField>(
            filterSystemFields(objectFields)
          )
        ) {
          fields.add(new SimpleQuerySObjectField(field));
        }
      }

      return fields;
    }
    set;
  }

  private String tableSegment {
    get {
      if (tableSegment == null) {
        tableSegment = childRelationship != null
          ? childRelationship.getRelationshipName()
          : sObjectType.getDescribe().getName();
      }

      return tableSegment;
    }
    set;
  }

  private Schema.SObjectType sObjectType;
  private Integer limitQuery;
  private Integer offsetQuery;
  private ISOQLCriteria[] conditions = new List<ISOQLCriteria>();
  private ListSOQLSegment orderBy = new ListSOQLSegment('ORDER BY', ', ');
  private Schema.ChildRelationship childRelationship;
  private List<CompositeQuerySObjectField> childSelects = new List<CompositeQuerySObjectField>();
  private QueryFactory[] subqueries = new List<QueryFactory>();
  private Boolean allRows = false;
  private Boolean forUpdate = false;

  public class ListSOQLSegment {
    private string keyWord;
    private string connector;
    private List<ISOQLSegment> values = new List<ISOQLSegment>();

    public ListSOQLSegment(String keyWord, String connector) {
      this.keyWord = keyWord;
      this.connector = connector;
    }

    public void setValues(List<ISOQLSegment> values) {
      this.values = values;
    }

    public void addValue(ISOQLSegment value) {
      this.values.add(value);
    }

    public String toSOQL() {
      if (values.isEmpty()) {
        return '';
      }

      String[] segments = new List<String>();

      for (ISOQLSegment segment : values) {
        String soql = segment.toSOQL();

        if (!String.isBlank(soql)) {
          segments.add(soql);
        }
      }

      String joinedSegments = String.join(segments, connector);

      if (String.isBlank(joinedSegments)) {
        return '';
      }

      return ' ' + keyWord + ' ' + joinedSegments;
    }
  }

  public class OrderByClause implements ISOQLSegment {
    private Schema.SObjectField relationshipField;
    private Schema.SObjectField field;
    private String direction;
    private Boolean nullsLast = false;

    public OrderByClause(Schema.SObjectField field) {
      this(null, field, null, false);
    }

    public OrderByClause(
      Schema.SObjectField relationshipField,
      Schema.SObjectField field
    ) {
      this(relationshipfield, field, null, false);
    }

    public OrderByClause(Schema.SObjectField field, String direction) {
      this(null, field, direction, false);
    }

    public OrderByClause(
      Schema.SObjectField field,
      String direction,
      Boolean nullsLast
    ) {
      this(null, field, direction, nullsLast);
    }

    public OrderByClause(
      Schema.SObjectField relationshipField,
      Schema.SObjectField field,
      String direction,
      Boolean nullsLast
    ) {
      this.relationshipField = relationshipField;
      this.field = field;
      this.direction = direction;
      this.nullsLast = nullsLast;
    }

    public String toSOQL() {
      return prefix() +
        field.getDescribe().getName() +
        directionSOQL() +
        nullsLastSOQL();
    }

    private String prefix() {
      if (relationshipField == null) {
        return '';
      }

      return relationshipField.getDescribe().getRelationshipName() + '.';
    }

    private String directionSOQL() {
      if (direction == null) {
        return '';
      }

      return ' ' + direction;
    }
    private String nullsLastSOQL() {
      if (!nullsLast) {
        return '';
      }

      return ' ' + 'NULLS LAST';
    }
  }

  public QueryFactory(Schema.SObjectType sObjectType) {
    this.sObjectType = sObjectType;
  }

  public QueryFactory setFields(Set<Schema.SObjectField> sobjectFields) {
    this.fields = new Set<QuerySObjectField>();

    for (Schema.SObjectField field : sobjectFields) {
      this.fields.add(new SimpleQuerySObjectField(field));
    }

    return this;
  }

  public QueryFactory setFields(Set<QuerySObjectField> fields) {
    this.fields = fields;
    return this;
  }

  public QueryFactory setCondition(ISOQLCriteria condition) {
    this.conditions = condition == null
      ? new List<ISOQLCriteria>()
      : new List<ISOQLCriteria>{ condition };
    return this;
  }

  public QueryFactory addCondition(ISOQLCriteria condition) {
    if (condition != null) {
      this.conditions.add(condition);
    }
    return this;
  }

  public QueryFactory addLimit(Integer v) {
    this.limitQuery = v;
    return this;
  }

  public QueryFactory addOffset(Integer offset) {
    this.offsetQuery = offset;
    return this;
  }

  public QueryFactory orderBy(Schema.SObjectField field) {
    this.orderBy.addValue(new QueryFactory.OrderByClause(field));
    return this;
  }

  public QueryFactory orderBy(
    Schema.SObjectField relationshipField,
    Schema.SObjectField field
  ) {
    this.orderBy.addValue(
      new QueryFactory.OrderByClause(relationshipField, field)
    );
    return this;
  }

  public QueryFactory orderBy(
    Schema.SObjectField relationshipField,
    Schema.SObjectField field,
    String direction
  ) {
    this.orderBy.addValue(
      new QueryFactory.OrderByClause(relationshipField, field, direction, false)
    );
    return this;
  }

  public QueryFactory orderBy(Schema.SObjectField field, String direction) {
    this.orderBy.addValue(new QueryFactory.OrderByClause(field, direction));
    return this;
  }

  public QueryFactory orderBy(
    Schema.SObjectField field,
    String direction,
    Boolean nullsLast
  ) {
    this.orderBy.addValue(
      new QueryFactory.OrderByClause(field, direction, nullsLast)
    );
    return this;
  }

  public Set<Schema.SObjectField> allFields() {
    Set<Schema.SObjectField> allFields = new Set<Schema.SObjectField>();

    for (QuerySObjectField field : fields) {
      allFields.add(field.field());
    }

    for (CompositeQuerySObjectField childField : childSelects) {
      allFields.add(childField.field());
    }

    for (QueryFactory subquery : subqueries) {
      allFields.addAll(subquery.allFields());
    }

    return allFields;
  }

  public QueryFactory allRows() {
    this.allRows = true;
    return this;
  }

  public QueryFactory forUpdate() {
    this.forUpdate = true;
    return this;
  }

  public QueryFactory addChildFields(
    Schema.SObjectField relationshipField,
    Set<Schema.SObjectField> selectFields
  ) {
    for (Schema.SObjectField field : selectFields) {
      this.childSelects.add(
        new CompositeQuerySObjectField(relationshipField, field)
      );
    }
    return this;
  }

  public QueryFactory addChildFields(
    Schema.SObjectField relationshipField,
    Set<QuerySObjectField> selectFields
  ) {
    for (QuerySObjectField field : selectFields) {
      this.childSelects.add(
        new CompositeQuerySObjectField(relationshipField, field)
      );
    }
    return this;
  }

  public QueryFactory addSubquery(
    Schema.SObjectField foreignKey,
    QueryFactory factory
  ) {
    for (
      Schema.ChildRelationship childRelationship : sObjectType.getDescribe()
        .getChildRelationships()
    ) {
      if (childRelationship.getField() == foreignKey) {
        factory.asChildRelationship(childRelationship);
        this.subqueries.add(factory);
        return this;
      }
    }

    return this;
  }

  public QueryFactory asChildRelationship(
    Schema.ChildRelationship childRelationship
  ) {
    this.childRelationship = childRelationship;
    return this;
  }

  public String toSOQL() {
    return 'SELECT ' +
      fieldsSegment() +
      ' FROM ' +
      tableSegment +
      conditionsSOQL() +
      orderBy.toSOQL() +
      limitSegment() +
      offsetSegment() +
      allRowsSegment() +
      forUpdateSegment();
  }

  public String toCountSoql() {
    return 'SELECT COUNT() FROM ' + tableSegment + conditionsSOQL();
  }

  private String conditionsSOQL() {
    String criteria = conditions.size() == 1
      ? conditions.get(0).toSOQL()
      : SOQLCriteriaUtils.joinWithAnd(conditions);
    return String.isBlank(criteria) ? '' : ' WHERE ' + criteria;
  }

  private String limitSegment() {
    return limitQuery != null ? ' LIMIT ' + limitQuery : '';
  }

  private String offsetSegment() {
    return offsetQuery != null ? ' OFFSET ' + offsetQuery : '';
  }

  private String allRowsSegment() {
    return allRows ? ' ALL ROWS' : '';
  }

  private String forUpdateSegment() {
    return forUpdate ? ' FOR UPDATE' : '';
  }

  private String fieldsSegment() {
    Set<String> fieldNames = new Set<String>();

    for (QuerySObjectField field : fields) {
      fieldNames.add(field.toSOQL());
    }

    for (CompositeQuerySObjectField field : childSelects) {
      fieldNames.add(field.toSOQL());
    }

    for (QueryFactory subqueryFactory : subqueries) {
      fieldNames.add('(' + subqueryFactory.toSOQL() + ')');
    }

    addCurrencyIsoCodeField(fieldNames);

    return String.join(new List<String>(fieldNames), ', ');
  }

  private Schema.SObjectField[] filterSystemFields(
    Set<Schema.SObjectField> fields
  ) {
    Schema.SObjectField[] filtered = new List<Schema.SObjectField>();

    for (Schema.SObjectField field : fields) {
      String fieldName = field.getDescribe().getName();

      if (
        WHITELIST_SYSTEM_FIELDS.contains(fieldName) || fieldName.contains('__c')
      ) {
        filtered.add(field);
      }
    }

    return filtered;
  }

  private void addCurrencyIsoCodeField(Set<String> fieldNames) {
    if (!MultiCurrencyUtils.isMultiCurrencyEnabled()) {
      return;
    }

    if (tableSegment.contains('__Share')) {
      return;
    }

    for (Schema.SObjectField field : objectFields) {
      String fieldName = field.getDescribe().getName();

      if (fieldName == CURRENCY_ISO_CODE_FIELD) {
        fieldNames.add(CURRENCY_ISO_CODE_FIELD);
        return;
      }
    }
  }
}