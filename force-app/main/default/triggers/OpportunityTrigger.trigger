trigger OpportunityTrigger on Opportunity (before update, after update, before delete) {
    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunityTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        OpportunityTriggerHandler.handleAfterUpdate(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isDelete) {
        OpportunityTriggerHandler.handleBeforeDelete(Trigger.old);
    }
}
