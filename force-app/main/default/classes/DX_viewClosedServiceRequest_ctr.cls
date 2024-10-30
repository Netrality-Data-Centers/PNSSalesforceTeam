public with sharing class DX_viewClosedServiceRequest_ctr {
    @AuraEnabled(cacheable=true)
    public static List<Case> getClosedServiceRequest() {
        List<Case> lstCase = new List<Case>();
		String IdUser = UserInfo.getUserId();
        String ContactId = getUserInfo(IdUser);
        If(!String.isBlank(ContactId)){
            String AccountId = getContactInfo(ContactId);
            if(!String.isBlank(AccountId)){
            	lstCase = getClosedSR(AccountId);
            }
        }
        return lstCase;
    }
    
    public static String getUserInfo(String UserId){
        List<User> lstUser = [SELECT Id, ContactId FROM User WHERE Id =: UserId Limit 1];
        return lstUser[0].ContactId;
    }
    
    public static String getContactInfo(String ContactId){
        List<Contact> lstContact = [SELECT Id, AccountId FROM Contact WHERE Id =: ContactId Limit 1];
        return lstContact[0].AccountId;
    }
    
    public static List<Case> getClosedSR(String AccountId){
        List<Case> lstCase = [SELECT Id, DX_Case_Number__c, RecordType.Name, Type, Status, DX_Site__c, DX_Completion_Date__c FROM Case WHERE AccountId  =: AccountId AND Status = 'Resolved'];
        return lstCase;
    }
}