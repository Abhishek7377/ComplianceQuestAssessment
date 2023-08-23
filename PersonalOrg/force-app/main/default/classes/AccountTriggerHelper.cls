public class AccountTriggerHelper {
    //create a contact record on account activation
	public static void createContactRecord(List<Account> accList)
    {
        List<Contact> contactListToInsert = new List<Contact>();
        for(Account accRec : accList)
        {
            Contact conRec = new Contact();
            conRec.AccountId = accRec.Id;
            conRec.FirstName = accRec.Name;
            conRec.LastName = 'Customer Representative';
            conRec.Email = accRec.Email__c;
            conRec.Phone = accRec.Phone;
            contactListToInsert.add(conRec);
        }
        if(!contactListToInsert.isEmpty())
        {
            insert contactListToInsert;
        }
    }
}