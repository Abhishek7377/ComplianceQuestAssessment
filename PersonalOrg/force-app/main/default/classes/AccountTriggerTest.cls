@isTest
public class AccountTriggerTest {
    @isTest 
    static void testAfterInsertErrorScenario() {
            Account acc = new Account(Name='Test Account 1', Type='Customer', Active_Account__c=true);
            Test.startTest();
        	Database.SaveResult result = Database.insert(acc, false);
            Test.stopTest();
            
            System.assert(!result.isSuccess());
            System.assertEquals('Account Activation Summary Can\'t be blank When Account is Active', result.getErrors()[0].getMessage());
        }

    @isTest 
    static void testAfterInsertCreateContactScenario() {
        Account acc = new Account(Name='Test Account 2', Type='Customer', Active_Account__c=true, Account_Activation_Summary__c='Test Summary');
        Test.startTest();
        insert acc;
        Test.stopTest();
        List<Contact> relatedContacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        System.assertEquals(1, relatedContacts.size(), 'Contact Record Should Be Created');
    }

    @isTest 
    static void testAfterUpdateScenario() {
        Account acc = new Account(Name='Test Account 3', Type='Customer', Active_Account__c=false);
        insert acc;
        
        acc.Active_Account__c = true;
        acc.Account_Activation_Summary__c='Test Summary';
        Test.startTest();
        update acc;
        Test.stopTest();

        List<Contact> relatedContacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        System.assertEquals(1, relatedContacts.size(), 'Contact Record Should Be Created');
    }
}