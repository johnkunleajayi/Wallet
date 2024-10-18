// Removed check of SelectorVersion
public virtual inherited sharing class Selector {
  private Schema.SObjectType sObjectType;
  private QueryFactory factory;
  private Boolean skipFLS = false;
  private Boolean systemMode = false;
  private Integer version;

  public Selector(Schema.SObjectType sObjectType) {
    this.factory = new QueryFactory(sObjectType);
    this.sObjectType = sObjectType;
  }

  public Selector selectFields(Set<Schema.SObjectField> fields) {
    factory.setFields(fields);
    return this;
  }

  public Selector selectFields(Set<QuerySObjectField> fields) {
    factory.setFields(fields);
    return this;
  }

  public Selector selectFields(Schema.FieldSet fieldset) {
    return selectFields(new Set<Schema.SObjectField>(), fieldset);
  }

  public Selector selectFields(
    Set<Schema.SObjectField> fields,
    Schema.FieldSet fieldset
  ) {
    Map<Schema.SObjectField, Set<Schema.SObjectField>> relationFieldsMap = new Map<Schema.SObjectField, Set<Schema.SObjectField>>();

    for (Schema.FieldSetMember fieldMember : fieldSet.getFields()) {
      String fieldPath = fieldMember.getFieldPath();
      List<String> relList = fieldPath.split('\\.');

      if (relList.size() == 1) {
        fields.add(fieldMember.getSObjectField());
      } else {
        Schema.SObjectField relationshipField = sObjectType.getDescribe()
          .fields.getMap()
          .get(relList[0].replace('__r', '__c'));

        if (relationFieldsMap.get(relationshipField) == null) {
          relationFieldsMap.put(
            relationshipField,
            new Set<Schema.SObjectField>()
          );
        }

        relationFieldsMap.get(relationshipField)
          .add(fieldMember.getSObjectField());
      }
    }

    if (!fields.isEmpty()) {
      factory.setFields(fields);
    }

    if (!relationFieldsMap.isEmpty()) {
      for (Schema.SObjectField relationshipField : relationFieldsMap.keySet()) {
        factory.addChildFields(
          relationshipField,
          relationFieldsMap.get(relationshipField)
        );
      }
    }

    return this;
  }

  public Selector addChildFields(
    Schema.SObjectField relationshipField,
    Set<Schema.SObjectField> selectFields
  ) {
    factory.addChildFields(relationshipField, selectFields);
    return this;
  }

  public Selector addChildFields(
    Schema.SObjectField relationshipField,
    Set<QuerySObjectField> selectFields
  ) {
    factory.addChildFields(relationshipField, selectFields);
    return this;
  }

  public Selector addSubquery(Subquery subquery) {
    return addSubquery(subquery.foreignKey, subquery.selector);
  }

  public Selector addSubquery(
    Schema.SObjectField foreignKey,
    Selector selector
  ) {
    factory.addSubQuery(foreignKey, selector.getQueryFactory());
    return this;
  }

  public Selector skipFLS() {
    this.skipFLS = true;
    return this;
  }

  public Selector systemMode() {
    this.systemMode = true;
    return this;
  }

  public Selector addLimit(Integer v) {
    factory.addLimit(v);
    return this;
  }

  public Selector addOffset(Integer offset) {
    factory.addOffset(offset);
    return this;
  }

  public Selector orderBy(Schema.SObjectField field) {
    factory.orderBy(field);
    return this;
  }

  public Selector orderBy(Schema.SObjectField field, String direction) {
    factory.orderBy(field, direction);
    return this;
  }

  public Selector orderBy(
    Schema.SObjectField field,
    String direction,
    Boolean nullsLast
  ) {
    factory.orderBy(field, direction, nullsLast);
    return this;
  }

  public Selector orderBy(
    Schema.SObjectField relationshipField,
    Schema.SObjectField field
  ) {
    factory.orderBy(relationshipField, field);
    return this;
  }

  public Selector orderBy(
    Schema.SObjectField relationshipField,
    Schema.SObjectField field,
    String direction
  ) {
    factory.orderBy(relationshipField, field, direction);
    return this;
  }

  public Selector withCriteria(ISOQLCriteria condition) {
    factory.setCondition(condition);
    return this;
  }

  public Selector allRows() {
    factory.allRows();
    return this;
  }

  public Selector forUpdate() {
    factory.forUpdate();
    return this;
  }

  public QueryFactory getQueryFactory() {
    return factory;
  }

  public SObject[] findAllByIds(Set<Id> recordIds) {
    factory.addCondition(
      new SOQLCriteriaBuilder()
        .whereIn(
          SObjectTypeUtils.getIdField(sobjectType),
          new List<Id>(recordIds)
        )
    );
    return getAll();
  }

  public SObject selectFirst() {
    addLimit(1);
    List<SObject> results = getAll();

    if (results.isEmpty()) {
      return null;
    }

    return results[0];
  }

  public Set<Schema.SObjectField> getAllQueriedFields() {
    return factory.allFields();
  }

  public SObject[] getAll() {
    String query = query();

    // This is a workaround for the case when we have empty list of ids
    // FYI we are skipping only queries that has root level where condition.
    // Otherwise it's risky to brake SubQueries and OrCriterias
    String emptyQueryString = '(Id = NULL)';
    if (
      query.contains(emptyQueryString) &&
      !query.contains('(' + emptyQueryString + ')')
    ) {
      return new List<SObject>();
    }

    return systemMode || skipFLS
      ? Database.query(query, AccessLevel.SYSTEM_MODE)
      : Database.query(query, AccessLevel.USER_MODE);
  }

  public Integer count() {
    factory.setFields(
      new Set<Schema.SObjectField>{ SObjectTypeUtils.getIdField(sObjectType) }
    );
    if (!skipFLS) {
      if (!sObjectType.getDescribe().isAccessible()) {
        return 0;
      }
    }
    return Database.countQuery(countQuery());
  }

  public String query() {
    return factory.toSOQL();
  }

  public String countQuery() {
    return factory.toCountSoql();
  }

  public class Subquery {
    public Schema.SObjectField foreignKey { get; private set; }
    public Selector selector { get; private set; }

    public Subquery(Schema.SObjectField foreignKey, Selector selector) {
      this.foreignKey = foreignKey;
      this.selector = selector;
    }
  }

  public Selector version(Integer version) {
    this.version = version;
    return this;
  }

  public Integer getSelectorVersion() {
    if (this.version != null) {
      return this.version;
    }

    if (Test.isRunningTest()) {
      // Otherwise we can't check if the Version 2 will pass all tests
      return 2;
    }

    return FeatureManagement.checkPackageIntegerValue('SelectorVersion');
  }

  public Boolean isSelectorVersion(Integer version) {
    Integer selectorVersionInOrg = getSelectorVersion();

    if (selectorVersionInOrg == null) {
      selectorVersionInOrg = 1;
    }

    return selectorVersionInOrg == version;
  }
}