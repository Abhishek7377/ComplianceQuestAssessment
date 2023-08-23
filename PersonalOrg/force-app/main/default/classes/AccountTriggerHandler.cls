public class AccountTriggerHandler {
    public static String customerType = 'Customer';
    public static Boolean isPermission = FeatureManagement.checkPermission('AccountEditAccess');
	public static void afterInsert(List<Account> newAccList)
    {
        List<Account> accList = new List<Account>();
        for(Account acc : newAccList)
        { 
            System.debug('isPermission'+isPermission);
            //Check Current User having permission to create/update the record. 
            if(isPermission==false)
            {
				acc.addError(Label.ErrorMessage2);   
            }
            else{
                //Check for Account Activation Summary Filed value
                if(acc.type == customerType && acc.Active_Account__c==true && acc.Account_Activation_Summary__c == null)
                {
                    acc.addError(label.ErrorMessage);
                }
                if(acc.type == customerType && acc.Active_Account__c==true && acc.Account_Activation_Summary__c != null)
                {
                    accList.add(acc);
                }
            }
        }
        if(!accList.isEmpty())
        {
            AccountTriggerHelper.createContactRecord(accList);
        }
    }
    public static void afterUpdate(List<Account> newAccList,Map<id, Account> oldAccountMap)
    {
        Boolean isPermission = FeatureManagement.checkPermission('AccountEditAccess');
        List<Account> accList = new List<Account>();
        for(Account acc : newAccList)
        {
            //Check Current User having permission to create/update the record. 
            if(isPermission==false)
            {
				acc.addError(Label.ErrorMessage2); 
            }
            else{
                if(acc.type == customerType && (oldAccountMap.get(acc.Id).Active_Account__c!=acc.Active_Account__c && acc.Active_Account__c==true) && acc.Account_Activation_Summary__c != null)
                {
                    accList.add(acc);
                }
            }
        }
        if(!accList.isEmpty())
        {
            AccountTriggerHelper.createContactRecord(accList);
        }
    }
}