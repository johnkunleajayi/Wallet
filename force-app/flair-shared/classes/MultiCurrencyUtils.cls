public class MultiCurrencyUtils {
  public static Boolean isMultiCurrencyEnabled() {
    return UserInfo.isMultiCurrencyOrganization();
  }

  public static Boolean isSameCurrencyIsoCode(SObject obj1, SObject obj2) {
    if (isMultiCurrencyEnabled()) {
      return obj1.get('CurrencyIsoCode') == obj2.get('CurrencyIsoCode');
    }
    return true;
  }

  public static String getObjectCurrencyCode(SObject obj) {
    if (isMultiCurrencyEnabled()) {
      return (String) obj.get('CurrencyIsoCode');
    }
    return UserInfo.getDefaultCurrency();
  }

  public static void setObjectCurrencyCode(
    SObject objToSet,
    String currencyCode
  ) {
    if (isMultiCurrencyEnabled()) {
      objToSet.put('CurrencyIsoCode', currencyCode);
    }
  }

  public static void setObjectCurrencyCode(
    SObject objToSet,
    SObject srcObject
  ) {
    setObjectCurrencyCode(objToSet, getObjectCurrencyCode(srcObject));
  }
}