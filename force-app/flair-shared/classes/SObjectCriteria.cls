public abstract class SObjectCriteria implements ISOQLCriteria {
  protected SOQLCriteriaBuilder builder = new SOQLCriteriaBuilder();

  public SOQLCriteriaBuilder forSameCurrencyIsoCode(SObject record) {
    if (MultiCurrencyUtils.isMultiCurrencyEnabled()) {
      builder.whereRaw(
        'CurrencyIsoCode = \'' +
        MultiCurrencyUtils.getObjectCurrencyCode(record) +
        '\''
      );
    }
    return builder;
  }

  public String toSOQL() {
    return builder.toSOQL();
  }
}