public with sharing class DX_viewBillingID_ctr {
    @AuraEnabled(cacheable=true)
    public static List<MRI_ID__c> getBillingsInfo() {
        List<MRI_ID__c> lstMRI_ID = new List<MRI_ID__c>();
		String IdUser = UserInfo.getUserId();
        String ContactId = getUserInfo(IdUser);
        If(!String.isBlank(ContactId)){
            String AccountId = getContactInfo(ContactId);
            if(!String.isBlank(AccountId)){
            	lstMRI_ID = getMRI_ID_Info(AccountId);
            }
        }
        return lstMRI_ID;
    }
    
    public static String getUserInfo(String UserId){
        List<User> lstUser = [SELECT Id, ContactId FROM User WHERE Id =: UserId Limit 1];
        return lstUser[0].ContactId;
    }
    
    public static String getContactInfo(String ContactId){
        List<Contact> lstContact = [SELECT Id, AccountId FROM Contact WHERE Id =: ContactId Limit 1];
        return lstContact[0].AccountId;
    }
    
    public static List<MRI_ID__c> getMRI_ID_Info(String AccountId){
        List<MRI_ID__c> lstMRI_ID = [SELECT Id, Name, Building_Name__c, MRI_Occupant_Name__c FROM MRI_ID__c WHERE Account__c =: AccountId];
        return lstMRI_ID;
    }
}