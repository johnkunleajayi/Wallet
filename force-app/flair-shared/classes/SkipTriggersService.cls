public without sharing class SkipTriggersService {
  public static void startSkippingTriggers() {
    Cache.Org.put(
      'flair.Internal.skipTrigger',
      Request.getCurrent().getRequestId()
    );
  }

  public static void stopSkippingTriggers() {
    Cache.Org.remove('flair.Internal.skipTrigger');
  }

  public static Boolean isSkippingTriggers() {
    if (
      Cache.Org.contains('flair.Internal.skipTrigger') &&
      (String) Cache.Org.get('flair.Internal.skipTrigger') ==
      Request.getCurrent().getRequestId()
    ) {
      return true;
    }

    flair__Flair_Migration_Settings__c settings = flair__Flair_Migration_Settings__c.getOrgDefaults();
    return settings != null && settings.flair__Disable_Triggers__c;
  }
}