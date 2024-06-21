public with sharing class OpportunityTriggerHandler {
    public static void handleAfterUpdate(Map<Id, Opportunity> updatedOpps) {
        List<Opportunity> opportunitiesToInsert = new List<Opportunity>();

        for(Opportunity opp : updatedOpps.values()) {
        if (opp.Amount <= 5000) {
            opp.addError('Opportunity amount must be greater than 5000');
        }
        }
    }

    public static void handleBeforeDelete(List<Opportunity> opportunitiesToInsert) {
        Set<Id> accountIds = new Set<Id>();
    
        for (Opportunity opp : opportunitiesToInsert) {
            if (opp.AccountId != null) {
                    accountIds.add(opp.AccountId);
            }
        }
    
        if (!accountIds.isEmpty()) {
            Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN :accountIds]);
    
            for (Opportunity opp : opportunitiesToInsert) {
                Account acc = accountMap.get(opp.AccountId);
                if (opp.StageName == 'Closed Won' && acc != null && acc.Industry == 'Banking') {
                    opp.addError('Cannot delete closed opportunity for a banking account that is won');
                }
            }
        }
    }    

    public static void handleBeforeUpdate(List<Opportunity> newOpportunities, Map<Id, Opportunity> oldMap) {
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : newOpportunities) {
            accountIds.add(opp.AccountId);
        }
        
        Map<Id, Contact> accountCEOContacts = new Map<Id, Contact>();
        for (Contact c : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accountIds AND Title = 'CEO']) {
            accountCEOContacts.put(c.AccountId, c);
        }
        
        for (Opportunity opp : newOpportunities) {
            if (accountCEOContacts.containsKey(opp.AccountId)) {
                opp.Primary_Contact__c = accountCEOContacts.get(opp.AccountId).Id;
            }
        }
    }
}    