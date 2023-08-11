trigger AccountTrigger on Account (after insert,after update,before insert) {
	if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            AccountTriggerHandler.afterInsert(Trigger.new);
        }
        if(Trigger.isUpdate)
        {
            AccountTriggerHandler.afterUpdate(Trigger.new,Trigger.oldMap);
        }
    }
}