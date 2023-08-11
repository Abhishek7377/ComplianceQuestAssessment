public class AccountTriggerHandler {
	public static void afterInsert(List<Account> newAccList)
    {
        List<Account> accList = new List<Account>();
        for(Account acc : newAccList)
        {
            if(acc.type == 'Customer' && acc.Active_Account__c==true && acc.Account_Activation_Summary__c == null)
            {
                acc.addError('Account Activation Summary Can\'t be blank When Account is Active');
            }
            if(acc.type == 'Customer' && acc.Active_Account__c==true)
            {
				accList.add(acc);
            }
        }
        if(!accList.isEmpty())
        {
            AccountTriggerHelper.createContactRecord(accList);
        }
    }
    public static void afterUpdate(List<Account> newAccList,Map<id, Account> oldAccountMap)
    {
        List<Account> accList = new List<Account>();
        for(Account acc : newAccList)
        {
            if(acc.type == 'Customer' && (oldAccountMap.get(acc.Id).Active_Account__c!=acc.Active_Account__c && acc.Active_Account__c==true) && acc.Account_Activation_Summary__c != null)
            {
				accList.add(acc);
            }
        }
        if(!accList.isEmpty())
        {
            AccountTriggerHelper.createContactRecord(accList);
        }
    }
}