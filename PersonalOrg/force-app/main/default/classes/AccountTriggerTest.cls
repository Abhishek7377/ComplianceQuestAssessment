@isTest
public class AccountTriggerTest {
    @testSetUp
    Static void declareData()
    {
        Profile p = [select id from profile where name='System Administrator'];
        Account acc = new Account(Name='Test Account 3', Type='Customer', Active_Account__c=false);
        insert acc;
        User u = new User(
            alias = 'abc', 
            email='test@email45434535.com',
            emailencodingkey='UTF-8',
            lastname='User', 
            languagelocalekey='en_US',
            localesidkey='en_GB',
            profileid = p.Id,
            timezonesidkey='Europe/London', 
            username='unit.test@email45434535.com'
        );
        insert u;
    }
    @isTest 
    static void testAfterInsertErrorScenario() {
            Account acc = new Account(Name='Test Account 1', Type='Customer', Active_Account__c=true);
            Test.startTest();
        	Database.SaveResult result = Database.insert(acc, false);
            Test.stopTest();
			System.debug(UserInfo.getUserId());
            System.assert(!result.isSuccess());
            System.assertEquals(Label.ErrorMessage, result.getErrors()[0].getMessage());
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
        Account acc = [SELECT Id,Active_Account__c,Account_Activation_Summary__c FROM Account WHERE Name = 'Test Account 3'][0];
        acc.Active_Account__c = true;
        acc.Account_Activation_Summary__c='Test Summary';
        Test.startTest();
        update acc;
        Test.stopTest();

        List<Contact> relatedContacts = [SELECT Id FROM Contact WHERE AccountId = :acc.Id];
        System.assertEquals(1, relatedContacts.size(), 'Contact Record Should Be Created');
    }
    @isTest
    static void testUserAccessOnAccount()
    {
        User u = [SELECT id FROM User WHERE username = 'unit.test@email45434535.com'];
        Test.startTest();
        System.runAs(u){
            Account acc = [SELECT Id,Active_Account__c,Account_Activation_Summary__c FROM Account WHERE Name = 'Test Account 3'][0];
            acc.Active_Account__c = true;
            acc.Account_Activation_Summary__c='Test Summary';
            Database.SaveResult result = Database.update(acc, false);
            System.assert(!result.isSuccess());
            System.assertEquals(Label.ErrorMessage2, result.getErrors()[0].getMessage());
        }
        Test.stopTest();
    }
}