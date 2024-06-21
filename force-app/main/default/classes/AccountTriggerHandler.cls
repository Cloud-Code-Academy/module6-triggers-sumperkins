public with sharing class AccountTriggerHandler {
    public static void handleBeforeInsert(List<Account> newAccounts) {
        setTypeProspect(newAccounts);
        addressCopy(newAccounts);
        setRating(newAccounts);
    }

    public static void handleAfterInsert(List<Account> newAccounts) {
        createContact(newAccounts);
    }

    public static void setTypeProspect(List<Account> accounts) {
        for (Account acc : accounts) {
            if (String.isBlank(acc.Type)) {
                acc.Type = 'Prospect';
            }
        }
    }

    public static void addressCopy(List<Account> accounts) {
        for (Account acc : accounts) {
            if (String.isBlank(acc.BillingStreet) && 
                String.isBlank(acc.BillingCity) && 
                String.isBlank(acc.BillingState) && 
                String.isBlank(acc.BillingPostalCode) && 
                String.isBlank(acc.BillingCountry)) {

                acc.BillingStreet = acc.ShippingStreet;
                acc.BillingCity = acc.ShippingCity;
                acc.BillingState = acc.ShippingState;
                acc.BillingPostalCode = acc.ShippingPostalCode;
                acc.BillingCountry = acc.ShippingCountry;
            }
        }
    }

    public static void setRating(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.Phone != null && acc.Website != null && acc.Fax != null) {
                acc.Rating = 'Hot';
            }
        }
    }

    public static void createContact(List<Account> accounts) {
        List<Contact> newContacts = new List<Contact>();

        for (Account acc : accounts) {
            Contact newContact = new Contact(
            AccountId = acc.Id,
            LastName = 'DefaultContact',
            Email = 'default@email.com'
            );

            newContacts.add(newContact);
        }
        if (!newContacts.isEmpty()) {
            insert newContacts;
        }
    }
}